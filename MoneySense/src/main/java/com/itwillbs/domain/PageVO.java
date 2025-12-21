package com.itwillbs.domain;

import lombok.Data;

@Data
public class PageVO {
	private Criteria cri;		// 페이징 기준 정보
	private int totalCount;		// 전체 게시물 수 
	private int totalPages;		// 전체 페이지 수
	private int startPage;		// 시작 페이지 번호
	private int endPage;		// 끝 페이지 번호
	private boolean prev;		// 이전 페이지 존재 여부
	private boolean next;		// 다음 페이지 존재 여부
	
	private int displayPageNum = 5;	// 한 번에 보여줄 페이지 개수
	
	// 기본 생성자
	public PageVO() {
		this(new Criteria(), 0);
	}

	// Criteria와 전체 개수로 생성
	public PageVO(Criteria cri, int totalCount) {
		this.cri = cri;
		this.totalCount = totalCount;
		
		calcData();
	}
	
	// 페이징 정보 계산
	private void calcData() {
		// 전체 페이지 수 계산
		totalPages = (int) Math.ceil((double) totalCount / cri.getPageSize());
		
		// 현재 페이지가 전체 페이지를 넘으면 마지막 페이지로 이동
		if(cri.getPage() > totalPages && totalPages > 0) {
			cri.setPage(totalPages);
		}
		
		// 끝 페이지 번호 계산
		// 예: 현재 3페이지 -> (3 / 5.0) = 0.6 → ceil = 1 → 1 * 5 = 5
		endPage = (int) (Math.ceil(cri.getPage() / (double) displayPageNum) * displayPageNum);
		
		// 시작 페이지 번호 계산
		// 예: endPage - 5 -> startPage = 1
		startPage = (endPage - displayPageNum) + 1;
		
		// startPage가 1보다 작으면 1로
		if(startPage <= 0) {
			startPage =1;
		}
		
		// endPage가 totalPages보다 크면 조정
		if(endPage > totalPages) {
			endPage = totalPages;
		}
		
		// 이전/다음 버튼 표시 여부
		prev = startPage > 1;
		next = endPage < totalPages;
	}
	
	// 전체 개수 변경 시 재계산
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
		calcData();
	}
	
	// 현재 페이지 번호
	public int getCurrentPage() {
		return cri.getPage();
	}
}
