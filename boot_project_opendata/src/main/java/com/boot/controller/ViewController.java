package com.boot.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.UserDTO;
import com.boot.service.UserServicelmpl;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ViewController {
	@Autowired
	private UserServicelmpl userService;

    // ------------------ 메인 ------------------
	@GetMapping("/main")
	public String main(HttpSession session) {
		return "main";
	}

	// ------------------ 회원가입 ------------------
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String register() {
		return "register";
	}

	@RequestMapping(value = "/register_ok", method = RequestMethod.POST)
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

	// ------------------ 로그인 ------------------
    @RequestMapping(value="/login", method=RequestMethod.GET)
    public String login() {
        return "login";
    }

    @RequestMapping(value="/login_yn", method=RequestMethod.POST)
    public String loginYn(@RequestParam Map<String, String> param, HttpSession session, Model model) {
        String userId = param.get("user_id");
        
        // 회원 정보 조회 (로그인 시도 및 시간 확인용)
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
                userService.resetLoginFail(userId); // 30초 지났으면 초기화
            }
        }
        boolean ok = userService.loginYn(param);

        if (ok) {
        	userService.resetLoginFail(userId);
            session.setAttribute("loginId", userId);

            // ✅ 로그인한 사용자 정보 불러오기 (항상 이름만 표시)
            Map<String, Object> userInfo = userService.getUser(userId);
            if (userInfo != null) {
                String name = (String) userInfo.get("user_name");
                session.setAttribute("loginDisplayName", name);
            }

            // 로그인 성공 후 메인으로 이동
            return "redirect:/main";
        } else {
        	userService.updateLoginFail(userId); // 실패 카운트 증가
            user = userService.getUserById(userId); // 갱신된 횟수 다시 조회

            if (user.getLogin_fail_count() >= 5) {
                model.addAttribute("login_err", "비밀번호를 5회 이상 틀리셨습니다.<br>계정이 30초간 비활성화 됩니다.");
            } else {
                model.addAttribute("login_err",
                    "아이디 또는 비밀번호가 잘못되었습니다. (" + user.getLogin_fail_count() + "/5)");
            }
            return "login";
        }
    }

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/main";
	}

	// ------------------ 아이디 중복 체크 ------------------
	@ResponseBody
	@RequestMapping(value = "/checkId", method = RequestMethod.POST)
	public String checkId(@RequestParam("user_id") String id) {
		int flag = userService.checkId(id);
		return (flag == 1) ? "Y" : "N";
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
	private String getLoginId(HttpSession session) {
		return (String) session.getAttribute("loginId");
	}

}