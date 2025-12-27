package com.itwillbs.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.domain.BankAccountVO;
import com.itwillbs.domain.OpenbankTokenVO;
import com.itwillbs.domain.openbank.AccountSearchRequestVO;
import com.itwillbs.domain.openbank.AccountSearchResponseVO;
import com.itwillbs.domain.openbank.RequestTokenVO;
import com.itwillbs.domain.openbank.ResponseTokenVO;
import com.itwillbs.mapper.BankAccountMapper;
import com.itwillbs.mapper.OpenbankTokenMapper;

@Service
public class OpenBankingService {
	
	private static final Logger logger = LoggerFactory.getLogger(OpenBankingService.class);
	
	@Autowired
	private OpenBankingApiClient openBankingApiClient;
	
	@Autowired
	private OpenbankTokenMapper openbankTokenMapper;
	
	@Autowired
	private BankAccountMapper bankAccountMapper;
	
	//토큰 발급 및 DB 저장
	@Transactional
	public ResponseTokenVO requestAndSaveToken(RequestTokenVO requestTokenVO, int memberId) throws Exception{
		logger.info(" @@@@@ 토큰 발급 및 저장 시작 ! - memberId : {}", memberId);
		ResponseTokenVO responseToken = openBankingApiClient.requestToken(requestTokenVO);
		
		logger.info("토큰 발급 성공 : {}", responseToken);
		
		OpenbankTokenVO tokenVO = new OpenbankTokenVO();
		tokenVO.setMemberId(memberId);
		
		logger.info("setMemberId 직후 - tokenVO.getMemberId(): {}", tokenVO.getMemberId());
		
		tokenVO.setAccessToken(responseToken.getAccess_token());
		tokenVO.setRefreshToken(responseToken.getRefresh_token());
		tokenVO.setUserSeqNo(responseToken.getUser_seq_no());
		
		long expiresInMillis = System.currentTimeMillis() + (responseToken.getExpires_in() * 1000L);
		tokenVO.setExpiresAt(new Timestamp(expiresInMillis));
		
		logger.info("최종 tokenVO: {}", tokenVO);
	    logger.info("tokenVO.toString(): {}", tokenVO.toString());
		
		OpenbankTokenVO existingToken = openbankTokenMapper.selectTokenByMemberId(memberId);
		
		if(existingToken != null) {
			openbankTokenMapper.updateToken(tokenVO);
			logger.info(" 기존 토큰 업데이트 완료");
		}else {
			logger.info(" 새 토큰 저장 ");
			logger.info("INSERT 직전 tokenVO.getMemberId(): {}", tokenVO.getMemberId());
			openbankTokenMapper.insertToken(tokenVO);
		}
		
		logger.info(" 토큰 저장 완료! ");
		logger.info(" =============================================== ");
		return responseToken;
		
	}
	
	// 토큰 갱신
	public ResponseTokenVO refreshAccessToken(int memberId) throws Exception{
		logger.info(" 토큰 갱신 시작 - memberId: {}", memberId);
		
		// 1. 기존 토큰 조회
		OpenbankTokenVO existingToken = openbankTokenMapper.selectTokenByMemberId(memberId);
		
		if (existingToken == null || existingToken.getRefreshToken() == null) {
			throw new Exception("Refresh Token이 없습니다. 재인증이 필요합니다.");
		}
		
		// 2. 토큰 갱신 API 호출
		ResponseTokenVO newToken = openBankingApiClient.refreshToken(existingToken.getRefreshToken());
		
		// 3. DB 업데이트
		OpenbankTokenVO tokenVO = new OpenbankTokenVO();
		tokenVO.setMemberId(memberId);
		tokenVO.setAccessToken(newToken.getAccess_token());
		tokenVO.setRefreshToken(newToken.getRefresh_token());
		tokenVO.setUserSeqNo(newToken.getUser_seq_no());
		
		long expiresInMillis = System.currentTimeMillis() + (newToken.getExpires_in() * 1000L);
		tokenVO.setExpiresAt(new Timestamp(expiresInMillis));
		
		openbankTokenMapper.updateToken(tokenVO);
		
		logger.info(" 토큰 갱신 완료!");
		return newToken;
	}
	
	// 유효한 토큰 조회 (자동 갱신 포함)
	public OpenbankTokenVO getValidToken(int memberId) throws Exception {
		logger.info(" 유효한 토큰 조회 - memberId: {}", memberId);
		
		OpenbankTokenVO token = openbankTokenMapper.selectTokenByMemberId(memberId);
		
		if (token == null) {
			throw new Exception("토큰 정보가 없습니다. 계좌 연동을 먼저 진행해주세요.");
		}
		
		// 토큰 만료 5분 전이면 갱신
		long now = System.currentTimeMillis();
		long expiresAt = token.getExpiresAt().getTime();
		long fiveMinutes = 5 * 60 * 1000;
		
		if (now + fiveMinutes >= expiresAt) {
			logger.info(" 토큰이 만료되었거나 곧 만료됩니다. 갱신합니다.");
			refreshAccessToken(memberId);
			
			// 갱신된 토큰 다시 조회
			token = openbankTokenMapper.selectTokenByMemberId(memberId);
		}
		
		return token;
	}
	
	// 회원의 토큰 정보 조회
	public OpenbankTokenVO getTokenByMemberId(int memberId) {
		logger.info(" 토큰 조회 - memberId : {}", memberId);
		return openbankTokenMapper.selectTokenByMemberId(memberId);
	}
	
	// 계좌목록 조회 및 DB 저장 + 토큰 갱신 로직 추가
	@Transactional
	public List<BankAccountVO> getAndSaveAccounts(int memberId) throws Exception{
		logger.info(" ============================================== ");
		logger.info(" 계좌 목록 조회 시작 - memberId : {}", memberId);
		
		// 1. 토큰 조회
		OpenbankTokenVO token = openbankTokenMapper.selectTokenByMemberId(memberId);
		
		if(token == null) {
			logger.info(" 토큰 정보가 없습니다. 계좌 연동을 먼저 진행해주세요.");
			throw new Exception("토큰 정보가 없습니다.");
		}
		
		// 2. 오픈뱅킹 API로 계좌 목록 조회
		AccountSearchRequestVO request = new AccountSearchRequestVO();
		request.setAccess_token(token.getAccessToken());
		request.setUser_seq_no(token.getUserSeqNo());
		request.setInclude_cancel_yn("N");
		request.setSort_order("D");
		
		AccountSearchResponseVO response = null;
		
		try {
			response = openBankingApiClient.findAccount(request);
		} catch (Exception e) {
			// API 호출 실패 시 토큰 문제일 수 있으니 갱신 후 재시도
			logger.warn(" 계좌 조회 실패. 토큰 갱신 후 재시도: {}", e.getMessage());
			
			refreshAccessToken(memberId);
			token = openbankTokenMapper.selectTokenByMemberId(memberId);
			
			request.setAccess_token(token.getAccessToken());
			response = openBankingApiClient.findAccount(request);
		}
		
		logger.info(" 계좌 조회 완료 - 계좌 수 : {}", response.getRes_cnt());
		
		// 3. 조회한 계좌를 DB에 저장
		List<BankAccountVO> accountList = new ArrayList<>();
		
		if(response.getRes_list() != null) {
			for(Object obj : response.getRes_list()) {
				Map<String, Object> accountData = (Map<String, Object>) obj;
				String fintechUseNum = (String) accountData.get("fintech_use_num");
				
				// 중복 체크
				BankAccountVO existing = bankAccountMapper.selectAccountByAccountNum(fintechUseNum);
				
				if(existing == null) {
					BankAccountVO account = new BankAccountVO();
					account.setMemberId(memberId);
					account.setBankCode((String) accountData.get("bank_code_std"));
					account.setBankName((String) accountData.get("bank_name"));
					account.setAccountNum(fintechUseNum);
					account.setAccountName((String) accountData.get("account_alias"));
					account.setFintechUseNum(fintechUseNum);
					account.setBalance(0L); // 잔액은 별도 조회
					
					bankAccountMapper.insertAccount(account);
					accountList.add(account);
					
					logger.info(" 계좌 저장 완료 : {}", account.getBankName());
				}else {
					accountList.add(existing);
					logger.info(" 기존 계좌 존재 : {}", existing.getBankName());
				}
			}
		}
		
		logger.info(" ===================================================== ");
		return accountList;
	}
	
	
	public List<BankAccountVO> getAccountsByMemberId(int memberId){
		logger.info(" 저장된 계좌 목록 조회 - memberId : {}", memberId);
		return bankAccountMapper.selectAccountsByMemberId(memberId);
	}
	
	// 특정 계좌 조회
	public BankAccountVO getAccountById(int accountId) {
		logger.info(" 계좌 조회 - accountId : {}", accountId);
		return bankAccountMapper.selectAccountById(accountId);
	}
	
}
