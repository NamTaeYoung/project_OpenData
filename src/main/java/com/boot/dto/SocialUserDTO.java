package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SocialUserDTO {
	private String id;          // 플랫폼별 고유 ID
    private String email;       // 이메일
    private String name;        // 이름
    private String nickname;    // 닉네임
    private String loginType;   // KAKAO / NAVER / GOOGLE

}
