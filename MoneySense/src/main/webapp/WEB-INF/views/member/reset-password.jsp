<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents">
    <div class="container">
        <h3>새 비밀번호 설정</h3>
        
        <form id="resetForm" action="${pageContext.request.contextPath}/members/reset-password" method="post">
            <sec:csrfInput/>
            
            <input type="hidden" name="email" value="${email}">
            <input type="hidden" name="token" value="${token}">
            
            <div class="form-group">
                <label>새 비밀번호</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" 
                       placeholder="새 비밀번호 입력 (8자 이상)" required>
            </div>
            
            <div class="form-group">
                <label>비밀번호 확인</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                       placeholder="비밀번호 다시 입력" required>
            </div>
            
            <div id="pwdError"></div>
            
            <button type="submit" class="btn">비밀번호 변경</button>
            
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/members/login">로그인으로 돌아가기</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="../include/Footer.jsp"%>
<script>
    $(document).ready(function() {
        const $form = $('#resetForm');
        const $newPw = $('#newPassword');
        const $confirmPw = $('#confirmPassword');
        const $pwdError = $('#pwdError');
        
        function validatePassword() {
            const pwd = $newPw.val();
            const pwdConfirm = $confirmPw.val();
            let pwdError = [];
            
            if (pwd.length < 8) {
                pwdError.push('비밀번호는 최소 8자 이상이어야 합니다.');
            }
            
            if (!/[A-Za-z]/.test(pwd)) {
                pwdError.push('비밀번호에는 영문자가 최소 하나 포함되어야 합니다.');
            }
            
            if (!/[0-9]/.test(pwd)) {
                pwdError.push('비밀번호에는 숫자가 최소 하나 포함되어야 합니다.');
            }
            
            if (!/[!@#$%^&*(),.?":{}|<>]/.test(pwd)) {
                pwdError.push('비밀번호에는 특수문자 하나 이상 포함되어야 합니다.');
            }
            
            if (pwd !== pwdConfirm) {
                pwdError.push('비밀번호와 확인 비밀번호가 일치하지 않습니다.');
            }
            
            if (pwdError.length > 0) {
                $pwdError.html(pwdError.join('<br>')).show();
                return false;
            } else {
                $pwdError.hide();
                return true;
            }
        }
        
        $newPw.on('keyup change', validatePassword);
        $confirmPw.on('keyup change', validatePassword);
        
        $form.on('submit', function(e) {
            if (!validatePassword()) {
                e.preventDefault();
                alert('비밀번호 조건을 다시 확인해주세요.');
            }
        });
    });
</script>