package com.itwillbs.service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.mapper.StatisticsMapper;

@Service
public class StatisticsService {
	
	private static final Logger logger = LoggerFactory.getLogger(StatisticsService.class);
	
	@Autowired
    private StatisticsMapper statisticsMapper;
	
	// 이 달의 카테고리별 지출
    public List<Map<String, Object>> getMonthlyCategoryExpense(int memberId) {
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();
        
        logger.info("카테고리별 지출 조회 - memberId: {}", memberId);
        logger.info("{}년 {}월", year, month);
        
        return statisticsMapper.selectMonthlyCategoryExpense(memberId, year, month);
    }
    
    // 주간 지출 추세
    public List<Map<String, Object>> getWeeklyExpenseTrend(int memberId) {
        logger.info("주간 지출 추세 조회 - memberId: {}", memberId);
        return statisticsMapper.selectWeeklyExpenseTrend(memberId, 4);
    }
    
    // 월별 소비 트렌드
    public List<Map<String, Object>> getMonthlyExpenseTrend(int memberId) {
        logger.info("월별 소비 트렌드 조회 - memberId: {}", memberId);
        return statisticsMapper.selectMonthlyExpenseTrend(memberId, 6);
    }
    
    // 카테고리별 증감률
    public List<Map<String, Object>> getCategoryChangeRate(int memberId) {
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();
        
        logger.info("카테고리별 증감률 조회 - memberId: {}", memberId);
        logger.info(" {}년 {}월", year, month);
        
        List<Map<String, Object>> data = statisticsMapper.selectCategoryChangeRate(memberId, year, month);
        
        // 증감률 계산
        for (Map<String, Object> item : data) {
            int current = ((Number) item.get("currentAmount")).intValue();
            int previous = ((Number) item.get("previousAmount")).intValue();
            
            double changeRate = 0;
            if (previous > 0) {
                changeRate = ((double)(current - previous) / previous) * 100;
            } else if (current > 0) {
                changeRate = 100;
            }
            
            item.put("changeRate", changeRate);
        }
        
        return data;
    }
    
    // 대시보드 전체 데이터
    public Map<String, Object> getDashboardData(int memberId) {
        Map<String, Object> dashboard = new HashMap<>();
        
        dashboard.put("categoryExpense", getMonthlyCategoryExpense(memberId));
        dashboard.put("weeklyTrend", getWeeklyExpenseTrend(memberId));
        dashboard.put("monthlyTrend", getMonthlyExpenseTrend(memberId));
        dashboard.put("categoryChange", getCategoryChangeRate(memberId));
        
        return dashboard;
    }
    
 // 이번 달 총 지출
    public Map<String, Object> getMonthlyTotalExpense(int memberId) {
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();
        
        logger.info("이번 달 총 지출 조회 - memberId: {}", memberId);
        logger.info("{}년 {}월", year, month);
        
        return statisticsMapper.selectMonthlyTotalExpense(memberId, year, month);
    }

    // 이번 달 총 수입
    public Map<String, Object> getMonthlyTotalIncome(int memberId) {
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();
        
        logger.info("이번 달 총 수입 조회 - memberId: {}", memberId);
        logger.info("{}년 {}월", year, month);
        
        return statisticsMapper.selectMonthlyTotalIncome(memberId, year, month);
    }
}
