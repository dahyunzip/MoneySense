<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/Header.jsp"%>
<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
<div id="subContents" class="mypage">
	<div class="fix-layout">
		<div class="container">
			<h1 class="page-title">마이페이지</h1>
		    <c:if test="${not empty msg}">
		        <div class="message">${msg}</div>
		    </c:if>
		    
		    <div class="info-section">
		        <h2>회원 정보</h2>
		        <div class="info-item">
		            <span class="info-label">이메일</span>
		            <span class="info-value">${member.email}</span>
		        </div>
		        <div class="info-item">
		            <span class="info-label">이름</span>
		            <span class="info-value">${member.name}</span>
		        </div>
		        <div class="info-item">
		            <span class="info-label">가입일</span>
		            <span class="info-value">
		                <fmt:formatDate value="${member.joinedAt}" pattern="yyyy-MM-dd HH:mm" />
		            </span>
		        </div>
		    </div>
		    
		    <div class="btn-group">
		        <a href="${pageContext.request.contextPath}/members/mypage/edit" class="btn btn-primary">정보 수정</a>
		        <a href="${pageContext.request.contextPath}/accounts/connect" class="btn btn-primary">계좌연동</a>
		        <a href="${pageContext.request.contextPath}/accounts/sync" class="btn btn-danger">계좌 리스트</a>
		        <%-- <a href="${pageContext.request.contextPath}/members/mypage/password" class="btn btn-warning">비밀번호 변경</a> --%>
		        <a href="${pageContext.request.contextPath}/members/mypage/withdraw" class="btn btn-danger">회원 탈퇴</a>
		    </div>
	    </div>
    </div>
</div>
<%@ include file="../include/Footer.jsp"%>