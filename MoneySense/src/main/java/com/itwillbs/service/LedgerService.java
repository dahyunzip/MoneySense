package com.itwillbs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.CalendarTransactionVO;
import com.itwillbs.mapper.LedgerMapper;

@Service
public class LedgerService {
	
	private static final Logger logger = LoggerFactory.getLogger(LedgerService.class);
	
	@Autowired
	private LedgerMapper ledgerMapper;
	
	// 월별 거래내역 조회 (캘린더용)
	public List<CalendarTransactionVO> getMonthlyTransactions(int memberId, int year, int month){
		logger.info(" 월별 거래내역 조회 - memberId : {}, month : {}", memberId, month);
		return ledgerMapper.selectMonthlyTransactions(memberId, year, month);
	}
	
	// 일별 거래내역 조회 (모달용)
	public List<CalendarTransactionVO> getDailyTransactions(int memberId, String date){
		logger.info(" 일별 거래내역 조회 - memberId : {}, date : {}", memberId, date);
		return ledgerMapper.selectDailyTransactions(memberId, date);
	}
	
	// 거래 상세 조회
	public CalendarTransactionVO getTransactionDetail(String transactionKey) {
		logger.info(" 거래 상세 조회 - key : {}", transactionKey);
		return ledgerMapper.selectTransactionDetail(transactionKey);
	}
	
	// 월별 집계 정보 조회
	public Map<String, Object> getMonthlySummary(int memberId, int year, int month){
		logger.info(" 월별 집계 조회 - memberId : {}, month : {}", memberId, month);
		
		int expense = ledgerMapper.selectMonthlyExpense(memberId, year, month);
		int income = ledgerMapper.selectMonthlyIncome(memberId, year, month);
		int net = income + expense; // expense는 음수
		
		Map<String, Object> summary = new HashMap<>();
		summary.put("expense", expense);
		summary.put("income", income);
		summary.put("net", net);
		
		logger.info(" 지출 : {}원, 수입 : {}원", expense, income);
		logger.info(" 순변화 : {}원", net);
		
		return summary;
	}
	
	// 일별 집계 맵 생성 (캘린더 히트맵)
	public Map<String, Integer> getDailyTotalsMap(List<CalendarTransactionVO> transactions){
		Map<String, Integer> dailyTotals = new HashMap<>();
		for(CalendarTransactionVO tx : transactions) {
			String date = tx.getTransactedAt().toString().substring(0, 10);
			dailyTotals.put(date, dailyTotals.getOrDefault(date, 0) + tx.getAmount());
		}
		
		return dailyTotals;
	}
}
