package com.itwillbs.domain.openbank;

import lombok.Data;

@Data
public class AccountSearchRequestVO {
	private String access_token;
	private String user_seq_no;
	private String include_cancel_yn;
	private String sort_order;
}
