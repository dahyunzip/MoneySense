/**
 * 랜딩페이지 js
 */
$(document).ready(function(){
	AOS.init({
		easing: 'ease-out-back',
		duration: 1000,
		offset : 300
	});
	
	function AOS_MOBILE() {
	  if (matchMedia("screen and (max-width: 768px)").matches) {

	    AOS.init({
			duration : 500,
			offset : 0
		});

	  }
	}
	AOS_MOBILE();
	
	var sect01Swiper = new Swiper('.sect01-slider', {
        slidesPerView: 1,
        spaceBetween: 0,
        loop: true,
        autoplay: {
            delay: 3000,
            disableOnInteraction: false,
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        navigation: {
            nextEl: '.button-next',
            prevEl: '.button-prev',
        },
        speed: 1000,
        effect: 'slide'
    });
	
	var sect02Swiper = new Swiper('.sect02-slider', {
	        slidesPerView: 1,
	        spaceBetween: 0,
	        loop: true,
	        autoplay: {
	            delay: 3000,
	            disableOnInteraction: false,
	        },
	        pagination: {
	            el: '.swiper-pagination',
	            clickable: true,
	        },
	        navigation: {
	            nextEl: '.button-next',
	            prevEl: '.button-prev',
	        },
	        speed: 1000,
	        effect: 'fade'
	    });
});