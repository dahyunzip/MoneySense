package com.itwillbs.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.CardTransactionVO;
import com.itwillbs.domain.Criteria;

public interface CardTransactionMapper {
	// 거래내역 저장
	int insertTransaction(CardTransactionVO transaction);
	
	// 특정 카드의 거래내역 조회(페이징)
	List<CardTransactionVO> selectTransactionsByCardId(
				@Param("cardId") int cardId,
				@Param("cri") Criteria cri
			);
	
	// 특정 카드의 모든 거래내역 조회
	List<CardTransactionVO> selectAllTransactionsByCardId(int cardId);
	
	// 날짜 필터 + 페이징
	List<CardTransactionVO> selectTransactionsByDateWithPaging(
				@Param("cardId") int cardId,
				@Param("startDate") String startDate,
				@Param("endDate") String endDate,
				@Param("cri") Criteria cri
			);
	
	// 전체 거래내역 개수
	int countTransactions(@Param("cardId") int cardId);
	
	// 날짜 필터 적용한 거래내역 개수
	int countTransactionsByDate(
				@Param("cardId") int cardId,
				@Param("startDate") String startDate,
				@Param("endDate") String endDate
			);
	
	// 회원의 모든 카드 거래 내역 조회 (최근순)
	List<CardTransactionVO> selectRecentTransactionsByMemberId(
				@Param("memberId") int memberId,
				@Param("limit") int limit
			);
	
	// 거래내역 삭제
	int deleteTransaction(long transactionId);
	
	// 카드의 모든 거래내역 삭제
	int deleteTransactionsByCardId(int cardId);
	
	// 메모 업데이트
	int updateMemo(
				@Param("transactionId") long transactionId,
				@Param("memo") String memo
			);
	
	// 카테고리 업데이트
	int updateCategory(
				@Param("transactionId") long transactionId,
				@Param("categoryId") Integer categoryId
			);
}
