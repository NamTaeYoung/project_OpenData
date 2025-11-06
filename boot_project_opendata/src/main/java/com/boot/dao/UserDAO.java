package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.UserDTO;

@Mapper
public interface UserDAO {
	String findNicknameByUserId(@Param("userId") String userId);
	
	public ArrayList<UserDTO> loginYn(HashMap<String, String> param);
	public void register(HashMap<String, String> param);
	// 특정 아이디로 사용자 조회 (로그인용 등)
	public List<UserDTO> findByUserId(String user_id);
	// 회원가입 (새 사용자 추가)
	public void insertUser(String user_id, String user_pw, String user_name, String user_email, String user_phone_num);
	// 회원 정보 수정
	public void updateUser(UserDTO user);
	// 회원 탈퇴
	public void deleteUser(String user_id);
	// 아이디 중복 체크
	public int checkId(String user_id);
	// 이메일 중복 체크
	public int checkEmail(String user_email);
	// 이메일로 아이디를 찾음
	public String findIdByEmail(String user_email);
	// 아이디, 이메일로 비밀번호를 찾음
	public String findPwByIdEmail(Map<String, String> param);
	// 사용자의 아이디와 생성된 토큰을 받아, 데이터베이스 토큰을 저장(사용자가 재설정할 권한이 있음을 증명)
	public int saveResetToken(Map<String, String> param);
	// 토큰으로 사용자 조회
	public UserDTO findUserByResetToken(String user_pwd_reset);
	// 토큰으로 비밀번호 업데이트
	public int updatePasswordByToken(Map<String, String> param);
	// 아이디로 회원 정보 조회(잠금 상태 확인, 세션용)
	public UserDTO getUserById(String user_id);
	// 로그인 시도 횟수 체크
	public void updateLoginFail(String user_id);
	// 로그인 실패 횟수 초기화
	public void resetLoginFail(String user_id);
	// 이메일로 기존 회원 조회
	public UserDTO getUserByEmail(String email);
	// 소셜 신규 회원 등록
	public void insertSocialUser(Map<String, String> param);
//    소셜 로그인 회원 탈퇴
//    public int withdrawSocial(Map<String, Object> param);
	// 내 정보 가져오기
	UserDTO getUserInfo(String user_id);
	//관심 지역 목록
	List<Map<String, Object>> getFavoriteList(String user_id);
	//관심 지역 목록 삭제
	long deleteFavoriteById(long favoriteId);
}
