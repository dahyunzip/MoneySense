package com.itwillbs.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.CategoryKeywordVO;
import com.itwillbs.domain.CategoryVO;

public interface CategoryMapper {
	// 카테고리 조회
    CategoryVO selectCategoryById(@Param("categoryId") int categoryId);
    
    // 기본 카테고리 목록 조회
    List<CategoryVO> selectDefaultCategories();
    
    // 키워드로 카테고리 찾기
    Integer selectCategoryIdByKeyword(
        @Param("keyword") String keyword,
        @Param("memberId") int memberId
    );
    
    // 키워드 추가 (사용자 학습)
    void insertKeyword(CategoryKeywordVO keyword);
    
    // 카테고리명으로 ID 찾기
    Integer selectCategoryIdByName(
        @Param("categoryName") String categoryName,
        @Param("memberId") int memberId
    );
}
