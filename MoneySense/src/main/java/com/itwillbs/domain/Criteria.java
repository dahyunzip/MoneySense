package com.itwillbs.domain;

import lombok.Data;

@Data
public class Criteria {
	private int page;
	private int pageSize;
	
	// 기본 생성자
	public Criteria() {
		this(1, 10);  // 기본 값 : 1페이지, 10개씩
	}
	
	// 페이지만 지정
	public Criteria(int page) {
		this(page, 10);
	}
	
	// 페이지와 사이즈 지정
	public Criteria(int page, int pageSize) {
		super();
		this.page = page;
		this.pageSize = pageSize;
	}
	
	// Offset 계산 (MyBatis)
	public int getOffset() {
		return (page - 1) * pageSize;
	}
	
	// 페이지 번호 유효성 검사
	public void setPage(int page) {
		if(page <= 0) {
			this.page=1;
		}else {
			this.page = page;
		}
	}
	
	// 페이지 사이즈 유효성 검사
	public void setPageSize(int pageSize) {
		if(pageSize <= 0 || pageSize > 100) {
			this.pageSize = 10;
		}else {
			this.pageSize = pageSize;
		}
	}
	
}
