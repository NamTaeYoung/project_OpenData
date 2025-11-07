package com.boot.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.boot.dto.SocialUserDTO;

/**
 * ✅ 구글 소셜 로그인 서비스
 * 1. 인가코드(code)로 AccessToken 발급
 * 2. AccessToken으로 사용자 정보 요청
 */
@Service("googleLoginService")
public class GoogleLoginServiceImpl implements SocialLoginService {

    @Value("${google.client.id}")
    private String clientId;

    @Value("${google.client.secret}")
    private String clientSecret;

    @Value("${google.redirect.uri}")
    private String redirectUri;


    @Override
    public String getAccessToken(String code) {
        String tokenUrl = "https://oauth2.googleapis.com/token";

        // 요청 파라미터
        MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("redirect_uri", redirectUri);
        params.add("code", code);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/x-www-form-urlencoded");

        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<MultiValueMap<String, String>>(params, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(tokenUrl, request, String.class);

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode node = mapper.readTree(response.getBody());
            return node.get("access_token").asText();
        } catch (Exception e) {
            throw new RuntimeException("구글 토큰 발급 실패: " + e.getMessage());
        }
    }

    @Override
    public SocialUserDTO getUserInfo(String accessToken) {
        String userInfoUrl = "https://www.googleapis.com/oauth2/v2/userinfo";

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response =
                restTemplate.exchange(userInfoUrl, HttpMethod.GET, new HttpEntity<String>(headers), String.class);

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(response.getBody());

            SocialUserDTO dto = new SocialUserDTO();
            dto.setId(json.get("id").asText());
            dto.setEmail(json.get("email").asText());
            dto.setName(json.has("name") ? json.get("name").asText() : json.get("email").asText());
            dto.setNickname(json.has("given_name") ? json.get("given_name").asText() : "GoogleUser");
            dto.setLoginType("GOOGLE");

            System.out.println("구글 사용자 정보: " + dto.getEmail());
            return dto;
        } catch (Exception e) {
            throw new RuntimeException("구글 사용자 정보 조회 실패: " + e.getMessage());
        }
    }
}
