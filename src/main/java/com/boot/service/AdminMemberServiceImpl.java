package com.boot.service;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminMemberServiceImpl implements AdminMemberService {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public List<Map<String, Object>> getAllMembers() {
        return sqlSession.selectList("com.boot.dao.AdminMemberDAO.getAllMembers");
    }

    @Override
    public Map<String, Object> getMemberById(String user_id) {
        return sqlSession.selectOne("com.boot.dao.AdminMemberDAO.getMemberById", user_id);
    }

    @Override
    public int updateMember(Map<String, String> param) {
        return sqlSession.update("com.boot.dao.AdminMemberDAO.updateMember", param);
    }

    @Override
    public int deleteMember(String user_id) {
        return sqlSession.delete("com.boot.dao.AdminMemberDAO.deleteMember", user_id);
    }
}