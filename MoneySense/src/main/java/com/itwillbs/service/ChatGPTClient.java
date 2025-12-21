package com.itwillbs.service;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class ChatGPTClient {
	
	private static final Logger logger = LoggerFactory.getLogger(ChatGPTClient.class);
	
	private String URL = "https://api.openai.com/v1/chat/completions";
	private String MODEL = "gpt-4o-mini";
	private double TEMPERATURE = 0.5;
	
	@Value("${openai.api.key}")
	private String APIKEY;
	
	public String sendChatGPT(String systemPrompt, String userPrompt) {
		
		// 1. 헤더 정보 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Authorization", "Bearer " + APIKEY);
		
		// 2. 요청 파라메터 정보 설정
		Map<String, String> roleSystem = new HashMap<>();
		roleSystem.put("role", "system");
		roleSystem.put("content", systemPrompt);
		
		// 사용자 요청정보(질문) 설정
		Map<String, String> roleUser = new HashMap<>();
		roleUser.put("role", "user");
		roleUser.put("content", userPrompt);
		
		// 리스트에 시스템 설정 + 사용자 질문정보 설정 저장
		List<Map<String, String>> messages = new ArrayList<>();
		messages.add(roleSystem);
		messages.add(roleUser);
		
		// Map 정보를 JSON 객체로 변환
		JSONObject requestData = new JSONObject();
		requestData.put("model", MODEL);
		requestData.put("temperature", TEMPERATURE);
		requestData.put("messages", messages);
		logger.info("-------------------- 전달 준비 완료 ! -------------------- ");
		
		// 3. HTTP 요청 정보를 관리하는 객체
		HttpEntity<String> httpEntity = new HttpEntity<>(requestData.toString(), headers);
		logger.info(" httpEntity : " + httpEntity);
		
		// 4. REST API 호출 객체 RestTemplate 생성
		RestTemplate restTemplate = new RestTemplate();
		
		// UTF-8 인코딩 설정
		List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
		messageConverters.add(new StringHttpMessageConverter(StandardCharsets.UTF_8));
		messageConverters.addAll(restTemplate.getMessageConverters());
		
		// RestTemplate 객체에 UTF-8 인코딩 설정
		restTemplate.setMessageConverters(messageConverters);
		
		// Rest API 호출
		ResponseEntity<String> responseEntity = restTemplate.exchange(URL, HttpMethod.POST, httpEntity, String.class);
		//String body = new String(responseEntity.getBody().getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
		String body = responseEntity.getBody();
		
		logger.info(" responseEntity : " + responseEntity);
		
		// JSON 응답 파싱
		JSONObject responseJson = new JSONObject(body);
		String answer = responseJson
		    .getJSONArray("choices")
		    .getJSONObject(0)
		    .getJSONObject("message")
		    .getString("content");

		logger.info("ChatGPT 답변: " + answer);
		return answer;
	}
}
