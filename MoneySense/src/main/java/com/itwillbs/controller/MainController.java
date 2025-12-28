package com.itwillbs.controller;

import java.text.DecimalFormat;
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
        
        // 6. 챗봇 메세지 생성
        String chatbotMessage = generateChatbotMessage(
        	memberName,
        	currentExpense,
        	previousExpense,
        	categoryExpense
		);
        
        model.addAttribute("memberName", memberName);
        model.addAttribute("totalAssets", totalAssets);
        model.addAttribute("monthlyExpense", currentExpense);
        model.addAttribute("expenseChange", expenseChange);
        model.addAttribute("monthlyIncome", currentIncome);
        model.addAttribute("incomeChange", incomeChange);
        model.addAttribute("accountCount", accountCount);
        model.addAttribute("cardCount", cardCount);
        model.addAttribute("categoryExpense", categoryExpense);
        model.addAttribute("chatbotMessage", chatbotMessage);
        
        logger.info("메인 데이터 조회 완료 - 총 자산: {}", totalAssets);
        logger.info("이번 달 지출: {}, 수입: {}", currentExpense, currentIncome);
        logger.info("========================================");
        
        return "main";
    }
    
    // AI 챗봇 메시지 생성 로직
    private String generateChatbotMessage(String memberName, int currentExpense, int previousExpense, List<Map<String, Object>> categoryExpense) {
    	
    	DecimalFormat df = new DecimalFormat("#,###");
    	
    	// 지출 증감률 계산
    	double changeRate = 0;
    	if (previousExpense > 0) {
            changeRate = ((double)(currentExpense - previousExpense) / previousExpense) * 100;
        }
    	
    	// 1) 지출 증감 메시지
        if (currentExpense == 0 && previousExpense == 0) {
            return memberName + "님, 아직 거래 내역이 없어요. 계좌를 연동해보세요!";
        }
        
        if (currentExpense == 0) {
            return memberName + "님, 이번 달 지출이 없네요! 완벽한 소비 관리예요 👍";
        }
        
        // 2) 증감률에 따른 메시지
        if (Math.abs(changeRate) < 5) {
            return memberName + "님, 이번 달 지출이 지난달과 비슷해요. 안정적인 소비 패턴이네요!";
        }
        
        if (changeRate > 0) {
            // 증가
            if (changeRate > 50) {
                return memberName + "님, 이번 달 지출이 지난달 대비 " + 
                       String.format("%.1f", changeRate) + "% 증가했어요. 소비를 줄여보는 건 어떨까요? 💡";
            } else if (changeRate > 20) {
                return memberName + "님, 이번 달 지출이 지난달 대비 " + 
                       String.format("%.1f", changeRate) + "% 증가했어요. 지출을 체크해보세요!";
            } else {
                return memberName + "님, 이번 달 지출이 지난달 대비 " + 
                       String.format("%.1f", changeRate) + "% 소폭 증가했어요.";
            }
        } else {
            // 감소
            if (Math.abs(changeRate) > 30) {
                return memberName + "님, 이번 달 지출이 지난달 대비 " + 
                       String.format("%.1f", Math.abs(changeRate)) + "% 감소했어요! 훌륭해요 🎉";
            } else if (Math.abs(changeRate) > 10) {
                return memberName + "님, 이번 달 지출이 지난달 대비 " + 
                       String.format("%.1f", Math.abs(changeRate)) + "% 감소했어요! 잘하고 계세요 👏";
            } else {
                return memberName + "님, 이번 달 지출이 지난달 대비 " + 
                       String.format("%.1f", Math.abs(changeRate)) + "% 감소했네요!";
            }
        }
    }
}
