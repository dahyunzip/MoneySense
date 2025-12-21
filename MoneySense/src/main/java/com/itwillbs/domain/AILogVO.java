package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class AILogVO {
	private int aiLogId;				// AI 로그 ID
	private int memberId;				// 회원 ID
	private String logType;				// chat, insight, report
	private String question;			// 사용자 질문(챗봇)
	private String answer;				// GPT 응답
	private String analysisPeriod;		// 분석기간(2025-12, 2025-W50)
	private String metadata;			// JSON 메타 데이터
	private Timestamp createdAt;		// 생성일시
}
