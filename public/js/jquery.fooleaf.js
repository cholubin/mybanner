var loadingStatus = null;
var popupStatus = null;
var prev_num = null;

function loadingView() {
	if($("#modal-bg").length == 0) {
		$("<div id=\"modal-bg\"><img id=\"loading-icon\" src=\"/images/default/loading.gif\" width=\"91\" height=\"120\" alt=\"로딩이미지\"/></div>")
		.css({"display":"none","background-color": "black", "position": "absolute", "top": "0", "left": "0","z-index":"10"})
		.appendTo('body')
	}
	if(!loadingStatus) {
		startX = ($(document).width()/2)-(91/2);
		startY = ($(window).height()/2)-(120/2)+$(document).scrollTop();
		$("#loading-icon").css({"position": "absolute","top":startY,"left":startX}).show()
		$("#modal-bg")
			.css({"width": "100%", "height": $(document).height()})
			.stop().fadeTo(0,"0.2")
		loadingStatus = "view";
	} else {
		$("#modal-bg").stop().fadeOut(0,function() {$("#loading-icon").hide();});
		loadingStatus = null;
	}
}

function popupView(popWidth, popHeight, url) {
	if($("#popup-view").length == 0) {
		$("<div id=\"popup-view\"></div>")
		.css({"display":"none","background-color": "White", "position": "absolute","z-index":"100","overflow":"hidden"})
		.appendTo('body');
		$("<a id=\"popup-closeButton\"></a>")
		.css({"display":"none", "background-image": "url('/images/default/button-close.png')", "position": "absolute","z-index":"110","width":"52px","height":"20px","cursor":"pointer"})
		.appendTo('body');
	}
	if(!popupStatus && url) {
		loadingView();
		popupStatus = "view"
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop();
		$("#popup-closeButton").css({"top":startY+10,"left":startX+popWidth-62})
		$("#popup-view")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight})
		.load(url+" #ajaxloadpage",function() { $(this).fadeIn("fast");$("#popup-closeButton").live("click",function(){popupView()}).fadeIn("fast");})
	} else if(popupStatus == "view" && url) {
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop()
		$("#popup-closeButton").fadeOut("fast",function() {$("#popup-closeButton").css({"top":startY+10,"left":startX+popWidth-62})})
		$("#popup-view #ajaxloadpage").fadeOut("fast",
		function() {
			$("#ajaxloadpage").remove();
			$("#popup-view").load(url+" #ajaxloadpage",
			function() {
				$("#popup-view #ajaxloadpage").css("display","none");
				$("#popup-view").animate({top:startY,left:startX,width: popWidth, height: popHeight },function () { $("#popup-view #ajaxloadpage").fadeIn("fast"); $("#popup-closeButton").live("click",function(){popupView()}).fadeIn("fast"); })
			})
		})
	} else if(popupStatus == "view" && !url) {
		popupStatus = null;
		$("#popup-view").fadeOut("fast")
		$("#popup-closeButton").fadeOut("fast")
		loadingView();
	}

}

function mainImageChange(num) {
	if($("#main-image img:eq("+num+")").css("z-index") != "3") {
		if(prev_num != null)
			$("#main-image img:eq("+prev_num+")").css("z-index","2")
		$("#main-image img:eq("+num+")").css("z-index","3")
		$("#main-image img:eq("+num+")").fadeIn("fast",function() { if(prev_num != null) $("#main-image img:eq("+prev_num+")").hide();prev_num = num; });
	}
}


$(function () {
//	$("a[href=/login]").live("click", function() { popupView(250,390,$(this).attr("href")); return false });
//	$("a[href=/users/new]").live("click", function() { popupView(660,350,$(this).attr("href")); return false });
//	$(".user-edit a").live("click", function() { popupView(400,330,$(this).attr("href")); return false });
//	$("a[href=/pages/withdraw]").live("click", function() { popupView(380,310,$(this).attr("href")); return false });
//	$("a[href=/pages/editorder]").live("click", function() { popupView(650,410,$(this).attr("href")); return false });
	$("#main-button li:eq(0)").click(function() { mainImageChange(0) });
	$("#main-button li:eq(1)").click(function() { mainImageChange(1) });
	$("#main-button li:eq(2)").click(function() { mainImageChange(2) });
	
	$("a[href='/pages/guide']").live("click", function() { alert("현재 사용방법을 쉽게 정리한\n메뉴얼 페이지를 준비중입니다. ^-^"); return false; });
	$("a[href='/pages/cscenter']").live("click", function() { alert("고객센터는, 각 솔루션이용 업체별 게시판, \n개인정보관리정책, 이용약관등을 명시하고 있습니다.\n현재 준비중입니다."); return false; });
	$("body").delegate(".ajax-sign-in","click", function() { popupView(250,390,$(this).attr("href")); return false });
	$("body").delegate(".ajax-sign-up","click", function() { popupView(660,350,$(this).attr("href")); return false });
	$("body").delegate(".ajax-edit","click", function() { popupView(360,330,$(this).attr("href")); return false });
	$("body").delegate(".ajax-withdraw","click", function() { popupView(380,310,$(this).attr("href")); return false });
	$("body").delegate(".ajax-edit-order","click", function() { popupView(620,340,$(this).attr("href")); return false });
});

$(window).load(function() {
	mainImageChange(0);
})