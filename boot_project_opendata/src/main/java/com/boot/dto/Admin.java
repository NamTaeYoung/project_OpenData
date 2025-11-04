package com.boot.dto;

import lombok.Data;
import java.util.Date;

@Data
public class Admin {
    private Long id;
    private String username;
    private String password;
    private String name;
    private String email;
    private Integer isActive;  // 0: 비활성, 1: 활성
    private Date createdAt;
    private Date updatedAt;
    
    public boolean isActive() {
        return this.isActive != null && this.isActive == 1;
    }
}