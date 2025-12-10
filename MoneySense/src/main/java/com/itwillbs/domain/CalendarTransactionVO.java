package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class CalendarTransactionVO {
	private String transactionKey; 		// BANK_123, CARD_456
	private String transactionType;		// BANK, CARD
	private Long transactionId;
	private int memberId;
	private Timestamp transactedAt;
	private String detail;				// 설명 / 가맹점명
	private int amount;
	private String inoutType;			// I(입금) / O(출금)
	private Integer balanceAfter;
	private Integer	categoryId;
	private String memo;
	private String sourceName;			// 은행명/카드사
	private String sourceNumber;		// 계좌번호/카드번호
	private Integer installment;		// 카드만(계좌는 NULL)
}
