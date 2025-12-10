<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents">
	<div class="fix-layout">    
	    <div class="container" id="callback">
	        <div class="success-icon text-center">✓</div>
	        <h1 class="page-title">계좌 연동 완료!</h1>
	        <p class="message">${msg}</p>
	        
	        <div class="token-info">
	            <h3>연동 정보</h3>
	            <div class="token-item">
	                <span class="token-label">사용자 번호:</span>
	                <span>${tokenInfo.user_seq_no}</span>
	            </div>
	            <div class="token-item">
	                <span class="token-label">토큰 타입:</span>
	                <span>${tokenInfo.token_type}</span>
	            </div>
	            <div class="token-item">
	                <span class="token-label">유효 기간:</span>
	                <span>${tokenInfo.expires_in}초</span>
	            </div>
	            <div class="token-item">
	                <span class="token-label">권한 범위:</span>
	                <span>${tokenInfo.scope}</span>
	            </div>
	        </div>
	        
	        <a href="${ctx}/" class="btn-dashboard">
	            홈으로 이동
	        </a>
	    </div>
    </div>
</div>
<%@ include file="../include/Footer.jsp"%>