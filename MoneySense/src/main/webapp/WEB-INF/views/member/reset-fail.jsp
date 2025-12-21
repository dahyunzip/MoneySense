<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents">
	<div class="container">
	    <h3>비밀번호 재설정 실패</h3>
	    <p class="msg">${msg}</p>
	    
	    <a href="${ctx}/members/find-password" class="btn">
	        다시 시도하기
	    </a>
	    
	    <div class="mt-3">
	        <a href="${ctx}/members/login">로그인으로 돌아가기</a>
	    </div>
	</div>
</div>
<%@ include file="../include/Footer.jsp"%>