package com.itwillbs.service;

import java.sql.Timestamp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.OpenbankTokenVO;
import com.itwillbs.domain.openbank.RequestTokenVO;
import com.itwillbs.domain.openbank.ResponseTokenVO;
import com.itwillbs.mapper.OpenbankTokenMapper;

@Service
public class OpenBankingService {
	
	private static final Logger logger = LoggerFactory.getLogger(OpenBankingService.class);
	
	@Autowired
	private OpenBankingApiClient openBankingApiClient;
	
	@Autowired
	private OpenbankTokenMapper openbankTokenMapper;
	
	//토큰 발급 및 DB 저장
	public ResponseTokenVO requestAndSaveToken(RequestTokenVO requestTokenVO, int memberId) throws Exception{
		logger.info(" 토큰 발급 및 저장 시작 - memberId : {}", memberId);
		
		// 1. 오픈 뱅킹 API 호출 하여 토큰 발급
		ResponseTokenVO responseToken = openBankingApiClient.requestToken(requestTokenVO);
		logger.info(" 토큰 발급 성공 : {} ", responseToken);
		
		// 2. 토큰 정보를 DB에 저장
		OpenbankTokenVO tokenVO = new OpenbankTokenVO();
		tokenVO.setMemberId(memberId);
		tokenVO.setAccessToken(responseToken.getAccess_token());
		tokenVO.setRefreshToken(responseToken.getRefresh_token());
		tokenVO.setUserSeqNo(responseToken.getUser_seq_no());
		
		// expires_in은 초 단위 이므로 현재 시간에 더해서 만료 시간 계산
		long expiresInMillis = System.currentTimeMillis() + (responseToken.getExpires_in() * 1000L);
		tokenVO.setExpiresAt(new Timestamp(expiresInMillis));
		
		// 3. 기존 토큰이 있는지 확인
		OpenbankTokenVO existingToken = openbankTokenMapper.selectTokenByMemberId(memberId);
		
		if(existingToken != null) {
			// 기존 토큰이 있으면 업데이트
			openbankTokenMapper.updateToken(tokenVO);
			logger.info(" 기존 토큰 업데이트 완료 ");
		}else {
			// 없으면 새로 저장
			openbankTokenMapper.insertToken(tokenVO);
			logger.info(" 새 토큰 저장 완료");
		}
		logger.info(" ======================================== ");
		return responseToken;
	}
	
	// 회원의 토큰 정보 조회
	public OpenbankTokenVO getTokenByMemberId(int memberId) {
		logger.info(" 토큰 조회 - memberId : {}", memberId);
		return openbankTokenMapper.selectTokenByMemberId(memberId);
	}
}
