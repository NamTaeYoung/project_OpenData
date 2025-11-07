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
 * 네이버 소셜 로그인용 서비스 구현체
 * 1. 인가코드(code) → AccessToken 요청
 * 2. AccessToken → 사용자 정보 요청
 */
@Service("naverLoginService")
public class NaverLoginServicelmpl implements SocialLoginService {

    // 네이버 개발자 등록 후 받은 Client ID / Secret
    @Value("${naver.client.id}")
    private String clientId;

    @Value("${naver.client.secret}")
    private String clientSecret;

    @Value("${naver.redirect.uri}")
    private String redirectUri;


    /**
     * 인가 코드(code)를 사용해 Access Token 발급
     */
    @Override
    public String getAccessToken(String code) {
        String tokenUrl = "https://nid.naver.com/oauth2.0/token";

        // 요청 파라미터
        MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("code", code);

        // 헤더
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

        // 요청 엔티티
        HttpEntity<MultiValueMap<String, String>> request =
                new HttpEntity<MultiValueMap<String, String>>(params, headers);

        // 요청 실행
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.postForEntity(tokenUrl, request, String.class);

        // JSON 파싱
        JsonObject json = JsonParser.parseString(response.getBody()).getAsJsonObject();
        String accessToken = json.get("access_token").getAsString();

        System.out.println("네이버 AccessToken 발급 완료: " + accessToken);
        return accessToken;
    }

    /**
     * AccessToken으로 사용자 정보 조회
     */
    @Override
    public SocialUserDTO getUserInfo(String accessToken) {
        String userInfoUrl = "https://openapi.naver.com/v1/nid/me";

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

        HttpEntity<String> entity = new HttpEntity<String>(headers);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response =
                restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

        JsonObject json = JsonParser.parseString(response.getBody()).getAsJsonObject();
        JsonObject responseObj = json.getAsJsonObject("response");

        // ✅ 사용자 정보 추출
        String id = responseObj.get("id").getAsString();
        String email = responseObj.has("email") ? responseObj.get("email").getAsString() : "no_email@naver.com";
        String nickname = responseObj.has("nickname") ? responseObj.get("nickname").getAsString() : "네이버유저";
        String name = responseObj.has("name") ? responseObj.get("name").getAsString() : nickname;

        SocialUserDTO dto = new SocialUserDTO();
        dto.setId(id);
        dto.setEmail(email);
        dto.setName(name);
        dto.setNickname(nickname);
        dto.setLoginType("NAVER");

        System.out.println("네이버 사용자 정보: " + name + " / " + email);
        return dto;
    }
}
