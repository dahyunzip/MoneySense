package com.itwillbs.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.itwillbs.domain.CategoryKeywordVO;
import com.itwillbs.mapper.CategoryMapper;

@Service
public class CategoryService {
    
    private static final Logger logger = LoggerFactory.getLogger(CategoryService.class);
    
    @Autowired
    private CategoryMapper categoryMapper;
    
    @Autowired
    private ChatGPTService chatGPTService;
    
    // 자동 카테고리 분류
    public Integer autoClassifyCategory(int memberId, String transactionName) {
        logger.info("카테고리 자동 분류 - memberId: {}, name: {}", memberId, transactionName);
        
        // 1단계: 키워드 매칭
        Integer categoryId = classifyByKeyword(memberId, transactionName);
        if (categoryId != null) {
            logger.info("키워드 매칭 성공 - categoryId: {}", categoryId);
            return categoryId;
        }
        
        // 2단계: GPT 분류
        categoryId = classifyByGPT(memberId, transactionName);
        if (categoryId != null) {
            logger.info("GPT 분류 성공 - categoryId: {}", categoryId);
            return categoryId;
        }
        
        // 3단계: 기타로 분류
        logger.info("분류 실패 - 기타로 설정");
        return 10;
    }
    
    // 키워드 기반 분류
    private Integer classifyByKeyword(int memberId, String transactionName) {
        return categoryMapper.selectCategoryIdByKeyword(transactionName, memberId);
    }
    
    // GPT 기반 분류
    private Integer classifyByGPT(int memberId, String transactionName) {
        try {
            String systemPrompt = 
                "너는 거래 내역을 분석해서 카테고리를 분류하는 전문가야. "
                + "다음 카테고리 중 하나로 분류해줘: "
                + "식비, 교육, 쇼핑, 문화, 의료/건강, 교통, 주거/통신, 주거, 통신, 기타. "
                + "카테고리 이름만 정확히 답변해줘. 다른 설명은 하지 마.";
            
            String userPrompt = "거래명: " + transactionName;
            
            String categoryName = chatGPTService.askChatGPT(systemPrompt, userPrompt);
            categoryName = categoryName.trim();
            
            logger.info("GPT 응답 카테고리: {}", categoryName);
            
            // 카테고리명으로 ID 찾기
            Integer categoryId = categoryMapper.selectCategoryIdByName(categoryName, memberId);
            
            return categoryId;
            
        } catch (Exception e) {
            logger.error("GPT 분류 오류: {}", e.getMessage());
            return null;
        }
    }
    
    // 사용자 학습 (카테고리 수정 시)
    @Transactional
    public void learnFromUser(int memberId, String transactionName, int categoryId) {
        logger.info("사용자 학습 - memberId: {}, name: {}", memberId, transactionName);
        logger.info("categoryId: {}", categoryId);
        
        // 거래명에서 핵심 키워드 추출
        String keyword = extractKeyword(transactionName);
        
        // 키워드 등록
        CategoryKeywordVO keywordVO = new CategoryKeywordVO();
        keywordVO.setCategoryId(categoryId);
        keywordVO.setKeyword(keyword);
        keywordVO.setPriority(5);
        keywordVO.setMemberId(memberId);
        
        categoryMapper.insertKeyword(keywordVO);
        
        logger.info("사용자 키워드 학습 완료 - keyword: {}", keyword);
    }
    
    // 키워드 추출
    private String extractKeyword(String transactionName) {
        // 공백 기준 첫 단어
        if (transactionName.contains(" ")) {
            return transactionName.split(" ")[0];
        }
        
        // 5글자 이상이면 앞 5글자
        if (transactionName.length() > 5) {
            return transactionName.substring(0, 5);
        }
        
        return transactionName;
    }
}