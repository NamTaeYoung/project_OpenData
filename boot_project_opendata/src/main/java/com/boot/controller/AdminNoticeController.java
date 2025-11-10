package com.boot.controller;

import java.io.IOException;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dto.NoticeBoardAttachDTO;
import com.boot.dto.NoticeBoardDTO;
import com.boot.dto.StationDTO;
import com.boot.service.NoticeBoardService;
import com.boot.util.AirQualityCalculator;
import com.boot.util.ExcelReader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AdminNoticeController {

    private final NoticeBoardService noticeService;

    @Autowired private ExcelReader excelReader;
    @Autowired private AirQualityCalculator airQualityCalculator;

    /**
     * ✅ 관리자 공지사항 목록
     */
    @GetMapping("/noticeManagement")
    public String noticeManagement(HttpSession session,
                                   @RequestParam(defaultValue = "1") int page,
                                   @RequestParam(defaultValue = "10") int size,
                                   @RequestParam(defaultValue = "tc") String type,
                                   @RequestParam(defaultValue = "") String keyword,
                                   Model model) {

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            log.warn("🚫 접근 차단: 관리자 세션 없음");
            return "redirect:/admin/login";
        }

        List<NoticeBoardDTO> list;
        int total;

        if (keyword.isEmpty()) {
            list = noticeService.getPage(page, size);
            total = noticeService.getTotalCount();
        } else {
            list = noticeService.getSearchPage(type, keyword, page, size);
            total = noticeService.getSearchTotalCount(type, keyword);
        }

        int pageCount = (int) Math.ceil(total / (double) size);
        int pageGroupSize = 5;
        int startPage = ((page - 1) / pageGroupSize) * pageGroupSize + 1;
        int endPage = Math.min(startPage + pageGroupSize - 1, pageCount);

        model.addAttribute("noticeList", list);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);

        // ✅ 상단 대기질 데이터
        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);
        model.addAttribute("cityAverages", cityAverages.values());

        return "admin/noticeManagement";
    }

    /**
     * ✅ 공지 상세보기 (조회수 증가 X)
     */
    @GetMapping("/admin/notice/detail")
    public String adminDetail(@RequestParam("noticeNo") Long noticeNo,
                              HttpSession session, Model model) {

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        NoticeBoardDTO post = noticeService.getById(noticeNo, false);
        if (post == null) return "redirect:/noticeManagement";

        List<NoticeBoardAttachDTO> attaches = noticeService.getAttachments(noticeNo);

        Date noticeDate = post.getNoticeDate() == null ? null :
                Date.from(post.getNoticeDate().atZone(ZoneId.systemDefault()).toInstant());

        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("post", post);
        model.addAttribute("attaches", attaches);
        model.addAttribute("noticeDate", noticeDate);
        model.addAttribute("cityAverages", cityAverages.values());

        return "notice/noticeDetail";
    }

    /**
     * ✅ 공지 작성 폼
     */
    @GetMapping("/admin/notice/write")
    public String writeForm(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        return "notice/noticeWrite";
    }

    /**
     * ✅ 공지 작성 처리
     */
    @PostMapping("/admin/notice/write.do")
    public String write(NoticeBoardDTO dto,
                        @RequestParam(value = "images", required = false) List<MultipartFile> images,
                        HttpSession session) throws IOException {

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        // ✅ 관리자 ID 세션에서 가져오기 (userId null 방지)
        String adminId = (String) session.getAttribute("loginId");
        if (adminId == null || adminId.isEmpty()) {
            log.warn("⚠️ 세션에 loginId 없음 → 기본 admin으로 대체");
            adminId = "admin";
        }

        dto.setUserId(adminId);

        Long noticeNo = noticeService.writeWithAttachments(dto, images);
        log.info("📢 공지 등록 완료 - noticeNo={}, userId={}", noticeNo, adminId);

        return "redirect:/admin/notice/detail?noticeNo=" + noticeNo;
    }

    /**
     * ✅ 공지 수정 폼
     */
    @GetMapping("/admin/notice/edit/{noticeNo}")
    public String editForm(@PathVariable Long noticeNo,
                           HttpSession session, Model model) {

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        NoticeBoardDTO post = noticeService.find(noticeNo);
        if (post == null) return "redirect:/noticeManagement";

        model.addAttribute("post", post);
        model.addAttribute("attaches", noticeService.getAttachments(noticeNo));

        return "notice/noticeEdit";
    }

    /**
     * ✅ 공지 수정 처리
     */
    @PostMapping("/admin/notice/edit.do")
    public String edit(NoticeBoardDTO dto,
                       @RequestParam(value = "images", required = false) List<MultipartFile> newImages,
                       @RequestParam(value = "deleteFiles", required = false) List<String> deleteFiles)
            throws IOException {

        noticeService.update(dto);

        if (deleteFiles != null) {
            List<Long> deleteIds = deleteFiles.stream().map(Long::valueOf).toList();
            noticeService.deleteAttachments(deleteIds);
        }

        if (newImages != null && !newImages.isEmpty()) {
            noticeService.addAttachments(dto.getNoticeNo(), newImages);
        }

        return "redirect:/admin/notice/detail?noticeNo=" + dto.getNoticeNo();
    }

    /**
     * ✅ 공지 삭제
     */
    @GetMapping("/admin/notice/delete/{noticeNo}")
    public String delete(@PathVariable("noticeNo") Long noticeNo,
                         HttpSession session) {

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        noticeService.delete(noticeNo);
        log.info("🗑️ 관리자 공지 삭제 완료 - noticeNo={}", noticeNo);

        return "redirect:/noticeManagement";
    }
}
