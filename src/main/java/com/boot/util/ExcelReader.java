package com.boot.util;

import com.boot.dto.StationDTO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;  // ✅ .xls용
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Component
public class ExcelReader {
    
    /**
     * 엑셀 파일에서 측정소 데이터 읽기 (.xls 형식)
     */
    public List<StationDTO> readStations() {
        List<StationDTO> stations = new ArrayList<>();
        
        try {
            ClassPathResource resource = new ClassPathResource("data/stations.xls");
            InputStream inputStream = resource.getInputStream();
            
            // ✅ .xls 형식은 HSSFWorkbook 사용
            Workbook workbook = new HSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0);
            
            System.out.println("📄 엑셀 시트명: " + sheet.getSheetName());
            System.out.println("📊 총 행 수: " + sheet.getLastRowNum());
            
            // 헤더 행 건너뛰기 (row 0)
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                String stationName = getCellValue(row.getCell(0));  // 지역
                Double dmY = getCellValueAsDouble(row.getCell(1));  // 위도
                Double dmX = getCellValueAsDouble(row.getCell(2));  // 경도
                Integer pm10 = getCellValueAsInt(row.getCell(3));   // PM10
                Integer pm25 = getCellValueAsInt(row.getCell(4));   // PM2.5
                Double o3 = getCellValueAsDouble(row.getCell(5));   // 오존
                Double no2 = getCellValueAsDouble(row.getCell(6));  // 이산화질소
                Double co = getCellValueAsDouble(row.getCell(7));   // 일산화탄소
                Double so2 = getCellValueAsDouble(row.getCell(8));  // 아황산가스
                
                StationDTO station = new StationDTO();
                station.setStationName(stationName);
                station.setDmY(dmY);
                station.setDmX(dmX);
                station.setAddr(stationName);  // 주소는 지역명 그대로 사용
                station.setPm10Value(pm10);
                station.setPm25Value(pm25);
                station.setO3Value(o3);
                station.setNo2Value(no2);
                station.setCoValue(co);
                station.setSo2Value(so2);
                
                stations.add(station);
            }
            
            workbook.close();
            inputStream.close();
            
            System.out.println("✅ 엑셀에서 " + stations.size() + "개 측정소 로드 완료");
            
        } catch (Exception e) {
            System.err.println("❌ 엑셀 파일 읽기 실패: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stations;
    }
    
    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                return String.valueOf((int) cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }
    
    private Double getCellValueAsDouble(Cell cell) {
        if (cell == null) return 0.0;
        
        switch (cell.getCellType()) {
            case NUMERIC:
                return cell.getNumericCellValue();
            case STRING:
                try {
                    return Double.parseDouble(cell.getStringCellValue());
                } catch (Exception e) {
                    return 0.0;
                }
            default:
                return 0.0;
        }
    }
    
    private Integer getCellValueAsInt(Cell cell) {
        if (cell == null) return 0;
        
        switch (cell.getCellType()) {
            case NUMERIC:
                return (int) cell.getNumericCellValue();
            case STRING:
                try {
                    return Integer.parseInt(cell.getStringCellValue());
                } catch (Exception e) {
                    return 0;
                }
            default:
                return 0;
        }
    }
}
