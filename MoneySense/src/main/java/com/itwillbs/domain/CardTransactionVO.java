package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class CardTransactionVO {
	private long transactionId;
	private int cardId;
	private Timestamp transactedAt;
	private String merchantName; 	// 가맹점명
	private int amount;
	private int installment;		// 할부 (0 = 일시불)
	private Integer categoryId;
	private String memo;
	private Timestamp createdAt;
	private String categoryName;
}
