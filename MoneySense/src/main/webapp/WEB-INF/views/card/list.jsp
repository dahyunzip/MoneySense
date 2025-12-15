<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file ="../include/Header.jsp"%>
<div id="subContents" class="accounts">
	<div class="fix-layout">
		<div class="container">
			<div class="title-btn">
	        	<h1 class="page-title">내 카드 목록</h1>
	    		<div class="btn-group right">
	    			<a href="${ctx}/cards/register" class="btn btn-success">
	                	카드 등록
	            	</a>
	            	<c:if test="${empty cards}">
		                <a href="${ctx}/cards/generate-dummy?count=3" 
		                   class="btn btn-primary"
		                   onclick="return confirm('테스트용 카드 3장을 생성하시겠습니까?');">
		                    테스트 카드 생성
		                </a>
		            </c:if>
	    		</div>
	    	</div>
	        
	        <c:if test="${not empty msg}">
	            <div class="message">${msg}</div>
	        </c:if>
	        
	        <div class="total-account">
                <span>총 ${totalCards}장</span>
            </div>
	        
	        <c:choose>
	            <c:when test="${empty cards}">
	                <div class="empty-message">
	                    <h3>등록된 카드가 없습니다</h3>
	                    <p>카드를 등록하거나 테스트용 카드를 생성해보세요.</p>
	                    <a href="${ctx}/cards/register" class="btn btn-primary">
	                        카드 등록하기
	                    </a>
	                </div>
	            </c:when>
	            <c:otherwise>
	                <div class="account-grid">
	                    <c:forEach var="card" items="${cards}">
	                        <div class="account-card" onclick="location.href='${ctx}/cards/transactions?cardId=${card.cardId}'">
	                        	<div class="account-header">
	                                <p class="bank-name">
	                                	${card.cardCompany}
	                                	<span class="info-value">${card.cardName}</span>
	                                </p>
	                            </div>
	                            <div class="account-info">
	                                <div class="info-value">${card.cardNumber}</div>
	                                <div class="info-value">${card.cardType}</div>
	                            </div>
	                            
	                            <div class="card-actions">
	                                <%-- <a href="${ctx}/cards/transactions?cardId=${card.cardId}" 
	                                   class="btn btn-primary btn-sm" style="flex: 1;">
	                                    사용내역 보기
	                                </a> --%>
	                                <%-- <form action="${ctx}/cards/delete" 
	                                      method="post" 
	                                      style="display: inline;"
	                                      onsubmit="return confirm('이 카드를 삭제하시겠습니까?\n관련된 모든 사용내역도 함께 삭제됩니다.');">
	                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	                                    <input type="hidden" name="cardId" value="${card.cardId}"/>
	                                    <button type="submit" class="btn btn-danger btn-sm">삭제</button>
	                                </form> --%>
	                            </div>
	                        </div>
	                    </c:forEach>
	                </div>
	            </c:otherwise>
	        </c:choose>
	    </div>
	</div>
</div>
<%@ include file ="../include/Footer.jsp"%>