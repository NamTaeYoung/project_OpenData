package com.boot.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SocialRedirectController {

    @Value("${kakao.client.id}")
    private String kakaoClientId;

    @Value("${kakao.redirect.uri}")
    private String kakaoRedirectUri;

    @Value("${naver.client.id}")
    private String naverClientId;

    @Value("${naver.redirect.uri}")
    private String naverRedirectUri;

    @Value("${google.client.id}")
    private String googleClientId;

    @Value("${google.redirect.uri}")
    private String googleRedirectUri;

    // ✅ 카카오 리디렉트
    @GetMapping("/oauth/kakao/login")
    public String kakaoLogin() {
        String url = "https://kauth.kakao.com/oauth/authorize"
                + "?client_id=" + kakaoClientId
                + "&redirect_uri=" + kakaoRedirectUri
                + "&response_type=code";
        return "redirect:" + url;
    }

    // ✅ 네이버 리디렉트
    @GetMapping("/oauth/naver/login")
    public String naverLogin() {
        String state = "random1234"; // 보안용 state (랜덤 문자열 추천)
        String url = "https://nid.naver.com/oauth2.0/authorize"
                + "?response_type=code"
                + "&client_id=" + naverClientId
                + "&redirect_uri=" + naverRedirectUri
                + "&state=" + state;
        return "redirect:" + url;
    }

    // ✅ 구글 리디렉트
    @GetMapping("/oauth/google/login")
    public String googleLogin() {
        String url = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + googleClientId
                + "&redirect_uri=" + googleRedirectUri
                + "&response_type=code"
                + "&scope=email%20profile"
                + "&access_type=offline"
                + "&prompt=consent";
        return "redirect:" + url;
    }
}
