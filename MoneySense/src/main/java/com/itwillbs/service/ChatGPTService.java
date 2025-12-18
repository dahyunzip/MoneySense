package com.itwillbs.service;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class ChatGPTService {
	
	private static final Logger logger = LoggerFactory.getLogger(ChatGPTService.class);
	
	@Inject
	private ChatGPTClient gptClient;
	
	public String askChatGPT(String systemPrompt, String userPrompt) throws Exception{
		logger.info("askChatGPT() 실행");
		// gpt 호출동작 실행
		String result = gptClient.sendChatGPT(systemPrompt, userPrompt);
	    return result;
	}
}
