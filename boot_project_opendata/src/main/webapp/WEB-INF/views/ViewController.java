package com.boot;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {
    
    // 메인 페이지
    @GetMapping("/")
    public String main() {
        return "main";
    }
    
    @GetMapping("/main")
    public String mainPage() {
        return "main";
    }
    
    // 게시판 목록
    @GetMapping("/board")
    public String board() {
        return "board";
    }
    
    // 글쓰기 페이지
    @GetMapping("/board/write")
    public String boardWrite() {
        return "boardWrite";
    }
    
    // 마이페이지
    @GetMapping("/mypage")
    public String mypage() {
        return "mypage";
    }
    
    // 공지사항 목록
    @GetMapping("/notice")
    public String notice() {
        return "notice";
    }
    
    // 공지사항 글쓰기 페이지
    @GetMapping("/notice/write")
    public String noticeWrite() {
        return "noticeWrite";
    }
    
    // QnA 목록
    @GetMapping("/qna")
    public String qna() {
        return "qna";
    }
    
    // QnA 글쓰기 페이지
    @GetMapping("/qna/write")
    public String qnaWrite() {
        return "qnaWrite";
    }
    
    // 게시판 상세 (나중에 구현)
    // @GetMapping("/board/{id}")
    // public String boardDetail(@PathVariable Long id, Model model) {
    //     return "boardDetail";
    // }
    
    // 공지사항 상세 (나중에 구현)
    // @GetMapping("/notice/{id}")
    // public String noticeDetail(@PathVariable Long id, Model model) {
    //     return "noticeDetail";
    // }
    
    // QnA 상세 (나중에 구현)
    // @GetMapping("/qna/{id}")
    // public String qnaDetail(@PathVariable Long id, Model model) {
    //     return "qnaDetail";
    // }
}

