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
import com.boot.util.AirQualityCalculator;
import com.boot.util.ExcelReader;
import com.boot.dto.StationDTO;
import com.boot.dto.UserDTO;

import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Controller
public class ViewController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private ExcelReader excelReader;
    
    @Autowired
    private AirQualityCalculator airQualityCalculator;
    
    // 메인 페이지
    @GetMapping("/")
    public String main() {
        return "main";
    }
    
    @GetMapping("/main")
    public String mainPage(Model model) {
    	List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
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

    
    // 회원 정보 수정 페이지
    @GetMapping("/mypage/edit")
    public String mypageEdit(HttpSession session, Model model) {
        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
        // 로그인 체크
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null || loginId.isEmpty()) {
            try {
                String message = URLEncoder.encode("로그인 후 이용 가능합니다", StandardCharsets.UTF_8.toString());
                return "redirect:/login?message=" + message;
            } catch (Exception e) {
                return "redirect:/login";
            }
        }
        
        // 관리자는 접근 불가
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            return "redirect:/adminMain";
        }
        
        // 사용자 정보 조회
        UserDTO user = userService.getUserById(loginId);
        if (user == null) {
            return "redirect:/mypage";
        }
        
        model.addAttribute("user", user);
        return "memberEdit";
    }
    
    // 회원 정보 수정 처리
    @PostMapping("/mypage/edit")
    public String mypageEditOk(@RequestParam Map<String, String> param, HttpSession session, Model model) {
        // 로그인 체크
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null || loginId.isEmpty()) {
            return "redirect:/login";
        }
        
        // 관리자는 접근 불가
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            return "redirect:/adminMain";
        }
        
        // 사용자 ID 설정
        param.put("user_id", loginId);
        
        // 회원 정보 수정 처리
        int result = userService.updateUser(param);
        
        if (result == 1) {
            // 세션 정보 업데이트
            UserDTO user = userService.getUserById(loginId);
            if (user != null) {
                session.setAttribute("loginDisplayName", user.getUser_name());
            }
            return "redirect:/mypage";
        } else {
            // 수정 실패 시 기존 정보 다시 로드
            UserDTO user = userService.getUserById(loginId);
            if (user != null) {
                model.addAttribute("user", user);
            }
            model.addAttribute("error", "회원 정보 수정에 실패했습니다.");
            return "memberEdit";
        }
    }
    
//    // 공지사항 목록
//    @GetMapping("/notice")
//    public String notice(Model model) {
//    	List<StationDTO> stations = excelReader.readStations();
//        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);
//
//        model.addAttribute("cityAverages", cityAverages.values());
//        return "notice";
//    }
    
//    // 공지사항 글쓰기 페이지 (관리자만 접근 가능)
//    @GetMapping("/noticeManagement/noticeWrite")
//    public String adminWrite(HttpSession session) {
//    	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
//    	if (isAdmin == null || !isAdmin) {
//    		return "redirect:/noticeManagement";
//    	}
//    	return "admin/noticeWrite";
//    }
    
    // 공지사항 글쓰기 페이지 (관리자만 접근 가능)
//    @GetMapping("/notice/write")
//    public String noticeWrite(HttpSession session) {
//        // 관리자 권한 체크
//        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
//        if (isAdmin == null || !isAdmin) {
//            // 관리자가 아니면 공지사항 목록으로 리다이렉트
//            return "redirect:/notice";
//        }
//        return "noticeWrite";
//    }
    
    // QnA 목록
    @GetMapping("/qna")
    public String qna(HttpSession session, Model model) {
    	List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
        // 관리자는 QnA 접근 불가 (지역관리 페이지로 이동)
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            return "redirect:/adminMain";
        }
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
        
        // 관리자는 접근 불가
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            return "redirect:/adminMain";
        }
        
        return "qnaWrite";
    }
    
    
    // 관리자 메인화면
    @GetMapping("/adminMain")
    public String adminMain(HttpSession session,Model model) {
    	List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);
        
        model.addAttribute("cityAverages", cityAverages.values());
    	// 관리자 권한 체크
    	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    	if (isAdmin == null || !isAdmin) {
    		// 관리자가 아니면 관리자 로그인 페이지로 리다이렉트
    		return "redirect:/admin/login";
    	}
    	return "admin/adminMain";
    }
    
    // 게시판 목록
//    @GetMapping("/boardManagement")
//    public String boardManagement(HttpSession session) {
//    	// 관리자 권한 체크
//    	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
//    	if (isAdmin == null || !isAdmin) {
//    		return "redirect:/admin/login";
//    	}
//        return "admin/boardManagement";
//    }
//   
    // 공지사항 목록
//    @GetMapping("/noticeManagement")
//    public String noticeManagement(HttpSession session, Model model) {
//    	// 관리자 권한 체크
//    	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
//    	if (isAdmin == null || !isAdmin) {
//    		return "redirect:/admin/login";
//    	}
//    	List<StationDTO> stations = excelReader.readStations();
//        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);
//
//        model.addAttribute("cityAverages", cityAverages.values());
//    	return "admin/noticeManagement";
//    }
//    
    // QnA 목록
    @GetMapping("/qnaManagement")
    public String qnaManagement(HttpSession session, Model model) {
    	// 관리자 권한 체크
    	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    	if (isAdmin == null || !isAdmin) {
    		return "redirect:/admin/login";
    	}
    	List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
    	return "admin/qnaManagement";
    }
    
    // 게시판 상세 (나중에 구현)
     @GetMapping("/board/{id}")
     public String boardDetail(@PathVariable Long id, Model model) {
         return "boardDetail";
     }
     
     // 관리자 게시판 상세 (나중에 구현)
     @GetMapping("/boardManagement/{id}")
     public String boardDetailManagement(@PathVariable Long id, Model model) {
    	 return "boardDetailManagement";
     }
     
////     공지사항 상세 (나중에 구현)
//     @GetMapping("/notice/{id}")
//     public String noticeDetail(@PathVariable Long id, Model model) {
//         return "noticeDetail";
//     }
    
    // QnA 상세 (나중에 구현)
     @GetMapping("/qna/{id}")
     public String qnaDetail(@PathVariable Long id, Model model) {
         return "qnaDetail";
     }
}
