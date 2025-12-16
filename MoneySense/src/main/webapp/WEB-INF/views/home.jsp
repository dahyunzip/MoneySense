<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneySense - 스마트한 가계부 관리</title>
    <link rel="stylesheet"  href="${ctx }/resources/css/common.css">
    <link rel="stylesheet"  href="${ctx }/resources/css/landing.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css"> 
    
    <script src="${ctx}/resources/js/jquery-3.7.1.min.js" type="text/javascript"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script> 
    <script src="${ctx}/resources/js/landing.js" type="text/javascript"></script>
</head>
<body>
    <header data-aos="zoom-out">
    	<div class="fix-layout">
	    	<div class="logo"><a href="/" title="홈으로 이동"><img src="${ctx}/resources/images/logo.svg"></a></div>
	    	<div class="buttons">
	    		<a href="/members/login" class="login_btn">로그인</a>
	    		<a href="/members/signup" class="join_btn">회원가입</a>
	    	</div>
    	</div>
    </header>
    <div id="main">
    	<section class="mainVisual">
    		<div class="fix-layout">
	    		<div class="text">
	    			<p data-aos="fade-up">당신의 소비를</p>
	    			<div class="point" data-aos="fade-up">가장 똑똑하게 관리하는 방법,</div>
	    			<h1 data-aos="zoom-out">MoneySense</h1>
	    			<p class="subtxt" data-aos="fade-up">오픈뱅킹 기반 자동 가계부 + AI 금융 분석 서비스</p>
	    			<a href="/members/join" class="rdBtn" data-aos="fade-up">지금 시작하기</a>
	    		</div>
	    		<div class="img"></div>
    		</div>
    	</section>
    	<section class="section sect01">
    		<div class="fix-layout">
	    		<h2 class="sect-title" data-aos="fade-up">돈관리, 생각보다 단순해질 수 있어요.</h2>
	    		<p class="sub-title" data-aos="fade-up">필요한 기능만 담은 스마트 가계부, MoneySense.</p>
	    		<div class="swiper sect01-slider" data-aos="zoom-out">
	    			<div class="swiper-wrapper">
		    			<div class="swiper-slide">
		    				<div class="cont-wrap">
			    				<div class="text">
			    					<h4>AI 소비 분석</h4>
			    					<p>GPT 기반으로 지출 트렌드를 분석해주는 개인 금융 비서</p>
			    					<p class="sm">GPT는 나의 금융비서! 나의 지출 트렌드를 분석해서 알려줘요!</p>
			    				</div>
			    				<div class="img">
			    					<img src="/resources/images/landing_main.png">
			    				</div>
		    				</div>
		    			</div>
		    			<div class="swiper-slide">
		    				<div class="cont-wrap">
			    				<div class="text">
			    					<h4>AI 소비 분석2222</h4>
			    					<p>GPT 기반으로 지출 트렌드를 분석해주는 개인 금융 비서</p>
			    					<p class="sm">GPT는 나의 금융비서! 나의 지출 트렌드를 분석해서 알려줘요!</p>
			    				</div>
			    				<div class="img">
			    					<img src="/resources/images/landing_main.png">
			    				</div>
		    				</div>
		    			</div>
		    			<div class="swiper-slide">
		    				<div class="cont-wrap">
			    				<div class="text">
			    					<h4>AI 소비 분석33333</h4>
			    					<p>GPT 기반으로 지출 트렌드를 분석해주는 개인 금융 비서</p>
			    					<p class="sm">GPT는 나의 금융비서! 나의 지출 트렌드를 분석해서 알려줘요!</p>
			    				</div>
			    				<div class="img">
			    					<img src="/resources/images/landing_main.png">
			    				</div>
		    				</div>
		    			</div>
	    			</div>
	    			<div class="swiper-buttons">
	    				<span class="button-prev"></span>
				    	<span class="button-next"></span>
	    			</div>
	    		</div>
    		</div>
    	</section>
    	<section class="section sect02">
    		<div class="fix-layout">
	    		<h2 class="sect-title" data-aos="fade-up">MoneySense는 이렇게 동작합니다.</h2>
	    		<p class="sub-title" data-aos="fade-up">캘린더로 한눈에 보는 소비, 자동으로 정리되는 거래 내역.</p>
	    		<div class="swiper sect02-slider" data-aos="zoom-out">
	    			<div class="swiper-wrapper">
		    			<div class="swiper-slide">
		    				<div class="cont-wrap">
			    				<div class="img">
			    				</div>
			    				<div class="text">
			    					<h4>AI 소비 분석</h4>
			    					<p>GPT 기반으로 지출 트렌드를 분석해주는 개인 금융 비서</p>
			    				</div>
		    				</div>
		    			</div>
		    			<div class="swiper-slide">
		    				<div class="cont-wrap">
			    				<div class="img">
			    				</div>
			    				<div class="text">
			    					<h4>AI 소비 분석222</h4>
			    					<p>GPT 기반으로 지출 트렌드를 분석해주는 개인 금융 비서</p>
			    				</div>
		    				</div>
		    			</div>
		    			<div class="swiper-slide">
		    				<div class="cont-wrap">
			    				<div class="img">
			    				</div>
			    				<div class="text">
			    					<h4>AI 소비 분석333</h4>
			    					<p>GPT 기반으로 지출 트렌드를 분석해주는 개인 금융 비서</p>
			    				</div>
		    				</div>
		    			</div>
	    			</div>
	    			<div class="swiper-buttons">
	    				<span class="button-prev"></span>
				    	<span class="button-next"></span>
	    			</div>
	    		</div>
    		</div>
    	</section>
    	<section class="section sect03">
    		<div class="fix-layout">
	    		<h2 class="sect-title" data-aos="fade-up">돈관리는 어렵지 않습니다.<br>지금까지 방법이 복잡했을 뿐</h2>
	    		<p class="sub-title" data-aos="fade-up">더 단순하고 똑똑한 방식, MoneySense가 제안합니다.</p>
	    		<div class="compare" data-aos="zoom-out">
	    			<div class="before">
	    				<ul>
	    					<li>“가계부 쓰는게 너무 귀찮아요.”</li>
	    					<li>“카드, 계좌가 많아서 내 소비 흐름을 잘 모르겠어요.”</li>
	    					<li>“어디에 돈을 많이 쓰는지 분석이 안돼요.”</li>
	    				</ul>
	    			</div>
	    			<div class="after">
	    				<ul>
	    					<li>“모든 거래 자동 수집 → ZERO 수기 입력”</li>
	    					<li>“캘린더 기반 소비 시각화”</li>
	    					<li>“AI가 한 줄로 정리하는 소비 리포트”</li>
	    				</ul>
	    			</div>
	    		</div>
    		</div>
    	</section>
    	<section class="section sect04">
    		<div class="fix-layout">
	    		<h2 class="sect-title" data-aos="fade-up">다른 가계부로는 못 돌아가요.</h2>
	    		<p class="sub-title" data-aos="fade-up">사용자들이 직접 말하는 MoneySense의 진짜 변화.</p>
	    		<div class="review" data-aos="zoom-out">
	    			<ul>
	    				<li>
	    					<div class="img img01"></div>
	    					<div class="star"></div>
	    					<div class="text">
	    						캘린더로 소비를 보는 게<br>이렇게 편할 줄 몰랐어요.
	    					</div>
	    				</li>
	    				
	    				<li>
	    					<div class="img img02"></div>
	    					<div class="star"></div>
	    					<div class="text">
	    						AI가 한 줄로 정리해주는<br>지출 분석 너무 유용해요.
	    					</div>
	    				</li>
	    				
	    				<li>
	    					<div class="img img03"></div>
	    					<div class="star"></div>
	    					<div class="text">
	    						AI 챗봇 덕분에 혼자 작성한다는<br>느낌이 전혀 없어요!
	    					</div>
	    				</li>
	    				
	    				<li>
	    					<div class="img img04"></div>
	    					<div class="star"></div>
	    					<div class="text">
	    						캘린더로 소비를 보는 게<br>이렇게 편할 줄 몰랐어요.
	    					</div>
	    				</li>
	    			</ul>
	    		</div>
    		</div>
    	</section>
    	<section class="bot-banner" data-aos="fade-left">
    		<p>지금 바로 당신의 소비를 한눈에 정리하세요.</p>
    		<a href="/members/join" class="rdBtn">지금 시작하기</a>
    	</section>
    </div>
    <footer>
    	<div class="fix-layout">
    		<ul class="li-wr">
    			<li><a href="#">이메일 / 문의 안내</a></li>
    			<li><a href="#">Github</a></li>
    		</ul>
    	</div>
    </footer>
</body>
</html>