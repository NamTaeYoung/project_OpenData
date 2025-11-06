package com.boot.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.dto.BoardDTO;
import com.boot.dao.UserDAO;
import com.boot.dto.BoardAttachDTO;
import com.boot.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
//@RequestMapping("/board")
public class AdminBoardController {
	private final UserDAO userDAO;
    private final BoardService boardService;

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
            return "redirect:/admin/login";
        }

        // ✅ 2. 게시판 데이터 조회
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

        // ✅ 4. 모델에 데이터 바인딩
        model.addAttribute("boardList", list);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);

        // ✅ 5. JSP로 이동
        return "admin/boardManagement";
    }
    
    /**
     * ✅ 관리자용 게시글 상세보기 (조회수 증가 X)
     */
    @GetMapping("/adminDetail")
    public String adminDetail(@RequestParam("boardNo") Long boardNo, Model model) {
        // 조회수 증가 없이 게시글만 조회
        BoardDTO post = boardService.getById(boardNo, false);

        if (post == null) {
            model.addAttribute("errorMessage", "해당 게시글을 찾을 수 없습니다.");
            return "admin/boardManagement";
        }

        // 첨부파일 목록
        List<BoardAttachDTO> attaches = boardService.getImages(boardNo);

        // LocalDateTime → java.util.Date 변환 (JSP의 fmt:formatDate용)
        Date boardDate = null;
        if (post.getBoardDate() != null) {
            boardDate = Date.from(post.getBoardDate().atZone(ZoneId.systemDefault()).toInstant());
        }

        model.addAttribute("post", post);
        model.addAttribute("attaches", attaches);
        model.addAttribute("boardDate", boardDate);

        log.info("관리자 게시글 상세 조회 - boardNo={}", boardNo);

        // 📄 /WEB-INF/views/admin/adminDetail.jsp 로 이동
        return "admin/adminDetail";
    }
}
