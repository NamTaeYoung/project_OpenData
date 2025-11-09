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

import com.boot.dao.UserDAO;
import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;
import com.boot.dto.StationDTO;
import com.boot.service.BoardService;
import com.boot.util.AirQualityCalculator;
import com.boot.util.ExcelReader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AdminBoardController {

    private final BoardService boardService;
    private final UserDAO userDAO;

    @Autowired private ExcelReader excelReader;
    @Autowired private AirQualityCalculator airQualityCalculator;

    /**
     * ✅ 관리자 게시판 목록
     */
    @GetMapping("/boardManagement")
    public String boardManagement(HttpSession session,
                                  @RequestParam(defaultValue = "1") int page,
                                  @RequestParam(defaultValue = "10") int size,
                                  @RequestParam(defaultValue = "tc") String type,
                                  @RequestParam(defaultValue = "") String keyword,
                                  Model model) {

        // ✅ 1. 관리자 권한 체크
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            log.warn("🚫 접근 차단: 관리자 세션 없음");
            return "redirect:/admin/login";
        }

        // ✅ 2. 게시판 목록 조회
        List<BoardDTO> list;
        int total;

        if (keyword.isEmpty()) {
            list = boardService.getPage(page, size);
            total = boardService.getTotalCount();
        } else {
            list = boardService.getSearchPage(type, keyword, page, size);
            total = boardService.getSearchTotalCount(type, keyword);
        }

        // ✅ 3. 페이징 계산
        int pageCount = (int) Math.ceil(total / (double) size);
        int pageGroupSize = 5;
        int startPage = ((page - 1) / pageGroupSize) * pageGroupSize + 1;
        int endPage = Math.min(startPage + pageGroupSize - 1, pageCount);

        // ✅ 4. 모델 바인딩
        model.addAttribute("boardList", list);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);

        // ✅ 5. 상단 대기질 데이터
        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);
        model.addAttribute("cityAverages", cityAverages.values());

        return "admin/boardManagement";
    }

 // ✅ 관리자 상세보기 (조회수 증가 X)
    @GetMapping("/admin/board/detail")
    public String adminDetail(@RequestParam("boardNo") Long boardNo,
                              HttpSession session, Model model) {

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        BoardDTO post = boardService.getById(boardNo, false);
        if (post == null) return "redirect:/boardManagement";

        List<BoardAttachDTO> attaches = boardService.getImages(boardNo);
        String nickname = userDAO.findNicknameByUserId(post.getUserId());

        Date boardDate = post.getBoardDate() == null ? null :
            Date.from(post.getBoardDate().atZone(ZoneId.systemDefault()).toInstant());

        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("post", post);
        model.addAttribute("attaches", attaches);
        model.addAttribute("nickname", nickname);
        model.addAttribute("boardDate", boardDate);
        model.addAttribute("cityAverages", cityAverages.values());

        return "board/detail"; // 공용 JSP 사용
    }

    // ✅ 관리자 삭제
    @GetMapping("/admin/board/delete/{boardNo}")
    public String delete(@PathVariable("boardNo") Long boardNo,
                         HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        boardService.delete(boardNo);
        log.info("🗑️ 관리자 게시글 삭제 완료 - boardNo={}", boardNo);

        return "redirect:/boardManagement";
    }

    // ✅ 관리자 수정 폼
    @GetMapping("/admin/board/edit/{boardNo}")
    public String editForm(@PathVariable Long boardNo,
                           HttpSession session, Model model) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        BoardDTO post = boardService.find(boardNo);
        if (post == null) return "redirect:/boardManagement";

        model.addAttribute("post", post);
        model.addAttribute("attaches", boardService.getImages(boardNo));

        return "board/edit";
    }

    // ✅ 관리자 수정 처리
    @PostMapping("/admin/board/edit.do")
    public String edit(BoardDTO dto,
                       @RequestParam(value = "images", required = false) List<MultipartFile> newImages,
                       @RequestParam(value = "deleteFiles", required = false) List<String> deleteFiles)
            throws IOException {

        boardService.update(dto);

        if (deleteFiles != null) {
            List<Long> deleteIds = deleteFiles.stream().map(Long::valueOf).toList();
            boardService.deleteAttachments(deleteIds);
        }

        if (newImages != null && !newImages.isEmpty()) {
            boardService.addAttachments(dto.getBoardNo(), newImages);
        }

        return "redirect:/admin/board/detail?boardNo=" + dto.getBoardNo();
    }
}
