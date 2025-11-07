package com.boot.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

@Data
public class BoardDTO {
    private Long boardNo;
    private String userId;
    private String boardTitle;
    private String boardContent;

    // ✅ DB: TIMESTAMP; API(JSON)로 내보낼 때 형식 지정
    @JsonFormat(shape = JsonFormat.Shape.STRING,
                pattern = "yyyy-MM-dd HH:mm",  // 초가 필요하면 "yyyy-MM-dd HH:mm:ss"
                timezone = "Asia/Seoul")
    private LocalDateTime boardDate;

    private Integer boardHit;
    private String boardImage;
    private String userNickname;

    // ✅ 화면(JSP) 표시용: 안전하고 가벼운 포맷터 사용
    @JsonIgnore // JSON 응답에 이 문자열을 포함시키지 않으려면 유지
    public String getFormattedDate() {
        if (boardDate == null) return "";
        return boardDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        // 초가 필요하면 "yyyy-MM-dd HH:mm:ss"
    }
}
