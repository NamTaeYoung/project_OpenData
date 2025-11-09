package com.boot.controller;

import com.boot.dto.Admin;
import com.boot.dto.UserDTO;
import com.boot.service.AdminService;
import com.boot.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.HashMap;

@Controller
public class LoginController {
    
    @Autowired
    private AdminService adminService;
    
    @Autowired
    private UserService userService;
    
    // 회원 로그인 페이지
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "message", required = false) String message,
                           Model model) {
        if (message != null && !message.isEmpty()) {
            try {
                String decodedMessage = URLDecoder.decode(message, StandardCharsets.UTF_8.toString());
                model.addAttribute("message", decodedMessage);
            } catch (Exception e) {
                model.addAttribute("message", message);
            }
        }
        return "login";
    }
    
    // 회원 로그인 처리
    @PostMapping("/login_yn")
    public String userLogin(@RequestParam("user_id") String username,
                           @RequestParam("user_pw") String password,
                           HttpSession session,
                           Model model) {
        
        Map<String, String> param = new HashMap<>();
        param.put("user_id", username);
        param.put("user_pw", password);
        
        String userId = param.get("user_id");
        UserDTO user = userService.getUserById(userId);

        if (user == null) {
            model.addAttribute("login_err", "존재하지 않는 아이디입니다.");
            return "login";
        }
        
        // 로그인 실패 기록 초기화 조건 확인 (마지막 실패 후 5분 경과 시 자동 초기화)
        if (user.getLast_fail_time() != null) {
            long diffMin = (System.currentTimeMillis() - user.getLast_fail_time().getTime()) / 1000 / 60;
            if (diffMin >= 5 && user.getLogin_fail_count() > 0) {
                userService.resetLoginFail(userId);
            }
        }

        // 로그인 잠금 상태 체크
        if (user.getLogin_fail_count() >= 5 && user.getLast_fail_time() != null) {
            long diffSec = (System.currentTimeMillis() - user.getLast_fail_time().getTime()) / 1000;
            if (diffSec < 30) {
                model.addAttribute("login_err", "비밀번호 5회 이상 틀려 30초간 계정이 비활성화 됩니다.<br>잠시 후 다시 시도해주세요.");
                return "login";
            } else {
                userService.resetLoginFail(userId);
            }
        }
        
        boolean ok = userService.loginYn(param);

        if (ok) {
            userService.resetLoginFail(userId);
            session.setAttribute("loginId", userId);
            session.setAttribute("loginDisplayName", user.getUser_name());
            session.setAttribute("loginDisplayNickName", user.getUser_nickname()); // ✅ 닉네임 추가
            session.setAttribute("isAdmin", false);
            
            return "redirect:/main";
        } else {
            userService.updateLoginFail(userId);
            user = userService.getUserById(userId);

            if (user.getLogin_fail_count() >= 5) {
                model.addAttribute("login_err", "비밀번호를 5회 이상 틀리셨습니다.<br>계정이 30초간 비활성화 됩니다.");
            } else {
                model.addAttribute("login_err",
                    "아이디 또는 비밀번호가 잘못되었습니다. (" + user.getLogin_fail_count() + "/5)");
            }
            return "login";
        }
    }
    
    // 관리자 로그인 페이지
    @GetMapping("/admin/login")
    public String adminLoginPage(@RequestParam(value = "message", required = false) String message,
                                 Model model) {
        if (message != null && !message.isEmpty()) {
            try {
                String decodedMessage = URLDecoder.decode(message, StandardCharsets.UTF_8.toString());
                model.addAttribute("message", decodedMessage);
            } catch (Exception e) {
                model.addAttribute("message", message);
            }
        }
        return "adminLogin"; // 관리자 전용 로그인 JSP 페이지
    }
    
    // 관리자 로그인 처리
    @PostMapping("/admin/login_yn")
    public String adminLogin(@RequestParam("username") String username,
                             @RequestParam("password") String password,
                             HttpSession session,
                             Model model) {
        
        try {
            Admin adminUser = adminService.authenticate(username, password);
            if (adminUser != null) {
                session.setAttribute("loginDisplayName", adminUser.getName());
                session.setAttribute("userId", adminUser.getId());
                session.setAttribute("isAdmin", true);
                session.setAttribute("role", "ADMIN");
                return "redirect:/adminMain";
            } else {
                model.addAttribute("login_err", "아이디 또는 비밀번호가 일치하지 않습니다.");
                return "adminLogin";
            }
        } catch (Exception e) {
            model.addAttribute("login_err", "로그인 처리 중 오류가 발생했습니다. 관리자에게 문의하세요.");
            e.printStackTrace();
            return "adminLogin";
        }
    }
    
    // 로그아웃 처리 (회원/관리자 공통)
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/main";
    }
}
