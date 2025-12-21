package com.itwillbs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.domain.AILogVO;
import com.itwillbs.domain.CalendarTransactionVO;
import com.itwillbs.mapper.AILogMapper;
import com.itwillbs.mapper.LedgerMapper;

@Service
public class AIChatService {
	
	private static final Logger logger = LoggerFactory.getLogger(AIChatService.class);
	
	@Autowired
	private AILogMapper aiLogMapper;
	
	@Autowired
	private LedgerMapper ledgerMapper;
	
	@Autowired
	private ChatGPTService chatGPTService;
	
	// 챗봇 대화 처리
    @Transactional
    public String chat(int memberId, String question) throws Exception {
        logger.info("챗봇 대화 시작 - memberId: {}, question: {}", memberId, question);
        
        // 1. 사용자 질문 분석 및 데이터 수집
        Map<String, Object> userData = collectUserData(memberId, question);
        
        // 2. GPT에게 전달할 프롬프트 생성
        String systemPrompt = buildSystemPrompt();
        String userPrompt = buildUserPrompt(question, userData);
        
        // 3. GPT 호출
        String answer = chatGPTService.askChatGPT(systemPrompt, userPrompt);
        
        // 4. 대화 로그 저장
        AILogVO log = new AILogVO();
        log.setMemberId(memberId);
        log.setLogType("CHAT");
        log.setQuestion(question);
        log.setAnswer(answer);
        aiLogMapper.insertChatLog(log);
        
        logger.info("챗봇 응답 완료 - answer: {}", answer);
        
        return answer;
    }
    
 // 사용자 데이터 수집
    private Map<String, Object> collectUserData(int memberId, String question) {
        Map<String, Object> data = new HashMap<>();
        
        // 질문 키워드 분석
        String lowerQuestion = question.toLowerCase();
        
        // 기간 판단
        int year = java.time.LocalDate.now().getYear();
        int month = java.time.LocalDate.now().getMonthValue();
        
        if (lowerQuestion.contains("이번 달") || lowerQuestion.contains("이달")) {
            // 이번 달 데이터
            List<CalendarTransactionVO> transactions = 
                ledgerMapper.selectMonthlyTransactions(memberId, year, month);
            data.put("period", year + "년 " + month + "월");
            data.put("transactions", transactions);
            data.put("summary", calculateMonthlySummary(transactions));
            
        } else if (lowerQuestion.contains("지난달")) {
            // 지난 달 데이터
            int prevMonth = month - 1;
            int prevYear = year;
            if (prevMonth == 0) {
                prevMonth = 12;
                prevYear--;
            }
            List<CalendarTransactionVO> transactions = 
                ledgerMapper.selectMonthlyTransactions(memberId, prevYear, prevMonth);
            data.put("period", prevYear + "년 " + prevMonth + "월");
            data.put("transactions", transactions);
            data.put("summary", calculateMonthlySummary(transactions));
            
        } else {
            // 기본: 이번 달
            List<CalendarTransactionVO> transactions = 
                ledgerMapper.selectMonthlyTransactions(memberId, year, month);
            data.put("period", year + "년 " + month + "월");
            data.put("transactions", transactions);
            data.put("summary", calculateMonthlySummary(transactions));
        }
        
        return data;
    }
    
    // 월간 요약 계산
    private Map<String, Object> calculateMonthlySummary(List<CalendarTransactionVO> transactions) {
        Map<String, Object> summary = new HashMap<>();
        Map<String, Integer> categoryExpense = new HashMap<>();
        
        int totalExpense = 0;
        int totalIncome = 0;
        
        for (CalendarTransactionVO tx : transactions) {
            if ("I".equals(tx.getInoutType())) {
                totalIncome += tx.getAmount();
            } else {
                totalExpense += Math.abs(tx.getAmount());
                
                // 카테고리별 집계
                String category = getCategoryName(tx.getCategoryId());
                categoryExpense.put(category, 
                    categoryExpense.getOrDefault(category, 0) + Math.abs(tx.getAmount()));
            }
        }
        
        summary.put("totalExpense", totalExpense);
        summary.put("totalIncome", totalIncome);
        summary.put("categoryExpense", categoryExpense);
        summary.put("transactionCount", transactions.size());
        
        // 최대 지출 카테고리
        String maxCategory = null;
        int maxAmount = 0;
        for (Map.Entry<String, Integer> entry : categoryExpense.entrySet()) {
            if (entry.getValue() > maxAmount) {
                maxAmount = entry.getValue();
                maxCategory = entry.getKey();
            }
        }
        summary.put("maxCategory", maxCategory);
        summary.put("maxCategoryAmount", maxAmount);
        
        return summary;
    }
    
    // 카테고리 ID -> 이름 변환
    private String getCategoryName(Integer categoryId) {
        if (categoryId == null) return "기타";
        
        // 카테고리 매핑
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
    
    // 시스템 프롬프트 생성
    private String buildSystemPrompt() {
        return "너는 개인 금융 관리 전문 AI 어시스턴트야. "
             + "사용자의 소비 데이터를 분석해서 친절하고 구체적인 답변을 해줘. "
             + "답변은 존댓말을 사용하고, 3-4문장 이내로 간결하게 작성해줘. "
             + "금액은 '원' 단위로 표시하고, 천 단위 구분 기호(,)를 사용해줘. "
             + "부정적인 표현보다는 긍정적이고 건설적인 조언을 해줘.";
    }
    
    // 사용자 프롬프트 생성
    private String buildUserPrompt(String question, Map<String, Object> userData) {
        StringBuilder prompt = new StringBuilder();
        
        prompt.append("사용자 질문: ").append(question).append("\n\n");
        prompt.append("사용자 데이터:\n");
        prompt.append("- 기간: ").append(userData.get("period")).append("\n");
        
        @SuppressWarnings("unchecked")
        Map<String, Object> summary = (Map<String, Object>) userData.get("summary");
        
        if (summary != null) {
            prompt.append("- 총 지출: ").append(summary.get("totalExpense")).append("원\n");
            prompt.append("- 총 수입: ").append(summary.get("totalIncome")).append("원\n");
            prompt.append("- 거래 건수: ").append(summary.get("transactionCount")).append("건\n");
            
            if (summary.get("maxCategory") != null) {
                prompt.append("- 최대 지출 카테고리: ")
                      .append(summary.get("maxCategory"))
                      .append(" (")
                      .append(summary.get("maxCategoryAmount"))
                      .append("원)\n");
            }
            
            @SuppressWarnings("unchecked")
            Map<String, Integer> categoryExpense = 
                (Map<String, Integer>) summary.get("categoryExpense");
            
            if (categoryExpense != null && !categoryExpense.isEmpty()) {
                prompt.append("\n카테고리별 지출:\n");
                for (Map.Entry<String, Integer> entry : categoryExpense.entrySet()) {
                    prompt.append("  - ")
                          .append(entry.getKey())
                          .append(": ")
                          .append(entry.getValue())
                          .append("원\n");
                }
            }
        }
        
        return prompt.toString();
    }
    
    // 챗봇 이력 조회
    public List<AILogVO> getChatHistory(int memberId, int limit) {
        logger.info("챗봇 이력 조회 - memberId: {}, limit: {}", memberId, limit);
        return aiLogMapper.selectChatHistory(memberId, limit);
    }
}
