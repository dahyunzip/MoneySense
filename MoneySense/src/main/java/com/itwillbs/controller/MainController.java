package com.itwillbs.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.itwillbs.domain.BankAccountVO;
import com.itwillbs.domain.BankTransactionVO;
import com.itwillbs.domain.CardVO;
import com.itwillbs.mapper.BankAccountMapper;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.CardService;
import com.itwillbs.service.StatisticsService;
import com.itwillbs.service.TransactionService;

@Controller
public class MainController {
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	private BankAccountMapper accountMapper;
    
    @Autowired
    private CardService cardService;
    
    @Autowired
    private StatisticsService statisticsService;
    
 // 메인 페이지
    @GetMapping("/main")
    public String main(Authentication auth, Model model) {
        logger.info("========================================");
        logger.info("메인 페이지 요청");
        
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        String memberName = userDetails.getMember().getName();
        
        // 1. 나의 총 자산 (계좌 잔액 합계)
        List<BankAccountVO> accounts = accountMapper.selectAccountsByMemberId(memberId);
        long totalAssets = accounts.stream()
                                  .mapToLong(BankAccountVO::getBalance)
                                  .sum();
        
        // 2. 이번 달 지출
        Map<String, Object> monthlyExpense = statisticsService.getMonthlyTotalExpense(memberId);
        int currentExpense = ((Number) monthlyExpense.get("totalAmount")).intValue();
        int previousExpense = ((Number) monthlyExpense.get("previousAmount")).intValue();
        int expenseChange = currentExpense - previousExpense;
        
        // 3. 이번 달 수입
        Map<String, Object> monthlyIncome = statisticsService.getMonthlyTotalIncome(memberId);
        int currentIncome = ((Number) monthlyIncome.get("totalAmount")).intValue();
        int previousIncome = ((Number) monthlyIncome.get("previousAmount")).intValue();
        int incomeChange = currentIncome - previousIncome;
        
        // 4. 연결된 계좌/카드 개수
        int accountCount = accounts.size();
        List<CardVO> cards = cardService.getCardsByMemberId(memberId);
        int cardCount = cards.size();
        
        // 5. 카테고리별 소비 그래프 데이터
        List<Map<String, Object>> categoryExpense = statisticsService.getMonthlyCategoryExpense(memberId);
        
        model.addAttribute("memberName", memberName);
        model.addAttribute("totalAssets", totalAssets);
        model.addAttribute("monthlyExpense", currentExpense);
        model.addAttribute("expenseChange", expenseChange);
        model.addAttribute("monthlyIncome", currentIncome);
        model.addAttribute("incomeChange", incomeChange);
        model.addAttribute("accountCount", accountCount);
        model.addAttribute("cardCount", cardCount);
        model.addAttribute("categoryExpense", categoryExpense);
        
        logger.info("메인 데이터 조회 완료 - 총 자산: {}", totalAssets);
        logger.info("이번 달 지출: {}, 수입: {}", currentExpense, currentIncome);
        logger.info("========================================");
        
        return "main";
    }
}
