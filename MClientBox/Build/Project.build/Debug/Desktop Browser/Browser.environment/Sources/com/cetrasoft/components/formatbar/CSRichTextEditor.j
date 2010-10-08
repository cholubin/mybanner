@STATIC;1.0;I;21;Foundation/CPObject.ji;13;CSFormatBar.ji;17;CSEditorWebView.jt;1002;objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("CSFormatBar.j", YES);
objj_executeFile("CSEditorWebView.j", YES);
{var the_class = objj_allocateClassPair(CPView, "CSRichTextEditor"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $CSRichTextEditor__initWithFrame_(self, _cmd, rect)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSRichTextEditor").super_class }, "initWithFrame:", rect)) {
  var richTextEditorWebView = objj_msgSend(objj_msgSend(CSEditorWebView, "alloc"), "initWithFrame:", CGRectMake(0, 26, CGRectGetWidth(rect), CGRectGetHeight(rect) - 26));
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBar, "alloc"), "initWithFrame:editor:", CGRectMake(0, 0, CGRectGetWidth(rect), 26), richTextEditorWebView));
  objj_msgSend(self, "addSubview:", richTextEditorWebView);
 }
 return self;
}
},["id","CGRect*"])]);
}

