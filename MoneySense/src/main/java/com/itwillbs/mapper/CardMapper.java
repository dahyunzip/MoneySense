package com.itwillbs.mapper;

import java.util.List;

import com.itwillbs.domain.CardVO;

public interface CardMapper {
	
	// 카드 저장
	int insertCard(CardVO card);
	
	// 회원의 모든 카드 조회
	List<CardVO> selectCardsByMemberId(int memberId);
	
	// 특정 카드 조회
	CardVO selectCardById(int cardId);
	
	// 카드 수정
	int updateCard(CardVO card);
	
	// 카드 삭제
	int deleteCard(int cardId);
	
	// 카드 개수 조회
	int countCardsByMemberId(int memberId);
}
