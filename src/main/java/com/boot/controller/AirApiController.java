package com.boot.controller;

import com.boot.dto.StationDTO;
import com.boot.util.ExcelReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import java.util.*;

@RestController
@RequestMapping("/api/air")
@CrossOrigin(origins = "*")
public class AirApiController {
    
    @Autowired
    private ExcelReader excelReader;
    
    private List<StationDTO> cachedStations = null;  // 캐싱
    
    /**
     * 전국 측정소 목록 조회 (엑셀에서 읽기)
     */
    @GetMapping("/stations")
    public ResponseEntity<?> getAllStations() {
        try {
            // 캐싱: 한 번만 읽기
            if (cachedStations == null) {
                cachedStations = excelReader.readStations();
            }
            
            // API 응답 형식으로 변환
            Map<String, Object> response = new HashMap<>();
            Map<String, Object> header = new HashMap<>();
            header.put("resultCode", "00");
            header.put("resultMsg", "NORMAL_CODE");
            
            Map<String, Object> body = new HashMap<>();
            body.put("items", cachedStations);
            body.put("totalCount", cachedStations.size());
            
            Map<String, Object> wrapper = new HashMap<>();
            wrapper.put("header", header);
            wrapper.put("body", body);
            
            response.put("response", wrapper);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                Map.of("success", false, "message", "엑셀 데이터 로드 실패: " + e.getMessage())
            );
        }
    }
    
    /**
     * 측정소별 실시간 데이터 (엑셀에서 읽어온 실제 값 사용)
     */
    @GetMapping("/station/{stationName}")
    public ResponseEntity<?> getStationData(@PathVariable String stationName) {
        try {
            if (cachedStations == null) {
                cachedStations = excelReader.readStations();
            }
            
            // 측정소 찾기
            StationDTO station = cachedStations.stream()
                .filter(s -> s.getStationName().equals(stationName))
                .findFirst()
                .orElse(null);
            
            if (station == null) {
                return ResponseEntity.status(404).body(
                    Map.of("success", false, "message", "측정소를 찾을 수 없습니다: " + stationName)
                );
            }
            
            // 등급 계산
            String pm10Grade = getGradeFromValue(station.getPm10Value(), "PM10");
            String pm25Grade = getGradeFromValue(station.getPm25Value(), "PM25");
            String o3Grade = getO3Grade(station.getO3Value());
            String no2Grade = getNO2Grade(station.getNo2Value());
            
            Map<String, Object> item = new HashMap<>();
            item.put("stationName", station.getStationName());
            item.put("dataTime", "2025-11-04 14:00");
            item.put("pm10Value", String.valueOf(station.getPm10Value()));
            item.put("pm10Grade", pm10Grade);
            item.put("pm25Value", String.valueOf(station.getPm25Value()));
            item.put("pm25Grade", pm25Grade);
            item.put("o3Value", String.format("%.3f", station.getO3Value()));
            item.put("o3Grade", o3Grade);
            item.put("no2Value", String.format("%.3f", station.getNo2Value()));
            item.put("no2Grade", no2Grade);
            item.put("coValue", String.format("%.1f", station.getCoValue()));
            item.put("so2Value", String.format("%.3f", station.getSo2Value()));
            
            Map<String, Object> response = new HashMap<>();
            Map<String, Object> body = new HashMap<>();
            body.put("items", List.of(item));
            
            Map<String, Object> wrapper = new HashMap<>();
            wrapper.put("body", body);
            
            response.put("response", wrapper);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                Map.of("success", false, "message", "데이터 조회 실패: " + e.getMessage())
            );
        }
    }
    
    private String getGradeFromValue(int value, String type) {
        if (type.equals("PM10")) {
            if (value <= 30) return "1";
            if (value <= 80) return "2";
            if (value <= 150) return "3";
            return "4";
        } else {  // PM25
            if (value <= 15) return "1";
            if (value <= 35) return "2";
            if (value <= 75) return "3";
            return "4";
        }
    }
    
    private String getO3Grade(double value) {
        if (value <= 0.030) return "1";
        if (value <= 0.090) return "2";
        if (value <= 0.150) return "3";
        return "4";
    }
    
    private String getNO2Grade(double value) {
        if (value <= 0.030) return "1";
        if (value <= 0.060) return "2";
        if (value <= 0.200) return "3";
        return "4";
    }
    
    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        int count = cachedStations != null ? cachedStations.size() : 0;
        return ResponseEntity.ok(Map.of(
            "status", "OK",
            "message", "엑셀 기반 실제 데이터 모드",
            "mode", "EXCEL_DATA",
            "stationCount", count
        ));
    }
}
