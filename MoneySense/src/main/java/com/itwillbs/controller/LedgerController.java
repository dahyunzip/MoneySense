package com.itwillbs.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.itwillbs.service.OpenBankingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.domain.CalendarTransactionVO;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.LedgerService;

@Controller
@RequestMapping("/ledger")
public class LedgerController {

    private final OpenBankingService openBankingService;
	
	private static final Logger logger = LoggerFactory.getLogger(LedgerController.class);
	
	@Autowired
	private LedgerService ledgerService;

    LedgerController(OpenBankingService openBankingService) {
        this.openBankingService = openBankingService;
    }
	
	// 가계부 메인 페이지
	@GetMapping("/calendar")
	public String calendar(Model model) {
		logger.info(" 가계부 캘린더 페이지");
		return "ledger/calendar";
	}
	
	// 월별 거래내역 API (JSON)
	@GetMapping("/month")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getMonthlyData(
				@RequestParam(defaultValue = "0") int year,
				@RequestParam(defaultValue =  "0") int month,
				Authentication auth
			){
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		// 기본값 설정 (year, month가 0이면 현재 날짜 사용)
		if(year == 0 || month == 0) {
			LocalDate now = LocalDate.now();
			year = now.getYear();
			month = now.getMonthValue();
		}
		
		logger.info(" ========================================= ");
		logger.info(" 월별 데이터 조회 - memberId : {}", memberId);
		logger.info(" {}년, {}월", year, month);
		
		// 거래내역 조회
		List<CalendarTransactionVO> transactions = 
				ledgerService.getMonthlyTransactions(memberId, year, month);
		
		// 월별 집계
		Map<String, Object> summary = 
				ledgerService.getMonthlySummary(memberId, year, month);
		
		// FullCalendar용 이벤트 변환
		List<Map<String, Object>> events = convertToCalendarEvents(transactions);
		
		// 일별 합계 (히트맵용)
		Map<String, Integer> dailyTotals = 
				ledgerService.getDailyTotalsMap(transactions);
		
		// 일별 지출/수입 분리 계산
		Map<String, Map<String, Integer>> dailySummary = calculateDailySummary(transactions);
		
		Map<String, Object> response = new HashMap<>();
		response.put("events", events);
		response.put("dailyTotals", dailyTotals);
		response.put("dailySummary", dailySummary);
		response.put("summary", summary);
		
		logger.info(" 거래내역 {}건 조회 완료", transactions.size());
		logger.info(" =========================================== ");
		
		return ResponseEntity.ok(response);
	}
	
	//일별 지출 / 수입 분리 계산
	private Map<String, Map<String, Integer>> calculateDailySummary(List<CalendarTransactionVO> transactions){
		Map<String, Map<String, Integer>> dailySummary = new HashMap<>();
		for(CalendarTransactionVO tx : transactions) {
			String date = tx.getTransactedAt().toString().substring(0,10);
			
			if(!dailySummary.containsKey(date)) {
				Map<String, Integer> summary = new HashMap<>();
				summary.put("income", 0);
				summary.put("expense", 0);
				dailySummary.put(date, summary);
			}
			
			Map<String, Integer> summary = dailySummary.get(date);
			if("I".equals(tx.getInoutType())) {
	            // 수입
	            summary.put("income", summary.get("income") + Math.abs(tx.getAmount()));
	        }else {
	            // 지출
	            summary.put("expense", summary.get("expense") - Math.abs(tx.getAmount()));
	        }
		}
		
	    logger.info("일별 수입/지출 분리 완료:"); 
	    for(Map.Entry<String, Map<String, Integer>> entry : dailySummary.entrySet()) { 
	        logger.info("수입: {}, 지출: {}",  
	            entry.getValue().get("income"),   
	            entry.getValue().get("expense")); 
	    }
		return dailySummary;
	}
	
	// 일별 거래내역 API (JSON)
	@GetMapping("/day")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getDailyData(
			@RequestParam String date,
			Authentication auth
			){
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		logger.info("일별 데이터 조회 - memberId : {}, date : {}", memberId, date);
		
		List<CalendarTransactionVO> transactions = 
				ledgerService.getDailyTransactions(memberId, date);
		
		Map<String, Object> response = new HashMap<>();
		response.put("date", date);
		response.put("transactions", transactions);
		
		logger.info(" 일별 거래내역 {}건 조회 완료", transactions.size());
		
		return ResponseEntity.ok(response);
	}
	
	// 거래 상세 API (JSON)
	@GetMapping("/detail")
	@ResponseBody
	public ResponseEntity<CalendarTransactionVO> getTransactionDetail(
				@RequestParam String key
			){
		logger.info(" 거래 상세 조회 - key : {}", key);
		
		CalendarTransactionVO transaction = ledgerService.getTransactionDetail(key);
		
		if(transaction == null) {
			logger.info(" 거래를 찾을 수 없음 - key : {}", key);
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(transaction);
	}
	
	// FullCalendar용 이벤트 변환
	private List<Map<String, Object>> convertToCalendarEvents(
				List<CalendarTransactionVO> transactions
			){
		
		List<Map<String, Object>> events = new ArrayList<>();

		for(CalendarTransactionVO tx : transactions) {
			Map<String, Object> event = new HashMap<>();
			
			// 날짜
			String date = tx.getTransactedAt().toString().substring(0,10);
			event.put("start", date);
			
			// 제목
			String icon = tx.getInoutType().equals("I") ? "💰" : "💳";
			String amountStr = String.format("%, d원", Math.abs(tx.getAmount()));
			event.put("title", icon + " " + amountStr);
			
			// 데이터
			event.put("transactionKey", tx.getTransactionKey());
			event.put("amount", tx.getAmount());
			event.put("inoutType", tx.getInoutType());
			event.put("detail", tx.getDetail());
			
			// 색상
			if(tx.getInoutType().equals("I")) {
				event.put("backgroundColor", "#28a745");
				event.put("borderColor", "#28a745");
			}else {
				event.put("backgroundColor", "#dc3545");
				event.put("borderColor", "#dc3545");
			}
			
			events.add(event);
		}
		return events;
	}
	
	
	
}
