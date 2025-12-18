<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../include/Header.jsp"%>
<script src="${ctx}/resources/js/jquery-ui.min.js"></script>
<link rel="stylesheet" href="${ctx}/resources/css/jquery-ui.css">
<div id="subContents">
	<div class="trans-title-section">
		<div class="account-details fix-layout">
           <div class="bank-name">${account.bankName}<span class="account-name">${account.accountName}</span></div>
           <div class="account-num">${account.accountNum}</div>
           <div class="balance-amount">
              <fmt:formatNumber value="${account.balance}" type="number" groupingUsed="true"/>원
          </div>
       </div>
	</div>
	<div class="fix-layout">
	    <div class="container" id="transList">
	        <c:if test="${not empty msg}">
	            <div class="message">${msg}</div>
	        </c:if>
	        
	        <c:if test="${pageVO.totalCount == 0}">
	        <div class="text-right mb10">
	                <a href="${ctx}/transactions/generate-mock?accountId=${account.accountId}" 
	                   class="btn btn-primary"
	                   onclick="return confirm('테스트용 거래내역을 생성하시겠습니까?');">
	                    테스트 거래내역 생성
	                </a>
	        </div>
	        </c:if>
	        
	        <!-- 날짜 필터 -->
	        <c:if test="${pageVO.totalCount > 0}">
	            <div class="filter-section mb20">
	                <form method="get" action="${ctx}/transactions/list">
	                    <input type="hidden" name="accountId" value="${account.accountId}">
	                    <div class="filter-row">
	                        <!-- <span class="filter-label">기간 선택</span> -->
	                        <input type="text" 
	                               id="startDate" 
	                               name="startDate" 
	                               class="date-input" 
	                               placeholder="거래 시작일"
	                               value="${startDate}"
	                               readonly>
	                        <input type="text" 
	                               id="endDate" 
	                               name="endDate" 
	                               class="date-input" 
	                               placeholder="거래 종료일"
	                               value="${endDate}"
	                               readonly>
	                        <button type="submit" class="btn btn-primary">조회</button>
	                        <a href="${ctx}/transactions/list?accountId=${account.accountId}" 
	                           class="btn btn-secondary">전체</a>
	                    </div>
	                </form>
	            </div>
	        </c:if>
	        
	        <div class="transaction-list">
	            <c:choose>
	                <c:when test="${empty transactions}">
	                    <div class="empty-message">
	                        <h3>거래내역이 없습니다</h3>
	                        <p>테스트용 거래내역을 생성하거나 실제 거래가 발생하면 여기에 표시됩니다.</p>
	                    </div>
	                </c:when>
	                
	                <c:otherwise>
	                    <c:forEach var="tx" items="${transactions}">
	                        <div class="transaction-item" id="tx-${tx.transactionId}">
	                        	<div class="transaction-month-day">
	                        		<fmt:formatDate value="${tx.transactedAt}" pattern="MM.dd"/>
	                        	</div>
	                            <div class="transaction-main">
	                            	<div class="transaction-wrap">
		                                <div class="transaction-info">
		                                    <div class="transaction-desc">${tx.description}</div>
		                                    <div class="transaction-date">
		                                        <fmt:formatDate value="${tx.transactedAt}" pattern="yyyy-MM-dd HH:mm"/>
		                                    </div>
		                                </div>
		                                <div class="transaction-amount">
		                                    <div class="amount-value ${tx.inoutType == 'I' ? 'amount-in' : 'amount-out'}">
		                                        ${tx.inoutType == 'I' ? '+' : '-'}
		                                        <fmt:formatNumber value="${tx.amount}" type="number" groupingUsed="true"/>원
		                                    </div>
		                                    <div class="balance-after">
		                                        잔액 <fmt:formatNumber value="${tx.balanceAfter}" type="number" groupingUsed="true"/>원
		                                    </div>
		                                </div>
	                                </div>
		                            <!-- 메모 섹션 -->
	                                <div class="memo-section">
		                                <div id="memo-display-${tx.transactionId}" style="${empty tx.memo ? 'display:none;' : ''}">
		                                    <div class="memo-display" id="memo-text-${tx.transactionId}">
		                                        ${tx.memo}
		                                    </div>
		                                    <div class="memo-actions btn-group right mt0">
		                                        <button data-action="edit-memo" data-tx-id="${tx.transactionId}" class="modify">수정</button>
		                                        <button data-action="delete-memo" data-tx-id="${tx.transactionId}" class="delete">삭제</button>
		                                    </div>
		                                </div>
		                                
		                                <div id="memo-edit-${tx.transactionId}" style="${empty tx.memo ? '' : 'display:none;'}">
		                                    <input type="text" 
		                                           class="memo-input" 
		                                           id="memo-input-${tx.transactionId}"
		                                           placeholder="메모를 입력하세요"
		                                           value="${tx.memo}">
		                                    <div class="memo-actions btn-group right mt0">
		                                        <button data-action="save-memo" data-tx-id="${tx.transactionId}" class="save">저장</button>
		                                        <button data-action="cancel-memo" data-tx-id="${tx.transactionId}" data-original-memo="${tx.memo}"  class="delete">취소</button>
		                                    </div>
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
                        <a href="${ctx}/transactions/list?accountId=${account.accountId}&page=1<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
                           class="page-link">«</a>
                    </c:if>
                    <!-- 이전 페이지 -->
                    <c:choose>
                        <c:when test="${pageVO.prev}">
                            <a href="${ctx}/transactions/list?accountId=${account.accountId}&page=${pageVO.currentPage - 1}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
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
                                <a href="${ctx}/transactions/list?accountId=${account.accountId}&page=${i}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
                                   class="page-link">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <!-- 다음 페이지 -->
                    <c:choose>
                        <c:when test="${pageVO.next}">
                            <a href="${ctx}/transactions/list?accountId=${account.accountId}&page=${pageVO.currentPage + 1}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
                               class="page-link">›</a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-link disabled">›</span>
                        </c:otherwise>
                    </c:choose>
                    <!-- 맨 끝 -->
                    <c:if test="${pageVO.next}">
                        <a href="${ctx}/transactions/list?accountId=${account.accountId}&page=${pageVO.totalPages}<c:if test='${not empty startDate}'>&startDate=${startDate}&endDate=${endDate}</c:if>" 
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
    // 메모 기능 - jQuery로 이벤트 위임
    // ========================================
    const csrfToken = '${_csrf.token}';
    const csrfHeader = '${_csrf.headerName}';
    
    // 메모 수정 버튼 클릭
    $(document).on('click', '[data-action="edit-memo"]', function() {
        const txId = $(this).data('tx-id');
        $(`#memo-display-\${txId}`).hide();
        $(`#memo-edit-\${txId}`).show();
        $(`#memo-input-\${txId}`).focus();
    });
    
    // 메모 저장 버튼 클릭
    $(document).on('click', '[data-action="save-memo"]', function() {
        const txId = $(this).data('tx-id');
        const memo = $(`#memo-input-\${txId}`).val().trim();
        
        if(!memo) {
            alert('메모를 입력해주세요.');
            return;
        }
        
        $.ajax({
            url: '${ctx}/transactions/save-memo',
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
    
    // 메모 취소 버튼 클릭
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
    
    // 메모 삭제 버튼 클릭
    $(document).on('click', '[data-action="delete-memo"]', function() {
        const txId = $(this).data('tx-id');
        
        if(!confirm('메모를 삭제하시겠습니까?')) {
            return;
        }
        
        $.ajax({
            url: '${ctx}/transactions/delete-memo',
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
<%@ include file="../include/Fixed.jsp"%>