<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents" class="accounts">
	<div class="fix-layout">
	    <div class="container">
	        <h1 class="page-title">내 계좌 목록</h1>
	        
	        <c:if test="${not empty msg}">
	            <div class="message">${msg}</div>
	        </c:if>
	        
	        <div class="header-actions">
	            <div>
	                <span style="color: #6c757d;">총 ${accounts.size()}개의 계좌</span>
	            </div>
	            <div>
	                <a href="${pageContext.request.contextPath}/accounts/sync" class="btn btn-success">
	                    계좌 동기화
	                </a>
	                <a href="${pageContext.request.contextPath}/accounts/connect" class="btn btn-primary">
	                    계좌 추가 연동
	                </a>
	            </div>
	        </div>
	        
	        <c:choose>
	            <c:when test="${empty accounts}">
	                <div class="empty-message">
	                    <h3>연동된 계좌가 없습니다</h3>
	                    <p>계좌를 연동하여 자동으로 거래내역을 관리해보세요!</p>
	                    <a href="${pageContext.request.contextPath}/accounts/connect" class="btn btn-primary" style="margin-top: 20px;">
	                        첫 계좌 연동하기
	                    </a>
	                </div>
	            </c:when>
	            <c:otherwise>
	                <div class="account-grid">
	                    <c:forEach var="account" items="${accounts}">
	                        <div class="account-card">
	                            <div class="account-header">
	                                <span class="bank-name">${account.bankName}</span>
	                            </div>
	                            
	                            <div class="account-info">
	                                <div class="info-label">계좌명</div>
	                                <div class="info-value">${account.accountName}</div>
	                            </div>
	                            
	                            <div class="account-info">
	                                <div class="info-label">계좌번호</div>
	                                <div class="info-value">${account.accountNum}</div>
	                            </div>
	                            
	                            <div class="balance">
	                                <fmt:formatNumber value="${account.balance}" type="number" groupingUsed="true"/>원
	                            </div>
	                            
	                            <div class="account-actions">
	                                <a href="${pageContext.request.contextPath}/transactions/list?accountId=${account.accountId}" 
	                                   class="btn btn-info btn-sm">
	                                    거래내역 보기
	                                </a>
	                            </div>
	                        </div>
	                    </c:forEach>
	                </div>
	            </c:otherwise>
	        </c:choose>
	    </div>
    </div>
</div>
<%@ include file="../include/Footer.jsp"%>