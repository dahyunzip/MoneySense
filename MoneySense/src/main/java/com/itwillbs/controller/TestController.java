package com.itwillbs.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import com.itwillbs.service.OpenBankingApiClient;

@Controller
@RequestMapping("/test")
public class TestController {
	
	private static final Logger logger = LoggerFactory.getLogger(TestController.class);
	
	@Value("${openbanking.client_id}")
	private String clientId;
	
	@Value("${openbanking.client_secret}")
	private String clientSecret;
	
	@Value("${openbanking.redirect_uri}")
	private String redirectUri;
	
	@Value("${openbanking.base_url}")
	private String baseUrl;
	
	@Value("${openbanking.grant_type}")
	private String grantType;
	
	@Autowired
	private OpenBankingApiClient openBankingApiClient;
	
	@GetMapping("/config")
	public String testConfig(Model model) {
		logger.info("========================================");
		logger.info(" 오픈뱅킹 설정 확인 ");
		logger.info("========================================");
		
		logger.info("client_id: {}", clientId);
        logger.info("client_secret: {}", clientSecret);
        logger.info("redirect_uri: {}", redirectUri);
        logger.info("base_url: {}", baseUrl);
        logger.info("grant_type: {}", grantType);
        
        logger.info("========================================");
        logger.info("OpenBankingApiClient 빈 주입: {}", 
                    openBankingApiClient != null ? "성공" : "실패");
        logger.info("========================================");
        
        model.addAttribute("clientId", clientId);
        model.addAttribute("clientSecret", maskSecret(clientSecret));
        model.addAttribute("redirectUri", redirectUri);
        model.addAttribute("baseUrl", baseUrl);
        model.addAttribute("grantType", grantType);
        model.addAttribute("apiClientStatus", 
                          openBankingApiClient != null ? "주입 성공" : "주입 실패");
        
        return "test/config";
	}
	
	public String maskSecret(String secret) {
		if(secret == null || secret.length() < 4) {
			return "****";
		}
		return secret.substring(0, 4) + "****" + secret.substring(secret.length() - 4);
	}
	
}
