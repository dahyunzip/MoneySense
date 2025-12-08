<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents">
	<div class="fix-layout">  
	    <div class="container">
	        <h1 class="page-title">오픈뱅킹 계좌 연동</h1>
	        
	        <div class="info-box">
	            <h3>연동 안내</h3>
	            <ul>
	                <li>금융결제원 오픈뱅킹 서비스를 통해 안전하게 연동됩니다.</li>
	                <li>계좌 정보는 암호화되어 저장됩니다.</li>
	                <li>언제든지 연동을 해제할 수 있습니다.</li>
	                <li>자동으로 거래내역이 가계부에 반영됩니다.</li>
	            </ul>
	        </div>
	        
	        <!-- 
	            실제 오픈뱅킹 인증 URL로 이동
	            금융결제원 테스트 환경 주소 예시
	        -->
	        <div class="btn-group center">
		        <a href="https://testapi.openbanking.or.kr/oauth/2.0/authorize?response_type=code&client_id=669dcc6e-ac4a-42a8-8910-85d7c1485911&redirect_uri=http://localhost:8088/accounts/callback&scope=login inquiry transfer&state=12345678901234567890123456789012&auth_type=0" 
		           class="btn btn-info">
		            계좌 연동하기
		        </a>
		        <a href="${pageContext.request.contextPath}/main" class="btn btn-secondary">나중에 하기</a>
	        </div>
	    </div>
	</div>
</div>
<%@ include file="../include/Footer.jsp"%>