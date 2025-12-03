package com.itwillbs.component;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

@Component
public class EmailSenderUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EmailSenderUtil.class);
	
	@Autowired
	private JavaMailSender mailSender;
	
	private String fromAddress = "moneysense@gmail.com";
	
	@Async
	public void sendEmail(String to, String subject, String htmlContent) {
		try {
			logger.info(" 메일 전송 시작 : " + to);
			
			MimeMessage mimeMessage = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
			
			helper.setFrom(fromAddress);
			helper.setTo(to);
			helper.setSubject(subject);
			helper.setText(htmlContent, true);
			
			mailSender.send(mimeMessage);
			
			logger.info(" 메일 전송 완료 : " + to);
		}catch(Exception e){
			logger.info(" 메일 전송 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
}
