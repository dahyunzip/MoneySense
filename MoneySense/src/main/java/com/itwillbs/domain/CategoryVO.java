package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class CategoryVO {
    
    private int categoryId;        // 카테고리 ID
    private String categoryName;   // 카테고리명
    private Integer parentId;      // 부모 카테고리 ID (대분류/소분류)
    private Integer memberId;      // 회원 ID (커스텀 카테고리)
    private boolean isDefault;     // 기본 카테고리 여부
    private Timestamp createdAt;   // 생성일시
    
    // 추가: 부모 카테고리명 (JOIN 시 사용)
    private String parentName;     // 부모 카테고리명
}