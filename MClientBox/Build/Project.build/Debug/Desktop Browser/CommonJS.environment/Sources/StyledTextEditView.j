@STATIC;1.0;I;15;AppKit/CPView.ji;52;com/cetrasoft/components/formatbar/CSEditorWebView.jt;15568;


objj_executeFile("AppKit/CPView.j", NO);
objj_executeFile("com/cetrasoft/components/formatbar/CSEditorWebView.j", YES);






debugger;

{var the_class = objj_allocateClassPair(CPObject, "StyleInfo"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mStyleName"), new objj_ivar("mFontSize"), new objj_ivar("mTextRed"), new objj_ivar("mTextGreen"), new objj_ivar("mTextBlue")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithString:"), function $StyleInfo__initWithString_(self, _cmd, styleInfoStr)
{ with(self)
{
 debugger;
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("StyleInfo").super_class }, "init");
 if(self) {
  var lFieldList = objj_msgSend(styleInfoStr, "componentsSeparatedByString:", ",");
  var i, icnt = objj_msgSend(lFieldList, "count");
  if(icnt !== 5) {
   objj_msgSend(self, "release");
   return nil;
  }
  mStyleName = objj_msgSend(objj_msgSend(lFieldList, "objectAtIndex:", 0), "retain");
  mFontSize = objj_msgSend(objj_msgSend(lFieldList, "objectAtIndex:", 1), "intValue");
  mTextRed = objj_msgSend(objj_msgSend(lFieldList, "objectAtIndex:", 2), "intValue");
  mTextGreen = objj_msgSend(objj_msgSend(lFieldList, "objectAtIndex:", 3), "intValue");
  mTextBlue = objj_msgSend(objj_msgSend(lFieldList, "objectAtIndex:", 4), "intValue");
 }
 return self;
}
},["id","CPString"]), new objj_method(sel_getUid("styleName"), function $StyleInfo__styleName(self, _cmd)
{ with(self)
{
 return mStyleName;
}
},["CPString"]), new objj_method(sel_getUid("fontSize"), function $StyleInfo__fontSize(self, _cmd)
{ with(self)
{
 return mFontSize;
}
},["int"]), new objj_method(sel_getUid("textRed"), function $StyleInfo__textRed(self, _cmd)
{ with(self)
{
 return mTextRed;
}
},["int"]), new objj_method(sel_getUid("textGreen"), function $StyleInfo__textGreen(self, _cmd)
{ with(self)
{
 return mTextGreen;
}
},["int"]), new objj_method(sel_getUid("textBlue"), function $StyleInfo__textBlue(self, _cmd)
{ with(self)
{
 return mTextBlue;
}
},["int"])]);
}
{var the_class = objj_allocateClassPair(CPView, "AddStyledItemView"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mAddButton"), new objj_ivar("mEditView")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $AddStyledItemView__initWithFrame_(self, _cmd, aRect)
{ with(self)
{
  debugger;
   if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("AddStyledItemView").super_class }, "initWithFrame:", aRect))
    {
  var lAddBtnRect = CPRectMake(5, 5, 24, 24);
  mAddButton = objj_msgSend(objj_msgSend(CPButton, "alloc"), "initWithFrame:", lAddBtnRect);
  objj_msgSend(mAddButton, "setTitle:", "+");
  objj_msgSend(self, "addSubview:", mAddButton);
     objj_msgSend(mAddButton, "setAction:", sel_getUid("addItem:"));
     objj_msgSend(mAddButton, "setTarget:", self);
 }
 return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("addItem:"), function $AddStyledItemView__addItem_(self, _cmd, sender)
{ with(self)
{
 objj_msgSend(mEditView, "addNewAddItemView:", self);
}
},["void","id"]), new objj_method(sel_getUid("setEditView:"), function $AddStyledItemView__setEditView_(self, _cmd, aEditView)
{ with(self)
{
 mEditView = aEditView;
}
},["void","StyledTextEditView"])]);
}





{var the_class = objj_allocateClassPair(CPView, "StyledTextItemView"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mAddButton"), new objj_ivar("mDeleteButton"), new objj_ivar("mStyleSelectPopup"), new objj_ivar("mTextEditView"), new objj_ivar("mEditView")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $StyledTextItemView__initWithFrame_(self, _cmd, aRect)
{ with(self)
{
  debugger;
   if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("StyledTextItemView").super_class }, "initWithFrame:", aRect))
    {
  var lSelfBounds = objj_msgSend(self, "bounds");
  var lPopupRect = CPRectMake(CPRectGetMaxX(lSelfBounds)-(100 +5), 5, 100, 24);
        mStyleSelectPopup = objj_msgSend(objj_msgSend(CPPopUpButton, "alloc"), "initWithFrame:", lPopupRect);
  objj_msgSend(self, "addSubview:", mStyleSelectPopup);
    objj_msgSend(mStyleSelectPopup, "setAction:", sel_getUid("changeStyle:"));
     objj_msgSend(mStyleSelectPopup, "setTarget:", self);

  var lAddBtnRect = CPRectMake(5, 5, 24, 24);
  mAddButton = objj_msgSend(objj_msgSend(CPButton, "alloc"), "initWithFrame:", lAddBtnRect);
  objj_msgSend(mAddButton, "setTitle:", "+");
  objj_msgSend(self, "addSubview:", mAddButton);
     objj_msgSend(mAddButton, "setAction:", sel_getUid("insertItemView:"));
     objj_msgSend(mAddButton, "setTarget:", self);

  var lDeleteBtnRect = CPRectMake(8+24, 5, 24, 24);;
  mDeleteButton = objj_msgSend(objj_msgSend(CPButton, "alloc"), "initWithFrame:", lDeleteBtnRect);
  objj_msgSend(mDeleteButton, "setTitle:", "-");
  objj_msgSend(self, "addSubview:", mDeleteButton);
      objj_msgSend(mDeleteButton, "setAction:", sel_getUid("deleteSelf:"));
     objj_msgSend(mDeleteButton, "setTarget:", self);

  var lEditViewRect = CPRectMake(5, 10+24, CPRectGetMaxX(lSelfBounds)-10, CPRectGetMaxY(lSelfBounds)-(15+24));
  mTextEditView = objj_msgSend(objj_msgSend(CSEditorWebView, "alloc"), "initWithFrame:", lEditViewRect);
    objj_msgSend(mTextEditView, "setAutoresizesSubviews:", YES);
  objj_msgSend(mTextEditView, "setAutoresizingMask:", CPViewWidthSizable | CPViewHeightSizable );
  objj_msgSend(self, "addSubview:", mTextEditView);
    }
    return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("textEditView"), function $StyledTextItemView__textEditView(self, _cmd)
{ with(self)
{
 return mTextEditView;
}
},["id"]), new objj_method(sel_getUid("styleSelectPopup"), function $StyledTextItemView__styleSelectPopup(self, _cmd)
{ with(self)
{
 return mStyleSelectPopup;
}
},["id"]), new objj_method(sel_getUid("insertItemView:"), function $StyledTextItemView__insertItemView_(self, _cmd, sender)
{ with(self)
{
 objj_msgSend(mEditView, "insertNewItemViewBefore:", self);
}
},["void","id"]), new objj_method(sel_getUid("deleteSelf:"), function $StyledTextItemView__deleteSelf_(self, _cmd, sender)
{ with(self)
{
 objj_msgSend(mEditView, "deleteItemView:", self);
}
},["void","id"]), new objj_method(sel_getUid("changeStyle:"), function $StyledTextItemView__changeStyle_(self, _cmd, sender)
{ with(self)
{

}
},["void","id"]), new objj_method(sel_getUid("setEditView:"), function $StyledTextItemView__setEditView_(self, _cmd, aEditView)
{ with(self)
{
 mEditView = aEditView;
}
},["void","StyledTextEditView"])]);
}





{var the_class = objj_allocateClassPair(CPScrollView, "StyledTextEditView"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mItemViewList"), new objj_ivar("mStyleInfoList"), new objj_ivar("mAddStyleItemView")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $StyledTextEditView__initWithFrame_(self, _cmd, aRect)
{ with(self)
{
   debugger;
  if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("StyledTextEditView").super_class }, "initWithFrame:", aRect))
    {
  var lSelfbounds = objj_msgSend(self, "bounds");
        var lDocview = objj_msgSend(objj_msgSend(CPView, "alloc"), "initWithFrame:", lSelfbounds);
  objj_msgSend(self, "setDocumentView:", lDocview);
  mStyleInfoList = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
  mItemViewList = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
  var lAddItemFrame = CPRectMake(0, 0, 300, (24 + 10));
  mAddStyleItemView = objj_msgSend(objj_msgSend(AddStyledItemView, "alloc"), "initWithFrame:", lAddItemFrame);
  objj_msgSend(mAddStyleItemView, "setEditView:", self);


  objj_msgSend(self, "addItemView:", mAddStyleItemView);
   objj_msgSend(lDocview, "release");
   }
    return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("itemViewList"), function $StyledTextEditView__itemViewList(self, _cmd)
{ with(self)
{
 return mItemViewList
}
},["CPArray"]), new objj_method(sel_getUid("clearStyleInfoList"), function $StyledTextEditView__clearStyleInfoList(self, _cmd)
{ with(self)
{
 objj_msgSend(mStyleInfoList, "removeAllObjects");
}
},["void"]), new objj_method(sel_getUid("addStyleInfo:"), function $StyledTextEditView__addStyleInfo_(self, _cmd, styleInfo)
{ with(self)
{
 objj_msgSend(mStyleInfoList, "addObject:", styleInfo);
}
},["void","StyleInfo"]), new objj_method(sel_getUid("__layoutSubviews"), function $StyledTextEditView____layoutSubviews(self, _cmd)
{ with(self)
{
   debugger;

 var i, icnt = objj_msgSend(mItemViewList, "count");
 var lYPos = 0, lMaxX = 0;
 for(i=0;i<icnt;i++){
  var lView = objj_msgSend(mItemViewList, "objectAtIndex:", i);
  var lViewFrame = objj_msgSend(lView, "frame");
  lViewFrame.origin.y = lYPos;
  lViewFrame.origin.x = 0;
  if(lViewFrame.size.width > lMaxX) {
   lMaxX = lViewFrame.size.width;
  }
  objj_msgSend(lView, "setFrame:", lViewFrame);
  lYPos += lViewFrame.size.height;
 }
 var lSelfFrame = CPRectMake(0, 0, lMaxX, lYPos);
 objj_msgSend(objj_msgSend(self, "documentView"), "setFrame:", lSelfFrame);

}
},["void"]), new objj_method(sel_getUid("_relayoutSubviews"), function $StyledTextEditView___relayoutSubviews(self, _cmd)
{ with(self)
{
  debugger;

 var i, icnt = objj_msgSend(mItemViewList, "count");
 var lYPos = 0, lMaxX = 300;
 for(i=0;i<icnt;i++){
  var lView = objj_msgSend(mItemViewList, "objectAtIndex:", i);
  var lViewFrame = objj_msgSend(lView, "frame");



  lYPos += lViewFrame.size.height;
 }
 if(mAddStyleItemView) {
  var lAddItemFrame = CPRectMake(0, lYPos, lMaxX, (24 + 10));
  lYPos += lAddItemFrame.size.height;
 }
 var lSelfFrame = CPRectMake(0, 0, lMaxX, lYPos);
 objj_msgSend(objj_msgSend(self, "documentView"), "setFrame:", lSelfFrame);

 lYPos = 0;
 lMaxX = 300;
 for(i=0;i<icnt;i++){
  var lView = objj_msgSend(mItemViewList, "objectAtIndex:", i);
  var lViewFrame = objj_msgSend(lView, "frame");
  lViewFrame.origin.y = lYPos;
  lViewFrame.origin.x = 0;
  lViewFrame.size.width = lMaxX;



  objj_msgSend(lView, "setFrame:", lViewFrame);

  lYPos += lViewFrame.size.height;
 }
 if(mAddStyleItemView) {
  var lAddItemFrame = CPRectMake(0, lYPos, lMaxX, (24 + 10));
  objj_msgSend(mAddStyleItemView, "setFrame:", lAddItemFrame);
 }


}
},["void"]), new objj_method(sel_getUid("addItemView:"), function $StyledTextEditView__addItemView_(self, _cmd, aItemView)
{ with(self)
{
 debugger;
 objj_msgSend(aItemView, "setAutoresizingMask:", CPViewWidthSizable | CPViewMaxYMargin);
 objj_msgSend(aItemView, "setBackgroundColor:", objj_msgSend(CPColor, "lightGrayColor"));
 objj_msgSend(aItemView, "setEditView:", self);
 objj_msgSend(objj_msgSend(self, "documentView"), "addSubview:", aItemView);
}
},["void","id"]), new objj_method(sel_getUid("addStyledTextItemViewAsSubview:"), function $StyledTextEditView__addStyledTextItemViewAsSubview_(self, _cmd, aItemView)
{ with(self)
{
 debugger;
 var lStylePopupBtn = objj_msgSend(aItemView, "styleSelectPopup");
 objj_msgSend(lStylePopupBtn, "removeAllItems");
 var j, jcnt = objj_msgSend(mStyleInfoList, "count");
 for(j=0;j<jcnt;j++) {
  var aStyleName = objj_msgSend(objj_msgSend(mStyleInfoList, "objectAtIndex:", j), "styleName");
  objj_msgSend(lStylePopupBtn, "addItemWithTitle:", aStyleName);
 }
 objj_msgSend(self, "addItemView:", aItemView);
}
},["void","StyledTextItemView"]), new objj_method(sel_getUid("removeAllItemViews"), function $StyledTextEditView__removeAllItemViews(self, _cmd)
{ with(self)
{
 debugger;
 var i, icnt = objj_msgSend(mItemViewList, "count");
 for(i=0;i<icnt;i++) {
  var lView = objj_msgSend(mItemViewList, "objectAtIndex:", i);
  objj_msgSend(lView, "removeFromSuperview");
 }
 objj_msgSend(mItemViewList, "removeAllObjects");
}
},["void"]), new objj_method(sel_getUid("insertNewItemViewBefore:"), function $StyledTextEditView__insertNewItemViewBefore_(self, _cmd, aItemView)
{ with(self)
{
  debugger;
 var lItemViewFrame = CPRectMake(0, 0, 300, 100);
 var lStyledTextItemView = objj_msgSend(objj_msgSend(StyledTextItemView, "alloc"), "initWithFrame:", lItemViewFrame);
 objj_msgSend(self, "addStyledTextItemViewAsSubview:", lStyledTextItemView);
 var idx = objj_msgSend(mItemViewList, "indexOfObject:", aItemView);
 objj_msgSend(mItemViewList, "insertObject:atIndex:", lStyledTextItemView, idx);
 objj_msgSend(self, "_relayoutSubviews");
}
},["void","StyledTextItemView"]), new objj_method(sel_getUid("addNewAddItemView:"), function $StyledTextEditView__addNewAddItemView_(self, _cmd, sender)
{ with(self)
{
 debugger;
  var lItemViewFrame = CPRectMake(0, 0, 300, 100);
 var lStyledTextItemView = objj_msgSend(objj_msgSend(StyledTextItemView, "alloc"), "initWithFrame:", lItemViewFrame);
 objj_msgSend(self, "addStyledTextItemViewAsSubview:", lStyledTextItemView);
 objj_msgSend(mItemViewList, "addObject:", lStyledTextItemView);
 objj_msgSend(self, "_relayoutSubviews");
}
},["void","id"]), new objj_method(sel_getUid("deleteItemView:"), function $StyledTextEditView__deleteItemView_(self, _cmd, aItemView)
{ with(self)
{
 debugger;
 objj_msgSend(aItemView, "removeFromSuperview");
 objj_msgSend(mItemViewList, "removeObject:", aItemView)
 objj_msgSend(self, "_relayoutSubviews");
}
},["void","StyledTextItemView"]), new objj_method(sel_getUid("toHTMLString:"), function $StyledTextEditView__toHTMLString_(self, _cmd, serverString)
{ with(self)
{
 debugger;
 var lHTMLText = "";
  var j, jcnt = objj_msgSend(serverString, "length");
 for(j=0;j<jcnt;j++) {
  var ch = objj_msgSend(serverString, "characterAtIndex:", j);
  if(ch === '\n') {

   ch = "<br>";
  }
  lHTMLText += ch;
 }

 return lHTMLText;
}
},["CPString","CPString"]), new objj_method(sel_getUid("loadXMLString:"), function $StyledTextEditView__loadXMLString_(self, _cmd, aStyledStr)
{ with(self)
{
 debugger;
 gParaLevel = 0;
 objj_msgSend(self, "removeAllItemViews");
 var lParaSepStr = objj_msgSend(CPString, "stringWithFormat:", "__PS%d__", gParaLevel);
 var lParaList = objj_msgSend(aStyledStr, "componentsSeparatedByString:", lParaSepStr);
 var i, icnt = objj_msgSend(lParaList, "count");
 for(i=0;i<icnt;i++) {
  var lParaStr = objj_msgSend(lParaList, "objectAtIndex:", i);
  var lParaRec = objj_msgSend(lParaStr, "componentsSeparatedByString:", "__FS__");
  var lStyleName = objj_msgSend(lParaRec, "objectAtIndex:", 0);
  var lContentText = objj_msgSend(lParaRec, "objectAtIndex:", 1);
  var lItemViewFrame = CPRectMake(0, 0, 300, 100);
  var lStyledTextItemView = objj_msgSend(objj_msgSend(StyledTextItemView, "alloc"), "initWithFrame:", lItemViewFrame);
  objj_msgSend(self, "addStyledTextItemViewAsSubview:", lStyledTextItemView);
  objj_msgSend(mItemViewList, "addObject:", lStyledTextItemView);
  lContentText = objj_msgSend(self, "toHTMLString:", lContentText);
  var lTextEditView = objj_msgSend(lStyledTextItemView, "textEditView");
  var lHTMLText = "<html><head></head><body>"+lContentText+"</body></html>";

  objj_msgSend(lTextEditView, "loadHTMLString:", lHTMLText);
  var textframe = objj_msgSend(lTextEditView, "frame");


  objj_msgSend(lStyledTextItemView, "release");

  var lStylePopupBtn = objj_msgSend(lStyledTextItemView, "styleSelectPopup");
  objj_msgSend(lStylePopupBtn, "selectItemWithTitle:", lStyleName);
 }
 objj_msgSend(self, "_relayoutSubviews");
}
},["void","CPString"])]);
}

{var the_class = objj_allocateClassPair(CPObject, "StyledTextEditController"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
}

