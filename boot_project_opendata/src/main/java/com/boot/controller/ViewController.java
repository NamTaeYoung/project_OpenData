package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.service.UserService;

import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Controller
public class ViewController {
    
    @Autowired
    private UserService userService;
    
    // 메인 페이지
    @GetMapping("/")
    public String main() {
        return "main";
    }
    
    @GetMapping("/main")
    public String mainPage() {
        return "main";
    }
    
    // 회원가입 페이지
    @GetMapping("/register")
    public String register() {
        return "register";
    }
    
    // 회원가입 처리
    @PostMapping("/register_ok")
    public String registerOk(@RequestParam Map<String, String> param, Model model) {
        if (param.get("user_email_chk") == null || param.get("user_email_chk").equals("")) {
            param.put("user_email_chk", "N");
        }

        int result = userService.register(param);
        if (result == 1) {
            return "redirect:/login";
        } else {
            model.addAttribute("msg", "회원가입 실패. 다시 시도하세요.");
            return "register";
        }
    }
    
    // 아이디 중복 체크 (AJAX)
    @PostMapping("/checkId")
    @ResponseBody
    public String checkId(@RequestParam("user_id") String id) {
        int flag = userService.checkId(id);
        return (flag == 1) ? "Y" : "N";
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
    
    // 공지사항 글쓰기 페이지 (관리자만 접근 가능)
    @GetMapping("/notice/write")
    public String noticeWrite(HttpSession session) {
        // 관리자 권한 체크
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            // 관리자가 아니면 공지사항 목록으로 리다이렉트
            return "redirect:/notice";
        }
        return "noticeWrite";
    }
    
    // QnA 목록
    @GetMapping("/qna")
    public String qna() {
        return "qna";
    }
    
    // QnA 글쓰기 페이지 (로그인 필요)
    @GetMapping("/qna/write")
    public String qnaWrite(HttpSession session) {
        // 로그인 체크
        String loginDisplayName = (String) session.getAttribute("loginDisplayName");
        if (loginDisplayName == null || loginDisplayName.isEmpty()) {
            // 로그인 안되어 있으면 로그인 페이지로 리다이렉트
            try {
                String message = URLEncoder.encode("로그인 후 이용 가능합니다", StandardCharsets.UTF_8.toString());
                return "redirect:/login?message=" + message;
            } catch (Exception e) {
                return "redirect:/login";
            }
        }
        return "qnaWrite";
    }
    
    
    // 관리자 메인화면
    @GetMapping("/adminMain")
    public String adminMain() {
    	return "admin/adminMain";
    }
    
    // 공지사항 목록
    @GetMapping("/noticeMangement")
    public String noticeMangement() {
    	return "admin/noticeMangement";
    }
    // QnA 목록
    @GetMapping("/qnaMangement")
    public String qnaMangement() {
    	return "admin/qnaMangement";
    }
    
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
