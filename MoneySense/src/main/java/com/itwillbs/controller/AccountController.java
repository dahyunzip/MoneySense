package com.itwillbs.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.openbank.RequestTokenVO;
import com.itwillbs.domain.openbank.ResponseTokenVO;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.OpenBankingService;

@Controller
@RequestMapping("/accounts")
public class AccountController {
	
	private static final Logger logger = LoggerFactory.getLogger(AccountController.class);
	
	@Autowired
	private OpenBankingService openBankingService;
	
	/*
	 * 오픈뱅킹 인증 후 콜백 
	 * URL : http://localhost:8088/accounts/callback?code=xxxxx&scope=xxxxx&state=xxxxx
	 * */
	@GetMapping("/callback")
	public String callback(RequestTokenVO requestTokenVO,
							RedirectAttributes rttr,
							Model model) {
		logger.info("========================================");
		logger.info(" 오픈뱅킹 인증 콜백 ");
		logger.info(" code : {}", requestTokenVO.getCode());
		logger.info(" scope : {}", requestTokenVO.getScope());
		logger.info(" state : {}", requestTokenVO.getState());
		logger.info("========================================");
		
		// 현재 로그인한 회원 정보 가져오기
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		logger.info(" 로그인 회원 ID : {}", memberId);
		
		try {
			//토큰 발급 및 DB 저장
			ResponseTokenVO responseToken =
					openBankingService.requestAndSaveToken(requestTokenVO, memberId);
			
			model.addAttribute("tokenInfo", responseToken);
			model.addAttribute("msg", "계좌 연동이 완료되었습니다.");
			
			return "account/callback-success";
		}catch(Exception e) {
			logger.info(" 토큰 발급 실패 : " + e.getMessage());
			e.printStackTrace();
			
			rttr.addFlashAttribute("msg", "계좌 연동에 실패했습니다. 다시 시도해 주세요.");
			return "redirect:/main";
		}
	}
	
	
	// 계좌 연동 시작 페이지
	@GetMapping("/connect")
	public String connectPage() {
		logger.info(" 계좌 연동 페이지 요청 ");
		return "account/connect";
	}
}
