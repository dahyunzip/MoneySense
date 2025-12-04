package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class OpenbankTokenVO {
	private int tokenId;
	private int memberId;
	private String accessToken;
	private String refreshToken;
	private Timestamp expiresAt;
	private Timestamp createdAt;
	private String userSeqNo;
}
