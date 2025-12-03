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
	
	// 마이페이지 관련 메서드
	// memberId로 회원 정보 조회
	MemberVO selectMemberById(int memberId);
	
	// 회원 이름 수정
	int updateMemberName(MemberVO member);
	
	// 회원 비밀번호 수정
	int updateMemberPassword(MemberVO member);
	
	// 회원 탈퇴(soft delete)
	int deleteMember(int memberId);
	
}
