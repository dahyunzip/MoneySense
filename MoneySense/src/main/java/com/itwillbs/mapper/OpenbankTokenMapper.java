package com.itwillbs.mapper;

import com.itwillbs.domain.OpenbankTokenVO;

public interface OpenbankTokenMapper {
	
	// 토큰 정보 저장
	public int insertToken(OpenbankTokenVO token);
	
	// 회원의 토큰 정보 조회
	public OpenbankTokenVO selectTokenByMemberId(int memberId);
	
	// 토큰 정보 업데이트
	public int updateToken(OpenbankTokenVO token);
	
	// 토큰 삭제
	public int deleteToken(int memberId);
}
