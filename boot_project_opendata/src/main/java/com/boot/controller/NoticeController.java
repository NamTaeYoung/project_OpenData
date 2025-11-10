package com.boot.controller;

import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
@RequestMapping("/notice")
public class NoticeController {

    private final NoticeBoardService noticeService;
    private final ExcelReader excelReader;
    private final AirQualityCalculator airQualityCalculator;

    /**
     * ✅ 공지사항 목록 페이지
     * JSP: /WEB-INF/views/notice/notice.jsp
     */
    @GetMapping
    public String noticeList(@RequestParam(defaultValue = "1") int page,
                             @RequestParam(defaultValue = "10") int size,
                             @RequestParam(defaultValue = "tc") String type,
                             @RequestParam(defaultValue = "") String keyword,
                             Model model) {

        List<NoticeBoardDTO> list;
        int total;

        if (keyword.isEmpty()) {
            list = noticeService.getPage(page, size);
            total = noticeService.getTotalCount();
        } else {
            list = noticeService.getSearchPage(type, keyword, page, size);
            total = noticeService.getSearchTotalCount(type, keyword);
        }

        // ✅ 페이지네이션 계산
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

        // ✅ 상단 대기질 데이터 (배너용)
        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);
        model.addAttribute("cityAverages", cityAverages.values());

        return "notice/notice"; // 사용자용 공지 목록 JSP
    }

    /**
     * ✅ 공지사항 상세보기
     * JSP: /WEB-INF/views/notice/noticeDetail.jsp
     */
    @GetMapping("/detail")
    public String noticeDetail(@RequestParam("noticeNo") Long noticeNo,
                               Model model,
                               HttpSession session) {

        NoticeBoardDTO post = noticeService.getById(noticeNo, true);
        if (post == null) {
            return "redirect:/notice"; // 존재하지 않으면 목록으로
        }

        List<NoticeBoardAttachDTO> attaches = noticeService.getAttachments(noticeNo);

        Date noticeDate = post.getNoticeDate() == null ? null :
                Date.from(post.getNoticeDate().atZone(ZoneId.systemDefault()).toInstant());

        model.addAttribute("post", post);
        model.addAttribute("attaches", attaches);
        model.addAttribute("noticeDate", noticeDate);

        return "notice/noticeDetail"; // 사용자용 공지 상세보기 JSP
    }
}
