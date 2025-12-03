<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents">
    <div class="container">
        <h3>비밀번호 찾기</h3>
        
        <form action="${pageContext.request.contextPath}/members/find-password" method="post">
        	<sec:csrfInput/>
            <div class="form-group">
                <label>가입 시 이메일</label>
                <input type="email" class="form-control" name="email" 
                       placeholder="example@moneysense.com" required />
            </div>
            <button type="submit" class="btn">메일 전송</button>
        </form>
        
        <c:if test="${not empty msg}">
            <p class="msg">${msg}</p>
        </c:if>
        
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/members/login">로그인으로 돌아가기</a>
        </div>
    </div>
</div>
<%@ include file="../include/Footer.jsp"%>