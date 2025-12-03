package com.itwillbs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.security.CustomUserDetails;
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
	
	// 로그아웃 처리
	@GetMapping("/logout")
	public String logout(HttpServletRequest request,
						HttpServletResponse response,
						RedirectAttributes rttr) {
		logger.info(" 로그아웃 요청");
		// 현재 인증정보 가져오기
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if(auth != null) {
			logger.info(" 로그아웃 사용자 : " + auth.getName());
			// Spring Security 로그아웃 핸들러
			new SecurityContextLogoutHandler().logout(request, response, auth);
			logger.info(" 로그아웃 완료! ");
		}

		rttr.addFlashAttribute("msg", "로그아웃 되었습니다.");
		return "redirect:/members/login";
	}
	
	
	// 접근 거부 페이지
	@GetMapping("/access-denied")
	public String accessDenied() {
		logger.info(" 접근 거부 ");
		return "member/access-denied";
	}
	
	
	//////////////////////////////////////////////////
	// 마이페이지 관련 메서드
	
	// 마이페이지 메인
	@GetMapping("/mypage")
	public String mypage(Model model) {
		logger.info(" 마이페이지 요청 ");
		
		//Spring Security에서 현재 로그인한 사용자 정보 가져오기
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		// 회원 정보 조회
		MemberVO member = mService.getMemberById(memberId);
		model.addAttribute("member", member);
		
		return "member/mypage";
	}
	
	// 회원정보 수정 페이지
	@GetMapping("/mypage/edit")
	public String editPage(Model model) {
		logger.info(" 회원정보 수정 페이지 요청");
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		MemberVO member = mService.getMemberById(memberId);
		model.addAttribute("member", member);
		
		return "member/mypage-edit";
	}
	
	// 이름 수정 처리
	@PostMapping("/mypage/update-name")
	public String updateName(@RequestParam String name, RedirectAttributes rttr) {
		logger.info(" 이름 수정 요청 : " + name );
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		boolean result = mService.updateMemberName(memberId, name);
		
		if(result) {
			rttr.addFlashAttribute("msg", "이름이 수정되었습니다.");
		}else {
			rttr.addFlashAttribute("msg", "이름 수정에 실패했습니다.");
		}
		return "redirect:/members/mypage";
	}
	
	// 회원 탈퇴 페이지
	@GetMapping("/mypage/withdraw")
	public String withdrawPage() {
		logger.info(" 회원 탈퇴 페이지 요청 ");
		return "member/mypage-withdraw";
	}
	// 회원 탈퇴 처리
	@PostMapping("/mypage/withdraw")
	public String withdraw(@RequestParam String password,
							RedirectAttributes rttr,
							HttpSession session) {
		logger.info(" 회원 탈퇴 요청 ");
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		int memberId = userDetails.getMember().getMemberId();
		
		boolean result = mService.withdrawMember(memberId, password);
		
		if(result) {
			rttr.addFlashAttribute("msg", "회원 탈퇴가 완료되었습니다.");
			session.invalidate();
			SecurityContextHolder.clearContext();
			return "redirect:/members/login";
		}else {
			rttr.addFlashAttribute("msg", "비밀번호가 일치하지 않습니다.");
			return "redirect:/members/mypage/withdraw";
		}
	}
}
