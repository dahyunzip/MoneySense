package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class BankTransactionVO {
	private int transactionId;
	private int accountId;
	private Timestamp transactedAt;
	private String inoutType;
	private int amount;
	private int balanceAfter;
	private String description;
	private Integer categoryId;
	private String memo;
	private Timestamp createdAt;
	private String categoryName;
}
