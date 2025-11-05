package com.boot.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.BoardDTO;
import com.boot.service.BoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    // ✅ 게시판 목록 + 페이징
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       @RequestParam(defaultValue = "tc") String type, // default search type
                       @RequestParam(defaultValue = "") String keyword, // empty string if no keyword
                       Model model) {
        List<BoardDTO> list;
        int total;

        if (keyword.isEmpty()) {
            // No keyword search
            list = boardService.getPage(page, size); 
            total = boardService.getTotalCount();
        } else {
            // Keyword search
            list = boardService.getSearchPage(type, keyword, page, size);
            total = boardService.getSearchTotalCount(type, keyword);
        }

        // Calculate total pages and start/end page
        int pageCount = (int) Math.ceil(total / (double) size);
        int pageGroupSize = 5;
        int startPage = ((page - 1) / pageGroupSize) * pageGroupSize + 1;
        int endPage = Math.min(startPage + pageGroupSize - 1, pageCount);

        model.addAttribute("list", list);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);

        return "board/list";
    }


    // ✅ 게시글 상세보기 + 조회수 증가
    @GetMapping("/detail")
    public String detail(@RequestParam Long boardNo, Model model) {
        BoardDTO dto = boardService.getById(boardNo, true); // true = 조회수 증가
        model.addAttribute("board", dto);
        return "board/detail";
    }
    
    @GetMapping("/write")
    public String writeForm() {
        return "board/write";  // write.jsp 화면을 보여줍니다.
    }
}
