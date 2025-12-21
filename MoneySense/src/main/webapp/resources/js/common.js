/**
 * 메뉴 관련 js
 */
$(document).ready(function(){
	$("#menu .menu-wrap").hide();
	$("#menu .open").click(function(){
		$("#menu .menu-wrap").fadeIn();
	});
	$("#menu .close").click(function(){
		$("#menu .menu-wrap").fadeOut();
	});
	
	// 하단 메뉴 
	var currentPath = window.location.pathname;
	
	// 모든 메뉴 아이템에서 selected 클래스 제거
	$('#fixedMenu .ico').removeClass('selected');
	
	// 메뉴별 매칭 규칙
	var selectedMenu = null;
	
	// 홈
	if(currentPath === '/' || currentPath === '/main'){
		selectedMenu = '/main';
	}
	
	// 계좌
	else if(currentPath.startsWith('/accounts') || currentPath.startsWith('/transactions')){
		selectedMenu = '/accounts/list';
	}
	
	// 카드
	else if(currentPath.startsWith('/cards')){
		selectedMenu = '/cards/list';
	}
	
	// 가계부 
    else if (currentPath.startsWith('/ledger')) {
        selectedMenu = '/ledger/calendar';
    }
	
	// 마이페이지
	else if(currentPath.startsWith('/members')){
		selectedMenu = '/members/mypage';
	}
	
	// 선택된 메뉴에 selected 클래스 추가
	if(selectedMenu){
		$('#fixedMenu a[href="'+selectedMenu+'"]').addClass('selected');
	}
	
	var topCont = $('#contents');
	if(topCont.children().hasClass('bgGray')){
		topCont.css({"background" : "#fafafa"});
	}
	
});