package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class BankAccountVO {
	private int accountId;
	private int memberId;
	private String bankCode;
	private String bankName;
	private String accountNum;
	private String accountName;
	private long balance;
	private Timestamp createdAt;
	private String fintechUseNum;
}
