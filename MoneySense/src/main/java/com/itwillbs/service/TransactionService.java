package com.itwillbs.service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.BankTransactionVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.PageVO;
import com.itwillbs.mapper.BankAccountMapper;
import com.itwillbs.mapper.BankTransactionMapper;

@Service
public class TransactionService {
	
	private static final Logger logger = LoggerFactory.getLogger(TransactionService.class);
	
	@Autowired
	private BankTransactionMapper transactionMapper;
	
	@Autowired
	private BankAccountMapper accountMapper;
	
	// Mock 거래 설명 (실제 같은 거래 내역)
    private static final String[] WITHDRAWAL_DESCRIPTIONS = {
        "스타벅스 강남점", "CU편의점", "올리브영 역삼점", "쿠팡 결제",
        "넷플릭스 구독", "전기요금", "통신비", "GS25 편의점",
        "배달의민족 결제", "요기요 결제", "카카오택시", "지하철",
        "이마트", "홈플러스", "CGV영화관", "교보문고",
        "다이소", "맥도날드", "버거킹", "롯데리아",
        "카페베네", "투썸플레이스", "이디야커피", "파리바게뜨",
        "뚜레쥬르", "배스킨라빈스", "던킨도너츠", "미스터피자",
        "도미노피자", "BBQ치킨", "BHC치킨", "교촌치킨",
        "CJ올리브영", "왓슨스", "랄라블라", "H&M",
        "ZARA", "유니클로", "무신사", "29CM",
        "쿠팡이츠", "배민", "요기요", "위메프",
        "티몬", "11번가", "G마켓", "옥션"
    };
    
    private static final String[] DEPOSIT_DESCRIPTIONS = {
            "급여입금", "상여금", "프리랜서 대금", "용돈",
            "환불", "이자", "배당금", "판매대금",
            "카카오페이 송금", "토스 송금", "계좌이체"};
    
    /**
     * Mock 거래내역 생성
     */
    public int generateMockTransactions(int accountId, int days, int transactionsPerDay) {
    	logger.info(" ========================================== ");
    	logger.info(" Mock 거래내역 생성 시작 ");
    	logger.info(" accountId: {}, 기간: {}일", accountId, days);
    	logger.info("일 평균 : {}", transactionsPerDay);
    	
    	Random random = new Random();
    	LocalDateTime now = LocalDateTime.now();
    	int totalCount = 0;
    	
    	// 초기 잔액 설정
    	int currentBalance = 1000000 + random.nextInt(4000000);
    	
    	// 과거부터 현재까지 거래내역 생성
    	for(int day = days; day>=0; day--) {
    		LocalDateTime transactionDate = now.minus(day, ChronoUnit.DAYS);
    		
    		// 하루에 몇 건의 거래가 발생할지 랜덤
    		int todayTransactions = 1 + random.nextInt(transactionsPerDay);
    		
    		for(int i =0; i<todayTransactions; i++) {
    			BankTransactionVO transaction = new BankTransactionVO();
    			transaction.setAccountId(accountId);
    			
    			// 거래 시간 랜덤 (오전 6시 ~ 오후 11시)
    			int hour = 6 + random.nextInt(17);
    			int minute = random.nextInt(60);
    			LocalDateTime txTime = transactionDate.withHour(hour).withMinute(minute);
    			transaction.setTransactedAt(Timestamp.valueOf(txTime));
    			
    			// 입금 / 출금 비율 (출금 70%, 입금 30%)
    			boolean isWithdrawal = random.nextInt(100) < 70;
    			
    			if(isWithdrawal) {
    				// 출금
    				transaction.setInoutType("O");
    				
    				// 출금액 (1,000원 ~ 100,000원)
    				int amount = (random.nextInt(100) + 1) * 1000;
    				transaction.setAmount(amount);
    				
    				// 설명 랜덤 선택
    				transaction.setDescription(
    						WITHDRAWAL_DESCRIPTIONS[random.nextInt(WITHDRAWAL_DESCRIPTIONS.length)]
    				);
    				
    				// 잔액 차감
    				currentBalance -= amount;
    			}else {
    				// 입금
    				transaction.setInoutType("I");
    				
    				// 입금액 (10,000원 ~ 5,000,000원)
    				int amount = (random.nextInt(500) + 1) * 10000;
    				transaction.setAmount(amount);
    				
    				// 설명 랜덤 선택
    				transaction.setDescription(
    						DEPOSIT_DESCRIPTIONS[random.nextInt(DEPOSIT_DESCRIPTIONS.length)]
    				);
    				
    				// 잔액 증가
    				currentBalance += amount;
    			}
    			
    			transaction.setBalanceAfter(currentBalance);
    			transaction.setCategoryId(null);
    			transaction.setMemo(null);
    			
    			transactionMapper.insertTransaction(transaction);
    			totalCount++;
    		}
    	}
    	// 계좌 잔액 업데이트
    	accountMapper.updateAccountBalance(accountId, currentBalance);
    	
    	logger.info(" Mock 거래내역 생성 완료 : 총 {}건", totalCount);
    	logger.info(" 최종 잔액 : {} 원", currentBalance);
    	logger.info(" ============================================= ");
    	return totalCount;
    }
    
    // 특정 계좌의 거래내역 조회
    public List<BankTransactionVO> getTransactionsByAccountId(int accountId, Criteria cri){
    	logger.info(" 거래내역 조회 - accountId : {}, limit : {}", accountId, cri.getPage());
    	return transactionMapper.selectTransactionsByAccountId(accountId, cri);
    }
    
    //페이징 처리된 거래내역 조회
    public List<BankTransactionVO> getTransactionsWithPaging(int accountId, Criteria cri) {
        logger.info("페이징 거래내역 조회 - page: {}, pageSize: {}", cri.getPage(), cri.getPageSize());
        
        return transactionMapper.selectTransactionsByAccountId(accountId, cri);
    }
    
    // 날짜 필터 + 페이징
    public List<BankTransactionVO> getTransactionsByDateWithPaging(
            int accountId, String startDate, String endDate, Criteria cri) {
        
        return transactionMapper.selectTransactionsByDateWithPaging(
            accountId, startDate, endDate, cri);
    }
    
    //전체 거래내역 개수
    public int getTotalCount(int accountId) {
        return transactionMapper.countTransactions(accountId);
    }

    //날짜 필터 적용한 거래내역 개수
    public int getTotalCountByDate(int accountId, String startDate, String endDate) {
        return transactionMapper.countTransactionsByDate(accountId, startDate, endDate);
    }
    
    // PageVO 생성 (날짜 필터 없음)
    public PageVO getPageVO(int accountId, Criteria cri) {
    	int totalCount = getTotalCount(accountId);
    	return new PageVO(cri, totalCount);
    }
    
    // PageVO 생성 (날짜 필터 있음)
    public PageVO getPageVOByDate(int accountId, String startDate, String endDate, Criteria cri) {
    	int totalCount = getTotalCountByDate(accountId, startDate, endDate);
    	return new PageVO(cri, totalCount);
    }
    
    // 메모 저장 / 수정
    public boolean saveMemo(int transactionId, String memo) {
    	logger.info(" =========================================== ");
    	logger.info(" 메모 저장 - transactionId :{}", transactionId);
    	logger.info(" 메모 내용 : {}", memo);
    	
    	try {
    		int result = transactionMapper.updateMemo(transactionId, memo);
    		if(result > 0) {
    			logger.info(" 메모 저장 완료 !");
    			logger.info(" ====================================== ");
    			return true;
    		}
    	}catch(Exception e) {
    		logger.info(" 메모 저장 실패 ! {}", e.getMessage());
    		e.printStackTrace();
    	}
    	
    	logger.info(" ================================== ");
    	return false;
    }
    
    // 메모 삭제
    public boolean deleteMemo(int transactionId) {
    	logger.info(" 메모 삭제 : transactionId - {}", transactionId);
    	return saveMemo(transactionId, null);
    }
    
    // 카테고리 업데이트
    public boolean updateCategory(int transactionId, Integer categoryId) {
    	logger.info(" 카테고리 업데이트 - transactionId : {}, categoryId : {}", transactionId);
    	try {
    		int result = transactionMapper.updateCategory(transactionId, categoryId);
    		return result > 0;
    	}catch(Exception e) {
    		logger.info(" 카테고리 업데이트 실패 ! : " +e.getMessage());
    		e.printStackTrace();
    		return false;
    	}
    }
    
}
