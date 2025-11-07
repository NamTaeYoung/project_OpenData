package com.boot.dao;

import java.util.List;
import java.util.Map;

public interface AdminMemberDAO {
    
    // 전체 회원 목록 조회
    List<Map<String, Object>> getAllMembers();
    
    // 회원 상세 정보 조회
    Map<String, Object> getMemberById(String user_id);
    
    // 회원 정보 수정
    int updateMember(Map<String, String> param);
    
    // 회원 삭제
    int deleteMember(String user_id);
}