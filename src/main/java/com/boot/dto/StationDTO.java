package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StationDTO {
    private String stationName;  // 지역
    private Double dmY;          // 위도
    private Double dmX;          // 경도
    private String addr;         // 주소 (지역명 그대로 사용)
    
    // 대기질 데이터
    private Integer pm10Value;   // PM10
    private Integer pm25Value;   // PM2.5
    private Double o3Value;      // 오존
    private Double no2Value;     // 이산화질소
    private Double coValue;      // 일산화탄소
    private Double so2Value;     // 아황산가스
}
