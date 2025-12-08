package com.itwillbs.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.BankAccountVO;

public interface BankAccountMapper {
	// 계좌 저장
	int insertAccount(BankAccountVO account);
	
	// 회원의 모든 계좌 조회
	List<BankAccountVO> selectAccountsByMemberId(int memberId);
	
	// 특정 계좌 조회
	BankAccountVO selectAccountById (int accountId);
	
	// 계좌번호로 조회 (중복 체크용)
	BankAccountVO selectAccountByAccountNum(String accountNum);
	
	// 계좌 잔액 업데이트
	int updateAccountBalance(@Param("accountId") int accountId,
							@Param("balance") long balance);
	
	// 계좌 삭제
	int deleteAccount(int accountId);
	
}
