<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>


<div id="fixedMenu">
	<div class="fix-layout">
		<ul>
			<li>
				<sec:authorize access="isAuthenticated()">
				<a href="${ctx}/main" title="홈으로 이동" class="ico ico01 selected">
					<span>홈</span>
				</a>
				</sec:authorize>
				<sec:authorize access="isAnonymous()">
					<a href="${ctx}/" title="홈으로 이동" class="ico ico01 selected">
						<span>홈</span>
					</a>
				</sec:authorize>
			</li>
			<li>
				<a href="${ctx}/ai/chat" title="센스봇으로 이동" class="ico ico02">
					<span>센스봇</span>
				</a>
			</li>
			<li>
				<a href="${ctx}/ledger/calendar" title="가계부로 이동" class="ico ico03">
					<span>가계부</span>
				</a>
			</li>
			<li>
				<a href="${ctx}/statistics/dashboard" title="통계 대시보드로 이동" class="ico ico04">
					<span>통계</span>
				</a>
			</li>
			<li>
				<a href="${ctx}/accounts/list" title="자산현황 이동" class="ico ico05">
					<span>나의 자산</span>
				</a>
			</li>
		</ul>
	</div>
</div>
<script src="${ctx}/resources/js/jquery-3.7.1.min.js" type="text/javascript"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
<script src="${ctx}/resources/js/common.js" type="text/javascript"></script>
<script>
$(document).ready(function() {
    <c:if test="${not empty msg}">
        showSuccess('${msg}');
    </c:if>
    
    <c:if test="${not empty msgFail}">
        showError('${msgFail}');
    </c:if>
    
    <c:if test="${not empty msgWarning}">
        showWarning('${msgWarning}');
    </c:if>
});
</script>