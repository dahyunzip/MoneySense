<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents" class="alignCenter">
	<div class="fix-layout">  
	    <div class="container" id="connect">
	        <h1 class="page-title">오픈뱅킹 계좌 연동</h1>
	        
	        <div class="info-box">
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
	        <div class="btn-block center">
		        <a href="https://testapi.openbanking.or.kr/oauth/2.0/authorize?response_type=code&client_id=669dcc6e-ac4a-42a8-8910-85d7c1485911&redirect_uri=http://c6d2507t1p2.itwillbs.com/accounts/callback&scope=login inquiry transfer&state=12345678901234567890123456789012&auth_type=0" 
		           class="btn-success">
		            계좌 연동하기
		        </a>
		        <a href="${ctx}/main" class="btn btn-underline">나중에 하기</a>
	        </div>
	    </div>
	</div>
</div>
<%@ include file="../include/Fixed.jsp"%>