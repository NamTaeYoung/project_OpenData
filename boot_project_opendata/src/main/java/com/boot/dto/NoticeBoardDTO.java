package com.boot.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

@Data
public class NoticeBoardDTO {

    private Long noticeNo;           // 게시글 번호 (PK)
    private String userId;           // 작성자 (관리자 계정 or 사용자)
    private String noticeTitle;      // 제목
    private String noticeContent;    // 내용

    // ✅ DB: TIMESTAMP → JSON 직렬화 시 형식 지정
    @JsonFormat(shape = JsonFormat.Shape.STRING,
                pattern = "yyyy-MM-dd HH:mm",
                timezone = "Asia/Seoul")
    private LocalDateTime noticeDate;  // 작성일시

    private Integer noticeHit;        // 조회수
    private String noticeImage;       // 대표 이미지 경로 (선택)
    private String userNickname;      // 작성자 닉네임 (JOIN용)

    // ✅ 화면(JSP) 표시용 포맷 메서드
    @JsonIgnore
    public String getFormattedDate() {
        if (noticeDate == null) return "";
        return noticeDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        // 초까지 표시하려면 "yyyy-MM-dd HH:mm:ss"
    }
}
