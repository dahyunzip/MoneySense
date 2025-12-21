package com.itwillbs.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.StatisticsService;

@Controller
@RequestMapping("/statistics")
public class StatisticsController {
	
	private static final Logger logger = LoggerFactory.getLogger(StatisticsController.class);
	
	@Autowired
    private StatisticsService statisticsService;
	
	// 통계 페이지
    @GetMapping("/dashboard")
    public String dashboard() {
        logger.info("통계 대시보드 페이지");
        return "statistics/dashboard";
    }
    
    // 대시보드 데이터 API
    @GetMapping("/data")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getData(Authentication auth) {
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        int memberId = userDetails.getMember().getMemberId();
        
        logger.info("대시보드 데이터 조회 - memberId: {}", memberId);
        
        Map<String, Object> data = statisticsService.getDashboardData(memberId);
        
        return ResponseEntity.ok(data);
    }
}
