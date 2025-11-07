package com.boot.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class FavoriteStationDTO {
    private Long favoriteId;
    private String userId;

    private String stationName;  // 지역
    private Double dmY;          // 위도
    private Double dmX;          // 경도

    // 대기질 데이터
    private Integer pm10Value;   // PM10
    private Integer pm25Value;   // PM2.5
    private Double o3Value;      // 오존
    private Double no2Value;     // 이산화질소
    private Double coValue;      // 일산화탄소
    private Double so2Value;     // 아황산가스

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
