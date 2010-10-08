var loadingStatus = null;
var popupStatus = null;
function loadingView() {
	if($("#modal-bg").length == 0) {
		$("<div id=\"modal-bg\"><img id=\"loading-icon\" src=\"/images/default/loading.gif\" width=\"91\" height=\"120\" alt=\"로딩이미지\"/></div>")
		.css({"display":"none","background-color": "black", "position": "absolute", "top": "0", "left": "0"})
		.appendTo('body')
	}
	if(!loadingStatus) {
		startX = ($(document).width()/2)-(91/2);
		startY = ($(window).height()/2)-(120/2)+$(document).scrollTop();
		$("#loading-icon").css({"position": "absolute","top":startY,"left":startX}).show()
		$("#modal-bg")
			.css({"width": $(document).width(), "height": $(document).height()})
			.stop().fadeTo("fast","0.2")
		loadingStatus = "view";
	} else {
		$("#modal-bg").stop().fadeOut("fast",function() {$("#loading-icon").hide();});
		loadingStatus = null;
	}
}

function popupView(popWidth, popHeight, url) {	
	if($("#popup-view").length == 0) {
		$("<div id=\"popup-view\"></div>")
		.css({"display":"none","background-color": "White", "position": "absolute","z-index":"100","overflow":"hidden"})
		.appendTo('body')
	}
	if(!popupStatus && url) {
		loadingView();
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop();
		$("#popup-view")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight})
		.load(url+" #ajaxloadpage",function() {$(this).fadeIn("fast");popupStatus = "view" })
	} else if(popupStatus == "view" && url) {
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop()
		$("#popup-view #ajaxloadpage").fadeOut("fast",
		function() {
			$("#ajaxloadpage").remove();
			$("#popup-view").load(url+" #ajaxloadpage",
			function() {
				$("#popup-view #ajaxloadpage").css("display","none");
				$("#popup-view").animate({top:startY,left:startX,width: popWidth, height: popHeight },function () { $("#popup-view #ajaxloadpage").fadeIn("fast"); })
				
			})
		})
	} else if(popupStatus == "view" && !url) {
		$("#popup-view").fadeOut("fast",function() { popupStatus = null; })
		loadingView();
	}

}

$(document).ready(function() {
	$("body").delegate("a[href='/login']","click", function() { popupView(240,390,$(this).attr("href")); return false });
	$("body").delegate("a[href='/users/new']","click", function() { popupView(450,430,$(this).attr("href")); return false });
});