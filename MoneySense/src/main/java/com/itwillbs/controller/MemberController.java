package com.itwillbs.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;

@Controller
@RequestMapping("/members")
public class MemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	private MemberService mService;
	
	// 회원가입 페이지 이동
	@GetMapping("/signup")
	public String signupForm() {
		logger.info(" 회원가입 페이지 요청 ");
		return "member/signup";
	}
	
	// 회원가입 처리
	@PostMapping("/signup")
	public String signup(MemberVO member, RedirectAttributes rttr) {
		logger.info(" 회원가입 요청 : " + member);
		
		// 회원가입 처리
		boolean result = mService.joinMember(member);
		
		if(result) {
			rttr.addFlashAttribute("msg", "회원가입이 완료되었습니다. 로그인해주세요.");
			return "redirect:/members/login";
		}else {
			rttr.addFlashAttribute("msg", "회원가입에 실패했습니다. 다시 시도해주세요.");
			return "redirect:/signup";
		}
	}
	
	// 이메일 중복 체크 (AJAX)
	@ResponseBody
	@GetMapping("/check-email")
	public String checkEmail(@RequestParam String email) {
		logger.info(" 이메일 중복 체크 요청 : " + email);
		
		boolean isDuplicate = mService.checkEmailDuplicate(email);
		if(isDuplicate) {
			return "duplicate"; // 중복
		}else {
			return "available"; // 사용가능
		}
	}
	
	// 로그인 페이지 이동
	@GetMapping("/login")
	public String login(@RequestParam(required = false) String error,
						@RequestParam(required = false) String message,
						@RequestParam(required = false) String expired,
						Model model) {
		logger.info(" 로그인 페이지 요청");
		if(error != null) {
			if(message != null) {
				model.addAttribute("msg", message);
			}else {
				model.addAttribute("msg", "이메일 또는 비밀번호가 올바르지 않습니다.");
			}
		}
		if(expired != null) {
			model.addAttribute("msg", "세션이 만료되었습니다. 다시 로그인해주세요.");
		}
		
		return "member/login";
	}
	
	// 접근 거부 페이지
	@GetMapping("/access-denied")
	public String accessDenied() {
		logger.info(" 접근 거부 ");
		return "member/access-denied";
	}
	
}
