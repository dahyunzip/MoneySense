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
	
	/*// 계좌
	else if(currentPath.startsWith('/accounts') || currentPath.startsWith('/transactions')){
		selectedMenu = '/accounts/list';
	}
	
	// 카드
	else if(currentPath.startsWith('/cards')){
		selectedMenu = '/cards/list';
	}*/
	
	// ai 
    else if (currentPath.startsWith('/ai')) {
        selectedMenu = '/ai/chat';
    }
	
	// 가계부 
    else if (currentPath.startsWith('/ledger')) {
        selectedMenu = '/ledger/calendar';
    }
	
	// 통계 
    else if (currentPath.startsWith('/statistics')) {
        selectedMenu = '/statistics/dashboard';
    }
	
	// 마이페이지
	else if(currentPath.startsWith('/accounts') || currentPath.startsWith('/cards') || currentPath.startsWith('/transactions')){
		selectedMenu = '/accounts/list';
	}
	console.log(currentPath);
	
	// 선택된 메뉴에 selected 클래스 추가
	if(selectedMenu){
		$('#fixedMenu a[href="'+selectedMenu+'"]').addClass('selected');
	}

	//console.log(window.location.pathname);
	// 출력: "/MoneySense/ai/chat"

	//console.log($('#fixedMenu a[href="/ai/chat"]').length);
	// 출력: 1 (있으면 정상)

	//console.log($('#fixedMenu a').map(function() { 
	//    return $(this).attr('href'); 
	//}).get());
	// 모든 메뉴 링크 확인
	
	// bgGray이면 백그라운드 컬러 지정
	var topCont = $('#contents');
	if(topCont.children().hasClass('bgGray')){
		topCont.css({"background" : "#fafafa"});
	}
	
});