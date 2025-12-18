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

import com.itwillbs.domain.CardTransactionVO;
import com.itwillbs.domain.CardVO;
import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.PageVO;
import com.itwillbs.mapper.CategoryMapper;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.CardService;
import com.itwillbs.service.CategoryService;

@Controller
@RequestMapping("/cards")
public class CardController {
	
	private static final Logger logger = LoggerFactory.getLogger(CardController.class);
	
	@Autowired
	private CardService cardService;
	
	@Autowired
	private CategoryMapper categoryMapper;
	
	@Autowired
	private CategoryService categoryService;
	
	// 카드 목록 페이지
	@GetMapping("/list")
	public String list(Authentication auth, Model model) {
		logger.info(" ============================== ");
		logger.info(" 카드 목록 페이지 요청 ");
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		List<CardVO> cards = cardService.getCardsByMemberId(memberId);
		
		model.addAttribute("cards", cards);
		model.addAttribute("totalCards", cards.size());
		
		logger.info(" 카드 목록 조회 완료 - 총 {}장", cards.size());
		logger.info(" =========================================== ");
		
		return "card/list";
	}
	
	// 카드 등록 페이지
	@GetMapping("/register")
	public String registerForm() {
		logger.info(" 카드 등록 페이지 요청 ");
		return "card/register";
	}
	
	// 카드 등록 처리
	@PostMapping("/register")
	public String register(Authentication auth, CardVO card, RedirectAttributes rttr) {
		logger.info(" =================================== ");
		logger.info(" 카드 등록 요청 ");
		
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		card.setMemberId(memberId);
		
		try {
			cardService.registerCard(card);
			
			logger.info(" 카드 등록 완료 : {}, {}", card.getCardCompany(), card.getCardName());
			rttr.addFlashAttribute("msg", "카드가 등록되었습니다.");
		}catch(Exception e) {
			logger.info(" 카드 등록 실패 : {}", e.getMessage());
			e.printStackTrace();
			rttr.addFlashAttribute("msg", "카드 등록에 실패하였습니다.");
		}
		logger.info(" ================================== ");
		return "redirect:/cards/list";
	}
	
	// 더미 카드 자동 생성
	@GetMapping("/generate-dummy")
	public String generateDummy(Authentication auth, @RequestParam(defaultValue= "3") int count, RedirectAttributes rttr ) {
		logger.info(" =================================== ");
		logger.info(" 더미 카드 생성 요청 - 개수 : {}", count);
		
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		try {
			int generatedCount = cardService.generateDummyCards(memberId, count);
			rttr.addFlashAttribute("msg", String.format("테스트 카드 %d장이 생성되었습니다.", generatedCount));
		}catch(Exception e) {
			logger.info(" 더미 카드 생성 실패 : {}", e.getMessage());
			rttr.addFlashAttribute("msg", "카드 생성에 실패했습니다.");
		}
		
		logger.info(" ==================================== ");
		return "redirect:/cards/list";
	}
	
	
	// 카드 사용내역 페이지
	@GetMapping("/transactions")
	public String transactions(
				@RequestParam("cardId") int cardId,
				@RequestParam(defaultValue = "1") int page,
				@RequestParam(required = false) String startDate,
				@RequestParam(required = false) String endDate,
				Model model) {
		logger.info(" ======================================");
		logger.info(" 카드 사용내역 페이지 요청 - cardId : ", cardId);
		
		// 카드 정보 조회
		CardVO card = cardService.getCardById(cardId);
		
		if(card == null) {
			logger.info(" 카드를 찾을 수 없습니다. ");
			return "redirect:/cards/list";
		}
		
		Criteria cri = new Criteria(page, 10);
		List<CardTransactionVO> transactions;
		PageVO pageVO;
		
		// 날짜 필터 여부에 따라 분기
		if(startDate != null && endDate !=null && !startDate.isEmpty() && !endDate.isEmpty()) {
			logger.info(" 날짜 필터 적용 : {} ~ {}", startDate, endDate);
			transactions = cardService.getTransactionsByDateWithPaging(cardId, startDate, endDate, cri);
			pageVO = cardService.getPageVOByDate(cardId, startDate, endDate, cri);
			model.addAttribute("startDate", startDate);
			model.addAttribute("endDate", endDate);
		}else {
			transactions = cardService.getTransactionsByCardId(cardId, cri);
			pageVO= cardService.getPageVO(cardId, cri);
		}
		
		List<CategoryVO> categories = categoryMapper.selectDefaultCategories();
		
		model.addAttribute("card", card);
		model.addAttribute("transactions", transactions);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("categories", categories);
		
		logger.info(" 카드 사용내역 조회 완료 - 총 {}건, {} 페이지", pageVO.getTotalCount(), pageVO.getTotalPages());
		logger.info(" ================================================ ");
		
		return "card/transactions";
	}
	
	// Mock 카드 사용내역 생성 (테스트용)
	@GetMapping("/generate-mock")
	public String generateMock(@RequestParam("cardId") int cardId,
								@RequestParam(defaultValue = "30") int days,
								@RequestParam(defaultValue = "2") int perDay,
								RedirectAttributes rttr) {
		
		logger.info(" ======================================= ");
		logger.info(" Mock 카드 사용내역 생성 요청 ");
		logger.info(" cardId : {}", cardId);
		
		try {
			int count = cardService.generateMockTransactions(cardId, days, perDay);
			rttr.addFlashAttribute("msg", String.format("테스트 카드 사용내역 %d건이 생성되었습니다.", count));
		}catch(Exception e) {
			logger.info(" Mock 생성 실패 : {}", e.getMessage());
			e.printStackTrace();
			rttr.addFlashAttribute("msg", "사용내역 생성에 실패했습니다.");
		}
		logger.info(" ======================================= ");
		return "redirect:/cards/transactions?cardId="+cardId;
	}
	
	// 카드 삭제
	@PostMapping("/delete")
	public String delete(@RequestParam("cardId") int cardId,
						RedirectAttributes rttr) {
		logger.info(" ================================== ");
		logger.info(" 카드 삭제 요청 - cardId : {}", cardId);
		
		try {
			cardService.deleteCard(cardId);
			logger.info(" 카드 삭제 완료");
			rttr.addFlashAttribute("msg", "카드가 삭제되었습니다.");
		}catch(Exception e) {
			logger.info(" 카드 삭제 실패 : {}", e.getMessage());
			rttr.addFlashAttribute("msg", "카드 삭제에 실패했습니다.");
		}
		
		logger.info(" ================================= ");
		return "redirect:/cards/list";
	}
	
	// 메모 저장 (AJAX)
	@PostMapping("/save-memo")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> saveMemo(
				@RequestParam("transactionId") long transactionId,
				@RequestParam("memo") String memo){
		logger.info(" 카드 거래 메모 저장 - transactionId : {}", transactionId);
		
		Map<String, Object> response = new HashMap<>();
		
		try {
			boolean success = cardService.saveMemo(transactionId, memo);
			if(success) {
				response.put("success", true);
				response.put("message", "메모가 저장되었습니다.");
			}else {
				response.put("success", false);
				response.put("message", "메모 저장에 실패했습니다.");
			}
		}catch(Exception e) {
			logger.info(" 메모 저장 중 오류 : {}", e.getMessage());
			response.put("success", false);
			response.put("message", "오류가 발생했습니다.");
		}
		return ResponseEntity.ok(response);
	}
	
	// 메모 삭제 (AJAX)
	@PostMapping("/delete-memo")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteMemo(
				@RequestParam("transactionId") long transactionId){
		logger.info(" 카드 거래 메모 삭제 - transactionId : {}", transactionId);
		
		Map<String, Object> response = new HashMap<>();
		
		try {
			boolean success = cardService.deleteMemo(transactionId);
			if(success) {
				response.put("success", true);
				response.put("message", "메모가 삭제되었습니다.");
			}else {
				response.put("success", false);
				response.put("message", "메모 삭제에 실패했습니다.");
			}
		}catch(Exception e) {
			logger.info(" 메모 삭제 중 오류 : {}", e.getMessage());
			response.put("success", false);
			response.put("message", "오류가 발생했습니다.");
		}
		
		return ResponseEntity.ok(response);
	}
	
	// 카테고리 업데이트 (AJAX)
	@PostMapping("/update-category")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateCategory(
			@RequestParam("transactionId") long transactionId,
			@RequestParam("categoryId") int categoryId) {
		
		logger.info("카테고리 업데이트 요청 - transactionId: {}, categoryId: {}", transactionId, categoryId);
		
		Map<String, Object> response = new HashMap<>();
		
		try {
			boolean success = cardService.updateCategory(transactionId, categoryId);
			response.put("success", success);
			response.put("message", success ? "카테고리가 변경되었습니다." : "카테고리 변경에 실패했습니다.");
		} catch (Exception e) {
			logger.error("카테고리 업데이트 오류: {}", e.getMessage());
			response.put("success", false);
			response.put("message", "오류가 발생했습니다.");
		}
		
		return ResponseEntity.ok(response);
	}
	
	// 카테고리 학습 (AJAX)
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
		
		Map<String, Object> response = new HashMap<>();
		
		try {
			categoryService.learnFromUser(memberId, transactionName, categoryId);
			response.put("success", true);
		} catch (Exception e) {
			logger.error("카테고리 학습 오류: {}", e.getMessage());
			response.put("success", false);
		}
		
		return ResponseEntity.ok(response);
	}

	
	
	
	
	
	
	
	
}
