package com.boot.client;

import com.boot.dto.TmCoordResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class KakaoLocalClient {

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${app.kakao.rest-key}")
    private String kakaoRestKey;

    public TmCoordResponse transcoordWgs84ToTm(double lon, double lat) {

        String url = "https://dapi.kakao.com/v2/local/geo/transcoord.json"
                + "?x=" + lon
                + "&y=" + lat
                + "&input_coord=WGS84"
                + "&output_coord=TM";

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + kakaoRestKey);

        HttpEntity<Void> entity = new HttpEntity<>(headers);

        ResponseEntity<TmCoordResponse> response =
                restTemplate.exchange(url, HttpMethod.GET, entity, TmCoordResponse.class);

        return response.getBody();
    }
}
