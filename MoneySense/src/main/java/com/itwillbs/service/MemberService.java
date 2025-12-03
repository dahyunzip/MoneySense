package com.itwillbs.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.mapper.MemberMapper;

@Service
public class MemberService {

	private static final Logger logger = LoggerFactory.getLogger(MemberService.class);	
	
	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	/*
	 * 회원가입 처리
	 * @param member - 회원정보
	 * @return 성공 : true, 실패 : false
	 * */
	public boolean joinMember(MemberVO member) {
		logger.info(" ========== ");
		logger.info("회원가입 처리 시작 : " + member.getEmail());
		logger.info(" ========== ");
		
		try {
			// 1. 비밀번호 암호화
			String rawPassword = member.getPassword();
			String encodedPassword = passwordEncoder.encode(rawPassword);
			member.setPassword(encodedPassword);
			
			logger.info("비밀번호 암호화 완료!");
			
			// 2. 회원 정보 저장
			int result = memberMapper.insertMember(member);
			
			if(result > 0) {
				logger.info(" 회원 정보 저장 성공 - member_id : " + member.getMemberId());
				
				// 3. 회원 권한 저장
				memberMapper.insertMemberAuth(member.getMemberId());
				logger.info(" 회원 권한 저장 완료 ");
				logger.info(" ========== ");
				logger.info(" 회원가입 완료 : " + member.getEmail());
				logger.info(" ========== ");
				
				return true;
			}
		}catch(Exception e) {
			logger.info(" XXX 회원가입 실패 XXX : " + e.getMessage());
			e.printStackTrace();
		}
		return false;
	}
	
	/**
	 * 이메일 중복 체크
	 * @param email - 확인할 이메일
	 * @return 중복 : true, 사용 가능 : false
	 */
	 public boolean checkEmailDuplicate(String email) {
		 logger.info(" 이메일 중복 체크 : " +email);
		 int count = memberMapper.checkEmailDuplicate(email);
		 return count > 0; // 중복이면 true
	 }
	
	 // ===== 마이페이지 관련 추가 메서드 =====
	 /**
	  * memberId로 회원 정보 조회
	  * @param memberId
	  * @return MemberVO
	  * */
	 public MemberVO getMemberById(int memberId) {
		 logger.info("회원 정보 조회 : memberId : " + memberId);
		 return memberMapper.selectMemberById(memberId);
	 }
	 
	 /**
	  * 회원 이름 수정
	  * @param memberId
	  * @param name
	  * @return 성공 : true, 실패 : false
	  */
	 public boolean updateMemberName(int memberId, String name) {
		 logger.info("회원 이름 수정 시작");
		 logger.info(" memberId : " + memberId + ", 새 이름 : " +name);
		 try {
			 MemberVO member = new MemberVO();
			 member.setMemberId(memberId);
			 member.setName(name);
			 
			 int result = memberMapper.updateMemberName(member);
			 
			 if(result >0) {
				 logger.info(" 회원 이름 수정 완료! ");
				 return true;
			 }
			 
		 }catch(Exception e) {
			 logger.info("회원 이름 수정 실패 : " + e.getMessage());
			 e.printStackTrace();
		 }
		 return false;
	 }
	 
	 /**
	  * 회원 탈퇴
	  * @param memberId
	  * @param password
	  * @return 성공 : true, 실패 : false
	  * */
	 public boolean withdrawMember(int memberId, String password) {
		 logger.info(" 회원 탈퇴 시작 - memberId : " + memberId);
		 try {
			 // 회원 정보 조회
			 MemberVO member = memberMapper.selectMemberById(memberId);
			 if(member == null) {
				 logger.info(" 회원 정보 없음");
				 return false;
			 }
			 
			 // 비밀번호 확인
			 if(!passwordEncoder.matches(password, member.getPassword())) {
				 logger.info(" 비밀번호가 일치하지 않음");
				 return false;
			 }
			 
			 // 회원 탈퇴 처리
			 int result = memberMapper.deleteMember(memberId);
			 if(result > 0) {
				 logger.info(" 회원 탈퇴 완료 !!! ");
				 return true;
			 }
		 }catch(Exception e) {
			 logger.info(" 회원 탈퇴 실패 : " +e.getMessage());
			 e.printStackTrace();
		 }
		 return false;
	 }
	 
	 
}
