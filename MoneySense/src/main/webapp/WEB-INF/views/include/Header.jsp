<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MoneySense</title>
	<!-- favicon.svg -->
	<link rel="shortcut icon" type="image/x-icon" href="https://notion-emojis.s3-us-west-2.amazonaws.com/prod/svg-twitter/1f4b5.svg" />
	
	<!-- Web Font -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
	
	<!-- (S) CSS -->
	<link  rel="stylesheet" href="${ctx}/resources/css/common.css">
	<c:choose>
	 <c:when test="${uri == '/main'}">
		<link rel="stylesheet" href="${ctx}/resources/css/main.css" />
	 </c:when>
	 <c:otherwise>
		<link rel="stylesheet" href="${ctx}/resources/css/sub.css" />
	 </c:otherwise>
	</c:choose>
	<!-- (E) CSS -->
	
	<!-- (S) JS -->
	<script src="${ctx}/resources/js/jquery-3.7.1.min.js" type="text/javascript"></script>
	<!-- (E) JS -->
</head>
<body id="RESPONSE_POINT">
	<header>
	<div class="header">
	    <div class="header-content fix-layout">
	        <div class="logo"><a href="/" title="홈으로 이동"><img src="${ctx}/resources/images/logo.svg"></a></div>
	        <div class="user-info">
	        	<!-- 로그인 상태일 때만 표시 -->
		        <sec:authorize access="isAuthenticated()">
		            <span class="name">
		                <sec:authentication property="principal.member.name"/>님
		            </span>
		            <form action="${ctx}/members/logout" method="post" style="display: inline;">
		                <sec:csrfInput/>
		                <button type="submit" class="btn-logout">로그아웃</button>
		            </form>
		            <button class="btn-logout" onclick="location.href='/members/mypage'">마이페이지</button>
		        </sec:authorize>
		        
		        <!-- 비로그인 상태일 때만 표시 -->
	            <sec:authorize access="isAnonymous()">
	                <button onclick="location.href='${ctx}/members/signup'" class="btn-logout">회원가입</button>
	                <button onclick="location.href='${ctx}/members/login'" class="btn-login">로그인</button>
	            </sec:authorize>
	        </div>
	    </div>
	</div>
	</header>
	<div id="contents">