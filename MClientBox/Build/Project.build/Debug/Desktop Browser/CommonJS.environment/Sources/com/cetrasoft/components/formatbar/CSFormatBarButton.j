@STATIC;1.0;I;21;Foundation/CPObject.jt;3526;objj_executeFile("Foundation/CPObject.j", NO);
CSFormatBarButtonNoLeftMask = 1;
CSFormatBarButtonNoRightMask = 2;
{var the_class = objj_allocateClassPair(CPButton, "CSFormatBarButton"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $CSFormatBarButton__initWithFrame_(self, _cmd, rect)
{ with(self)
{
}
},["id","CGRect*"]), new objj_method(sel_getUid("initWithFrame:styleMask:"), function $CSFormatBarButton__initWithFrame_styleMask_(self, _cmd, rect, styleMask)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSFormatBarButton").super_class }, "initWithFrame:", rect)) {
  var bezelLeft = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButton0.png", CGSizeMake(3,18));
   var bezelCenter = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButton1.png", CGSizeMake(3,18));
  var bezelRight = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButton2.png", CGSizeMake(3,18));
  var bezelHighlightedLeft = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButtonHighlighted0.png", CGSizeMake(3,18));
   var bezelHighlightedCenter = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButtonHighlighted1.png", CGSizeMake(3,18));
   var bezelHighlightedRight = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButtonHighlighted2.png", CGSizeMake(3,18));
  if(styleMask == (CSFormatBarButtonNoLeftMask)) {
    bezelLeft = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButtonDivider.png", CGSizeMake(1,18));
    bezelHighlightedLeft = bezelLeft;
  }
  else if(styleMask == (CSFormatBarButtonNoRightMask)) {
   bezelRight = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButtonDivider.png", CGSizeMake(1,18));
   bezelHighlightedRight = bezelRight;
  }
  else if(styleMask == (CSFormatBarButtonNoLeftMask | CSFormatBarButtonNoRightMask)) {
   bezelLeft = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButtonDivider.png", CGSizeMake(1,18));
   bezelRight = bezelLeft;
   bezelHighlightedLeft = bezelLeft;
   bezelHighlightedRight = bezelLeft;
  }
   var bezelColor = objj_msgSend(CPColor, "colorWithPatternImage:", objj_msgSend(objj_msgSend(CPThreePartImage, "alloc"), "initWithImageSlices:isVertical:", [bezelLeft, bezelCenter, bezelRight], NO));
   var highlightedBezelColor = objj_msgSend(CPColor, "colorWithPatternImage:", objj_msgSend(objj_msgSend(CPThreePartImage, "alloc"), "initWithImageSlices:isVertical:", 
    [
     bezelHighlightedLeft,
     bezelHighlightedCenter,
     bezelHighlightedRight
    ], NO));
        objj_msgSend(self, "setValue:forThemeAttribute:inState:", bezelColor, "bezel-color", CPThemeStateBordered);
        objj_msgSend(self, "setValue:forThemeAttribute:inState:", highlightedBezelColor, "bezel-color", CPThemeStateBordered|CPThemeStateHighlighted);
        objj_msgSend(self, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 7.0), "content-inset", CPThemeStateBordered);
 }
 return self;
}
},["id","CGRect*","int"])]);
}

