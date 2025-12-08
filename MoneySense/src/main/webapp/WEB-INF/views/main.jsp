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
    <div class="container">
        <p style="margin-top: 10px;">
            이메일: <strong><sec:authentication property="principal.username"/></strong>
        </p>
    </div>
</div>

<%@ include file="include/Footer.jsp"%>