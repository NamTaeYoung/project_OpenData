package com.boot.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.boot.dto.SocialUserDTO;

/**
 * 카카오 소셜 로그인용 서비스 구현체
 * 1. 인가코드(code) → AccessToken 요청
 * 2. AccessToken → 사용자 정보 요청
 */
@Service("kakaoLoginService")
public class KaKaoLoginServiceImpl implements SocialLoginService {

    // 🔑 카카오 개발자 REST API 키 (본인 앱에서 발급받은 키로 교체)
    @Value("${kakao.client.id}")
    private String clientId;

    @Value("${kakao.redirect.uri}")
    private String redirectUri;

    /**
     * 인가 코드(code)를 사용해 Access Token 발급
     */
    @Override
    public String getAccessToken(String code) {
        String tokenUrl = "https://kauth.kakao.com/oauth/token";

        // 요청 파라미터 세팅
        MultiValueMap<String, String> params = new LinkedMultiValueMap<String,String>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("redirect_uri", redirectUri);
        params.add("code", code);

        // 헤더 + 요청 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<MultiValueMap<String, String>>(params, headers);

        // API 요청
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.postForEntity(tokenUrl, request, String.class);

        // JSON 파싱 (AccessToken 추출)
        JsonObject json = JsonParser.parseString(response.getBody()).getAsJsonObject();
        String accessToken = json.get("access_token").getAsString();

        System.out.println("카카오 AccessToken 발급 완료: " + accessToken);
        return accessToken;
    }

    /**
     * AccessToken으로 사용자 정보 조회
     */
    @Override
    public SocialUserDTO getUserInfo(String accessToken) {
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        HttpEntity<String> entity = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response =
                restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

        JsonObject json = JsonParser.parseString(response.getBody()).getAsJsonObject();
        JsonObject kakaoAccount = json.getAsJsonObject("kakao_account");
        JsonObject profile = kakaoAccount.getAsJsonObject("profile");

        // ✅ 사용자 정보 추출
        String id = json.get("id").getAsString();
        String email = kakaoAccount.has("email") ? kakaoAccount.get("email").getAsString() : "no_email@kakao.com";
        String nickname = profile.has("nickname") ? profile.get("nickname").getAsString() : "카카오유저";

        SocialUserDTO dto = new SocialUserDTO();
        dto.setId(id);
        dto.setEmail(email);
        dto.setName(nickname);
        dto.setNickname(nickname);
        dto.setLoginType("KAKAO");

        System.out.println("카카오 사용자 정보: " + nickname + " / " + email);
        return dto;
    }
}
