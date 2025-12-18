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
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.domain.CardTransactionVO;
import com.itwillbs.domain.CardVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.PageVO;
import com.itwillbs.mapper.CardMapper;
import com.itwillbs.mapper.CardTransactionMapper;

@Service
public class CardService {
	
	private static final Logger logger = LoggerFactory.getLogger(CardService.class);
	
	@Autowired
	private CardMapper cardMapper;
	
	@Autowired
	private CardTransactionMapper cardTransactionMapper;
	
	@Autowired
	private CategoryService categoryService;
	
	// 카드사 목록
	private static final String[] CARD_COMPANIES = {
		"삼성카드", "현대카드", "신한카드", "KB국민카드", "하나카드",
        "우리카드", "NH농협카드", "롯데카드", "BC카드", "IBK기업은행카드"
	};
	
	// 카드명 목록 (카드사별)
	private static final String[][] CARD_NAMES = {
		{"iD LINK", "iD PLUS", "iD PREMIUM"},                    // 삼성
        {"M Edition", "M2", "M3", "Zero Edition"},                // 현대
        {"Deep Dream", "Deep Oil", "Deep ECO"},                   // 신한
        {"노리", "모리", "리브 메이트"},                            // KB국민
        {"1Q", "원큐페이", "트래블로그"},                          // 하나
        {"위비", "The V", "우리V카드"},                            // 우리
        {"올원", "NH채움", "NH스마트"},                            // NH농협
        {"탭탭", "ZERO", "모아모아"},                              // 롯데
        {"BC바로", "BC빅플러스", "BC맥스"},                        // BC
        {"i-ONE", "IBK Smart", "IBK Plus"}                        // IBK기업
	};
	
	// Mock 가맹점명 (실제 사용처)
	private static final String[] MERCHANT_NAMES = {
		// 카페/디저트
        "스타벅스 강남점", "이디야커피", "투썸플레이스", "카페베네", "할리스커피",
        "공차 역삼점", "매머드커피", "빽다방", "커피빈", "파스쿠찌",
        "베스킨라빈스", "던킨도너츠", "크리스피크림", "파리바게뜨", "뚜레쥬르",
        
        // 편의점
        "CU편의점", "GS25", "세븐일레븐", "이마트24", "미니스톱",
        
        // 마트/쇼핑
        "이마트", "홈플러스", "롯데마트", "코스트코", "GS수퍼마켓",
        "올리브영", "왓슨스", "랄라블라", "다이소", "아트박스",
        
        // 온라인쇼핑
        "쿠팡", "G마켓", "옥션", "11번가", "위메프", "티몬",
        "무신사", "29CM", "지그재그", "에이블리",
        
        // 배달음식
        "배달의민족", "요기요", "쿠팡이츠", "배민1",
        
        // 외식
        "맥도날드", "버거킹", "롯데리아", "KFC", "맘스터치",
        "BBQ치킨", "BHC치킨", "교촌치킨", "푸라닭치킨",
        "미스터피자", "도미노피자", "파파존스", "피자헛",
        "스시로", "스시마루", "놀부보쌈", "투다리", "아웃백",
        
        // 교통
        "카카오T", "택시", "지하철", "버스", "주차장",
        "GS칼텍스", "SK에너지", "현대오일뱅크", "S-OIL",
        
        // 문화/여가
        "CGV영화관", "롯데시네마", "메가박스", 
        "교보문고", "YES24", "알라딘",
        "PC방", "노래방", "당구장", "볼링장",
        
        // 구독서비스
        "넷플릭스", "유튜브 프리미엄", "웨이브", "티빙", "왓챠",
        "멜론", "지니뮤직", "플로", "스포티파이",
        
        // 패션
        "유니클로", "H&M", "ZARA", "무신사스탠다드", "8IGHT SECONDS",
        "나이키", "아디다스", "뉴발란스", "컨버스",
        
        // 기타
        "병원", "약국", "헬스장", "미용실", "네일샵",
        "SKT", "KT", "LG U+", "전기요금", "가스요금"
	};
	
	/**
	 * 회원에게 더미 카드 자동 생성
	 */
	@Transactional
	public int generateDummyCards(int memberId, int cardCount) {
		logger.info(" 더미 카드 생성 시작 - memberId : {}", memberId);
		
		Random random = new Random();
		int count = 0;
		
		for(int i=0; i<cardCount ; i++ ) {
			CardVO card = new CardVO();
			card.setMemberId(memberId);
			
			// 랜덤 카드사 선택
			int companyIndex = random.nextInt(CARD_COMPANIES.length);
			card.setCardCompany(CARD_COMPANIES[companyIndex]);
			
			// 해당 카드사의 랜덤 카드명 선택
			String[] names = CARD_NAMES[companyIndex];
			card.setCardName(names[random.nextInt(names.length)]);
			
			// 카드번호 생성 (마스킹)
			String lastFourDigits = String.format("%04d", random.nextInt(10000));
			card.setCardNumber("****-****-****-" + lastFourDigits);
			
			// 카드 타입 (신용 70%, 체크 30%)
			card.setCardType(random.nextInt(100) < 70 ? "신용" : "체크");
			
			cardMapper.insertCard(card);
			count++;
			
			logger.info("카드 생성 완료 - 카드 회사 : {}", card.getCardCompany());
			logger.info("카드 생성 완료 - 카드 이름 : {}", card.getCardName());
			logger.info("카드 생성 완료 - 카드 유형 : {}", card.getCardType());
		}
		
		logger.info(" 총 {}장의 카드 생성 완료", count);
		logger.info(" ================================= ");
		
		return count;
	}
	
	/**
	 * Mock 카드 사용내역 생성
	 */
	@Transactional
	public int generateMockTransactions(int cardId, int days, int transactionsPerDay) {
		logger.info(" ================================ ");
		logger.info(" Mock 카드 사용내역 생성 시작 ");
		logger.info(" cardId : {}", cardId);
		logger.info(" 기간 : {}일 ", days);
		logger.info(" 일 평균 : {}", transactionsPerDay);
		
		Random random = new Random();
		LocalDateTime now = LocalDateTime.now();
		int totalCount = 0;
		
		// 과거부터 현재까지 거래내역 생성
		for(int day = days; day >= 0; day--) {
			LocalDateTime transactionDate = now.minus(day, ChronoUnit.DAYS);
			
			// 하루에 몇 건의 거래가 발생할지 랜덤
			int todayTransactions = 1 + random.nextInt(transactionsPerDay);
			
			for(int i = 0; i < todayTransactions; i++) {
				CardTransactionVO transaction = new CardTransactionVO();
				transaction.setCardId(cardId);
				
				// 거래 시간 랜덤
				int hour = 8 + random.nextInt(15);
				int minute = random.nextInt(60);
				LocalDateTime txTime = transactionDate.withHour(hour).withMinute(minute);
				transaction.setTransactedAt(Timestamp.valueOf(txTime));
				
				// 가맹점명 랜덤 선택
				String merchantName = MERCHANT_NAMES[random.nextInt(MERCHANT_NAMES.length)];
			    transaction.setMerchantName(merchantName);
				
				// 결제 금액
				int amount = (random.nextInt(200) + 1) * 1000;
				transaction.setAmount(amount);
				
				// 할부
				if(random.nextInt(100) < 90) {
					transaction.setInstallment(0);
				}else {
					int[] installmentOptions = {3,6,12};
					transaction.setInstallment(
								installmentOptions[random.nextInt(installmentOptions.length)]
					);
				}
				try {
			        int memberId = cardMapper.selectCardById(cardId).getMemberId();
			        Integer categoryId = categoryService.autoClassifyCategory(memberId, merchantName);
			        transaction.setCategoryId(categoryId);
			    } catch (Exception e) {
			        logger.warn("카테고리 자동 분류 실패: {}", e.getMessage());
			        transaction.setCategoryId(10); // 기타
			    }
				transaction.setMemo(null);
				
				cardTransactionMapper.insertTransaction(transaction);
				totalCount++;
				
			}
		}
		logger.info(" Mock 카드 사용내역 생성 완료 : 총 {}건", totalCount);
		logger.info(" ================================================ ");
		return totalCount;
	} //generateMockTransactions()
	
	/**
	 * 회원의 모든 카드 조회
	 */
	public List<CardVO> getCardsByMemberId(int memberId){
		logger.info(" 카드 목록 조회 - memberId : {}", memberId);
		return cardMapper.selectCardsByMemberId(memberId);
	}
	
	// 특정 카드 조회
	public CardVO getCardById(int cardId) {
		logger.info(" 카드 조회 - cardId : {}", cardId);
		return cardMapper.selectCardById(cardId);
	}
	
	// 카드 등록
	@Transactional
	public int registerCard(CardVO card) {
		logger.info(" 카드 등록 - memberId : {}, {}", card.getMemberId(), card.getCardName());
		return cardMapper.insertCard(card);
	}
	
	// 카드 삭제
	@Transactional
	public int deleteCard(int cardId) {
		logger.info(" 카드 삭제 - cardId : {}", cardId);
		return cardMapper.deleteCard(cardId);
	}
	
	// 특정 카드의 거래내역 조회 (페이징)
	public List<CardTransactionVO> getTransactionsByCardId(int cardId, Criteria cri){
		logger.info(" 카드 거래내역 조회 - cardId : {}, page : {}", cardId, cri.getPage());
		return cardTransactionMapper.selectTransactionsByCardId(cardId, cri);
	}
	
	// 날짜 필터 + 페이징
	public List<CardTransactionVO> getTransactionsByDateWithPaging(int cardId, String startDate, String endDate, Criteria cri){
		logger.info(" 날짜 필터 카드 거래내역 조회 -  cardId : {}", cardId);
		logger.info("기간 : {} ~ {}",startDate, endDate);
		return cardTransactionMapper.selectTransactionsByDateWithPaging(cardId, startDate, endDate, cri);
	}
	
	// 전체 거래내역 개수
	public int getTotalCount(int cardId) {
		return cardTransactionMapper.countTransactions(cardId);
	}
	
	// 날짜 필터 적용한 거래내역 개수
	public int getTotalCountByDate(int cardId, String startDate, String endDate) {
		return cardTransactionMapper.countTransactionsByDate(cardId, startDate, endDate);
	}
	
	// PageVO 생성 (날짜 필터 없음)
	public PageVO getPageVO(int cardId, Criteria cri) {
		int totalCount = getTotalCount(cardId);
		return new PageVO(cri, totalCount);
	}
	
	// PageVO 생성 (날짜 필터 있음)
	public PageVO getPageVOByDate(int cardId, String startDate, String endDate, Criteria cri) {
		int totalCount = getTotalCountByDate(cardId, startDate, endDate);
		return new PageVO(cri, totalCount);
	}
	
	// 회원의 최근 카드 사용 내역 조회
	public List<CardTransactionVO> getRecentTransactionsByMemberId(int memberId, int limit){
		logger.info(" 회원의 최근 카드 사용내역 조회 - memberId : {}, limit : {}", memberId, limit);
		return cardTransactionMapper.selectRecentTransactionsByMemberId(memberId, limit);
	}
	
	// 메모 저장/수정
	public boolean saveMemo(long transactionId, String memo) {
		logger.info(" 카드 거래 메모 저장 - transactionId : {}", transactionId);
		try {
			int result = cardTransactionMapper.updateMemo(transactionId, memo);
			return result > 0;
		}catch(Exception e) {
			logger.info(" 메모 저장 실패 : {}", e.getMessage());
			return false;
		}
	}
	
	// 메모 삭제
	public boolean deleteMemo(long transactionId) {
		logger.info("카드 거래 메모 삭제 - transactionId : {}", transactionId);
		return saveMemo(transactionId, null);
	}

	public boolean updateCategory(long transactionId, Integer categoryId) {
		logger.info(" 카드 거래 카테고리 업데이트 - transactionId : {}, categoryId : {}", transactionId, categoryId);
		try {
			int result = cardTransactionMapper.updateCategory(transactionId, categoryId);
			return result > 0;
		}catch(Exception e) {
			logger.info(" 카테고리 업데이트 실패 : {}", e.getMessage());
			return false;
		}
	}
}
