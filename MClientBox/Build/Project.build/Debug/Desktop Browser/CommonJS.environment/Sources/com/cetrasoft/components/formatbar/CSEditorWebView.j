@STATIC;1.0;I;21;Foundation/CPObject.jt;940;objj_executeFile("Foundation/CPObject.j", NO);
{var the_class = objj_allocateClassPair(CPWebView, "CSEditorWebView"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $CSEditorWebView__initWithFrame_(self, _cmd, rect)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSEditorWebView").super_class }, "initWithFrame:", rect)) {
  objj_msgSend(self, "loadHTMLString:", "");
  objj_msgSend(self, "setFrameLoadDelegate:", self);
 }
 return self;
}
},["id","CGRect*"]), new objj_method(sel_getUid("webView:didFinishLoadForFrame:"), function $CSEditorWebView__webView_didFinishLoadForFrame_(self, _cmd, aWebView, aFrame)
{ with(self)
{
 CPLog.debug("webView: " + aWebView + " didFinishLoadForFrame: " + aFrame);
 objj_msgSend(self, "DOMWindow").document.designMode = "On";
}
},["void","CPWebView","id"])]);
}

