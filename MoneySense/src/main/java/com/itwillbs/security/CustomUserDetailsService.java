package com.itwillbs.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.mapper.MemberMapper;

@Service
public class CustomUserDetailsService implements UserDetailsService{

	private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);

	@Autowired
	private MemberMapper memberMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		logger.info("로그인 시도 - email : " + username);
		
		//email로 회원 정보 조회
		MemberVO member = memberMapper.selectMemberByEmail(username);
		
		if(member == null) {
			logger.info("회원 정보를 찾을 수 없습니다. : " + username);
			throw new UsernameNotFoundException("회원 정보를 찾을 수 없습니다. : " + username);
		}
		
		// 탈퇴한 회원 체크
		if(member.getIsDeleted() == 1) {
			logger.info("탈퇴한 회원입니다. : " + username);
			throw new UsernameNotFoundException("탈퇴한 회원입니다. : " +username);
		}
		
		logger.info("회원 정보 조회 성공 : " + member);
		
		return new CustomUserDetails(member);
	}
	
}
