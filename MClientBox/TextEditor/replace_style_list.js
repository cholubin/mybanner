var temp_path = document.location.search; // template path
var slen = temp_path.length;
var temp_web_path = temp_path.substr(1, slen-1) + "/web/"; // template web path
var js_path = temp_web_path + "style_list.js";
var iframe_css_path = temp_web_path + "style_list.css";  // for jquery.wymeditor.js
//var style_loader = '<script type="text/javascript" src="'+js_path+'"></script>';
document.write('<script type="text/javascript" src="'+js_path+'"></script>\n');
document.write('<script type="text/javascript" src="'+'../wymeditor/jquery.wymeditor.js'+'"></script>\n');
//var mydiv = document.getElementById("style_container");
//mydiv.innerHTML = style_loader;
