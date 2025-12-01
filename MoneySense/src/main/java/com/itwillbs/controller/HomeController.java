package com.itwillbs.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	// http://localhost:8088/controller/
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Authentication authentication) {

		logger.info(" home 요청 ");
		
		// 이미 로그인돼있으면 메인으로 리다이렉트
		if(authentication != null && authentication.isAuthenticated()) {
			logger.info(" 이미 로그인된 사용자, 메인페이지로 ");
			return "redirect:/main";
		}
		
		return "home";
	}
	
	@GetMapping("/main")
	public String main() {
		logger.info(" 메인 페이지 요청 ");
		return "main";
	}
	
}
