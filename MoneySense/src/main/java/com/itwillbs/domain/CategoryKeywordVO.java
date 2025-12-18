package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class CategoryKeywordVO {
	private int keywordId;
    private int categoryId;
    private String keyword;
    private int priority;
    private Integer memberId;
    private Timestamp createdAt;
}
