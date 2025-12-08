<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="include/Header.jsp"%>
<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
<div id="mainContents">
	<div class="fix-layout">
	    <div class="container">
		<h1 class="text-center" style="font-family: 'Paperlogy'; font-size:50px;">메인페이지</h1>
	        <p style="margin-top: 10px;">
	            접속자 : <strong><sec:authentication property="principal.username"/></strong>
	        </p>
	        <div class="btn-group">
	        	<h1>버튼색상</h1>
	        	<button class="btn btn-primary">btn btn-primary</button>
	        	<button class="btn btn-success">btn btn-success</button>
	        	<button class="btn btn-info">btn btn-info</button>
	        	<button class="btn btn-danger">btn btn-danger</button>
	        	<button class="btn btn-warning">btn btn-warning</button>
	        	<button class="btn btn-secondary">btn btn-secondary</button>
	        	<button class="btn btn-back">btn btn-back</button>
	        </div>
	        <div class="mt30">
	        	<a href="/members/mypage">마이페이지</a>
	        	<a href="/members/mypage/edit">정보수정</a>
	        	<a href="/accounts/connect">계좌연동</a>
	        	<a href="/accounts/sync">계좌 리스트(동기화)</a>
	        	<a href="/members/mypage/withdraw">회원탈퇴</a>
	        	<a href="#">마이페이지</a>
	        	<a href="#">마이페이지</a>
	        </div>
	    </div>
    </div>
</div>

<%@ include file="include/Footer.jsp"%>