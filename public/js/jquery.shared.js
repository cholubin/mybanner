var loadingStatus = null;
var popupStatus = null;
var quickViewStatus = null;
var prev_num = null;

function setCookie(cName, cValue, cDay){
	var expire = new Date();
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
	if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;
}

function getCookie(cName) {
	cName = cName + '=';
	var cookieData = document.cookie;
	var start = cookieData.indexOf(cName);
	var cValue = '';
	if(start != -1){
		start += cName.length;
		var end = cookieData.indexOf(';', start);
		if(end == -1)end = cookieData.length;
		cValue = cookieData.substring(start, end);
	}
	return unescape(cValue);
}

function loadingView() {
	if($("#modal-bg").length == 0) {
		$("<div id=\"modal-bg\"><img id=\"loading-icon\" src=\"/images/default/loading.gif\" width=\"91\" height=\"120\" alt=\"로딩이미지\"/></div>")
		.css({"display":"none","background-color": "black", "position": "absolute", "top": "0", "left": "0","z-index":"10"})
		.appendTo('body')
	}
	if(!loadingStatus) {
		loadingStatus = "view";
		startX = ($(document).width()/2)-(91/2);
		startY = ($(window).height()/2)-(120/2)+$(document).scrollTop();
		$("#loading-icon").css({"position": "absolute","top":startY,"left":startX}).show()
		$("#modal-bg")
			.css({"width": "100%", "height": $(document).height()})
			.stop().fadeTo(0,"0.2")
	} else {
		if(popupStatus) {
			if(loadingStatus == "view") {
				loadingStatus = "top";
				$("#modal-bg").css("z-index","130");	
			} else {
				loadingStatus = "view";
				$("#modal-bg").css("z-index","10");
			}
		} else {
			loadingStatus = null;
			$("#modal-bg").stop().fadeOut(0,function() {$("#loading-icon").hide();});
		}
	}
}

function popupView(popWidth, popHeight, url, post, callback) {
	if(typeof(post) == "function") {
		callback = post;
		post = null;
	}
	if($("#popup-view").length == 0) {
		$("<div id=\"popup-view\"></div>")
		.appendTo('body');
		$("<a id=\"popup-closeButton\"></a>")
		.appendTo('body');
	}
	$("#popup-view")
	.css({"display":"none","background-color": "White", "position": "absolute","z-index":"100","overflow":"hidden"})
	.mousedown(function(){$(document).mousemove(function(e){return false;});})
	$("#popup-closeButton")
	.css({"display":"none", "background-image": "url('/images/default/button-close.png')", "position": "absolute","z-index":"110","width":"52px","height":"20px","cursor":"pointer"})
	
	if(!popupStatus && url) {
		loadingView();
		popupStatus = "view"
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop();
		if(startY < 20) startY = 20;
		$("#popup-closeButton").css({"top":startY+10,"left":startX+popWidth-62})
		$("#popup-view")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight})
		.load(url+" #ajaxloadpage",post,function(responseText, textStatus, XMLHttpRequest) { $(this).fadeIn("fast");$("#popup-closeButton").live("click",function(){popupView()}).fadeIn("fast"); if(typeof(callback) == "function") callback(responseText, textStatus, XMLHttpRequest);})
	} else if(popupStatus == "view" && url) {
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop()
		$("#popup-closeButton").fadeOut("fast",function() {$("#popup-closeButton").css({"top":startY+10,"left":startX+popWidth-62})})
		$("#popup-view #ajaxloadpage").fadeOut("fast",
		function() {
			$("#ajaxloadpage").remove();
			$("#popup-view").load(url+" #ajaxloadpage",post,
			function(responseText, textStatus, XMLHttpRequest) {
				$("#popup-view #ajaxloadpage").css("display","none");
				$("#popup-view").animate({top:startY,left:startX,width: popWidth, height: popHeight },function () { $("#popup-view #ajaxloadpage").fadeIn("fast"); $("#popup-closeButton").live("click",function(){popupView()}).fadeIn("fast"); })
				if(typeof(callback) == "function") callback(responseText, textStatus, XMLHttpRequest);
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

function openWebTopEditor(user,id,href) {
	if($("#webTopEditor").length == 0) {
		$("<div id=\"webTopEditor\"><div id=\"editor_header\"><h2>WebTop Editor</h2><a href=\"#\" id=\"back_to_home\">저장하고 홈페이지로 돌아가기.</a></div></div>")
		.css({"display":"none","background-color": "White" ,"position": "absolute","width":"100%", "z-index":"150","overflow":"hidden","top":"0","left":"0"})
		.mousedown(function(){$(document).mousemove(function(e){return false;});})
		.appendTo('body');
	}

	var url = "/MClientBox/index.html?spread_list=NO&user_path=/user_files/"+user+"&doc_path=/article_templates/"+ id +".mlayoutP"

	$("<iframe id=\"webTop_iFrame\" src=\""+url+"\" width=\"100%\" border=\"0\" frameborder=\"0\"/>").css({"display":"block","border":"0","height":$(window).height()-75}).appendTo("#webTopEditor");
	$("<div id=\"editor_footer\"><img src=\"/images/editor/footer.png\" width=\"960\" height=\"34\"/></div>").appendTo("#webTopEditor");
	$("#webTopEditor").css({"display":"block","height":$(window).height()});
	href = (href == null)?"/":href;
	$("#back_to_home").attr("href",href)

	// 리사이즈시 자동으로 사이즈 변경	
	$(window).resize(function() {
		$("#webTopEditor").css("height",$(window).height());
		$("#webTop_iFrame").css("height",$(window).height()-75);
	})
	$("body").css("background","#63828c");
	$("#header").remove();
	$("#content").remove();
	$("#footer").remove();

}

function quickPreview(popWidth, popHeight, url, content_id) {
	if($("#quick_preview").length == 0) {
		$("<div id=\"quick_preview\"></div>")
		.css({"display":"none","background-color": "transparent", "position": "absolute","z-index":"140","overflow":"hidden"})
		.mousedown(function(){$(document).mousemove(function(e){return false;});})
		.appendTo('body');
		$("<div id=\"quick_preview_bg\"></div>")
		.css({"display":"none","position": "absolute","z-index":"139","background":"url(\"/images/content/block-quickview-bg.png\") black repeat-x left top"})
		.appendTo('body');
		$("<a id=\"quick_preview_closeButton\"></a>")
		.css({"display":"none", "background-image": "url('/images/default/button-close.png')", "position": "absolute","z-index":"141","width":"52px","height":"20px","cursor":"pointer"})
		.appendTo('body');
	}
	if(!quickViewStatus && url) {
		loadingView();
		quickViewStatus = "view";
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop();
		if(startY < 20) startY = 20;
		$("#quick_preview_closeButton").css({"top":startY+10,"left":startX+popWidth-62})
		$("#quick_preview_bg")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight});
		$("#quick_preview")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight})
		.load(url+" #"+content_id, function(responseText, textStatus, XMLHttpRequest) { $("#loading-icon").fadeOut();$("#quick_preview_bg").fadeTo("fast","0.80",function() { $("#modal-bg").click(function() { quickPreview() } );$("#quick_preview").fadeIn("fast"); });$("#quick_preview_closeButton").live("click",function(){quickPreview()}).fadeIn("fast");})
	} else if(quickViewStatus == "view"){
		quickViewStatus = null;
		loadingView();
		$("#modal-bg").click(function() {return false});
		$("#quick_preview").fadeOut("fast",function() { $("#quick_preview_bg").fadeOut("fast"); $("#quick_preview_closeButton").fadeOut("fast"); });
	}
	
}


$(function () {
	// 메인 페이지 이미지 교체 액션
	$("#main-button li:eq(0)").click(function() { mainImageChange(0) });
	$("#main-button li:eq(1)").click(function() { mainImageChange(1) });
	$("#main-button li:eq(2)").click(function() { mainImageChange(2) });
	$("body").delegate(".ajax-sign-in","click", function() { popupView(250,390,$(this).attr("href")); return false });
	$("body").delegate(".ajax-sign-up","click", function() { popupView(660,350,$(this).attr("href")); return false });
	$("body").delegate(".ajax-edit","click", function() { popupView(360,330,$(this).attr("href")); return false }); 
	$("body").delegate(".ajax-myimages","click", function() { 
		popupView(798,554,$(this).attr("href"), function(){
			$("#sortables").sortable({
			   update: function(event, ui) { 
				update_folder_order();
				},
				axis: 'y' 
			  }).addTouch();
		} ); 
		return false 
	});
	
	$("body").delegate("li.preview a","click",function() { quickPreview(740,540,$(this).attr("href"),"ajaxloadpage"); return false })
	$("body").delegate(".ajax-withdraw","click", function() { popupView(380,310,$(this).attr("href")); return false });
	$("body").delegate(".ajax-edit-order","click", function() { popupView(620,340,$(this).attr("href")); return false });
	$.preloadCssImages();
});

$(window).load(function() {
	mainImageChange(0);
})