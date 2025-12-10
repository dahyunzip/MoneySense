<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file ="../include/Header.jsp"%>
<div id="subContents">
	<div class="fix-layout">
		<div class="container">
        <div class="form-card">
            <h1>💳 카드 등록</h1>
            <form action="${ctx}/cards/register" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="form-group">
                    <label for="cardCompany">카드사 *</label>
                    <select id="cardCompany" name="cardCompany" required>
                        <option value="">선택하세요</option>
                        <option value="삼성카드">삼성카드</option>
                        <option value="현대카드">현대카드</option>
                        <option value="신한카드">신한카드</option>
                        <option value="KB국민카드">KB국민카드</option>
                        <option value="하나카드">하나카드</option>
                        <option value="우리카드">우리카드</option>
                        <option value="NH농협카드">NH농협카드</option>
                        <option value="롯데카드">롯데카드</option>
                        <option value="BC카드">BC카드</option>
                        <option value="IBK기업은행카드">IBK기업은행카드</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="cardName">카드명 *</label>
                    <input type="text" 
                           id="cardName" 
                           name="cardName" 
                           placeholder="예: iD LINK, M Edition" 
                           required>
                    <div class="help-text">카드 상품명을 입력하세요</div>
                </div>
                
                <div class="form-group">
                    <label for="cardNumber">카드번호 뒷 4자리 *</label>
                    <input type="text" 
                           id="cardNumber" 
                           name="cardNumber" 
                           placeholder="1234" 
                           maxlength="4"
                           pattern="[0-9]{4}"
                           required>
                    <div class="help-text">카드번호 마지막 4자리만 입력하세요</div>
                </div>
                
                <div class="form-group">
                    <label for="cardType">카드 종류 *</label>
                    <select id="cardType" name="cardType" required>
                        <option value="">선택하세요</option>
                        <option value="신용">신용카드</option>
                        <option value="체크">체크카드</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="button" 
                            class="btn btn-secondary" 
                            onclick="location.href='${ctx}/cards/list'">
                        취소
                    </button>
                    <button type="submit" class="btn btn-primary">
                        등록하기
                    </button>
                </div>
            </form>
        </div>
    </div>
	</div>
</div>
<script>
    // 카드번호 입력란 자동 포맷팅
    document.getElementById('cardNumber').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if(value.length > 4) {
            value = value.slice(0, 4);
        }
        e.target.value = value;
    });
    
    // 카드번호 뒷 4자리를 마스킹 형태로 변환
    document.querySelector('form').addEventListener('submit', function(e) {
        const cardNumberInput = document.getElementById('cardNumber');
        const lastFour = cardNumberInput.value;
        
        if(lastFour.length === 4) {
            cardNumberInput.value = '****-****-****-' + lastFour;
        }
    });
</script>
<%@ include file ="../include/Footer.jsp"%>
