package com.itwillbs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
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
import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.PageVO;
import com.itwillbs.mapper.CategoryMapper;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.CategoryService;
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
	
	@Autowired
	private CategoryMapper categoryMapper;
	
	@Autowired
	private CategoryService categoryService;
	
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
		
		Criteria cri = new Criteria(page, 10);
		List<BankTransactionVO> transactions;
		PageVO pageVO;
		
	    // 날짜 필터 여부에 따라 분기
	    if(startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
	        // 날짜 필터 적용
	        transactions = transactionService.getTransactionsByDateWithPaging(
	            accountId, startDate, endDate, cri);
	        pageVO = transactionService.getPageVOByDate(accountId, startDate, endDate, cri);
	        
	        model.addAttribute("startDate", startDate);
	        model.addAttribute("endDate", endDate);
	    } else {
	        // 전체 조회
	        transactions = transactionService.getTransactionsByAccountId(accountId, cri);
	        pageVO = transactionService.getPageVO(accountId, cri);
	    }
	    
	    //  카테고리 목록 추가
	    List<CategoryVO> categories = categoryMapper.selectDefaultCategories();
		
	    model.addAttribute("account", account);
	    model.addAttribute("transactions", transactions);
	    model.addAttribute("pageVO", pageVO);
	    model.addAttribute("categories", categories);
	    logger.info("총 {}건, {}페이지", pageVO.getTotalCount(), pageVO.getTotalPages());
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
	
	//  카테고리 업데이트 (AJAX)
	@PostMapping("/update-category")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateCategory(
			@RequestParam("transactionId") int transactionId,
			@RequestParam("categoryId") int categoryId) {
		
		logger.info("카테고리 업데이트 요청 - transactionId: {}, categoryId: {}", transactionId, categoryId);
		
		Map<String, Object> result = new HashMap<>();
		
		boolean success = transactionService.updateCategory(transactionId, categoryId);
		
		result.put("success", success);
		result.put("message", success ? "카테고리가 변경되었습니다." : "카테고리 변경에 실패했습니다.");
		
		return ResponseEntity.ok(result);
	}
	
	//  카테고리 학습 (AJAX)
	@PostMapping("/learn-category")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> learnCategory(
			@RequestParam("transactionName") String transactionName,
			@RequestParam("categoryId") int categoryId,
			Authentication auth) {
		
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		logger.info("카테고리 학습 - memberId: {}", memberId);
		logger.info(" transactionName: {}, categoryId: {}", transactionName, categoryId);
		
		Map<String, Object> result = new HashMap<>();
		
		try {
			categoryService.learnFromUser(memberId, transactionName, categoryId);
			result.put("success", true);
		} catch (Exception e) {
			logger.error("카테고리 학습 오류: {}", e.getMessage());
			result.put("success", false);
		}
		
		return ResponseEntity.ok(result);
	}
	
}
