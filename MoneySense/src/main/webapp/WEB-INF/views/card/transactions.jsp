<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file ="../include/Header.jsp"%>
<script src="${ctx}/resources/js/jquery-ui.min.js"></script>
<link rel="stylesheet" href="${ctx}/resources/css/jquery-ui.css">

<div id="subContents">
	<div class="fix-layout">
		<div class="container">
	        <div class="card-header">
	            <div class="card-info">
	                <div>
	                    <div class="card-company">${card.cardCompany}</div>
	                    <div class="card-name">
	                        ${card.cardName}
	                        <span class="card-type-badge">${card.cardType}</span>
	                    </div>
	                    <div class="card-number">${card.cardNumber}</div>
	                </div>
	            </div>
	        </div>
	        
	        <c:if test="${not empty msg}">
	            <div class="message">${msg}</div>
	        </c:if>
	        
	        <div class="actions">
	            <a href="${ctx}/cards/list" class="btn btn-secondary">
	                카드 목록
	            </a>
	            <c:if test="${pageVO.totalCount == 0}">
	                <a href="${ctx}/cards/generate-mock?cardId=${card.cardId}&days=30&perDay=2" 
	                   class="btn btn-success"
	                   onclick="return confirm('테스트용 카드 사용내역을 생성하시겠습니까?');">
	                   테스트 사용내역 생성
	                </a>
	            </c:if>
	        </div>
	        
	        <!-- 날짜 필터 -->
	        <c:if test="${pageVO.totalCount > 0}">
	            <div class="filter-section">
	                <form method="get" action="${ctx}/cards/transactions">
	                    <input type="hidden" name="cardId" value="${card.cardId}">
	                    <div class="filter-row">
	                        <span class="filter-label">기간 선택:</span>
	                        <input type="text" 
	                               id="startDate" 
	                               name="startDate" 
	                               class="date-input" 
	                               placeholder="시작일 (예: 2025-01-01)"
	                               value="${startDate}"
	                               autocomplete="off">
	                        <span>~</span>
	                        <input type="text" 
	                               id="endDate" 
	                               name="endDate" 
	                               class="date-input" 
	                               placeholder="종료일 (예: 2025-12-31)"
	                               value="${endDate}"
	                               autocomplete="off">
	                        <button type="submit" class="btn btn-primary">조회</button>
	                        <a href="${ctx}/cards/transactions?cardId=${card.cardId}" 
	                           class="btn btn-secondary">전체</a>
	                    </div>
	                </form>
	            </div>
	        </c:if>
	        
	        <div class="transaction-list">
	            <div class="transaction-header">
	                <h2>사용내역</h2>
	                <span class="transaction-count">
	                    총 ${pageVO.totalCount}건
	                    <c:if test="${not empty startDate && not empty endDate}">
	                        (${startDate} ~ ${endDate})
	                    </c:if>
	                </span>
	            </div>
	            
	            <c:choose>
	                <c:when test="${empty transactions}">
	                    <div class="empty-message">
	                        <h3>사용내역이 없습니다</h3>
	                        <c:choose>
	                            <c:when test="${not empty startDate && not empty endDate}">
	                                <p>선택한 기간에 사용내역이 없습니다.</p>
	                            </c:when>
	                            <c:otherwise>
	                                <p>테스트용 사용내역을 생성하거나 실제 거래가 발생하면 여기에 표시됩니다.</p>
	                            </c:otherwise>
	                        </c:choose>
	                    </div>
	                </c:when>
	                <c:otherwise>
	                    <c:forEach var="tx" items="${transactions}">
	                        <div class="transaction-item">
	                            <div class="transaction-main">
	                                <div class="transaction-info">
	                                    <div class="transaction-date">
	                                        <fmt:formatDate value="${tx.transactedAt}" pattern="yyyy-MM-dd HH:mm"/>
	                                    </div>
	                                    <div class="transaction-merchant">${tx.merchantName}</div>
	                                    <c:if test="${tx.installment > 0}">
	                                        <div class="transaction-installment">
	                                            💳 ${tx.installment}개월 할부
	                                        </div>
	                                    </c:if>
	                                </div>
	                                <div class="transaction-amount">
	                                    <div class="amount-value">
	                                        -<fmt:formatNumber value="${tx.amount}" type="number" groupingUsed="true"/>원
	                                    </div>
	                                </div>
	                            </div>
	                            
	                            <!-- 메모 섹션 -->
	                            <div class="memo-section">
	                                <div id="memo-display-${tx.transactionId}" 
	                                     style="${empty tx.memo ? 'display:none;' : ''}">
	                                    <div class="memo-display" id="memo-text-${tx.transactionId}">
	                                        📝 ${tx.memo}
	                                    </div>
	                                    <div class="memo-actions btn-group right mt10">
	                                        <button data-action="edit-memo" 
	                                                data-tx-id="${tx.transactionId}" 
	                                                class="btn btn-sm btn-primary">수정</button>
	                                        <button data-action="delete-memo" 
	                                                data-tx-id="${tx.transactionId}" 
	                                                class="btn btn-sm btn-secondary">삭제</button>
	                                    </div>
	                                </div>
	                                
	                                <div id="memo-edit-${tx.transactionId}" 
	                                     style="${empty tx.memo ? '' : 'display:none;'}">
	                                    <input type="text" 
	                                           class="memo-input" 
	                                           id="memo-input-${tx.transactionId}"
	                                           placeholder="메모를 입력하세요"
	                                           value="${tx.memo}">
	                                    <div class="memo-actions btn-group right mt10">
	                                        <button data-action="save-memo" 
	                                                data-tx-id="${tx.transactionId}" 
	                                                class="btn btn-sm btn-success">저장</button>
	                                        <button data-action="cancel-memo" 
	                                                data-tx-id="${tx.transactionId}" 
	                                                data-original-memo="${tx.memo}" 
	                                                class="btn btn-sm btn-secondary">취소</button>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                    </c:forEach>
	                </c:otherwise>
	            </c:choose>
	        </div>
	        
	        <!-- 페이징 -->
	        <c:if test="${pageVO.totalPages > 1}">
	            <div class="pagination">
	                <!-- 맨 처음 -->
	                <c:if test="${pageVO.prev}">
	                    <a href="${ctx}/cards/transactions?cardId=${card.cardId}&page=1<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
	                       class="page-link">«</a>
	                </c:if>
	                
	                <!-- 이전 페이지 -->
	                <c:choose>
	                    <c:when test="${pageVO.prev}">
	                        <a href="${ctx}/cards/transactions?cardId=${card.cardId}&page=${pageVO.currentPage - 1}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
	                           class="page-link">‹</a>
	                    </c:when>
	                    <c:otherwise>
	                        <span class="page-link disabled">‹</span>
	                    </c:otherwise>
	                </c:choose>
	                
	                <!-- 페이지 번호 -->
	                <c:forEach var="i" begin="${pageVO.startPage}" end="${pageVO.endPage}">
	                    <c:choose>
	                        <c:when test="${i == pageVO.currentPage}">
	                            <span class="page-link active">${i}</span>
	                        </c:when>
	                        <c:otherwise>
	                            <a href="${ctx}/cards/transactions?cardId=${card.cardId}&page=${i}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
	                               class="page-link">${i}</a>
	                        </c:otherwise>
	                    </c:choose>
	                </c:forEach>
	                
	                <!-- 다음 페이지 -->
	                <c:choose>
	                    <c:when test="${pageVO.next}">
	                        <a href="${ctx}/cards/transactions?cardId=${card.cardId}&page=${pageVO.currentPage + 1}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
	                           class="page-link">›</a>
	                    </c:when>
	                    <c:otherwise>
	                        <span class="page-link disabled">›</span>
	                    </c:otherwise>
	                </c:choose>
	                
	                <!-- 맨 끝 -->
	                <c:if test="${pageVO.next}">
	                    <a href="${ctx}/cards/transactions?cardId=${card.cardId}&page=${pageVO.totalPages}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
	                       class="page-link">»</a>
	                </c:if>
	            </div>
	        </c:if>
	    </div>
	</div>
</div>
<script>
$(function() {
    // ========================================
    // Datepicker 초기화
    // ========================================
    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNames: ['일','월','화','수','목','금','토'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
        showMonthAfterYear: true,
        yearSuffix: '년',
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true
    });
    
    // 시작일 Datepicker
    $("#startDate").datepicker({
        maxDate: new Date(),
        onSelect: function(selectedDate) {
            $("#endDate").datepicker("option", "minDate", selectedDate);
        }
    });
    
    // 종료일 Datepicker
    $("#endDate").datepicker({
        maxDate: new Date(),
        onSelect: function(selectedDate) {
            $("#startDate").datepicker("option", "maxDate", selectedDate);
        }
    });
    
    // 이미 선택된 날짜가 있으면 제약조건 적용
    <c:if test="${not empty startDate}">
        $("#endDate").datepicker("option", "minDate", "${startDate}");
    </c:if>
    <c:if test="${not empty endDate}">
        $("#startDate").datepicker("option", "maxDate", "${endDate}");
    </c:if>
    
    
    // ========================================
    // 메모 기능
    // ========================================
    const csrfToken = '${_csrf.token}';
    const csrfHeader = '${_csrf.headerName}';
    
    // 메모 수정 버튼
    $(document).on('click', '[data-action="edit-memo"]', function() {
        const txId = $(this).data('tx-id');
        $(`#memo-display-\${txId}`).hide();
        $(`#memo-edit-\${txId}`).show();
        $(`#memo-input-\${txId}`).focus();
    });
    
    // 메모 저장
    $(document).on('click', '[data-action="save-memo"]', function() {
        const txId = $(this).data('tx-id');
        const memo = $(`#memo-input-\${txId}`).val().trim();
        
        if(!memo) {
            alert('메모를 입력해주세요.');
            return;
        }
        
        $.ajax({
            url: '${pageContext.request.contextPath}/cards/save-memo',
            type: 'POST',
            data: {
                transactionId: txId,
                memo: memo
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(data) {
                if(data.success) {
                    $(`#memo-text-\${txId}`).text(memo);
                    $(`#memo-display-\${txId}`).show();
                    $(`#memo-edit-\${txId}`).hide();
                    alert(data.message);
                } else {
                    alert(data.message);
                }
            },
            error: function() {
                alert('메모 저장 중 오류가 발생했습니다.');
            }
        });
    });
    
    // 메모 취소
    $(document).on('click', '[data-action="cancel-memo"]', function() {
        const txId = $(this).data('tx-id');
        const originalMemo = $(this).data('original-memo');
        
        if(originalMemo && originalMemo !== 'null' && originalMemo.trim() !== '') {
            $(`#memo-display-\${txId}`).show();
            $(`#memo-edit-\${txId}`).hide();
            $(`#memo-input-\${txId}`).val(originalMemo);
        } else {
            $(`#memo-edit-\${txId}`).hide();
        }
    });
    
    // 메모 삭제
    $(document).on('click', '[data-action="delete-memo"]', function() {
        const txId = $(this).data('tx-id');
        
        if(!confirm('메모를 삭제하시겠습니까?')) {
            return;
        }
        
        $.ajax({
            url: '${pageContext.request.contextPath}/cards/delete-memo',
            type: 'POST',
            data: {
                transactionId: txId
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(data) {
                if(data.success) {
                    $(`#memo-display-\${txId}`).hide();
                    $(`#memo-edit-\${txId}`).show();
                    $(`#memo-input-\${txId}`).val('');
                    alert(data.message);
                } else {
                    alert(data.message);
                }
            },
            error: function() {
                alert('메모 삭제 중 오류가 발생했습니다.');
            }
        });
    });
});
</script>
<%@ include file ="../include/Footer.jsp"%>