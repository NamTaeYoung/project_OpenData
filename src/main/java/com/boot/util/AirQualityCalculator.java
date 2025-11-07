package com.boot.util;

import com.boot.dto.StationDTO;
import java.util.*;

import org.springframework.stereotype.Component;

@Component
public class AirQualityCalculator {

    // 지역별 CAI 평균 계산
    public Map<String, StationDTO> calculateCityAverages(List<StationDTO> stations) {
        Map<String, List<StationDTO>> grouped = new HashMap<>();

        // 시/도 단위로 그룹화 (서울특별시, 부산광역시 등)
        for (StationDTO s : stations) {
            String cityKey = extractCityName(s.getStationName());
            grouped.computeIfAbsent(cityKey, k -> new ArrayList<>()).add(s);
        }
        
        List<String> cityOrder = Arrays.asList("서울", "부산", "대구", "인천", "광주", "대전", "울산", "제주");
        
        Map<String, StationDTO> result = new LinkedHashMap<>();

        // 각 도시별 평균 및 CAI 계산
        for (String city : cityOrder) {
            List<StationDTO> list = grouped.get(city);
            if (list == null || list.isEmpty()) continue;

            double avgPm10 = list.stream().mapToInt(StationDTO::getPm10Value).average().orElse(0);
            double avgPm25 = list.stream().mapToInt(StationDTO::getPm25Value).average().orElse(0);
            double avgO3 = list.stream().mapToDouble(StationDTO::getO3Value).average().orElse(0);
            double avgNo2 = list.stream().mapToDouble(StationDTO::getNo2Value).average().orElse(0);
            double avgCo = list.stream().mapToDouble(StationDTO::getCoValue).average().orElse(0);
            double avgSo2 = list.stream().mapToDouble(StationDTO::getSo2Value).average().orElse(0);

            int cai = Math.max(
                Math.max(gradePm10(avgPm10), gradePm25(avgPm25)),
                Math.max(Math.max(gradeO3(avgO3), gradeNo2(avgNo2)), Math.max(gradeCo(avgCo), gradeSo2(avgSo2)))
            );

            String gradeText = getGradeText(cai);

            StationDTO dto = new StationDTO();
            dto.setStationName(city);
            dto.setPm10Value((int) avgPm10);
            dto.setPm25Value((int) avgPm25);
            dto.setO3Value(avgO3);
            dto.setNo2Value(avgNo2);
            dto.setCoValue(avgCo);
            dto.setSo2Value(avgSo2);
            dto.setAddr(gradeText);

            result.put(city, dto);
        }

        return result;
    }

    // 시/도 이름만 추출 (예: "서울특별시 강남구" → "서울")
    private String extractCityName(String fullName) {
        if (fullName.startsWith("서울")) return "서울";
        if (fullName.startsWith("부산")) return "부산";
        if (fullName.startsWith("대구")) return "대구";
        if (fullName.startsWith("인천")) return "인천";
        if (fullName.startsWith("광주")) return "광주";
        if (fullName.startsWith("대전")) return "대전";
        if (fullName.startsWith("울산")) return "울산";
        if (fullName.startsWith("제주")) return "제주";
        return "기타";
    }

    // 지수 계산 (단순 등급화)
    private int gradePm10(double v) {
        if (v <= 30) return 50;
        if (v <= 80) return 100;
        if (v <= 150) return 250;
        return 500;
    }

    private int gradePm25(double v) {
        if (v <= 15) return 50;
        if (v <= 35) return 100;
        if (v <= 75) return 250;
        return 500;
    }

    private int gradeO3(double v) {
        if (v <= 0.03) return 50;
        if (v <= 0.09) return 100;
        if (v <= 0.15) return 250;
        return 500;
    }

    private int gradeNo2(double v) {
        if (v <= 0.03) return 50;
        if (v <= 0.06) return 100;
        if (v <= 0.20) return 250;
        return 500;
    }

    private int gradeCo(double v) {
        if (v <= 2.0) return 50;
        if (v <= 9.0) return 100;
        if (v <= 15.0) return 250;
        return 500;
    }

    private int gradeSo2(double v) {
        if (v <= 0.02) return 50;
        if (v <= 0.05) return 100;
        if (v <= 0.15) return 250;
        return 500;
    }

    private String getGradeText(int cai) {
        if (cai <= 50) return "좋음";
        if (cai <= 100) return "보통";
        if (cai <= 250) return "나쁨";
        return "매우나쁨";
    }
}
