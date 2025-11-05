package com.boot.dto;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    // NUMBER PRIMARY KEY
    private Long boardNo;

    // VARCHAR2(60) NOT NULL (FK: users.user_id)
    private String userId;

    // VARCHAR2(100) NOT NULL
    private String boardTitle;

    // VARCHAR2(300) NOT NULL
    private String boardContent;

    // TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime boardDate;

    // NUMBER DEFAULT 0 NOT NULL
    private Integer boardHit;

    // VARCHAR2(300) NULL
    private String boardImage;
    
    private String userNickname;
    
    @JsonIgnore
    public String getFormattedDate() {
        if (boardDate == null) return "";
        return boardDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }
}
