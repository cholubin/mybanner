
@import <AppKit/CPView.j>
 @import "com/cetrasoft/components/formatbar/CSEditorWebView.j"
      
var STYLE_POPUP_WIDTH =	100;
var STYLE_POPUP_HEIGHT = 24;
var DEF_ITEM_VIEW_WIDTH	= 300;
var DEF_ITEM_VIEW_HEIGHT = 100;
var DEF_ADD_ITEM_HEIGHT = (STYLE_POPUP_HEIGHT + 10);
var selfbounds;
var lFrameDocument;
var gContent = nil;

function frameDidLoad()
{
	if(!gContent)
		return;
	lFrameDocument.body.style.cssText = "margin:0;height:"+selfbounds.size.height+"px;";
	var lFrames = lFrameDocument.all.tags('iframe');
	var lFrame = lFrames[0];
	if(!lFrame) {
		window.setTimeout('frameDidLoad()',0.5);
		return;
	}
	if(lFrame.contentDocument.body) {
		lFrame.contentDocument.body.innerHTML = ""; 
		lFrame.contentDocument.body.innerHTML = gContent; 
		[gContent release];
		gContent = nil;
	}
	else {
		window.setTimeout('frameDidLoad()',0.5);
		return;
	}
	
}


@implementation StyleInfo : CPObject
{
	CPString mStyleName;
	int mFontSize;
	int mTextRed;
	int mTextGreen;
	int mTextBlue;
}

- (id)initWithString:(CPString)styleInfoStr
{
	self = [super init];
	if(self) {
		var lFieldList = [styleInfoStr componentsSeparatedByString:@","];
		var i, icnt = [lFieldList count];
		if(icnt !== 5) {
			[self release];
			return nil;
		}
		mStyleName = 	[[lFieldList objectAtIndex:0] retain];
		mFontSize = 	[[lFieldList objectAtIndex:1] intValue];
		mTextRed = 		[[lFieldList objectAtIndex:2] intValue];
		mTextGreen = 	[[lFieldList objectAtIndex:3] intValue];
		mTextBlue = 	[[lFieldList objectAtIndex:4] intValue];
	}
	return self;
}

- (CPString)styleName
{
	return mStyleName;
}

- (int)fontSize
{
	return mFontSize;
}

- (int)textRed
{
	return mTextRed;
}

- (int)textGreen
{
	return mTextGreen;
}

- (int)textBlue
{
	return mTextBlue;
}
@end

/* 																						 
			StyledTextEditView

*/
@implementation StyledTextEditView : CPWebView
{
	EditController mEditController;
	CPString mContent;
	CPArray mStyleInfoList;
	CPDictionary mClassNameDict;
	CPDictionary mStyleNameDict;
}

- (id)initWithFrame:(CGRect)aRect
{
  	if (self = [super initWithFrame:aRect])
    {
		[self setFrameLoadDelegate:self];
		mStyleInfoList = [[CPArray alloc] init];
		mClassNameDict = [[CPDictionary alloc] init];
		mStyleNameDict = [[CPDictionary alloc] init];
   	}
    return self;
}

- (void)dealloc
{
	[mStyleInfoList release];
	[mClassNameDict release];
	[mStyleNameDict release];
	[super dealloc];
}
- (void)clearStyleInfoList
{
	[mStyleInfoList removeAllObjects];
	[mClassNameDict removeAllObjects]
	[mStyleNameDict removeAllObjects]
}

- (void)addStyleInfo:(StyleInfo)styleInfo
{
	var lClassName = "para"+[mStyleInfoList count];
	[mStyleInfoList addObject:styleInfo];
	[mClassNameDict setObject:lClassName forKey:[styleInfo styleName]];
	[mStyleNameDict setObject:[styleInfo styleName] forKey:lClassName];
}

- (void)setController:(EditController)aController
{
	mEditController = aController;
}

var gParaLevel = 0;

- (CPString)HTMLStringFromCString:(CPString)serverString className:(CPString)styleName
{
	var lHTMLText = @"<p class=\""+styleName+"\">";
 	var j, jcnt = [serverString length];
	var ch = "";
	for(j=0;j<jcnt;j++) {
		ch = [serverString characterAtIndex:j];
		if(ch === '\n') {
			if(j < jcnt -1)
				ch = "</p><p class=\""+styleName+"\">";
			else
				ch = "</p>"
		}
		lHTMLText += ch;
	}
	if(ch != "</p>")
		lHTMLText += @"</p>";
	return lHTMLText;
}



- (CPString)htmlStringFrom:(CPString)aStyledStr
{
	gParaLevel = 0;
	var lRetStr = "";
	var lParaSepStr = [CPString stringWithFormat:@"__PS%d__", gParaLevel]; // gParaLevel: for future enhancement
	var lParaList = [aStyledStr componentsSeparatedByString:lParaSepStr];
	var i, icnt = [lParaList count];
	for(i=0;i<icnt;i++) {
		var lParaStr = [lParaList objectAtIndex:i];
		var lParaRec = [lParaStr componentsSeparatedByString:@"__FS__"];  // Field Separator
		var lStyleName = [lParaRec objectAtIndex:0];
		var lClassName = [mClassNameDict objectForKey:lStyleName];
		var lContentText = [lParaRec objectAtIndex:1];
		lContentText = [self HTMLStringFromCString:lContentText className:lClassName];
		lRetStr += lContentText;
	}
	return lRetStr;
}


- (void)webView:(CPWebView)aWebView didFinishLoadForFrame:(id)aFrame 
{

//	var lFrameDocument = aFrame.document;
	var selfdomwin = [self DOMWindow];
	selfbounds = [self bounds];
	lFrameDocument = selfdomwin.document;
	// var lDivs = lFrameDocument.all.tags('div'); //class('wym_box wym_box_0 wym_skin_default');
	// var i=0;
	// for(;i<lDivs.length;i++) {
	// 	var aDiv = lDivs[i];
	// 	if(aDiv.className == "wym_box wym_box_0 wym_skin_default") {
	// 		//aDiv.style.cssText = "height:"+selfbounds.size.height+"px";
	// 		aDiv.clientHeight = selfbounds.size.height;
	// 		break;
	// 	}
	// }
	debugger;
	lFrameDocument.body.style.cssText = "margin:0;height:"+selfbounds.size.height+"px;";
	var lFrames = lFrameDocument.all.tags('iframe');
	var lFrame = lFrames[0];
	if(!lFrame && !gContent) {
		gContent = [[CPString alloc] initWithString:mContent];
		window.setTimeout('frameDidLoad()',0.5);
		return;
	}
//	lFrame.height = selfbounds.size.height; // "100%";
//	lFrameDocument.height = selfbounds.size.height;	
	if(lFrame.contentDocument.body) {
		gContent = [[CPString alloc] initWithString:mContent];
		lFrame.contentDocument.body.innerHTML = ""; 
		lFrame.contentDocument.body.innerHTML = gContent; 
		[gContent release];
		gContent = nil;
	}
	else {
		gContent = [[CPString alloc] initWithString:mContent];
		window.setTimeout('frameDidLoad()',0.5);
		return;
	}
	// "<p>Text From Cappucinno.</p><p>Hello Charlie!<p>";
//	alert("webView:(CPWebView)aWebView didFinishLoadForFrame");
	// var lForm = lFrameDocument.getElementById("form_1");
	// if(lForm) {
	// 	lForm.textarea_1.innerHTML = "<p>Text From Cappucinno.</p><p>Hello Charlie!<p>";
	// 	alert("innerHTML = "+lForm.textarea_1.innerText);
	// }
}

- (CPString)htmlContentString
{
	var lFrameDocument = [self DOMWindow].document;
	var lFrames = lFrameDocument.all.tags('iframe');
	var lFrame = lFrames[0];
	if(!lFrame.contentDocument.body) {
		alert("lFrame.contentDocument.body is nil in htmlContentString");
	}
	var lContentHTMLStr = lFrame.contentDocument.body.innerHTML;
	return lContentHTMLStr;
}

- (CPString)serverString
{
	//var lServerString = [self htmlContentString];
	var lRetStr = "";
	var lFrameDocument = [self DOMWindow].document;
	var lFrames = lFrameDocument.all.tags('iframe');
	var lFrame = lFrames[0];
	
	if(!lFrame.contentDocument.body) {
		alert("lFrame.contentDocument.body is nil in serverString");
	}
	var ptags = lFrame.contentDocument.body.children; // lFrame.contentDocument.body.all.tags('p');
	var i, icnt = ptags.length;
	for(i=0;i<icnt;i++) {
		var p_node = ptags[i];
		var lInnerText = [mEditController parsebleStringFrom:p_node.innerText];
		var lStyleName = [mStyleNameDict objectForKey:p_node.className];
		var lParaStr = lStyleName + "__FS__" + lInnerText;
		if (lRetStr.length > 0) {
			lRetStr += "__PS0__";
		}
		lRetStr += lParaStr;
	}
	return lRetStr;
}

- (void)loadXMLString:(CPString)aStyledStr
{
	mContent = [self htmlStringFrom:aStyledStr];
//	[self DOMWindow].document.location = null;
	[self DOMWindow].document.body.height = [self bounds].size.height;
	var lDocPath = [[[CPApplication sharedApplication] delegate] localDocPath];
	var lStyleListPath ="../.." + gUserPath + lDocPath; 
	[self DOMWindow].document.location = "";
	[self DOMWindow].document.location = "TextEditor/01-basic.html?"+lStyleListPath;
	
//	alert("loadXMLString:(CPString)aStyledStr");
//	[self DOMWindow].document.form_1.textarea_1.innerText = "<p>Text From Cappucinno.</p><p>Hello Charlie!<p>";
	
	// var lFrameDocument = [self DOMWindow].document;
	// var lForm = lFrameDocument.getElementById("form_1");
	// lForm.textarea_1.innerText = "<p>Text From Cappucinno.</p><p>Hello Charlie!<p>";
}

- (void)_loadXMLString:(CPString)aStyledStr
{
	var lHTMLText = "";
	lHTMLText += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
	lHTMLText += '<html>';
	lHTMLText += '<head>';
	lHTMLText += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
	lHTMLText += '<title>WYMeditor</title>\n';
	lHTMLText += '<script type="text/javascript" src="jquery/jquery.js"></script>\n';
	lHTMLText += '<script type="text/javascript" src="wymeditor/jquery.wymeditor.min.js"></script>\n';
	lHTMLText += '<script type="text/javascript">\n';
	lHTMLText += 'jQuery(function() {\n';
//	lHTMLText += 'debugger;\n';
	lHTMLText += "	    jQuery('.wymeditor').wymeditor();\n";
	lHTMLText += '});\n';
	lHTMLText += '</script>\n';
	lHTMLText += '</head>';
	lHTMLText += '<body style="margin:0" height=400>';
	lHTMLText += '<form>';
	lHTMLText += '<textarea class="wymeditor">&lt;p&gt;Hello, World!!!!&lt;/p&gt;&lt;p&gt;Another World!&lt;/p&gt;</textarea>';
	lHTMLText += '</form>';
	lHTMLText += '</body>';
	lHTMLText += '</html>';
//	var _baseurl = [[CPURL alloc] initWithString:"file:///Volumes/Work/cappuccino/MClientBox/TextEditor"];
//	var _url = [[CPURL alloc] initWithString:"01-basic.html" relativeToURL:_baseurl];
//	var _url = "file:///Volumes/Work/cappuccino/MClientBox/TextEditor/";
//	[self loadHTMLString:lHTMLText];
//	var _doc = [self DOMWindow].document;
//	alert("location = "+_doc.location);
//	_doc.URL = "file:///Volumes/Work/cappuccino/MClientBox/TextEditor/";
	[self loadHTMLString:lHTMLText];
	
	//var _contentDoc = _doc.contentDocument;
	//_contentDoc.innerHTML = lHTMLText;
//	[self loadHTMLString:lHTMLText baseURL:_baseurl];
}

// - (void)loadXMLString:(CPString)aStyledStr
// {
// 	var lHTMLText = @"<html><head></head>";
// 	lHTMLText += @"<body onKeyDown=KeyDown()>";
// 	lHTMLText += "<script type=\"text/javascript\">";
// 	lHTMLText += @"<p>";
//  	var j, jcnt = [aStyledStr length];
// 	for(j=0;j<jcnt;j++) {
// 		var ch = [aStyledStr characterAtIndex:j];
// 		if(ch === '\n') {
// 			ch = "</p><p>";
// 		}
// 		lHTMLText += ch;
// 	}
// 	lHTMLText += @"</p>";
// 	lHTMLText += @"</body></html>";
// 	
// 	[self loadHTMLString:lHTMLText];
// 	
// }
@end
