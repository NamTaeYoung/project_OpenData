package com.boot.dto;

import lombok.Data;

@Data
public class NoticeBoardAttachDTO {

    private Long attachNo;       // 첨부파일 번호 (PK)
    private Long noticeNo;       // 공지사항 번호 (FK → notice_board.notice_no)
    private String fileName;     // 원본 파일명
    private String filePath;     // 서버 저장 경로
    private String uuid;         // UUID (파일 중복 방지용)
    private String isImage;      // 'Y' or 'N' (이미지 여부)
    private String thumbPath;    // 썸네일 경로 (이미지일 경우)
    private Integer sortOrder;   // 대표=0, 그 외=1,2,...
}
