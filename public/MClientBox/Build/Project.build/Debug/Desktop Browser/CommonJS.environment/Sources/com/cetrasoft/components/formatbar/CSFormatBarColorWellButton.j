@STATIC;1.0;I;21;Foundation/CPObject.ji;19;CSFormatBarButton.jt;1388;objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("CSFormatBarButton.j", YES);
{var the_class = objj_allocateClassPair(CSFormatBarButton, "CSFormatBarColorWellButton"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("colorWell")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $CSFormatBarColorWellButton__initWithFrame_(self, _cmd, rect)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSFormatBarColorWellButton").super_class }, "initWithFrame:styleMask:", rect, nil)) {
  var limg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButton0.png", CGSizeMake(3,18));
   var mimg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButton1.png", CGSizeMake(3,18));
   var rimg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/popup-bezel-right.png", CGSizeMake(10,18));
  var w = CGRectGetWidth(rect);
  colorWell = objj_msgSend(objj_msgSend(CPColorWell, "alloc"), "initWithFrame:", CGRectMake(0,0,w,17));
  objj_msgSend(colorWell, "setColor:", objj_msgSend(CPColor, "blackColor"));
  objj_msgSend(self, "addSubview:", colorWell);
 }
 return self;
}
},["id","CGRect*"])]);
}

