package com.boot.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
	private String user_id;
	private String user_pw;
	private String user_email;
	private String user_email_chk;
    private String user_phone_num;
    private String user_post_num;
    private String user_address;
    private String user_detail_address;
    private String user_name;
    private String user_nickname;
    private String user_pwd_reset;
    private int login_fail_count;
    private Date last_fail_time;
    private Date reg_date;
    private Date last_login_date;
    private String login_type;
    private String social_id;
}
