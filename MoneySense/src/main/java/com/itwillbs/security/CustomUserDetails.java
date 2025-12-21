package com.itwillbs.security;


import java.util.Collection;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.itwillbs.domain.MemberVO;

import lombok.Getter;

@Getter
public class CustomUserDetails implements UserDetails{
	
	private static final Logger logger = LoggerFactory.getLogger(CustomUserDetails.class);
	
	private static final long serialVersionUID = 1L;
	
	private MemberVO member;
	
	public CustomUserDetails(MemberVO member) {
		this.member = member;
	}
	
    public void setMember(MemberVO member) {
        this.member = member;
    }
	
	// 권한 목록 반환
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities(){
		return member.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuthority()))
				.collect(Collectors.toList());
	}

	// 비밀번호 반환
	@Override
	public String getPassword() {
		return member.getPassword();
	}

	// 사용자 ID(email) 반환
	@Override
	public String getUsername() {
		return member.getEmail();
	}

	// 계정 만료 여부 (true : 만료 안됨)
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	// 계정 잠금 여부 (true : 잠금 안됨)
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	// 비밀번호 만료 여부 (true : 만료 안됨)
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	// 계정 활성화 여부 (true : 활성화)
	@Override
	public boolean isEnabled() {
		return member.getIsDeleted() == 0;
	}
}
