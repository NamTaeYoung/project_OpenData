package com.boot.service;

import com.boot.dto.SocialUserDTO;

public interface SocialLoginService {
	public String getAccessToken(String code);
	public SocialUserDTO getUserInfo(String accessToken);
}
