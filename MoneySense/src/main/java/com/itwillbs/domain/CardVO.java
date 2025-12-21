package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class CardVO {
	private int cardId;
	private int memberId;
	private String cardCompany;		// 카드사
	private String cardName;		// 카드명
	private String cardNumber;		// 카드번호(마스킹)
	private String cardType;		// 신용/체크
	private Timestamp createdAt;
}
