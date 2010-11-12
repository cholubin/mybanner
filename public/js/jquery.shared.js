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
			.css({"width": "100%","min-width":"960px", "height": $(document).height()})
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
		popupStatus = Array("view",popWidth,popHeight)
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop();
		if(startY < 20) startY = 20;
		$("#popup-closeButton").css({"top":startY+10,"left":startX+popWidth-62})
		$("#popup-view")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight})
		.load(url+" #ajaxloadpage",post,function(responseText, textStatus, XMLHttpRequest) { $(this).fadeIn("fast");$("#popup-closeButton").live("click",function(){popupView()}).fadeIn("fast"); if(typeof(callback) == "function") callback(responseText, textStatus, XMLHttpRequest);})
	} else if(popupStatus[0] == "view" && url) {
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
	} else if(popupStatus[0] == "view" && !url) {
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

function openWebTopHelper() {
	if($("#webtop_helper").length == 0) {
		$("<iframe id='webtop_helper' border='0' frameborder='0'>")
		.css({"diplay":"block","background":"white","border":"1px solid #555","position":"absolute","top":$(window).height()/2,"left":$(window).width()/2})
		.hide()
		.appendTo("#webTopEditor")
	}
	if($("#webtop_helper").css("display") == "none")
		$("#webtop_helper").attr("src","about:blank").css({"width":0,"height":0,"top":$(window).height()/2,"left":$(window).width()/2}).show().animate({"top":($(window).height()/2)-185,"left":($(window).width()/2)-215, "width":430, "height":291},function() { $("#webtop_helper").attr("src","/webtop_helper/") });
	else
		alert("이미 사용방법이 화면에 표시중입니다.")
}

function openWebTopEditor_user(user,id,href) {
	if($("#webTopEditor").length == 0) {
		$("<div id=\"webTopEditor\"><div id=\"editor_header\"><h2>WebTop Editor</h2><a href=\"#\" id=\"back_to_home\">저장하고 홈페이지로 돌아가기.</a></div></div>")
		.css({"display":"none","background-color": "White" ,"position": "absolute","width":"100%", "z-index":"150","overflow":"hidden","top":"0","left":"0"})
		.mousedown(function(){$(document).mousemove(function(e){return false;});})
		.bind("contextmenu",function(e) { return false })
		.appendTo('body');
	}

	$("<iframe id=\"webtop_iframe\" width=\"100%\" border=\"0\" frameborder=\"0\"/>")
	.css({"display":"block","border":"0","height":$(window).height()-75})
	.appendTo("#webTopEditor");
	$("<div id=\"editor_footer\"><img src=\"/images/editor/footer.png\" width=\"960\" height=\"34\"/></div>")
	.appendTo("#webTopEditor");
	$("<a href='#'></a>").css({"display":"block","position":"absolute","width":"145px","height":"21px","top":"10px","left":"180px"}).click(function() { openWebTopHelper(); }).appendTo("#webTopEditor");;
	$("#webTopEditor").css({"display":"block","height":$(window).height()});
	$("#back_to_home").attr("href",(href == null)?"/":href)
	
	// 리사이즈시 사이즈시 자동으로 사이즈 변경	

	$(window).resize(function() {
		$("#webTopEditor").css("height",$(window).height());
		$("#webtop_iframe").css("height",$(window).height()-75);
	})
	
	var url = "/MClientBox/index.html?pdf_button=no&spread_list=NO&user_path=/user_files/"+user+"&doc_path=/article_templates/"+ id +".mlayoutP"	
	$("#webtop_iframe").attr("src",url);
	$("#webtop_iframe").load(function(){
		if(getCookie("hide-tutorial") == "false" || getCookie("hide-tutorial") == "") openWebTopHelper();
	})
	$("body").css("background","#63828c");
	$("#header").remove();
	$("#content").remove();
	$("#footer").remove();

}

function openWebTopEditor(user,id,href) {
	$("body *").remove();
	$("body").css({"margin":"0","padding":"0"})
	if($("#webTopEditor").length == 0) {
		$("<div id=\"webTopEditor\"><div id=\"editor_header\"><h2>WebTop Editor</h2><a href=\"#\" id=\"back_to_home\">저장하고 홈페이지로 돌아가기.</a></div></div>")
		.css({"display":"none","background-color": "White" ,"position": "absolute","width":"100%", "z-index":"150","overflow":"hidden","top":"0","left":"0"})
		.mousedown(function(){$(document).mousemove(function(e){return false;});})
		.bind("contextmenu",function(e) { return false })
		.appendTo('body');
	}

	$("<iframe id=\"webtop_iframe\" width=\"100%\" border=\"0\" frameborder=\"0\"/>")
	.css({"display":"block","border":"0","height":$(window).height()-75})
	.appendTo("#webTopEditor");
	$("<div id=\"editor_footer\"><img src=\"/images/editor/footer.png\" width=\"960\" height=\"34\"/></div>")
	.appendTo("#webTopEditor");
	$("<a href='#'></a>").css({"display":"block","position":"absolute","width":"145px","height":"21px","top":"10px","left":"180px"}).click(function() { openWebTopHelper(); }).appendTo("#webTopEditor");;
	$("#webTopEditor").css({"display":"block","height":$(window).height()});
	$("#back_to_home").attr("href",(href == null)?"/":href)
	
	// 리사이즈시 사이즈시 자동으로 사이즈 변경	
	$(window).resize(function() {
		$("#webTopEditor").css("height",$(window).height());
		$("#webtop_iframe").css("height",$(window).height()-75);
	})
	
	var url = "/MClientBox/index.html?admin=yes&spread_list=NO&user_path=/user_files/"+user+"&doc_path=/article_templates/"+ id +".mlayoutP"	
	$("#webtop_iframe").attr("src",url);
	$("#webtop_iframe").load(function(){
		if(getCookie("hide-tutorial") == "false" || getCookie("hide-tutorial") == "") openWebTopHelper();
	})
	$("body").css("background","#63828c");

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
		quickViewStatus = Array("view",popWidth,popHeight);
		startX = ($(document).width()/2)-(popWidth/2);
		startY = ($(window).height()/2)-(popHeight/2)+$(document).scrollTop();
		if(startY < 20) startY = 20;
		$("#quick_preview_closeButton").css({"top":startY+10,"left":startX+popWidth-62})
		$("#quick_preview_bg")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight});
		$("#quick_preview")
		.css({"top": startY, "left": startX, "width":popWidth, "height":popHeight})
		
		if(typeof(url) == "string") {
			$("#quick_preview").load(url+" #"+content_id, function(responseText, textStatus, XMLHttpRequest) {
				$("#loading-icon").fadeOut();
				$("#quick_preview_bg").fadeTo("fast","0.80",function() { 
					$("#modal-bg").click(function() { quickPreview() } );
					$("#quick_preview").fadeIn("fast");
				});
				$("#quick_preview_closeButton").live("click",function(){
					quickPreview()
				}).fadeIn("fast");
			})
		} else if(url[0] == "image") {
			$("#loading-icon").fadeOut();
			$("#quick_preview_bg").fadeTo("fast","0.80",function() {
				$("#modal-bg").click(function() { quickPreview() } );
				$("#quick_preview")
					.html("<img src='"+url[1]+"'/ width='"+url[2]+"' height='"+url[3]+"'>")
					.css({"display":"block","padding":"20px","-ms-interpolation-mode":"bicubic"})
					.bind("contextmenu",function(e) { return false })
					.hide().fadeIn("fast");
			})
			$("#quick_preview_closeButton").live("click",function(){
				quickPreview()
			}).fadeIn("fast");			
		}
	} else if(quickViewStatus[0] == "view"){
		quickViewStatus = null;
		loadingView();
		$("#modal-bg").click(function() {return false});
		$("#quick_preview").fadeOut("fast",function() { $("#quick_preview_bg").fadeOut("fast"); $("#quick_preview_closeButton").fadeOut("fast"); });
	}
	
}

function repositionViews() {
	if(loadingStatus != null) {
		startX = ($(document).width()/2)-(91/2);
		startY = ($(window).height()/2)-(120/2)+$(document).scrollTop();
		$("#loading-icon").css({"top":startY,"left":startX})
	}
	if(popupStatus != null) {
		startX = ($(document).width()/2)-(popupStatus[1]/2);
		startY = ($(window).height()/2)-(popupStatus[2]/2)+$(document).scrollTop();
		if(startY < 20) startY = 20;
		
		$("#popup-closeButton").css({"top":startY+10,"left":startX+popupStatus[1]-62})
		$("#popup-view").css({"top": startY, "left": startX})
	}
	if(quickViewStatus != null) {
		startX = ($(document).width()/2)-(quickViewStatus[1]/2);
		startY = ($(window).height()/2)-(quickViewStatus[2]/2)+$(document).scrollTop();
		if(startY < 20) startY = 20;
		
		$("#quick_preview_closeButton").css({"top":startY+10,"left":startX+quickViewStatus[1]-62})
		$("#quick_preview_bg").css({"top": startY, "left": startX});
		$("#quick_preview").css({"top": startY, "left": startX})	
	}
}

// 임시 퍼포먼스용 CSS바꾸기

function skin(change) {
	now_skin = getCookie("skin");
	
	if(!now_skin) {
		setCookie("skin","cloud","1");
	} else if(change == true) {
		switch(now_skin) {
			case "modern":
				$("#site_logo img").attr({"src":"/images/skin.cloud/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.cloud.css");
				setCookie("skin","cloud","1");
			break;
			case "cloud":
				$("#site_logo img").attr({"src":"/images/skin.grace/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.grace.css");
				setCookie("skin","grace","1");
			break;
			case "grace":
				$("#site_logo img").attr({"src":"/images/skin.purplenight/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.purplenight.css");
				setCookie("skin","purplenight","1");
			break;
			case "purplenight":
				$("#site_logo img").attr({"src":"/images/skin.modern/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.modern.css");
				setCookie("skin","modern","1");
			break;
		}
	} else {
		switch(now_skin) {
			case "cloud":
				$("#site_logo img").attr({"src":"/images/skin.cloud/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.cloud.css");
			break;
			case "grace":
				$("#site_logo img").attr({"src":"/images/skin.grace/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.grace.css");
			break;
			case "purplenight":
				$("#site_logo img").attr({"src":"/images/skin.purplenight/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.purplenight.css");
			break;
			case "modern":
				$("#site_logo img").attr({"src":"/images/skin.modern/default_logo.png"})
				$("#skin_css").attr("href","/css/skin.modern.css");
			break;
		}
	}
}
$(function () {
	// 메인 페이지 이미지 교체 액션
	$("#main-button li:eq(0)").click(function() { mainImageChange(0) });
	$("#main-button li:eq(1)").click(function() { mainImageChange(1) });
	$("#main-button li:eq(2)").click(function() { mainImageChange(2) });
	$("body").delegate(".ajax-sign-in","click", function() { popupView(250,390,$(this).attr("href")); return false });
	$("body").delegate(".ajax-sign-up","click", function() {
		popupView(660,350,$(this).attr("href"),function() {
			$("#signup_tos_title").click(function() {
				if(!$("#signup_tos_content #tos_content").length)
					$("#signup_tos_content").load("/pages/tos #tos_content");
				$("#signup_tos_content").toggle(); 
				if($("#signup_tos_content").css("display") != "none")
					$(this).css("background-position","left bottom")
				else
					$(this).css("background-position","left top")
			})
			$("#signup_policy_title").click(function() {
				if(!$("#signup_policy_content #tos_content").length)
					$("#signup_policy_content").load("/pages/tos #tos_content");
				$("#signup_policy_content").toggle(); 
				if($("#signup_policy_content").css("display") != "none")
					$(this).css("background-position","left bottom")
				else
					$(this).css("background-position","left top")
			})
		}
	);return false});
	$("body").delegate(".ajax-edit","click", function() { popupView(360,330,$(this).attr("href")); return false }); 
	$("body").delegate(".ajax-myimages","click", function() { popupView(798,554,$(this).attr("href")); return false }); // 차후 김현수 과장과 합칠때 확인 할것!
	$("body").delegate("li.preview a","click",function() { quickPreview(740,540,$(this).attr("href"),"ajaxloadpage"); return false })
	$("body").delegate(".ajax-withdraw","click", function() { popupView(380,310,$(this).attr("href")); return false });
	$("body").delegate(".ajax-edit-order","click", function() { popupView(620,340,$(this).attr("href")); return false });
	$(".tempskin").click(function() { skin(1) });
	skin();
	$.preloadCssImages();
	$.localScroll();
});

$(window).load(function() {
	mainImageChange(0);
})
$(window).resize(function() { repositionViews() })
$(window).scroll(function() { repositionViews() })
