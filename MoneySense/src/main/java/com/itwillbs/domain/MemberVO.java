package com.itwillbs.domain;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	private int memberId;
	private String email;
	private String password;
	private String name;
	private int agreePrivacy;
	private int agreeOpenbank;
	private Timestamp joinedAt;
	private Timestamp updatedAt;
	private int isDeleted;
	
	// 권한 정보 (member_auth 테이블 조인)
	private List<MemberAuthVO> authList;
}
