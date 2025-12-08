package com.itwillbs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BankAccountVO;
import com.itwillbs.domain.BankTransactionVO;
import com.itwillbs.service.OpenBankingService;
import com.itwillbs.service.TransactionService;

@Controller
@RequestMapping("/transactions")
public class TransactionController {
	
	private static final Logger logger = LoggerFactory.getLogger(TransactionController.class);
	
	@Autowired
	private TransactionService transactionService;
	
	@Autowired
	private OpenBankingService openbankingService;
	
	// 거래내역 조회 페이지
	@GetMapping("/list")
	public String transactionList(@RequestParam("accountId") int accountId,
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "startDate", required = false) String startDate,
	        @RequestParam(value = "endDate", required = false) String endDate,
	        Model model) {
		
		logger.info("거래내역 조회 페이지 - accountId : {}", accountId);
		
		BankAccountVO account = openbankingService.getAccountById(accountId);
		
		if(account == null) {
			model.addAttribute("msg", "계좌 정보를 찾을 수 없습니다.");
			return "redirect:/accounts/list";
		}
		
		int pageSize = 10;  // 한 페이지에 10개씩
	    List<BankTransactionVO> transactions;
	    int totalCount;
		
	    // 날짜 필터 여부에 따라 분기
	    if(startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
	        // 날짜 필터 적용
	        transactions = transactionService.getTransactionsByDateWithPaging(
	            accountId, startDate, endDate, page, pageSize);
	        totalCount = transactionService.getTotalCountByDate(accountId, startDate, endDate);
	    } else {
	        // 전체 조회
	        transactions = transactionService.getTransactionsWithPaging(accountId, page, pageSize);
	        totalCount = transactionService.getTotalCount(accountId);
	    }
	    
	    // 총 페이지 수 계산
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
		
	    model.addAttribute("account", account);
	    model.addAttribute("transactions", transactions);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    logger.info("총 {}건, {}페이지", totalCount, page);
		return "transaction/list";
	}
	
	// Mock 거래내역 데이터 생성
	@GetMapping("/generate-mock")
	public String generateMock(@RequestParam("accountId") int accountId,
								RedirectAttributes rttr) {
		logger.info(" Mock 거래내역 생성 요청 - accountId : {}", accountId);
		try {
			int count = transactionService.generateMockTransactions(accountId, 30, 1);
			
			rttr.addFlashAttribute("msg", count + "건의 거래내역이 생성되었습니다.");
			return "redirect:/transactions/list?accountId=" + accountId;
		}catch(Exception e) {
			logger.info(" Mock 거래내역 생성 실패 : {}", e.getMessage());
			e.printStackTrace();
			
			rttr.addFlashAttribute("msg", "거래내역 생성에 실패했습니다.");
			return "redirect:/accounts/list";
		}
	}
	
	// 메모 저장 (AJAX)
	@PostMapping("/save-memo")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> saveMemo(
									@RequestParam("transactionId") int transactionId,
									@RequestParam("memo") String memo){
		logger.info("메모 저장 요청 - transactionId : {}, memo : {}", transactionId, memo);
		
		Map<String, Object> result = new HashMap<>();
		
		boolean success = transactionService.saveMemo(transactionId, memo);
		
		result.put("success", success);
		result.put("message", success ? "메모가 저장되었습니다." : "메모 저장에 실패하였습니다.");
		
		return ResponseEntity.ok(result);
	}
	
	// 메모 삭제 (AJAX)
	@PostMapping("/delete-memo")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteMemo(
									@RequestParam("transactionId") int transactionId){
		logger.info("메모 삭제 요청 - transactionId : {}, memo : {}", transactionId);
		
		Map<String, Object> result = new HashMap<>();
		
		boolean success = transactionService.deleteMemo(transactionId);
		
		result.put("success", success);
		result.put("message", success ? "메모가 삭제되었습니다." : "메모 삭제에 실패하였습니다.");
		
		return ResponseEntity.ok(result);
	}
	
}
