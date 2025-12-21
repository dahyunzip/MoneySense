package com.itwillbs.service;

import java.util.concurrent.ConcurrentHashMap;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
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
	
	@Autowired
	private JavaMailSender mailSender;
	
	// 토큰 저장소
	private ConcurrentHashMap<String, String> tokenStore = new ConcurrentHashMap<>();

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
	 

	 
	 /**
	  * 비밀번호 재설정 관련 메서드 추가 
	  * */
	 public MemberVO findMemberByEmail(String email) {
		 logger.info(" 이메일로 회원 조회 : " + email);
		 return memberMapper.selectMemberByEmail(email);
	 }
	 
	 @Async
	 public void sendResetMail(String toEmail, String token, String baseUrl) {
		 try {
			 logger.info(" 비밀번호 재설정 메일 발송 시작 : " + toEmail);
			 String resetLink = baseUrl+"/members/reset-password?token=" + token;
			 
			 MimeMessage mimeMessage = mailSender.createMimeMessage();
			 MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
			 
			 helper.setTo(toEmail);
			 helper.setSubject("[MoneySense] 비밀번호 재설정 안내");
			 String htmlContent = ""
		                + "<div style='font-family: Pretendard, sans-serif; max-width: 500px; margin: 0 auto; padding: 30px; border: 1px solid #ddd; border-radius: 8px;'>"
		                + "<h2 style='color:#007bff; text-align:center;'>MoneySense 비밀번호 재설정 안내</h2>"
		                + "<p style='font-size:15px; color:#333;'>안녕하세요, MoneySense 회원님</p>"
		                + "<p style='font-size:15px; color:#333;'>아래 버튼을 클릭하시면 비밀번호 재설정 페이지로 이동합니다.<br>"
		                + "보안을 위해 이 링크는 <strong>15분 동안만 유효</strong>합니다.</p>"
		                + "<div style='text-align:center; margin:30px 0;'>"
		                + "<a href='" + resetLink + "' style='background:#007bff; color:white; padding:12px 20px; text-decoration:none; border-radius:5px; font-weight:bold;'>비밀번호 재설정하기</a>"
		                + "</div>"
		                + "<p style='font-size:13px; color:#777;'>만약 버튼이 작동하지 않는다면 아래 링크를 복사해 브라우저에 붙여넣으세요.</p>"
		                + "<p style='word-break:break-all; font-size:13px; color:#007bff;'>" + resetLink + "</p>"
		                + "<hr style='margin-top:30px;'>"
		                + "<p style='font-size:12px; color:#999; text-align:center;'>본 메일은 발신전용입니다. 문의사항은 MoneySense 고객센터를 이용해주세요.</p>"
		                + "</div>";
			 helper.setText(htmlContent, true);
			 mailSender.send(mimeMessage);
			 tokenStore.put(token, toEmail);
			 logger.info(" 비밀번호 재설정 메일 발송 완료 : " + toEmail);
		 }catch(Exception e) {
			 logger.info(" 메일 전송 실패 : " +e.getMessage());
			 e.printStackTrace();
		 }
	 }
	 
	 public String getEmailByToken(String token) {
		 return tokenStore.get(token);
	 }
	 
	 public void invalidateToken(String token) {
		 tokenStore.remove(token);
	 }
	 
	 public void updatePasswordByEmail(String email, String newPassword) {
		 logger.info(" 비밀번호 재설정 처리 시작 : " + email);
		 try {
			 String encodedPassword = passwordEncoder.encode(newPassword);
			 
			 MemberVO member = new MemberVO();
			 member.setEmail(email);
			 member.setPassword(encodedPassword);
			 
			 int result = memberMapper.updatePasswordByEmail(member);
			 
			 if(result > 0) {
				 logger.info(" 비밀번호 재설정 완료! ");
			 }
		 }catch(Exception e) {
			 logger.info(" 비밀번호 재설정 처리 실패 : " + e.getMessage());
			 e.printStackTrace();
		 }
	 }
}
