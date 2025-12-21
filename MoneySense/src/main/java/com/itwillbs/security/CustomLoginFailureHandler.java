package com.itwillbs.security;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class CustomLoginFailureHandler implements AuthenticationFailureHandler {

	private static final Logger logger = LoggerFactory.getLogger(CustomLoginFailureHandler.class);
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		
		logger.info("로그인 실패!");
		logger.info("에러 메시지: " + exception.getMessage());
		
		String errorMessage = "이메일 또는 비밀번호가 올바르지 않습니다.";
		
		// 예외 타입에 따른 메시지 설정
		if (exception instanceof BadCredentialsException) {
			errorMessage = "이메일 또는 비밀번호가 올바르지 않습니다.";
		} else if (exception instanceof UsernameNotFoundException) {
			errorMessage = "존재하지 않는 계정입니다.";
		} else if (exception instanceof DisabledException) {
			errorMessage = "비활성화된 계정입니다.";
		}
		
		// 로그인 페이지로 리다이렉트
		response.sendRedirect(request.getContextPath() + "/members/login?error=true&message=" 
				+ URLEncoder.encode(errorMessage, "UTF-8"));
	}
}
