package com.itwillbs.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.AILogVO;

public interface AILogMapper {
	// 챗봇 로그 저장
	void insertChatLog(AILogVO log);
	
	// 회원의 챗봇 이력 조회 (최근N개)
	List<AILogVO> selectChatHistory(
			@Param("memberId") int memberId,
			@Param("limit") int limit
			);
	
	// 특정 로그 조회
	AILogVO selectLogById(@Param("aiLogId") int aiLogId);
	
	// 회원의 특정 기간 로그 조회
	List<AILogVO> selectLogsByPeriod(
			@Param("memberId") int memberId,
			@Param("logType") String logType,
			@Param("analysisPeriod") String analysisPeriod
			);
	
	// 로그 삭제
	void deleteLog(@Param("aiLogId") int aiLogId);
	
	// 회원의 모든 로그 삭제
	void deleteLogsByMemberId(@Param("memberId") int memberId);
}
