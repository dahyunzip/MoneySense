package com.itwillbs.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.domain.AIInsightVO;
import com.itwillbs.domain.CalendarTransactionVO;
import com.itwillbs.mapper.AIInsightMapper;
import com.itwillbs.mapper.LedgerMapper;

@Service
public class AIAnalysisService {
	
	private static final Logger logger = LoggerFactory.getLogger(AIAnalysisService.class);
    
    @Autowired
    private AIInsightMapper aiInsightMapper;
    
    @Autowired
    private LedgerMapper ledgerMapper;
    
    @Autowired
    private ChatGPTService chatGPTService;
    
    // 월간 인사이트 생성
    @Transactional
    public AIInsightVO generateMonthlyInsight(int memberId, int year, int month) throws Exception {
        logger.info("월간 인사이트 생성 - memberId: {}", memberId);
        logger.info("{}년 {}월", year, month);
        
        String period = String.format("%d-%02d", year, month);
        
        // 이미 존재하는지 확인
        AIInsightVO existing = aiInsightMapper.selectInsightByPeriod(memberId, "MONTHLY", period);
        if (existing != null) {
            logger.info("이미 생성된 월간 인사이트 존재: {}", existing.getInsightId());
            return existing;
        }
        
        // 1. 현재 월 데이터
        List<CalendarTransactionVO> currentTransactions = 
            ledgerMapper.selectMonthlyTransactions(memberId, year, month);
        int currentExpense = calculateTotalExpense(currentTransactions);
        
        // 2. 이전 월 데이터
        int prevMonth = month - 1;
        int prevYear = year;
        if (prevMonth == 0) {
            prevMonth = 12;
            prevYear--;
        }
        List<CalendarTransactionVO> prevTransactions = 
            ledgerMapper.selectMonthlyTransactions(memberId, prevYear, prevMonth);
        int prevExpense = calculateTotalExpense(prevTransactions);
        
        // 3. 변화율 계산
        BigDecimal changeRate = calculateChangeRate(currentExpense, prevExpense);
        
        // 4. GPT로 요약문 생성
        String summary = generateMonthlySummaryText(
            year, month, currentExpense, prevExpense, changeRate, currentTransactions);
        
        // 5. 인사이트 저장
        AIInsightVO insight = new AIInsightVO();
        insight.setMemberId(memberId);
        insight.setInsightType("MONTHLY");
        insight.setPeriod(period);
        insight.setCurrentAmount(currentExpense);
        insight.setPreviousAmount(prevExpense);
        insight.setChangeRate(changeRate);
        insight.setSummary(summary);
        
        aiInsightMapper.insertInsight(insight);
        
        logger.info("월간 인사이트 생성 완료 - insightId: {}", insight.getInsightId());
        
        return insight;
    }
    
    // 카테고리별 인사이트 생성
    @Transactional
    public AIInsightVO generateCategoryInsight(
            int memberId, int year, int month, String category) throws Exception {
        
        logger.info("카테고리별 인사이트 생성 - memberId: {}", memberId);
        logger.info("{}년 {}월", year, month);
        logger.info("category: {}", category);
        
        String period = String.format("%d-%02d", year, month);
        
        // 이미 존재하는지 확인
        AIInsightVO existing = aiInsightMapper.selectCategoryInsight(memberId, period, category);
        if (existing != null) {
            logger.info("이미 생성된 카테고리 인사이트 존재: {}", existing.getInsightId());
            return existing;
        }
        
        // 1. 현재 월 데이터
        List<CalendarTransactionVO> currentTransactions = 
            ledgerMapper.selectMonthlyTransactions(memberId, year, month);
        int currentExpense = calculateCategoryExpense(currentTransactions, category);
        
        // 2. 이전 월 데이터
        int prevMonth = month - 1;
        int prevYear = year;
        if (prevMonth == 0) {
            prevMonth = 12;
            prevYear--;
        }
        List<CalendarTransactionVO> prevTransactions = 
            ledgerMapper.selectMonthlyTransactions(memberId, prevYear, prevMonth);
        int prevExpense = calculateCategoryExpense(prevTransactions, category);
        
        // 3. 변화율 계산
        BigDecimal changeRate = calculateChangeRate(currentExpense, prevExpense);
        
        // 4. GPT로 요약문 생성
        String summary = generateCategorySummaryText(
            category, year, month, currentExpense, prevExpense, changeRate);
        
        // 5. 인사이트 저장
        AIInsightVO insight = new AIInsightVO();
        insight.setMemberId(memberId);
        insight.setInsightType("CATEGORY");
        insight.setPeriod(period);
        insight.setCategory(category);
        insight.setCurrentAmount(currentExpense);
        insight.setPreviousAmount(prevExpense);
        insight.setChangeRate(changeRate);
        insight.setSummary(summary);
        
        aiInsightMapper.insertInsight(insight);
        
        logger.info("카테고리 인사이트 생성 완료 - insightId: {}", insight.getInsightId());
        
        return insight;
    }
    
 // 최신 인사이트 조회
    public List<AIInsightVO> getRecentInsights(int memberId, int limit) {
        logger.info("최신 인사이트 조회 - memberId: {}, limit: {}", memberId, limit);
        return aiInsightMapper.selectRecentInsights(memberId, limit);
    }
    
    // 총 지출 계산
    private int calculateTotalExpense(List<CalendarTransactionVO> transactions) {
        int total = 0;
        for (CalendarTransactionVO tx : transactions) {
            if ("O".equals(tx.getInoutType())) {
                total += Math.abs(tx.getAmount());
            }
        }
        return total;
    }
    
    // 카테고리별 지출 계산
    private int calculateCategoryExpense(List<CalendarTransactionVO> transactions, String category) {
        int categoryId = getCategoryId(category);
        int total = 0;
        
        for (CalendarTransactionVO tx : transactions) {
            if ("O".equals(tx.getInoutType()) && 
                tx.getCategoryId() != null && 
                tx.getCategoryId() == categoryId) {
                total += Math.abs(tx.getAmount());
            }
        }
        return total;
    }
    
    // 카테고리 이름 -> ID 변환
    private int getCategoryId(String categoryName) {
        Map<String, Integer> categoryMap = new HashMap<>();
        categoryMap.put("식비", 1);
        categoryMap.put("카페", 2);
        categoryMap.put("쇼핑", 3);
        categoryMap.put("교통", 4);
        categoryMap.put("문화", 5);
        categoryMap.put("의료", 6);
        categoryMap.put("교육", 7);
        categoryMap.put("주거", 8);
        categoryMap.put("통신", 9);
        categoryMap.put("기타", 10);
        
        return categoryMap.getOrDefault(categoryName, 10);
    }
    
    // 변화율 계산
    private BigDecimal calculateChangeRate(int current, int previous) {
        if (previous == 0) {
            return current > 0 ? new BigDecimal("100.00") : BigDecimal.ZERO;
        }
        
        BigDecimal currentBD = new BigDecimal(current);
        BigDecimal previousBD = new BigDecimal(previous);
        BigDecimal diff = currentBD.subtract(previousBD);
        
        return diff.divide(previousBD, 4, RoundingMode.HALF_UP)
                   .multiply(new BigDecimal("100"))
                   .setScale(2, RoundingMode.HALF_UP);
    }
    
    // 월간 요약문 생성
    private String generateMonthlySummaryText(
            int year, int month, int current, int previous, 
            BigDecimal changeRate, List<CalendarTransactionVO> transactions) throws Exception {
        
        String systemPrompt = 
            "너는 개인 금융 분석 전문가야. "
            + "사용자의 월간 지출 데이터를 바탕으로 2-3문장의 간결하고 친절한 인사이트를 제공해줘. "
            + "존댓말을 사용하고, 금액은 '원' 단위에 천 단위 구분 기호(,)를 사용해줘. "
            + "변화율을 언급할 때는 긍정적인 톤을 유지해줘.";
        
        StringBuilder userPrompt = new StringBuilder();
        userPrompt.append(year).append("년 ").append(month).append("월 지출 분석:\n");
        userPrompt.append("- 이번 달 지출: ").append(current).append("원\n");
        userPrompt.append("- 지난 달 지출: ").append(previous).append("원\n");
        userPrompt.append("- 변화율: ").append(changeRate).append("%\n");
        
        // 카테고리별 지출 상위 3개
        Map<String, Integer> categoryExpense = new HashMap<>();
        for (CalendarTransactionVO tx : transactions) {
            if ("O".equals(tx.getInoutType())) {
                String category = getCategoryName(tx.getCategoryId());
                categoryExpense.put(category, 
                    categoryExpense.getOrDefault(category, 0) + Math.abs(tx.getAmount()));
            }
        }
        
        userPrompt.append("\n주요 지출 카테고리:\n");
        categoryExpense.entrySet().stream()
            .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
            .limit(3)
            .forEach(entry -> {
                userPrompt.append("- ")
                          .append(entry.getKey())
                          .append(": ")
                          .append(entry.getValue())
                          .append("원\n");
            });
        
        return chatGPTService.askChatGPT(systemPrompt, userPrompt.toString());
    }
    
    // 카테고리 요약문 생성
    private String generateCategorySummaryText(
            String category, int year, int month, 
            int current, int previous, BigDecimal changeRate) throws Exception {
        
        String systemPrompt = 
            "너는 개인 금융 분석 전문가야. "
            + "특정 카테고리의 지출 변화를 1-2문장으로 간결하게 설명해줘. "
            + "존댓말을 사용하고, 금액은 '원' 단위에 천 단위 구분 기호(,)를 사용해줘.";
        
        String userPrompt = String.format(
            "%s 카테고리 %d년 %d월 분석:\n이번 달: %d원\n지난 달: %d원\n변화율: %s%%",
            category, year, month, current, previous, changeRate.toString()
        );
        
        return chatGPTService.askChatGPT(systemPrompt, userPrompt);
    }
    
    // 카테고리 ID -> 이름
    private String getCategoryName(Integer categoryId) {
        if (categoryId == null) return "기타";
        
        Map<Integer, String> categoryMap = new HashMap<>();
        categoryMap.put(1, "식비");
        categoryMap.put(2, "카페");
        categoryMap.put(3, "쇼핑");
        categoryMap.put(4, "교통");
        categoryMap.put(5, "문화");
        categoryMap.put(6, "의료");
        categoryMap.put(7, "교육");
        categoryMap.put(8, "주거");
        categoryMap.put(9, "통신");
        categoryMap.put(10, "기타");
        
        return categoryMap.getOrDefault(categoryId, "기타");
    }
}
