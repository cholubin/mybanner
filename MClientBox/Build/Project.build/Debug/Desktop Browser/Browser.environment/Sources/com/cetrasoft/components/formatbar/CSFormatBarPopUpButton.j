@STATIC;1.0;I;21;Foundation/CPObject.jt;2391;objj_executeFile("Foundation/CPObject.j", NO);
{var the_class = objj_allocateClassPair(CPPopUpButton, "CSFormatBarPopUpButton"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:pullsDown:"), function $CSFormatBarPopUpButton__initWithFrame_pullsDown_(self, _cmd, rect, pulls)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSFormatBarPopUpButton").super_class }, "initWithFrame:pullsDown:", rect, pulls)) {
  var limg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButton0.png", CGSizeMake(3,18));
   var mimg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarButton1.png", CGSizeMake(3,18));
   var rimg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/popup-bezel-right.png", CGSizeMake(10,18));
  var color = objj_msgSend(CPColor, "colorWithPatternImage:", objj_msgSend(objj_msgSend(CPThreePartImage, "alloc"), "initWithImageSlices:isVertical:", [limg, mimg, rimg], NO));
        objj_msgSend(self, "setValue:forThemeAttribute:inState:", color, "bezel-color", CPThemeStateBordered);
        objj_msgSend(self, "setValue:forThemeAttribute:", objj_msgSend(CPFont, "systemFontOfSize:", 11.0), "font");
        objj_msgSend(self, "setValue:forThemeAttribute:", objj_msgSend(CPColor, "blackColor"), "text-color");
     objj_msgSend(self, "setValue:forThemeAttribute:", objj_msgSend(CPColor, "clearColor"), "text-shadow-color");
 }
 return self;
}
},["id","CGRect*",null]), new objj_method(sel_getUid("fontMenuItems"), function $CSFormatBarPopUpButton__fontMenuItems(self, _cmd)
{ with(self)
{
 var fontMenuItems = objj_msgSend(CPArray, "array");
 var availableFonts = objj_msgSend(objj_msgSend(CPFontManager, "sharedFontManager"), "availableFonts");
 for(var i = 0; i < objj_msgSend(availableFonts, "count"); i++) {
  var font = objj_msgSend(availableFonts, "objectAtIndex:", i);
  var menuItem = objj_msgSend(objj_msgSend(CPMenuItem, "alloc"), "initWithTitle:action:keyEquivalent:", font, nil, nil);
  objj_msgSend(menuItem, "setFont:", objj_msgSend(CPFont, "fontWithName:size:", font, 11.0));
  objj_msgSend(fontMenuItems, "addObject:", menuItem);
 }
 return fontMenuItems;
}
},["CPArray"])]);
}

