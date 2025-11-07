package com.boot.dto;

import lombok.Data;

@Data
public class BoardAttachDTO {
    private Long attachNo;
    private Long boardNo;
    private String fileName;
    private String filePath;
    private String uuid;
    private String isImage;     // 'Y' or 'N'
    private String thumbPath;   // 썸네일 URL
    private Integer sortOrder;  // 대표=0, 그 외=1,2,...
}