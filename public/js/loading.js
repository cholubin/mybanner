var loading;
function loadingView() {
	if($("#modal-bg").length == 0) $("<div id=\"modal-bg\"><img id=\"loading-icon\" src=\"/images/loading.gif\" width=\"91\" height=\"120\" alt=\"로딩이미지\"/></div>").css({"display":"none","background-color": "black", "position": "absolute", "top": "0", "left": "0"}).appendTo('body')
	if(!loading) {
		startX = ($(document).width()/2)-(91/2);
		startY = ($(window).height()/2)-(120/2)+$(document).scrollTop();
		$("#loading-icon").css({"position": "absolute","top":startY,"left":startX}).show()
		$("#modal-bg")
			.css({"width": $(document).width(), "height": $(document).height()})
			.fadeTo("fast","0.2")
		loading = "on";
	} else {
		$("#modal-bg").fadeOut("fast",function() {$("#loading-icon").hide();});
		loading = null;
	}
}