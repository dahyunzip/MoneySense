package com.itwillbs.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.AIInsightVO;

public interface AIInsightMapper {
	// 인사이트 저장
	void insertInsight(AIInsightVO insight);
	
	// 회원의 최신 인사이트 조회
	List<AIInsightVO> selectRecentInsights(
			@Param("memberId") int memberId,
			@Param("limit") int limit
			);
	
	// 특정 기간 인사이트 조회
	AIInsightVO selectInsightByPeriod(
			@Param("memberId") int memberId,
			@Param("insightType") String insightType,
			@Param("period") String period
			);
	
	// 특정 카테고리 인사이트 조회
    AIInsightVO selectCategoryInsight(
        @Param("memberId") int memberId,
        @Param("period") String period,
        @Param("category") String category
    );
	
	// 월간 인사이트 목록
	List<AIInsightVO> selectMonthlyInsights(
			@Param("memberId") int memberId,
			@Param("year") int year
			);
	
	// 주간 인사이트 목록
	List<AIInsightVO> selectWeeklyInsights(
			@Param("memberId") int memberId,
			@Param("year") int year,
			@Param("month") int month
			);
	
	// 인사이트 존재 확인
	int existsInsight(
			@Param("memberId") int memberId,
			@Param("insightType") String insightType,
			@Param("period") String period,
			@Param("category") String category
			);
	
	// 인사이트 업데이트
	void updateInsight(AIInsightVO insight);
	
	// 인사이트 삭제
	void deleteInsight(@Param("insightId") int insightId);

}
