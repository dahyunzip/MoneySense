<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/Header.jsp"%>
<script>
    function confirmWithdraw() {
        var agreed = document.getElementById('agreeWithdraw').checked;
        
        if(!agreed) {
            alert('탈퇴 안내를 확인하고 동의해주세요.');
            return false;
        }
        
        var password = document.getElementById('password').value;
        if(password.trim() === '') {
            alert('비밀번호를 입력해주세요.');
            return false;
        }
        
        return confirm('정말로 회원 탈퇴하시겠습니까?\n\n이 작업은 되돌릴 수 없으며,\n모든 데이터가 삭제됩니다.');
    }
</script>
<div id="subContents" class="mypage">
	<div class="container">
        <h1 class="page-title">⚠️ 회원 탈퇴</h1>
        
        <c:if test="${not empty msg}">
            <div class="message">${msg}</div>
        </c:if>
        
        <div class="warning-box">
            <h3>회원 탈퇴 전 꼭 확인하세요</h3>
            <ul>
                <li>탈퇴 시 모든 계좌 정보와 거래 내역이 영구 삭제됩니다.</li>
                <li>저장된 AI 분석 결과도 모두 삭제됩니다.</li>
                <li>카테고리 설정 및 모든 개인 설정이 초기화됩니다.</li>
                <li>탈퇴 후 동일한 이메일로 재가입이 가능합니다.</li>
                <li><strong>탈퇴 처리 후에는 데이터 복구가 불가능합니다.</strong></li>
            </ul>
        </div>
        
        <form action="${pageContext.request.contextPath}/members/mypage/withdraw" method="post" onsubmit="return confirmWithdraw()">
        	<sec:csrfInput/>
            <div class="form-group">
                <label>비밀번호 확인</label>
                <input type="password" name="password" id="password" required 
                       placeholder="본인 확인을 위해 비밀번호를 입력하세요">
            </div>
            
            <div class="checkbox-group">
                <label>
                    <input type="checkbox" id="agreeWithdraw" required>
                    위 내용을 모두 확인했으며 회원 탈퇴에 동의합니다.
                </label>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-danger">탈퇴하기</button>
                <a href="${pageContext.request.contextPath}/members/mypage" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="../include/Footer.jsp"%>