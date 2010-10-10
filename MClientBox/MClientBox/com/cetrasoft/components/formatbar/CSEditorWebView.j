/*
 * CSEditorWebView.j
 * CSRichTextEditor
 *
 * A view that represents our iframe.
 *
 * Created by Ryan Jafari on ?.
 * Cetrasoft Inc.
 */
 
@import <Foundation/CPObject.j>


function finishedText()
{
	alert("finished text...");
}
function onfocusout()
{
	alert("onfocusout text...");
}

@implementation CSEditorWebView : CPWebView { }

- (id)initWithFrame:(CGRect*)rect {

	if(self = [super initWithFrame:rect]) {
			
		// Content editable sets that specific element to be the focus of editing.
		[self loadHTMLString:@""];
		
		[self setFrameLoadDelegate:self];
	}

	return self;
}

// FIXME: Not guaranteed that the frame has finished loading.
// See: http://groups.google.com/group/objectivej/browse_thread/thread/772eba10a9fc177d/5d2631318246f4f3?lnk=gst&q=CPWebView#5d2631318246f4f3
// for detais.
- (void)webView:(CPWebView)aWebView didFinishLoadForFrame:(id)aFrame { 

	CPLog.debug("webView: " + aWebView + " didFinishLoadForFrame: " + aFrame);
	[self DOMWindow].document.designMode = "On";
//	[self DOMWindow].ondeactivate = "finishedText()";
	
	[self DOMWindow].document.onfocusout = "onfocusout()";
} 

@end