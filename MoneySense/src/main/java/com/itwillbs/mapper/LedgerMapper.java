package com.itwillbs.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.CalendarTransactionVO;

public interface LedgerMapper {
	// 월별 거래내역 조회 (캘린더용)
	List<CalendarTransactionVO> selectMonthlyTransactions(
											@Param("memberId") int memberId,
											@Param("year") int year,
											@Param("month") int month
			);
	
	// 일별 거래내역 조회 (모달용)
	List<CalendarTransactionVO> selectDailyTransactions(
				@Param("memberId") int memberId,
				@Param("date") String date
			);
	
	// 거래 상세 조회
	CalendarTransactionVO selectTransactionDetail(
				@Param("transactionKey") String transactionKey
			);
	
	// 월별 지출 합계
	int selectMonthlyExpense(
				@Param("memberId") int memberId,
				@Param("year") int year,
				@Param("month") int month
			);
	
	// 월별 수입 합계
	int selectMonthlyIncome(
				@Param("memberId") int memberId,
				@Param("year") int year,
				@Param("month") int month
			);
}
