package com.boot.dto;
import lombok.*;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class StationListItem {
    private Long stationId;
    private String name;
    private Double lat;   // WGS84
    private Double lon;   // WGS84
    private Integer pm10; // 최근값(옵션)
    private Integer pm25; // 최근값(옵션)
}