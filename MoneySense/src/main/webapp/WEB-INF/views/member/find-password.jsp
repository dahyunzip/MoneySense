<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents">
	<div class="fix-layout">   
	    <div class="container" id="loginPage">
	        <h1 class="page-title">비밀번호 찾기</h1>
	        <form action="${ctx}/members/find-password" method="post">
	        	<sec:csrfInput/>
	            <div class="form-group">
	                <label>가입 시 이메일</label>
	                <input type="email" class="form-control" name="email" 
	                       placeholder="example@moneysense.com" required />
	            </div>
	            <div class="btn-group">
	           		<button type="submit" class="btn btn-login mb20">메일 전송</button>
	            </div>
	        </form>
	        
	        <c:if test="${not empty msg}">
	            <p class="msg">${msg}</p>
	        </c:if>
	        
	        <div class="text-center">
	            <a href="${ctx}/members/login">로그인으로 돌아가기</a>
	        </div>
	    </div>
    </div>
</div>
<%@ include file="../include/Fixed.jsp"%>