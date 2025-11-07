package com.boot.controller;

import com.boot.dao.BoardDAO;
import com.boot.dto.BoardDTO;
import com.boot.dto.FavoriteStationDTO;
import com.boot.dto.StationDTO;
import com.boot.dto.UserDTO;
import com.boot.service.UserService;
import com.boot.util.AirQualityCalculator;
import com.boot.util.ExcelReader;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.HashMap;

@Controller
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    UserService userService;
    
    @Autowired
    BoardDAO boardDAO;  
    
    @Autowired
    private ExcelReader excelReader;
    
    @Autowired
    private AirQualityCalculator airQualityCalculator;
    
    // 마이페이지 화면
    @GetMapping
    public String mypage(HttpSession session, Model model, @ModelAttribute("msg") String msg) {

        String user_id = (String) session.getAttribute("loginId");
        if (user_id == null) return "redirect:/login";

        // ✅ 최신 회원 정보 조회
        UserDTO user = userService.getUserById(user_id);
        model.addAttribute("user", user);

        // ✅ 세션 값 업데이트
        session.setAttribute("loginDisplayName", user.getUser_name());
        session.setAttribute("loginId", user.getUser_id());
        session.setAttribute("userEmail", user.getUser_email());
        session.setAttribute("userPhone", user.getUser_phone_num());
        session.setAttribute("userRegDate", user.getReg_date());

        // ✅ 관심 지역 리스트 조회
        List<FavoriteStationDTO> favorites = userService.getFavoriteList(user_id);
        model.addAttribute("favorites", favorites);

        // ✅ 내가 작성한 게시글 목록 조회 (최신 5개)
        List<BoardDTO> myBoardList = boardDAO.selectMyBoardList(user_id);
        model.addAttribute("myBoardList", myBoardList);

        
        // 메시지 전달
        model.addAttribute("msg", msg);
        
        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
        return "mypage"; 
    }

    // 회원 정보 수정
    @PostMapping("/update")
    public String updateUser(
            @RequestParam Map<String, String> param,
            HttpSession session,
            RedirectAttributes rttr) {

        String user_id = (String) session.getAttribute("loginId");
        param.put("user_id", user_id);   // ✅ user_id 강제 설정

        // ✅ DB 업데이트
        userService.updateUser(param);

        // ✅ 최신 유저 정보 다시 조회
        UserDTO updatedUser = userService.getUserById(user_id);

        // ✅ 세션 정보 갱신
        session.setAttribute("user", updatedUser);
        session.setAttribute("loginDisplayName", updatedUser.getUser_name());

        rttr.addFlashAttribute("msg", "수정되었습니다!");
        return "redirect:/mypage";
    }

    @RestController
    @RequestMapping("/mypage/region")
    public class FavoriteController {

        @Autowired
        private UserService userService; 
        
        @DeleteMapping("/{favoriteId}")
        public ResponseEntity<?> deleteFavoriteById(@PathVariable long favoriteId) {
            long result = userService.deleteFavoriteById(favoriteId);
            if(result > 0) {
                return ResponseEntity.ok(Collections.singletonMap("message", "삭제 성공"));
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                     .body(Collections.singletonMap("message", "삭제 실패"));
            }
        }
    }
    
 // 회원 탈퇴 페이지
    @GetMapping("/withdraw")
    public String withdrawPage(HttpSession session) {
        String user_id = (String) session.getAttribute("loginId");
        if (user_id == null) {
            return "redirect:/login";
        }
        
        return "memberWithdraw";
    }

    // 일반 회원 탈퇴 처리
    @PostMapping("/withdraw")
    public String withdrawProcess(
            @RequestParam String user_pw,
            HttpSession session,
            RedirectAttributes rttr) {
        
        String user_id = (String) session.getAttribute("loginId");
        if (user_id == null) {
            return "redirect:/login";
        }
        
        // 비밀번호 확인 후 탈퇴
        Map<String, String> param = new HashMap<>();
        param.put("user_id", user_id);
        param.put("user_pw", user_pw);
        
        int result = userService.withdraw(param);
        
        if (result > 0) {
            // 탈퇴 성공 - 세션 무효화
            session.invalidate();
            rttr.addFlashAttribute("msg", "회원 탈퇴가 완료되었습니다.");
            return "redirect:/";
        } else {
            // 비밀번호 불일치
            rttr.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "redirect:/mypage/withdraw";
        }
    }
}
