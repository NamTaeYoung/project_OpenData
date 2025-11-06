package com.boot.service;

import java.util.List;
import java.util.Map;

import com.boot.dto.UserDTO;

public interface UserService {
	public String getNicknameByUserId(String userId);
	
	// 로그인 검증
	boolean loginYn(Map<String, String> param);

	// 회원가입
	int register(Map<String, String> param);

	// 마이페이지 조회
	Map<String, Object> getUser(String userId);

    // 마이페이지 수정 
    int updateUser(Map<String, String> param);

    // 회원 탈퇴
    int withdraw(Map<String, String> param);

	// 소셜 로그인 회원 탈퇴
	int withdrawSocial(Map<String, Object> param);

	// 아이디 중복 체크
	int checkId(String id);

	// 아이디로 회원 정보 조회
	UserDTO getUserById(String user_id);

	// 로그인 시도횟수 체크
	void updateLoginFail(String user_id);

	// 로그인 시도횟수 초기화
	void resetLoginFail(String user_id);

	// 이메일로 기존 회원 조회
	UserDTO getUserByEmail(String email);

	// 소셜 신규 회원 등록
	void insertSocialUser(Map<String, String> param);

	// 이메일로 아이디 찾기
	String findIdByEmail(String email);

	// 아이디, 이메일로 비밀번호 찾기
	String findPwByIdEmail(Map<String, String> param);

	// 비밀번호 재설정 토큰 저장
	int saveResetToken(Map<String, String> param);

	// 토큰으로 사용자 조회
	UserDTO findUserByResetToken(String token);

	// 토큰으로 비밀번호 업데이트
	int updatePasswordByToken(Map<String, String> param);
	
	//관심 지역 목록
	List<com.boot.dto.FavoriteStationDTO> getFavoriteList(String user_id);
	
	// 관심지역 삭제
	int deleteFavoriteById(Long favoriteId);
}
