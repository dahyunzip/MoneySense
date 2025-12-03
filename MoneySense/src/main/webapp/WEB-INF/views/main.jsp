<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="include/Header.jsp"%>

<div id="mainContents">
    <div class="container">
        <div class="welcome">
            <h1>🎉 로그인 성공!</h1>
            <p>MoneySense에 오신 것을 환영합니다.</p>
            <p style="margin-top: 10px;">
                이메일: <strong><sec:authentication property="principal.username"/></strong>
            </p>
        </div>
    </div>
</div>

<%@ include file="include/Footer.jsp"%>