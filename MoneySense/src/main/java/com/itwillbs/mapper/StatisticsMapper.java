package com.itwillbs.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface StatisticsMapper {

	// 이 달의 카테고리별 지출
	List<Map<String, Object>> selectMonthlyCategoryExpense(
        @Param("memberId") int memberId,
        @Param("year") int year,
        @Param("month") int month
    );
	
	// 주간 지출 추세 (최근 4주)
	List<Map<String, Object>> selectWeeklyExpenseTrend(
        @Param("memberId") int memberId,
        @Param("weeks") int weeks
    );
	
	// 월별 소비 트렌드 (최근 6개월)
    List<Map<String, Object>> selectMonthlyExpenseTrend(
        @Param("memberId") int memberId,
        @Param("months") int months
    );
	
	// 카테고리별 전월 대비 증감률
    List<Map<String, Object>> selectCategoryChangeRate(
        @Param("memberId") int memberId,
        @Param("year") int year,
        @Param("month") int month
    );
    
    // 이번 달 총 지출
    Map<String, Object> selectMonthlyTotalExpense(
        @Param("memberId") int memberId,
        @Param("year") int year,
        @Param("month") int month
    );

    // 이번 달 총 수입
    Map<String, Object> selectMonthlyTotalIncome(
        @Param("memberId") int memberId,
        @Param("year") int year,
        @Param("month") int month
		);
}
