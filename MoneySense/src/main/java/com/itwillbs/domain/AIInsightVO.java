package com.itwillbs.domain;

import java.math.BigDecimal;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class AIInsightVO {
	private int insightId;				// 인사이트ID
	private int memberId;				// 회원ID
	private String insightType;			// Monthly, Weekly, CATEGORY
	private String period;				// 분석 기간
	private String category;			// 카테고리명
	private int currentAmount;			// 현재 기간 금액
	private Integer previousAmount;		// 이전 기간 금액
	private BigDecimal changeRate;		// 변화율(%)
	private String summary;				// GPT 생성 요약문
	private String detailData;			// JSON 상세 데이터
	private Timestamp createdAt;		// 생성일시
}
