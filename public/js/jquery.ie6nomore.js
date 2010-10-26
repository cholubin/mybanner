if(getCookie("ie6close") != "yes") {
	$(function (){
		$("<div id='ie6nomore'></div>")
		.css({"background": "black url('/images/ie6nomore/ie6nomore-bg.png')", "height": "67px" })
		.prependTo('body');
		$("body").css("background-position","center 67px")
		
		$("<p></p>")
		.css({"margin": "0", "width": "960px", "height": "63px", "margin": "0 auto", "position": "relative"})
		.appendTo("#ie6nomore");
		
		$("<img src='/images/ie6nomore/ie6nomore-content.png' class='content' width='687' height='63'/>")
		.appendTo("#ie6nomore p");
		$("<a href='http://campaign.naver.com/goodbye-ie6' class='campaign' target='_blank'><img src='/images/ie6nomore/ie6nomore-button.png' width='249' height='63'/></a>")
		.css({"position": "absolute", "top": "0", "left": "700px"})
		.appendTo("#ie6nomore p");
		
		$("<a href='#' class='close'>하루동안 안보기</a>")
		.css({"display": "block", "position":"absolute", "top": "34px", "left": "540px", "background": "white", "padding": "4px", "font-size": "11px", "font-family": "dotum, sans-serif"})
		.click(function() { setCookie("ie6close","yes",1); $("#ie6nomore").remove(); $("body").css("background-position","center top") })
		.appendTo("#ie6nomore p");
	})
}