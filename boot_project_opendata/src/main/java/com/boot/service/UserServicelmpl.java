package com.boot.service;

import java.util.Map;
import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.FavoriteStationDAO;
import com.boot.dao.UserDAO;
import com.boot.dto.FavoriteStationDTO;
import com.boot.dto.UserDTO;

@Service
public class UserServicelmpl implements UserService {

	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
    private UserDAO userDAO;

	/** 로그인 검증: users.user_pw를 읽어와 비교 (현 상태 유지) */
	public boolean loginYn(Map<String, String> param) {
		// mapper: loginYn -> 비밀번호만 조회
		String dbPw = (String) sqlSession.selectOne("com.boot.dao.UserDAO.loginYn", param);
		if (dbPw == null)
			return false;
		String inputPw = param.get("user_pw");
		return dbPw.equals(inputPw);
	}

	/** 마이페이지 조회 */
	public Map<String, Object> getUser(String userId) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("user_id", userId);
		return sqlSession.selectOne("com.boot.dao.UserDAO.selectUser", m);
	}

	/** 마이페이지 수정 - 비밀번호 NULL 처리 추가 */
	public int updateUser(Map<String, String> param) {
	    // ✅ 비밀번호가 비어있거나 NULL인 경우 기존 비밀번호 유지
	    String userPw = param.get("user_pw");
	    
	    if (userPw == null || userPw.trim().isEmpty()) {
	        // 기존 사용자 정보 조회
	        String userId = param.get("user_id");
	        Map<String, Object> existingUser = getUser(userId);
	        
	        if (existingUser != null && existingUser.get("user_pw") != null) {
	            // 기존 비밀번호를 param에 설정
	            param.put("user_pw", (String) existingUser.get("user_pw"));
	        }
	    }
	    
	    return sqlSession.update("com.boot.dao.UserDAO.updateUser", param);
	}


	/** 회원가입 로직 */
	public int register(Map<String, String> param) {
		// User.xml 의 <insert id="register"> 문 실행
		return sqlSession.insert("com.boot.dao.UserDAO.register", param);
	}

	public int withdraw(Map<String, String> param) {
		// 비번 일치하면 1, 아니면 0
		return sqlSession.delete("com.boot.dao.UserDAO.withdraw", param);
	}

	@Override
	public int withdrawSocial(Map<String, Object> param) {
		return sqlSession.delete("com.boot.dao.UserDAO.withdrawSocial", param);
	}

	// 아이디 중복 체크
	@Override
	public int checkId(String id) {
		return sqlSession.selectOne("com.boot.dao.UserDAO.checkId", id);
	}

	// 아이디로 회원 조회
	@Override
	public UserDTO getUserById(String user_id) {
		return sqlSession.selectOne("com.boot.dao.UserDAO.getUserById", user_id);
	}

	// 로그인 시도 횟수 체크
	@Override
	public void updateLoginFail(String user_id) {
		sqlSession.update("com.boot.dao.UserDAO.updateLoginFail", user_id);
	}

	// 로그인 시도횟수 초기화
	@Override
	public void resetLoginFail(String user_id) {
		sqlSession.update("com.boot.dao.UserDAO.resetLoginFail", user_id);
	}

	// 이메일로 회원 조회
	@Override
	public UserDTO getUserByEmail(String email) {
		return sqlSession.selectOne("com.boot.dao.UserDAO.getUserByEmail", email);
	}

	// 소셜 로그인 회원 등록
	@Override
	public void insertSocialUser(Map<String, String> param) {
		sqlSession.insert("com.boot.dao.UserDAO.insertSocialUser", param);
	}

	// 이메일로 아이디 찾기
	@Override
	public String findIdByEmail(String email) {
		return sqlSession.selectOne("com.boot.dao.UserDAO.findIdByEmail", email);
	}

	// 아이디, 이메일로 비밀번호 찾기
	@Override
	public String findPwByIdEmail(Map<String, String> param) {
		return sqlSession.selectOne("com.boot.dao.UserDAO.findPwByIdEmail", param);
	}

	// 비밀번호 재설정 토큰 저장
	@Override
	public int saveResetToken(Map<String, String> param) {
		return sqlSession.update("com.boot.dao.UserDAO.saveResetToken", param);
	}

	// 토큰으로 사용자 조회
	@Override
	public UserDTO findUserByResetToken(String token) {
		return sqlSession.selectOne("com.boot.dao.UserDAO.findUserByResetToken", token);
	}

	// 토큰으로 비밀번호 업데이트
	@Override
	public int updatePasswordByToken(Map<String, String> param) {
		return sqlSession.update("com.boot.dao.UserDAO.updatePasswordByToken", param);
	}
	
	// userId로 닉네임을 가져오는 메서드
    public String getNicknameByUserId(String userId) {
        return userDAO.findNicknameByUserId(userId);  // UserDAO를 통해 닉네임 조회
    }

	@Autowired
    private FavoriteStationDAO favoriteStationDAO;

    @Override
    public List<FavoriteStationDTO> getFavoriteList(String user_id) {
        return favoriteStationDAO.getFavoriteList(user_id);
    }

    @Override
    public int deleteFavoriteById(Long favoriteId) {
        return favoriteStationDAO.deleteFavoriteById(favoriteId);
    }
}
