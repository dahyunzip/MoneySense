package com.itwillbs.mapper;

import com.itwillbs.domain.MemberVO;

public interface MemberMapper {
	
	// 이메일로 회원 조회 (Spring Security 로그인용)
	MemberVO selectMemberByEmail(String email);
	
	// 회원 가입
	int insertMember(MemberVO member);
	
	// 회원 권한 등록
	int insertMemberAuth(int memberId);
	
	// 이메일 중복 체크
	int checkEmailDuplicate(String email);
}
