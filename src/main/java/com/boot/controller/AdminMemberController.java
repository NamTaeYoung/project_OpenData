package com.boot.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.StationDTO;
import com.boot.service.AdminMemberService;
import com.boot.util.AirQualityCalculator;
import com.boot.util.ExcelReader;

import javax.servlet.http.HttpSession;

@Controller
public class AdminMemberController {
    
    @Autowired
    private AdminMemberService adminMemberService;
    
    @Autowired
    private ExcelReader excelReader;
    
    @Autowired
    private AirQualityCalculator airQualityCalculator;
    
    // 회원 관리 목록 페이지
    @GetMapping("/memberManagement")
    public String memberManagement(HttpSession session, Model model) {
        // 관리자 권한 체크
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            return "redirect:/main";
        }
        
        List<Map<String, Object>> memberList = adminMemberService.getAllMembers();
        model.addAttribute("memberList", memberList);
        
        List<StationDTO> stations = excelReader.readStations();
        Map<String, StationDTO> cityAverages = airQualityCalculator.calculateCityAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
        
        return "admin/memberManagement";
    }
    
    // 회원 수정 페이지
    @GetMapping("/memberManagement/edit")
    public String editMemberForm(@RequestParam("user_id") String user_id, 
                                 HttpSession session, 
                                 Model model) {
        // 관리자 권한 체크
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            return "redirect:/main";
        }
        
        Map<String, Object> member = adminMemberService.getMemberById(user_id);
        if (member == null) {
            return "redirect:/memberManagement";
        }
        
        model.addAttribute("member", member);
        return "admin/memberEdit";
    }
    
    // 회원 수정 처리
    @PostMapping("/memberManagement/update")
    public String updateMember(@RequestParam Map<String, String> param,
                               HttpSession session) {
        // 관리자 권한 체크
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            return "redirect:/main";
        }
        
        int result = adminMemberService.updateMember(param);
        if (result > 0) {
            return "redirect:/memberManagement?success=update";
        } else {
            return "redirect:/memberManagement?error=update";
        }
    }
    
    // 회원 삭제 처리
    @PostMapping("/memberManagement/delete")
    public String deleteMember(@RequestParam("user_id") String user_id,
                               HttpSession session) {
        // 관리자 권한 체크
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            return "redirect:/main";
        }
        
        int result = adminMemberService.deleteMember(user_id);
        if (result > 0) {
            return "redirect:/memberManagement?success=delete";
        } else {
            return "redirect:/memberManagement?error=delete";
        }
    }
}
