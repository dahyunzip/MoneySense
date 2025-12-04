package com.itwillbs.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import com.itwillbs.domain.openbank.AccountSearchRequestVO;
import com.itwillbs.domain.openbank.AccountSearchResponseVO;
import com.itwillbs.domain.openbank.RequestTokenVO;
import com.itwillbs.domain.openbank.ResponseTokenVO;

@Component
public class OpenBankingApiClient {
	
	private static final Logger logger = LoggerFactory.getLogger(OpenBankingApiClient.class);
	
	@Value("${openbanking.client_id}")
	private String clientId;
	
	@Value("${openbanking.client_secret}")
	private String clientSecret;
	
	@Value("${openbanking.redirect_uri}")
	private String redirectUri;
	
	@Value("${openbanking.base_url}")
	private String baseUrl;
	
	@Value("${openbanking.grant_type}")
	private String grantType;
	
	private RestTemplate restTemplate;
	private HttpHeaders httpHeaders;
	
	// 토큰 발급 요청
	public ResponseTokenVO requestToken(RequestTokenVO requestTokenVO) throws Exception{
		logger.info(" 토큰 발급 요청 시작 ");
		
		restTemplate = new RestTemplate();
		httpHeaders = new HttpHeaders();
		
		httpHeaders.add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
		
		requestTokenVO.setClient_id(clientId);
		requestTokenVO.setClient_secret(clientSecret);
		requestTokenVO.setRedirect_uri(redirectUri);
		requestTokenVO.setGrant_type(grantType);
		
		MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();
		parameters.add("code", requestTokenVO.getCode());
		parameters.add("client_id", requestTokenVO.getClient_id());
		parameters.add("client_secret", requestTokenVO.getClient_secret());
		parameters.add("redirect_uri", requestTokenVO.getRedirect_uri());
		parameters.add("grant_type", requestTokenVO.getGrant_type());
		
		HttpEntity<MultiValueMap<String, String>> param = new HttpEntity<>(parameters, httpHeaders);
		
		String requestURL = "https://testapi.openbanking.or.kr/oauth/2.0/token";
		
		ResponseTokenVO response = restTemplate.exchange(requestURL, HttpMethod.POST, param, ResponseTokenVO.class).getBody();
		
		logger.info(" 토큰 발급 완료 : {}", response);
		
		return response;
	} // requestToken
	
	// 계좌 목록 조회
	public AccountSearchResponseVO findAccount(AccountSearchRequestVO accountSearchRequestVO) throws Exception{
		logger.info(" 계좌 목록 조회 시작 ");
		
		restTemplate = new RestTemplate();
		httpHeaders = new HttpHeaders();
		
		String url = baseUrl + "/account/list";
		
		httpHeaders.add("Authorization", "Bearer " + accountSearchRequestVO.getAccess_token());
		
		HttpEntity<String> accountListRequest = new HttpEntity<>(httpHeaders);
		
		UriComponents uriBuilder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("user_seq_no", accountSearchRequestVO.getUser_seq_no())
				.queryParam("include_cancel_yn", accountSearchRequestVO.getInclude_cancel_yn())
				.queryParam("sort_order", accountSearchRequestVO.getSort_order())
				.build();
		
		AccountSearchResponseVO response = restTemplate.exchange(
				uriBuilder.toString(),
				HttpMethod.GET,
				accountListRequest,
				AccountSearchResponseVO.class
				).getBody();
		
		logger.info(" 계좌 목록 조회 완료 : {}", response);
		
		return response;
	} //findAccount
	
	
	
	
} // OpenBankingApiClient
