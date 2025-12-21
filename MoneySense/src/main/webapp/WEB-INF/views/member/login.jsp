<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents" class="fix-layout">
    <div id="loginPage" class="container alignCenter">
        <h1 class="page-title">Login</h1>
        <p class="page-sub-title">로그인 후 머니센스를 이용해주세요!</p>
        <c:if test="${not empty msg}">
            <div class="alert ${msg.contains('완료') || msg.contains('성공') ? 'alert-success' : 'alert-danger'}">
                ${msg}
            </div>
        </c:if>
        
        <form action="${ctx}/members/login-process" method="post" id="loginForm">
            <!-- CSRF 토큰 -->
            <sec:csrfInput/>
            
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" required placeholder="example@email.com" autofocus>
            </div>
            
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required placeholder="비밀번호를 입력하세요">
            </div>
            
            <button type="submit" class="btn-login">로그인</button>
        </form>
        <div class="text-right">
		    <a href="${ctx}/members/find-password">비밀번호 찾기</a>
		</div>
        <div class="signup-link">
            계정이 없으신가요? <a href="${ctx}/members/signup">회원가입</a>
        </div>
    </div>
</div>
<%@ include file="../include/Fixed.jsp"%>
<script>
    $(document).ready(function() {
        // 폼 제출 전 유효성 검사
        $('#loginForm').on('submit', function(e) {
            const email = $('#email').val().trim();
            const password = $('#password').val();
            
            if (!email) {
                e.preventDefault();
                alert('이메일을 입력해주세요.');
                $('#email').focus();
                return false;
            }
            
            if (!password) {
                e.preventDefault();
                alert('비밀번호를 입력해주세요.');
                $('#password').focus();
                return false;
            }
            
            // 로그인 버튼 비활성화 (중복 제출 방지)
            $('.btn-login').prop('disabled', true).text('로그인 중...');
        });
        
        // Enter 키 처리
        $('#email, #password').on('keypress', function(e) {
            if (e.which === 13) {
                $('#loginForm').submit();
            }
        });
    });
</script>
