package com.itwillbs.controller;

import java.time.LocalDate;
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

import com.itwillbs.domain.AIInsightVO;
import com.itwillbs.domain.AILogVO;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.AIAnalysisService;
import com.itwillbs.service.AIChatService;

@Controller
@RequestMapping("/ai")
public class AIController {
	
	private static final Logger logger = LoggerFactory.getLogger(AIController.class);
	
	@Autowired
    private AIChatService aiChatService;
    
    @Autowired
    private AIAnalysisService aiAnalysisService;
    
    // AI 챗봇 페이지
    @GetMapping("/chat")
    public String chatPage(Model model, Authentication auth) {
        logger.info("AI 챗봇 페이지");
        
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        
        // 최근 대화 이력 조회 (최근 10개)
        List<AILogVO> chatHistory = aiChatService.getChatHistory(memberId, 10);
        model.addAttribute("chatHistory", chatHistory);
        
        return "ai/chat";
    }
    
 // AI 챗봇 대화 API
    @PostMapping("/chat")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> chat(
            @RequestParam("question") String question,
            Authentication auth) {
        
        logger.info("AI 챗봇 대화 요청 - question: {}", question);
        
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 챗봇 대화 처리
            String answer = aiChatService.chat(memberId, question);
            
            response.put("success", true);
            response.put("question", question);
            response.put("answer", answer);
            
            logger.info("AI 챗봇 응답 완료");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("AI 챗봇 오류: {}", e.getMessage());
            
            response.put("success", false);
            response.put("message", "챗봇 응답 중 오류가 발생했습니다.");
            
            return ResponseEntity.status(500).body(response);
        }
    }
    
    
    // AI 인사이트 페이지
    @GetMapping("/insights")
    public String insightsPage(Model model, Authentication auth) {
        logger.info("AI 인사이트 페이지");
        
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        
        // 최근 인사이트 조회 (최근 5개)
        List<AIInsightVO> insights = aiAnalysisService.getRecentInsights(memberId, 5);
        model.addAttribute("insights", insights);
        
        return "ai/insights";
    }
    
    // 월간 인사이트 생성 API
    @PostMapping("/insights/monthly")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateMonthlyInsight(
            @RequestParam(defaultValue = "0") int year,
            @RequestParam(defaultValue = "0") int month,
            Authentication auth) {
        
        logger.info("월간 인사이트 생성 요청 - {}년 {}월", year, month);
        
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        
        // 기본값 설정 (현재 날짜)
        if (year == 0 || month == 0) {
            LocalDate now = LocalDate.now();
            year = now.getYear();
            month = now.getMonthValue();
        }
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 월간 인사이트 생성
            AIInsightVO insight = aiAnalysisService.generateMonthlyInsight(memberId, year, month);
            
            response.put("success", true);
            response.put("insight", insight);
            
            logger.info("월간 인사이트 생성 완료 - insightId: {}", insight.getInsightId());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("월간 인사이트 생성 오류: {}", e.getMessage());
            
            response.put("success", false);
            response.put("message", "인사이트 생성 중 오류가 발생했습니다.");
            
            return ResponseEntity.status(500).body(response);
        }
    }
    
    // 카테고리별 인사이트 생성 API
    @PostMapping("/insights/category")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateCategoryInsight(
            @RequestParam int categoryId,
            @RequestParam(defaultValue = "0") int year,
            @RequestParam(defaultValue = "0") int month,
            Authentication auth) {
        
        logger.info("카테고리 인사이트 생성 요청 - categoryId: {}", categoryId);
        logger.info("{}년 {}월", year, month);
        
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        
        // 기본값 설정
        if (year == 0 || month == 0) {
            LocalDate now = LocalDate.now();
            year = now.getYear();
            month = now.getMonthValue();
        }
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 카테고리 인사이트 생성
            AIInsightVO insight = aiAnalysisService.generateCategoryInsight(
                memberId, year, month, categoryId);
            
            response.put("success", true);
            response.put("insight", insight);
            
            logger.info("카테고리 인사이트 생성 완료 - insightId: {}", insight.getInsightId());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("카테고리 인사이트 생성 오류: {}", e.getMessage());
            
            response.put("success", false);
            response.put("message", "인사이트 생성 중 오류가 발생했습니다.");
            
            return ResponseEntity.status(500).body(response);
        }
    }
    
    
    // 인사이트 목록 조회 API
    @GetMapping("/insights/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getInsightsList(
            @RequestParam(defaultValue = "10") int limit,
            Authentication auth) {
        
        logger.info("인사이트 목록 조회 - limit: {}", limit);
        
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<AIInsightVO> insights = aiAnalysisService.getRecentInsights(memberId, limit);
            
            response.put("success", true);
            response.put("insights", insights);
            response.put("count", insights.size());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("인사이트 목록 조회 오류: {}", e.getMessage());
            
            response.put("success", false);
            response.put("message", "인사이트 조회 중 오류가 발생했습니다.");
            
            return ResponseEntity.status(500).body(response);
        }
    }
}
