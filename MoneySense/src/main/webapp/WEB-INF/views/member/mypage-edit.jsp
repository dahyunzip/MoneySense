<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../include/Header.jsp"%>
<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
<div id="subContents" class="mypage">
	<div class="fix-layout">
	    <div class="container">
	        <h1 class="page-title">회원정보 수정</h1>
	        
	        <form action="${ctx}/members/mypage/update-name" method="post">
	        	<sec:csrfInput/>
	            <div class="form-group">
	                <label>이메일</label>
	                <input type="email" value="${member.email}" disabled>
	                <small style="color: #6c757d; display:block; margin-top:10px;">이메일은 변경할 수 없습니다.</small>
	            </div>
	            
	            <div class="form-group">
	                <label>이름</label>
	                <input type="text" name="name" value="${member.name}" required maxlength="100">
	            </div>
	            
	            <div class="btn-group center">
	                <button type="submit" class="btn btn-primary">수정하기</button>
	                <a href="${ctx}/members/mypage" class="btn btn-secondary">취소</a>
	            </div>
	        </form>
	    </div>
    </div>
</div>
<%@ include file="../include/Footer.jsp"%>