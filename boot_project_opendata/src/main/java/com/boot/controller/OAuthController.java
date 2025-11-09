package com.boot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.UserDTO;
import com.boot.dto.SocialUserDTO;
import com.boot.service.SocialLoginService;
import com.boot.service.UserService;

@Controller
@RequestMapping("/oauth")
public class OAuthController {

    @Autowired
    private UserService userService;

    @Autowired @Qualifier("kakaoLoginService")
    private SocialLoginService kakaoService;

    @Autowired @Qualifier("naverLoginService")
    private SocialLoginService naverService;

    @Autowired @Qualifier("googleLoginService")
    private SocialLoginService googleService;

    @RequestMapping("/{provider}")
    public String socialLogin(@PathVariable String provider,
                              @RequestParam("code") String code,
                              HttpSession session) {

        // 서비스 선택
    	SocialLoginService service;

    	if ("kakao".equalsIgnoreCase(provider)) {
    	    service = kakaoService;
    	} 
    	 else if ("naver".equalsIgnoreCase(provider)) {
    	     service = naverService;
    	 } 
    	 else if ("google".equalsIgnoreCase(provider)) {
    	     service = googleService;
    	 } 
    	else {
    	    throw new IllegalArgumentException("지원하지 않는 로그인 방식입니다.");
    	}

        // Access Token 발급
        String token = service.getAccessToken(code);

        // 사용자 정보
        SocialUserDTO userInfo = service.getUserInfo(token);
        String email = userInfo.getEmail();
        
        // 기존 회원 조회
        UserDTO existing = userService.getUserByEmail(email);

        if (existing != null) {
            // 이미 존재하는 이메일이면
            String existingType = existing.getLogin_type();

            if (existingType != null && existingType.equalsIgnoreCase(userInfo.getLoginType())) {
                // 같은 플랫폼 → 로그인 허용
                session.setAttribute("loginId", existing.getUser_id());
                session.setAttribute("loginDisplayName", existing.getUser_name());
                session.setAttribute("loginDisplayNickName", existing.getUser_nickname()); // ✅ 닉네임 추가
                session.setAttribute("loginType", existingType);
                return "redirect:/main";
            } else {
                // 다른 플랫폼이거나 일반회원 → 로그인 차단
                String typeName = (existingType == null) ? "일반 회원" : existingType;
                session.setAttribute("socialLoginError",
                    "이미 다른 플랫폼(" + typeName + ")으로 가입된 이메일입니다. "
                    + userInfo.getLoginType() + " 로그인을 사용할 수 없습니다.");
                return "redirect:/login";
            }
        }

        // 신규 카카오 회원 등록
        Map<String, String> map = new HashMap<String,String>();
        map.put("user_id", userInfo.getLoginType().toLowerCase() + "_" + userInfo.getId());
        map.put("user_email", email);
        map.put("user_name", userInfo.getName());
        map.put("user_nickname", userInfo.getNickname());
        map.put("login_type", userInfo.getLoginType());
        map.put("social_id", userInfo.getId());
        map.put("user_phone_num", "000-0000-0000");

        userService.insertSocialUser(map);

        // 세션 저장
        session.setAttribute("loginId", map.get("user_id"));
        session.setAttribute("loginDisplayName", userInfo.getName());
        session.setAttribute("loginDisplayNickName", userInfo.getNickname()); // ✅ 닉네임 추가     
        session.setAttribute("loginType", map.get("login_type"));
        return "redirect:/main";
    }
}
