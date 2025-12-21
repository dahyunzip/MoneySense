package com.itwillbs.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.BankTransactionVO;
import com.itwillbs.domain.Criteria;

public interface BankTransactionMapper {
	// 거래내역 저장
	int insertTransaction(BankTransactionVO transaction);
	
	// 특정 계좌의 거래내역 조회 (최신순)
	List<BankTransactionVO> selectTransactionsByAccountId(
							@Param("accountId") int accountId,
							@Param("cri") Criteria cri);
	
	// 특정 계좌의 모든 거래내역 조회
	List<BankTransactionVO> selectAllTransactionsByAccountId(int accountId);
	
	// 특정 기간의 거래내역조회
	List<BankTransactionVO> selectTransactionsByDateRange(
							@Param("accountId") int accountId,
							@Param("startDate") String startDate,
							@Param("endDate") String endDate);
	
	// 날짜 필터 + 페이징
    List<BankTransactionVO> selectTransactionsByDateWithPaging(
        @Param("accountId") int accountId,
        @Param("startDate") String startDate,
        @Param("endDate") String endDate,
        @Param("cri") Criteria cri
    );
    
    // 전체 거래내역 개수
    int countTransactions(@Param("accountId") int accountId);
    
    // 날짜 필터 적용한 거래내역 개수
    int countTransactionsByDate(
        @Param("accountId") int accountId,
        @Param("startDate") String startDate,
        @Param("endDate") String endDate
    );
	
	// 거래내역 삭제
	int deleteTransaction(int transactionId);
	
	// 계좌의 모든 거래내역 삭제
	int deleteTransactionsByAccountId(int accountId);
	
	// 메모 업데이트
	int updateMemo(@Param("transactionId") int transactionId,
					@Param("memo") String memo);
	
	// 카테고리 업데이트
	int updateCategory(@Param("transactionId") int transactionId,
						@Param("categoryId") Integer categoryId);
}
