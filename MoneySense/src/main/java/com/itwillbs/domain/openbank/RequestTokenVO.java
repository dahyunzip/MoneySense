package com.itwillbs.domain.openbank;

import lombok.Data;

@Data
public class RequestTokenVO {
	private String code;
	private String scope;
	private String state;
	private String client_info;
	
	private String client_id;
	private String client_secret;
	private String redirect_uri;
	private String grant_type;
}
