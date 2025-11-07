package com.boot.service;

import com.boot.dao.AdminDao;
import com.boot.dto.Admin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminService {
    
    @Autowired
    private AdminDao adminDao;
    
    // 관리자 계정 조회
    public Admin findByUsername(String username) {
        return adminDao.findByUsername(username);
    }
    
    // 관리자 로그인 검증
    public Admin authenticate(String username, String password) {
        Admin admin = adminDao.findByUsername(username);
        if (admin != null && password.equals(admin.getPassword())) {
            return admin;
        }
        return null;
    }
}