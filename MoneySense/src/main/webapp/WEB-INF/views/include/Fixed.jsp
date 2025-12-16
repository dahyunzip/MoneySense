<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div id="fixedMenu">
	<div class="fix-layout">
		<ul>
			<li>
				<sec:authorize access="isAuthenticated()">
				<a href="/main" title="홈으로 이동" class="ico ico01 selected">
					<span>홈</span>
				</a>
				</sec:authorize>
				<sec:authorize access="isAnonymous()">
					<a href="/" title="홈으로 이동" class="ico ico01 selected">
						<span>홈</span>
					</a>
				</sec:authorize>
			</li>
			<li>
				<a href="/accounts/list" title="계좌목록으로 이동" class="ico ico02">
					<span>계좌</span>
				</a>
			</li>
			<li>
				<a href="/cards/list" title="카드목록으로 이동" class="ico ico03">
					<span>카드</span>
				</a>
			</li>
			<li>
				<a href="/ledger/calendar" title="가계부로 이동" class="ico ico04">
					<span>가계부</span>
				</a>
			</li>
			<li>
				<a href="/members/mypage" title="마이페이지로 이동" class="ico ico05">
					<span>마이페이지</span>
				</a>
			</li>
		</ul>
	</div>
</div>