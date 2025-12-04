package com.itwillbs.domain.openbank;

import java.util.List;

import lombok.Data;

@Data
public class AccountSearchResponseVO {
	private String api_tran_id;
	private String api_tran_dtm;
	private String rsp_code;
	private String rsp_message;
	private String user_name;
	private String res_cnt;
	private List res_list;
}
