package com.boot.dao;

import com.boot.dto.Admin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AdminDao {
    // 관리자 계정 조회 (아이디로)
    Admin findByUsername(@Param("username") String username);
    
    // 관리자 계정 조회 (아이디와 비밀번호로)
    Admin findByUsernameAndPassword(@Param("username") String username, 
                                   @Param("password") String password);
}