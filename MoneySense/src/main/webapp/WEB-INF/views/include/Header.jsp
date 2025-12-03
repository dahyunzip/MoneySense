<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
	<link  rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/common.css">
	<c:choose>
	 <c:when test="${uri == '/'}">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css" />
	 </c:when>
	 <c:otherwise>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sub.css?ver=1.1" />
	 </c:otherwise>
	</c:choose>
	<!-- (E) CSS -->
	
	<!-- (S) JS -->
	<script src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js" type="text/javascript"></script>
	<!-- (E) JS -->
</head>
<body>
<header>
<div class="header">
    <div class="header-content">
        <div class="logo">MoneySense</div>
        <div class="user-info">
            <span>
                <sec:authentication property="principal.member.name"/>님 환영합니다!
            </span>
            <form action="${pageContext.request.contextPath}/members/logout" method="post" style="display: inline;">
                <sec:csrfInput/>
                <button type="submit" class="btn-logout">로그아웃</button>
            </form>
        </div>
    </div>
</div>
</header>
<div id="contents">