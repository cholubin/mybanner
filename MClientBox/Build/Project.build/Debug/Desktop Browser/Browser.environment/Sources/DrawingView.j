@STATIC;1.0;I;21;Foundation/CPObject.ji;23;ImagePickerController.ji;20;StyledTextEditView.ji;52;com/cetrasoft/components/formatbar/CSEditorWebView.ji;14;ImageTrimmer.ji;16;ProgressWindow.jt;39659;

objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("ImagePickerController.j", YES);
objj_executeFile("StyledTextEditView.j", YES);
objj_executeFile("com/cetrasoft/components/formatbar/CSEditorWebView.j", YES);
objj_executeFile("ImageTrimmer.j", YES);
objj_executeFile("ProgressWindow.j", YES);


gKnobWidth = 10;
gKnobHeight = 10;

gKnobPostionLeftTop = 1;
gKnobPostionTop = 2;
gKnobPostionRightTop = 3;
gKnobPostionRight = 4;
gKnobPostionRightBottom = 5;
gKnobPostionBottom = 6;
gKnobPostionLeftBottom = 7;
gKnobPostionLeft = 8;


{var the_class = objj_allocateClassPair(CPObject, "Knob"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mKnobRect"), new objj_ivar("mGFrame"), new objj_ivar("position")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithRect:gFrame:position:"), function $Knob__initWithRect_gFrame_position_(self, _cmd, aRect, aGFrame, pos)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("Knob").super_class }, "init");
 if(self) {
  mKnobRect = aRect;
  mGFrame = aGFrame;
  position = pos;
 }
 return self;
}
},["id","CGRect","GraphicFrame","int"]), new objj_method(sel_getUid("rect"), function $Knob__rect(self, _cmd)
{ with(self)
{
 return mKnobRect;
}
},["CGRect"]), new objj_method(sel_getUid("graphicFrame"), function $Knob__graphicFrame(self, _cmd)
{ with(self)
{
 return mGFrame;
}
},["GraphicFrame"]), new objj_method(sel_getUid("position"), function $Knob__position(self, _cmd)
{ with(self)
{
 return position;
}
},["int"])]);
}


{var the_class = objj_allocateClassPair(CPObject, "GraphicFrame"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mRect"), new objj_ivar("mGID"), new objj_ivar("mKnobList")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithRect:gid:"), function $GraphicFrame__initWithRect_gid_(self, _cmd, aRect, aGID)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("GraphicFrame").super_class }, "init");
 if(self) {
  mRect = aRect;
  mGID = aGID;
   mKnobList = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init")
 }
 return self;
}
},["id","CGRect","var"]), new objj_method(sel_getUid("rect"), function $GraphicFrame__rect(self, _cmd)
{ with(self)
{
 return mRect;
}
},["CGRect"]), new objj_method(sel_getUid("GID"), function $GraphicFrame__GID(self, _cmd)
{ with(self)
{
 return mGID;
}
},["var"]), new objj_method(sel_getUid("isEventInFrame:view:"), function $GraphicFrame__isEventInFrame_view_(self, _cmd, anEvent, aView)
{ with(self)
{
 var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
 var lWin = objj_msgSend(aView, "window");

 var lPtInView = objj_msgSend(aView, "convertPoint:fromView:", lPtInWindow, nil);
 var lScaledRect = objj_msgSend(aView, "scaledRectFrom:", mRect);
 return CPRectContainsPoint(lScaledRect, lPtInView);
}
},["BOOL","CPEvent","CPView"]), new objj_method(sel_getUid("setOrigin:"), function $GraphicFrame__setOrigin_(self, _cmd, point)
{ with(self)
{
 mRect.origin = point;
}
},["void","CPPoint"]), new objj_method(sel_getUid("drawKnobsOnView:"), function $GraphicFrame__drawKnobsOnView_(self, _cmd, aView)
{ with(self)
{
 var lScaledRect = objj_msgSend(aView, "scaledRectFrom:", mRect);
 var lOutRect = CPRectInset(lScaledRect, -3, -3);
 objj_msgSend(objj_msgSend(CPColor, "darkGrayColor"), "set");

 objj_msgSend(mKnobList, "removeAllObjects");
 var knobRect = CPRectMake(lOutRect.origin.x, lOutRect.origin.y, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionLeftTop);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");

 knobRect = CPRectMake(lOutRect.origin.x+(lOutRect.size.width-gKnobWidth)/2.0, lOutRect.origin.y, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionTop);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");

 knobRect = CPRectMake(CPRectGetMaxX(lOutRect)-gKnobWidth, lOutRect.origin.y, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionRightTop);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");

 knobRect = CPRectMake(CPRectGetMaxX(lOutRect)-gKnobWidth, lOutRect.origin.y+(lOutRect.size.height-gKnobHeight)/2.0, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionRight);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");

 knobRect = CPRectMake(CPRectGetMaxX(lOutRect)-gKnobWidth, CPRectGetMaxY(lOutRect)-gKnobHeight, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionRightBottom);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");

 knobRect = CPRectMake(lOutRect.origin.x+(lOutRect.size.width-gKnobWidth)/2.0, CPRectGetMaxY(lOutRect)-gKnobHeight, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionBottom);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");

 knobRect = CPRectMake(lOutRect.origin.x, CPRectGetMaxY(lOutRect)-gKnobHeight, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionLeftBottom);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");

 knobRect = CPRectMake(lOutRect.origin.x, lOutRect.origin.y+(lOutRect.size.height-gKnobHeight)/2.0, gKnobWidth,gKnobHeight);
 objj_msgSend(CPBezierPath, "fillRect:", knobRect);
 var lKnobObj = objj_msgSend(objj_msgSend(Knob, "alloc"), "initWithRect:gFrame:position:", knobRect, self, gKnobPostionLeft);
 objj_msgSend(mKnobList, "addObject:", lKnobObj);
 objj_msgSend(lKnobObj, "release");


}
},["void","CPView"]), new objj_method(sel_getUid("knobMouseIn:inView:"), function $GraphicFrame__knobMouseIn_inView_(self, _cmd, anEvent, aView)
{ with(self)
{
 var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");


 var lPtInView = objj_msgSend(aView, "convertPoint:fromView:", lPtInWindow, nil);
 var i = 0;
 for(;i<objj_msgSend(mKnobList, "count");i++) {
  var lKnob = objj_msgSend(mKnobList, "objectAtIndex:", i);
  var lKnobRect = objj_msgSend(lKnob, "rect");
  if(CPRectContainsPoint(lKnobRect, lPtInView)) {
   return lKnob;
  }
 }
 return nil;
}
},["Knob","CPEvent","CPView"])]);
}


{var the_class = objj_allocateClassPair(CPObject, "EditController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mInspectorWin"), new objj_ivar("mSelectPopupBtn"), new objj_ivar("mInspectorViewContainer"), new objj_ivar("mImageInspectorView"), new objj_ivar("mImageImageView"), new objj_ivar("mImagePicker"), new objj_ivar("mTextInspectorView"), new objj_ivar("mXMLInspectorView"), new objj_ivar("mArticleInspectorView"), new objj_ivar("mGetContentsCon"), new objj_ivar("mSetContentsCon"), new objj_ivar("mDocumentName"), new objj_ivar("mAppController"), new objj_ivar("mGID"), new objj_ivar("mOrgImagePath"), new objj_ivar("mImagePath"), new objj_ivar("mIsVisible"), new objj_ivar("mTextContent")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("dealloc"), function $EditController__dealloc(self, _cmd)
{ with(self)
{
 if(mImagePath)
  objj_msgSend(mImagePath, "release");
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("EditController").super_class }, "dealloc");
}
},["void"]), new objj_method(sel_getUid("awakeFromCib"), function $EditController__awakeFromCib(self, _cmd)
{ with(self)
{
 objj_msgSend(mSelectPopupBtn, "removeAllItems");
 objj_msgSend(mSelectPopupBtn, "addItemWithTitle:", "Text");
 objj_msgSend(mSelectPopupBtn, "addItemWithTitle:", "Image");
 objj_msgSend(mSelectPopupBtn, "selectItemAtIndex:", 0);

 var lFrame = CPRectInset(objj_msgSend(mTextInspectorView, "frame"), 3, 3);
 var lAutoMask = objj_msgSend(mTextInspectorView, "autoresizingMask");
 var lSView = objj_msgSend(mTextInspectorView, "superview");

 objj_msgSend(mTextInspectorView, "removeFromSuperview");
 mTextInspectorView = objj_msgSend(objj_msgSend(CSEditorWebView, "alloc"), "initWithFrame:", lFrame);
  objj_msgSend(mTextInspectorView, "setAutoresizesSubviews:", YES);
 objj_msgSend(mTextInspectorView, "setAutoresizingMask:", CPViewWidthSizable | CPViewHeightSizable );
 objj_msgSend(lSView, "addSubview:", mTextInspectorView);
   objj_msgSend(lSView, "setAutoresizesSubviews:", YES);







 mArticleInspectorView = mTextInspectorView;

 objj_msgSend(self, "changeInspector:", mSelectPopupBtn);
 objj_msgSend(mTextInspectorView, "retain");
 var newImageViewFrame = objj_msgSend(mImageImageView, "frame");
 objj_msgSend(mImageImageView, "removeFromSuperview");
 mImageImageView = objj_msgSend(objj_msgSend(ImageTrimmer, "alloc"), "initWithFrame:", newImageViewFrame);
 objj_msgSend(mImageImageView, "setAutoresizingMask:", CPViewWidthSizable | CPViewHeightSizable );
 objj_msgSend(mImageInspectorView, "addSubview:", mImageImageView);
 objj_msgSend(mImageInspectorView, "retain");
 mIsVisible = NO;
 objj_msgSend(mInspectorWin, "setAcceptsMouseMovedEvents:", YES);
 objj_msgSend(mInspectorWin, "setDelegate:", self);
}
},["void"]), new objj_method(sel_getUid("windowWillClose:"), function $EditController__windowWillClose_(self, _cmd, aWin)
{ with(self)
{
  if(aWin == mInspectorWin) {
  mIsVisible = NO;
  }
 }
},["void","id"]), new objj_method(sel_getUid("setDocumentName:"), function $EditController__setDocumentName_(self, _cmd, aString)
{ with(self)
{
 mDocumentName = aString;
}
},["void","CPString"]), new objj_method(sel_getUid("setImagePath:"), function $EditController__setImagePath_(self, _cmd, aImagePath)
{ with(self)
{
 if(mImagePath)
  objj_msgSend(mImagePath, "release");
 mImagePath = objj_msgSend(aImagePath, "retain");
}
},["void","CPString"]), new objj_method(sel_getUid("isWindowVisible"), function $EditController__isWindowVisible(self, _cmd)
{ with(self)
{
 return mIsVisible;
}
},["BOOL"]), new objj_method(sel_getUid("styledTextEditView"), function $EditController__styledTextEditView(self, _cmd)
{ with(self)
{
 return mXMLInspectorView;
}
},["id"]), new objj_method(sel_getUid("setNewImage:"), function $EditController__setNewImage_(self, _cmd, anImage)
{ with(self)
{
 var boxSize = objj_msgSend(mImageImageView, "serverBoxSize");
 var imgSize = objj_msgSend(anImage, "size");
 var imgFrame = CPRectMake(0, 0, 0, 0);
 debugger;
 if(boxSize.width / imgSize.width > boxSize.height / imgSize.height) {
  imgFrame.size.width = boxSize.width;
  imgFrame.size.height = imgSize.height * boxSize.width / imgSize.width;
 }
 else {
  imgFrame.size.width = imgSize.width * boxSize.height / imgSize.height;
  imgFrame.size.height = boxSize.height;
 }
 imgFrame.origin.x = (boxSize.width - imgFrame.size.width) / 2.0;
 imgFrame.origin.y = (boxSize.height - imgFrame.size.height) / 2.0;
 objj_msgSend(mImageImageView, "setServerBoxImageFrame:", imgFrame);
 objj_msgSend(mImageImageView, "setImage:", anImage);
}
},["void","CPImage"]), new objj_method(sel_getUid("setImagePathToImageView:"), function $EditController__setImagePathToImageView_(self, _cmd, aImagePath)
{ with(self)
{
 objj_msgSend(self, "setImagePath:", aImagePath);
 var lExtLen = objj_msgSend(objj_msgSend(mImagePath, "pathExtension"), "length");
 var lImgPathNoExt = objj_msgSend(mImagePath, "substringToIndex:", objj_msgSend(mImagePath, "length")-lExtLen-1);
 var lImgName = objj_msgSend(lImgPathNoExt, "lastPathComponent");
 var lOrgPath = objj_msgSend(lImgPathNoExt, "stringByDeletingLastPathComponent");
 var lPreviewPath = gBaseURL + lOrgPath + "/Preview/"+lImgName+".jpg";
 var lImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lPreviewPath);
 objj_msgSend(mImageImageView, "setImage:", lImage);
 objj_msgSend(lImage, "release");
}
},["void","CPString"]), new objj_method(sel_getUid("setNewImagePathToImageView:"), function $EditController__setNewImagePathToImageView_(self, _cmd, aImagePath)
{ with(self)
{
 objj_msgSend(self, "setImagePath:", aImagePath);
 var lExtLen = objj_msgSend(objj_msgSend(mImagePath, "pathExtension"), "length");
 var lImgPathNoExt = objj_msgSend(mImagePath, "substringToIndex:", objj_msgSend(mImagePath, "length")-lExtLen-1);
 var lImgName = objj_msgSend(lImgPathNoExt, "lastPathComponent");
 var lOrgPath = objj_msgSend(lImgPathNoExt, "stringByDeletingLastPathComponent");
 var lPreviewPath = gBaseURL + lOrgPath + "/Preview/"+lImgName+".jpg";
 var lImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lPreviewPath);
 if(lImage) {
   objj_msgSend(lImage, "setDelegate:", self);
     if(objj_msgSend(lImage, "loadStatus") == CPImageLoadStatusCompleted) {
   objj_msgSend(self, "setNewImage:", lImage);
  }
 }
 objj_msgSend(lImage, "release");
}
},["void","CPString"]), new objj_method(sel_getUid("imageDidLoad:"), function $EditController__imageDidLoad_(self, _cmd, anImage)
{ with(self)
{
 objj_msgSend(self, "setNewImage:", anImage);
}
},["void","CPImage"]), new objj_method(sel_getUid("selectImage:"), function $EditController__selectImage_(self, _cmd, sender)
{ with(self)
{
 if(!mImagePicker) {
  mImagePicker = objj_msgSend(objj_msgSend(ImagePickerController, "alloc"), "init");
 }
 objj_msgSend(mImagePicker, "runModalForReceiver:", self);

}
},["@action","id"]), new objj_method(sel_getUid("setAppController:"), function $EditController__setAppController_(self, _cmd, aController)
{ with(self)
{
 mAppController = aController;
}
},["void","id"]), new objj_method(sel_getUid("stringFromHTML:"), function $EditController__stringFromHTML_(self, _cmd, htmlStr)
{ with(self)
{
 var retstr = "";
 var paralist = objj_msgSend(htmlStr, "componentsSeparatedByString:", "</p>");
 var i, icnt = objj_msgSend(paralist, "count");
 for(i=0;i<icnt;i++) {
  var pstr = objj_msgSend(paralist, "objectAtIndex:", i);
  var strlist = objj_msgSend(pstr, "componentsSeparatedByString:", "<p>");
  pstr = objj_msgSend(strlist, "componentsJoinedByString:", "");
  retstr += pstr + "\n";
 }
 return retstr;
}
},["CPString","CPSTring"]), new objj_method(sel_getUid("sendJSONRequest:data:"), function $EditController__sendJSONRequest_data_(self, _cmd, command, datastr)
{ with(self)
{
    var lDocOpenURL = objj_msgSend(CPString, "stringWithFormat:", "%@/post_mlayout",gBaseURL);
   var JSONString = '{"requested_action":"'+command+'","docname":"'+mDocumentName+'","userinfo":"'+datastr+'"}';

    var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocOpenURL);
 objj_msgSend(lRequest, "setHTTPMethod:", "POST");
 objj_msgSend(lRequest, "setHTTPBody:", JSONString);
 objj_msgSend(lRequest, "setValue:forHTTPHeaderField:", "application/json", "Accept") ;
 objj_msgSend(lRequest, "setValue:forHTTPHeaderField:", "application/json", "Content-Type") ;

    var lConnection = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
 return lConnection;
}
},["CPURLConnection","CPString","CPString"]), new objj_method(sel_getUid("sendJSONRequestAndRefresh:data:"), function $EditController__sendJSONRequestAndRefresh_data_(self, _cmd, command, datastr)
{ with(self)
{
 mSetContentsCon = objj_msgSend(self, "sendJSONRequest:data:", command, datastr);
}
},["void","CPString","CPString"]), new objj_method(sel_getUid("applyInspector:"), function $EditController__applyInspector_(self, _cmd, sender)
{ with(self)
{
 var str = "";
 if(mArticleInspectorView == mTextInspectorView) {
  var win = objj_msgSend(mTextInspectorView, "DOMWindow");
  if(win) {

    var lInnerText = win.document.body.innerText;
    str = "TEXT__FIELD_SEP__"+lInnerText;
  }
 }
 else if(mArticleInspectorView == mXMLInspectorView) {
  var lItemViewList = objj_msgSend(mXMLInspectorView, "itemViewList");
  var i, icnt = objj_msgSend(lItemViewList, "count");
  var lXMLStr = "";
  for(i=0;i<icnt;i++) {
   var lItemView = objj_msgSend(lItemViewList, "objectAtIndex:", i);
   var lItemStylePopup = objj_msgSend(lItemView, "styleSelectPopup");
   var lStyleName = objj_msgSend(lItemStylePopup, "titleOfSelectedItem");
   var lItemTextEditView = objj_msgSend(lItemView, "textEditView");
   var win = objj_msgSend(lItemTextEditView, "DOMWindow");
   if(win) {

    if(objj_msgSend(lXMLStr, "length"))
     lXMLStr = lXMLStr + "__PARA_SEP__";

    var lInnerText = win.document.body.innerText;
    var lServerText = "";
    var j, jcnt = objj_msgSend(lInnerText, "length");
    var charcnt = 0;
    for(j=0;j<jcnt;j++) {
     var ch = objj_msgSend(lInnerText, "characterAtIndex:", j);
     if(ch === '\n' && charcnt > 0) {
      ch = "\n\n";
      charcnt = 0;
     }
     else {
      charcnt++;
     }
     lServerText += ch;
    }

    lXMLStr += lStyleName+"__TAG_SEP__"+lServerText;
   }
  }
  str = "XML__FIELD_SEP__"+lXMLStr;
 }
 if(mImagePath) {
  var lImgRect = CPStringFromRect(objj_msgSend(mImageImageView, "orgImageFrame"));
  var lImgInfoStr = "Path__IMG_ATTR__"+mImagePath+"__ATTR_SEP__ImgRect__IMG_ATTR__"+lImgRect;
  if(objj_msgSend(str, "length"))
   str = str + "__TYPE_SEP__";
  str = str + "IMAGE2__FIELD_SEP__" + lImgInfoStr;

 }
 var datastr = mGID+"__GIDSEP__"+str;

 mSetContentsCon = objj_msgSend(self, "sendJSONRequest:data:", "SetContents", datastr);
 objj_msgSend(mInspectorWin, "orderOut:", self);
 mIsVisible = NO;
 objj_msgSend(objj_msgSend(ProgressWindow, "sharedWindow"), "show");
}
},["@action","id"]), new objj_method(sel_getUid("closeInspector:"), function $EditController__closeInspector_(self, _cmd, sender)
{ with(self)
{
 objj_msgSend(mInspectorWin, "orderOut:", self);
 mIsVisible = NO;
}
},["@action","id"]), new objj_method(sel_getUid("stringFromTextInspector"), function $EditController__stringFromTextInspector(self, _cmd)
{ with(self)
{
 var retstr = "";
 if(mArticleInspectorView == mTextInspectorView) {
  var win = objj_msgSend(mTextInspectorView, "DOMWindow");
  if(win) {

    retstr = win.document.body.innerHTML;
  }
 }
 return retstr;
}
},["CPString"]), new objj_method(sel_getUid("setTextContent:"), function $EditController__setTextContent_(self, _cmd, str)
{ with(self)
{
 if(mTextContent)
  objj_msgSend(mTextContent, "release");
 mTextContent = objj_msgSend(str, "retain");
}
},["void","CPString"]), new objj_method(sel_getUid("changeInspector:"), function $EditController__changeInspector_(self, _cmd, sender)
{ with(self)
{
 var idx = objj_msgSend(sender, "indexOfSelectedItem");
 if(objj_msgSend(mTextInspectorView, "superview"))
  objj_msgSend(mTextInspectorView, "removeFromSuperview");
 if(mXMLInspectorView && objj_msgSend(mXMLInspectorView, "superview"))
  objj_msgSend(mXMLInspectorView, "removeFromSuperview");
 if(objj_msgSend(mImageInspectorView, "superview"))
  objj_msgSend(mImageInspectorView, "removeFromSuperview");

 if(idx == 0) {
  var lFrame = CPRectInset(objj_msgSend(mInspectorViewContainer, "bounds"), 3, 3);
  objj_msgSend(mArticleInspectorView, "setFrame:", lFrame);
  objj_msgSend(mInspectorViewContainer, "addSubview:", mArticleInspectorView);
  if(mTextContent) {
   if(mArticleInspectorView === mTextInspectorView) {
    objj_msgSend(mTextInspectorView, "loadHTMLString:", mTextContent);
   }
   else if(mXMLInspectorView){
    objj_msgSend(mXMLInspectorView, "loadXMLString:", mTextContent);
   }
  }
 }
 else {
  var lStrFromInspector = objj_msgSend(self, "stringFromTextInspector");
  objj_msgSend(self, "setTextContent:", lStrFromInspector);
  objj_msgSend(mImageInspectorView, "setFrame:", objj_msgSend(mInspectorViewContainer, "bounds"));
  objj_msgSend(mInspectorViewContainer, "addSubview:", mImageInspectorView);
 }
}
},["@action","id"]), new objj_method(sel_getUid("drawingView:frameSelected:"), function $EditController__drawingView_frameSelected_(self, _cmd, aDrawingView, aFrame)
{ with(self)
{
    var lDocOpenURL = objj_msgSend(CPString, "stringWithFormat:", "%@/request_mlayout?requested_action=GetContentsJSON&docname=%@&userinfo=%d",gBaseURL ,mDocumentName,objj_msgSend(aFrame, "GID"));
    var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocOpenURL);
    mGetContentsCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
 mIsVisible = YES;
 objj_msgSend(mInspectorWin, "makeKeyAndOrderFront:", self);
 mGID = objj_msgSend(aFrame, "GID");

}
},["void","DrawingView","GraphicFrame"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $EditController__connection_didReceiveData_(self, _cmd, connection, data)
{ with(self)
{
    if (connection === mGetContentsCon)
    {
  var lTextViewChanged = NO;
  objj_msgSend(self, "setImagePath:", nil);
  if(mOrgImagePath)
   objj_msgSend(mOrgImagePath, "release");
  mOrgImagePath = nil;
  var hasImage = NO;
  var contentsDict = JSON.parse(data);
  var textContent = contentsDict["TEXT"];
  if(textContent) {
   var xmlContent = textContent["XML"];
   if(xmlContent) {
    if(mArticleInspectorView != mXMLInspectorView) {
     lTextViewChanged = YES;
     mArticleInspectorView = mXMLInspectorView;
    }
    objj_msgSend(self, "setTextContent:", xmlContent);
   }
   else {
    var plainContent = textContent["Plain"];
    if(plainContent) {
     var lHTMLText = "<p>";
      var j, jcnt = objj_msgSend(plainContent, "length");
     for(j=0;j<jcnt;j++) {
      var ch = objj_msgSend(plainContent, "characterAtIndex:", j);
      if(ch === '\n') {
       ch = "</p><p>";
      }
      lHTMLText += ch;
     }
     lHTMLText += "</p>";
     lHTMLText = "<html><head></head><body>"+lHTMLText+"</body></html>";
     if(mArticleInspectorView != mTextInspectorView) {
      lTextViewChanged = YES;
      mArticleInspectorView = mTextInspectorView;
     }
     objj_msgSend(self, "setTextContent:", lHTMLText);
    }
   }
  }
  var imgContentDict = contentsDict["IMAGE"];
  if(imgContentDict) {
   var lGraphicDict = contentsDict["Graphic"];
   var lBoxFrame = CGRectFromString(lGraphicDict["Frame"]);
   var lImageRect = CGRectFromString(imgContentDict["Frame"]);
   mOrgImagePath = imgContentDict["Path"];
   objj_msgSend(mImageImageView, "setServerBoxSize:", lBoxFrame.size);
   objj_msgSend(mImageImageView, "setServerBoxImageFrame:", lImageRect);
   objj_msgSend(self, "setImagePathToImageView:", mOrgImagePath);
   hasImage = YES;
  }

  if(hasImage && objj_msgSend(mSelectPopupBtn, "indexOfSelectedItem") != 1) {
   objj_msgSend(mSelectPopupBtn, "selectItemAtIndex:", 1);

  }
  else if(!hasImage) {
    if(objj_msgSend(mSelectPopupBtn, "indexOfSelectedItem") != 0){
    objj_msgSend(mSelectPopupBtn, "selectItemAtIndex:", 0);

   }
   else if(lTextViewChanged){

   }
  }
  objj_msgSend(self, "changeInspector:", mSelectPopupBtn);
  mIsVisible = YES;
   objj_msgSend(mInspectorWin, "makeKeyAndOrderFront:", self);
   }
 else if(connection === mSetContentsCon) {
  if(objj_msgSend(data, "isEqualToString:", "OK")) {

   objj_msgSend(mAppController, "refreshSpreadListView");
  }
  else {
   objj_msgSend(mAppController, "refreshSpreadListView");

  }
  objj_msgSend(objj_msgSend(ProgressWindow, "sharedWindow"), "hide");

 }
}
},["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("connection:didFailWithError:"), function $EditController__connection_didFailWithError_(self, _cmd, connection, error)
{ with(self)
{
    alert("Connection did fail with error : " + error) ;
}
},["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("connectionDidFinishLoading:"), function $EditController__connectionDidFinishLoading_(self, _cmd, aConnection)
{ with(self)
{

}
},["void","CPURLConnection"])]);
}






{var the_class = objj_allocateClassPair(CPView, "DrawingView"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mSpreadSize"), new objj_ivar("mFrameList"), new objj_ivar("mFocusedFrame"), new objj_ivar("mEditController"), new objj_ivar("mSelectedFrameList"), new objj_ivar("mPointInView"), new objj_ivar("mFrameGrabed"), new objj_ivar("mMouseMoved"), new objj_ivar("mKnobGrabed")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $DrawingView__initWithFrame_(self, _cmd, frame)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("DrawingView").super_class }, "initWithFrame:", frame);
 if(self) {
  mFrameList = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
  mSelectedFrameList = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
  selectedFrame = nil;
 }
 return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("clearFrameList"), function $DrawingView__clearFrameList(self, _cmd)
{ with(self)
{
 objj_msgSend(mFrameList, "removeAllObjects");
}
},["void"]), new objj_method(sel_getUid("addFrame:"), function $DrawingView__addFrame_(self, _cmd, anObject)
{ with(self)
{
 objj_msgSend(mFrameList, "addObject:", anObject);
}
},["void","id"]), new objj_method(sel_getUid("setSpreadSize:"), function $DrawingView__setSpreadSize_(self, _cmd, aSize)
{ with(self)
{
 mSpreadSize = aSize;
}
},["void","CPSize"]), new objj_method(sel_getUid("scaleFactor"), function $DrawingView__scaleFactor(self, _cmd)
{ with(self)
{
 var lViewBounds = objj_msgSend(self, "bounds");
 var rate;
 if(lViewBounds.size.width / mSpreadSize.width > lViewBounds.size.height / mSpreadSize.height) {
  rate = lViewBounds.size.height / mSpreadSize.height;
 }
 else {
  rate = lViewBounds.size.width / mSpreadSize.width;
 }
 return rate;
}
},["float"]), new objj_method(sel_getUid("scaledRectFrom:"), function $DrawingView__scaledRectFrom_(self, _cmd, orgFrame)
{ with(self)
{
 var lViewBounds = objj_msgSend(self, "bounds");
 var lSpreadFrame = CPMakeRect(0,0,0,0);
 var rate;
 if(lViewBounds.size.width / mSpreadSize.width > lViewBounds.size.height / mSpreadSize.height) {
  rate = lViewBounds.size.height / mSpreadSize.height;
  lSpreadFrame.size.height = lViewBounds.size.height;
  lSpreadFrame.size.width = mSpreadSize.width * rate;
 }
 else {
  rate = lViewBounds.size.width / mSpreadSize.width;
  lSpreadFrame.size.width = lViewBounds.size.width;
  lSpreadFrame.size.height = mSpreadSize.height * rate;
 }
 lSpreadFrame.origin.x = (lViewBounds.size.width - lSpreadFrame.size.width) / 2.0;
 lSpreadFrame.origin.y = (lViewBounds.size.height - lSpreadFrame.size.height) / 2.0;
 var retFrame = CPMakeRect(0,0,0,0);
 retFrame.origin.x = lSpreadFrame.origin.x + orgFrame.origin.x * rate;
 retFrame.origin.y = lSpreadFrame.origin.y + orgFrame.origin.y * rate;
 retFrame.size.width = orgFrame.size.width * rate;
 retFrame.size.height = orgFrame.size.height * rate;
 return retFrame;
}
},["CGRect","CGRect"]), new objj_method(sel_getUid("spreadFrame"), function $DrawingView__spreadFrame(self, _cmd)
{ with(self)
{
 var lViewBounds = objj_msgSend(self, "bounds");
 var lSpreadFrame = CPMakeRect(0,0,0,0);
 var rate;
 if(lViewBounds.size.width / mSpreadSize.width > lViewBounds.size.height / mSpreadSize.height) {
  rate = lViewBounds.size.height / mSpreadSize.height;
  lSpreadFrame.size.height = lViewBounds.size.height;
  lSpreadFrame.size.width = mSpreadSize.width * rate;
 }
 else {
  rate = lViewBounds.size.width / mSpreadSize.width;
  lSpreadFrame.size.width = lViewBounds.size.width;
  lSpreadFrame.size.height = mSpreadSize.height * rate;
 }
 lSpreadFrame.origin.x = (lViewBounds.size.width - lSpreadFrame.size.width) / 2.0;
 lSpreadFrame.origin.y = (lViewBounds.size.height - lSpreadFrame.size.height) / 2.0;
 return lSpreadFrame;
}
},["CGRect"]), new objj_method(sel_getUid("drawRect:"), function $DrawingView__drawRect_(self, _cmd, aRect)
{ with(self)
{
 if(objj_msgSend(objj_msgSend(self, "superview"), "editMode")) {
  if(mFocusedFrame) {
   var lOrgRect = objj_msgSend(mFocusedFrame, "rect");
   var lScaledRect = objj_msgSend(self, "scaledRectFrom:", lOrgRect);
   objj_msgSend(objj_msgSend(CPColor, "whiteColor"), "set");
   objj_msgSend(CPBezierPath, "setDefaultLineWidth:", 6);
   objj_msgSend(CPBezierPath, "strokeRect:", lScaledRect);
   objj_msgSend(objj_msgSend(CPColor, "colorWithRed:green:blue:alpha:", 1, 0, 0, 0.3), "set");
   objj_msgSend(CPBezierPath, "setDefaultLineWidth:", 4);
   objj_msgSend(CPBezierPath, "strokeRect:", lScaledRect);
  }
  if(objj_msgSend(mSelectedFrameList, "count")) {
   var i = 0;
   var icnt = objj_msgSend(mSelectedFrameList, "count");
   for(;i<icnt;i++) {
    var lSelectedFrame = objj_msgSend(mSelectedFrameList, "objectAtIndex:", i);
    var lOrgRect = objj_msgSend(lSelectedFrame, "rect");
    var lScaledRect = objj_msgSend(self, "scaledRectFrom:", lOrgRect);
    objj_msgSend(objj_msgSend(CPColor, "whiteColor"), "set");
    objj_msgSend(CPBezierPath, "setDefaultLineWidth:", 6);
    objj_msgSend(CPBezierPath, "strokeRect:", lScaledRect);
    objj_msgSend(objj_msgSend(CPColor, "colorWithRed:green:blue:alpha:", 0, 0, 1, 0.3), "set");
    objj_msgSend(CPBezierPath, "setDefaultLineWidth:", 4);
    objj_msgSend(CPBezierPath, "strokeRect:", lScaledRect);
    objj_msgSend(lSelectedFrame, "drawKnobsOnView:", self);
   }
  }
 }
}
},["void","CGRect"]), new objj_method(sel_getUid("acceptsFirstResponder"), function $DrawingView__acceptsFirstResponder(self, _cmd)
{ with(self)
{
        return YES;
}
},["BOOL"]), new objj_method(sel_getUid("keyDown:"), function $DrawingView__keyDown_(self, _cmd, anEvent)
{ with(self)
{
 var keycode = objj_msgSend(anEvent, "keyCode");
 if(keycode == 8) {
  var frames_str = "";
  var i = 0;
  var icnt = objj_msgSend(mSelectedFrameList, "count");
  for(;i<icnt;i++) {
   var lSelectedFrame = objj_msgSend(mSelectedFrameList, "objectAtIndex:", i);
   var gid = objj_msgSend(lSelectedFrame, "GID");
   if(i > 0) {
    frames_str += "__GRAPHICSEP__";
   }
   frames_str += gid;
   objj_msgSend(mFrameList, "removeObject:", lSelectedFrame);
  }
  objj_msgSend(mSelectedFrameList, "removeAllObjects");
  objj_msgSend(objj_msgSend(ProgressWindow, "sharedWindow"), "show");
  objj_msgSend(mEditController, "sendJSONRequestAndRefresh:data:", "DeleteGraphics", frames_str);
  mFocusedFrame = nil;
  objj_msgSend(self, "setNeedsDisplay:", YES);
 }
}
},["void","CPEvent"]), new objj_method(sel_getUid("frameAtEvent:"), function $DrawingView__frameAtEvent_(self, _cmd, anEvent)
{ with(self)
{
 var i, icnt = objj_msgSend(mFrameList, "count");
 for(i=0;i<icnt;i++) {
  var aFrame = objj_msgSend(mFrameList, "objectAtIndex:", icnt - i - 1);
  if(objj_msgSend(aFrame, "isEventInFrame:view:", anEvent, self)) {
   return aFrame;
  }
 }
 return nil;
}
},["id","CPEvent"]), new objj_method(sel_getUid("mouseMoved:"), function $DrawingView__mouseMoved_(self, _cmd, anEvent)
{ with(self)
{
 if(!objj_msgSend(objj_msgSend(self, "superview"), "editMode"))
  return;
 if(!objj_msgSend(mEditController, "isWindowVisible")) {
  mFocusedFrame = objj_msgSend(self, "frameAtEvent:", anEvent);
 }
 objj_msgSend(self, "setNeedsDisplay:", YES);
}
},["void","CPEvent"]), new objj_method(sel_getUid("knobMouseIn:"), function $DrawingView__knobMouseIn_(self, _cmd, anEvent)
{ with(self)
{
 var i = 0;
 var icnt = objj_msgSend(mSelectedFrameList, "count");
 for(;i<icnt;i++) {
  var lSelectedFrame = objj_msgSend(mSelectedFrameList, "objectAtIndex:", i);
  var lKnob = objj_msgSend(lSelectedFrame, "knobMouseIn:inView:", anEvent, self);
  return lKnob;
 }
 return nil;
}
},["int","CPEvent"]), new objj_method(sel_getUid("mouseDown:"), function $DrawingView__mouseDown_(self, _cmd, anEvent)
{ with(self)
{
 objj_msgSend(objj_msgSend(self, "window"), "makeFirstResponder:", self);
 if(!objj_msgSend(objj_msgSend(self, "superview"), "editMode"))
  return;
 if(!objj_msgSend(mEditController, "isWindowVisible")) {
  mKnobGrabed = objj_msgSend(self, "knobMouseIn:", anEvent);
  if(mKnobGrabed) {
   var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
   var lPtInView = objj_msgSend(self, "convertPoint:fromView:", lPtInWindow, nil);
   mPointInView = lPtInView;
  }
  else {
   objj_msgSend(mSelectedFrameList, "removeAllObjects");
   var lSelFrame = objj_msgSend(self, "frameAtEvent:", anEvent);
   if(lSelFrame) {
    objj_msgSend(mSelectedFrameList, "addObject:", lSelFrame);
    objj_msgSend(self, "setNeedsDisplay:", YES);
    if(objj_msgSend(anEvent, "clickCount") == 2) {
     objj_msgSend(mEditController, "drawingView:frameSelected:", self, lSelFrame);
    }
    else {
     var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
     var lPtInView = objj_msgSend(self, "convertPoint:fromView:", lPtInWindow, nil);
     mPointInView = lPtInView;
     mKnobGrabed = objj_msgSend(self, "knobMouseIn:", anEvent);
     if(mKnobGrabed) {
     }
     else {
      mMouseMoved = YES;
      mFrameGrabed = NO;
     }
    }
   }
  }
 }
}
},["void","CPEvent"]), new objj_method(sel_getUid("mouseUp:"), function $DrawingView__mouseUp_(self, _cmd, anEvent)
{ with(self)
{
 if(mFrameGrabed || mKnobGrabed) {
  mFrameGrabed = NO;
  var frames_str = "";
  var i = 0;
  var icnt = objj_msgSend(mSelectedFrameList, "count");
  var scaleFactor = objj_msgSend(self, "scaleFactor");
  for(;i<icnt;i++) {
   var lSelectedFrame = objj_msgSend(mSelectedFrameList, "objectAtIndex:", i);
   var lOrgRect = objj_msgSend(lSelectedFrame, "rect");
   var framestr = CPStringFromRect(lOrgRect);
   var gid = objj_msgSend(lSelectedFrame, "GID");
   if(i > 0) {
    frames_str += "__GRAPHICSEP__";
   }
   frames_str += gid + "__GIDSEP__" + framestr;
  }
  objj_msgSend(objj_msgSend(ProgressWindow, "sharedWindow"), "show");
  objj_msgSend(mEditController, "sendJSONRequestAndRefresh:data:", "SetFrames", frames_str);
 }
 mMouseMoved = NO;
 mKnobGrabed = nil;
}
},["void","CPEvent"]), new objj_method(sel_getUid("mouseDragged:"), function $DrawingView__mouseDragged_(self, _cmd, anEvent)
{ with(self)
{
 if(mMouseMoved == YES && mFrameGrabed == NO) {
  var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
  var lPtInView = objj_msgSend(self, "convertPoint:fromView:", lPtInWindow, nil);
  var dx = mPointInView.x - lPtInView.x;
  var dy = mPointInView.y - lPtInView.y;
  if(dx > 5 || dx < -5 || dy > 5 || dy < -5) {
   mMouseMoved = NO;
   mFrameGrabed = YES;
  }
 }
 if(mFrameGrabed) {
  var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
  var lPtInView = objj_msgSend(self, "convertPoint:fromView:", lPtInWindow, nil);
  var dx = lPtInView.x - mPointInView.x;
  var dy = lPtInView.y - mPointInView.y;
  var i = 0;
  var icnt = objj_msgSend(mSelectedFrameList, "count");
  var scaleFactor = objj_msgSend(self, "scaleFactor");
  for(;i<icnt;i++) {
   var lSelectedFrame = objj_msgSend(mSelectedFrameList, "objectAtIndex:", i);
   var lOrgRect = objj_msgSend(lSelectedFrame, "rect");
   lOrgRect.origin.x += (dx / scaleFactor);
   lOrgRect.origin.y += (dy / scaleFactor);
   objj_msgSend(lSelectedFrame, "setOrigin:", lOrgRect.origin);
  }
  objj_msgSend(self, "setNeedsDisplay:", YES);
  mPointInView = lPtInView;
 }
 else if(mKnobGrabed) {
  var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
  var lPtInView = objj_msgSend(self, "convertPoint:fromView:", lPtInWindow, nil);
  var scaleFactor = objj_msgSend(self, "scaleFactor");
  var dx = (lPtInView.x - mPointInView.x) / scaleFactor;
  var dy = (lPtInView.y - mPointInView.y) / scaleFactor;
  var lCurFrame = objj_msgSend(mKnobGrabed, "graphicFrame");
  var lOrgRect = objj_msgSend(lCurFrame, "rect");
  switch(objj_msgSend(mKnobGrabed, "position")) {
   case gKnobPostionLeftTop:
    lOrgRect.origin.x += dx;
    lOrgRect.size.width -= dx;
    lOrgRect.origin.y += dy;
    lOrgRect.size.height -= dy;
    break;
   case gKnobPostionTop:
    lOrgRect.origin.y += dy;
    lOrgRect.size.height -= dy;
    break;
   case gKnobPostionRightTop:
    lOrgRect.size.width += dx;
    lOrgRect.origin.y += dy;
    lOrgRect.size.height -= dy;
    break;
   case gKnobPostionRight:
    lOrgRect.size.width += dx;
    break;
   case gKnobPostionRightBottom:
    lOrgRect.size.width += dx;
    lOrgRect.size.height += dy;
    break;
   case gKnobPostionBottom:
    lOrgRect.size.height += dy;
    break;
   case gKnobPostionLeftBottom:
    lOrgRect.origin.x += dx;
    lOrgRect.size.width -= dx;
    lOrgRect.size.height += dy;
    break;
   case gKnobPostionLeft:
    lOrgRect.origin.x += dx;
    lOrgRect.size.width -= dx;
    break;
  }
  objj_msgSend(lSelectedFrame, "setFrame:", lOrgRect);
  objj_msgSend(self, "setNeedsDisplay:", YES);
  mPointInView = lPtInView;
 }
}
},["void","CPEvent"]), new objj_method(sel_getUid("setController:"), function $DrawingView__setController_(self, _cmd, anObject)
{ with(self)
{
 if(mEditController)
  objj_msgSend(mEditController, "release");
 mEditController = objj_msgSend(anObject, "retain");
}
},["void","id"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $DrawingView__connection_didReceiveData_(self, _cmd, connection, data)
{ with(self)
{
}
},["void","CPURLConnection","CPString"])]);
}
{var the_class = objj_allocateClassPair(CPView, "SSIImageView"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mImage")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setImage:"), function $SSIImageView__setImage_(self, _cmd, anImage)
{ with(self)
{
 mImage = anImage;
 objj_msgSend(mImage, "setDelegate:", self);
}
},["void","CPImage"]), new objj_method(sel_getUid("image"), function $SSIImageView__image(self, _cmd)
{ with(self)
{
 return mImage;
}
},["CPImage"]), new objj_method(sel_getUid("imageDidLoad:"), function $SSIImageView__imageDidLoad_(self, _cmd, image)
{ with(self)
{
 objj_msgSend(self, "setNeedsDisplay:", YES);
}
},["void","CPImage"]), new objj_method(sel_getUid("spreadFrame"), function $SSIImageView__spreadFrame(self, _cmd)
{ with(self)
{
 var mSpreadSize = objj_msgSend(mImage, "size");
 var lViewBounds = objj_msgSend(self, "bounds");
 var lSpreadFrame = CPMakeRect(0,0,0,0);
 var rate;
 if(lViewBounds.size.width / mSpreadSize.width > lViewBounds.size.height / mSpreadSize.height) {
  rate = lViewBounds.size.height / mSpreadSize.height;
  lSpreadFrame.size.height = lViewBounds.size.height;
  lSpreadFrame.size.width = mSpreadSize.width * rate;
 }
 else {
  rate = lViewBounds.size.width / mSpreadSize.width;
  lSpreadFrame.size.width = lViewBounds.size.width;
  lSpreadFrame.size.height = mSpreadSize.height * rate;
 }
 lSpreadFrame.origin.x = (lViewBounds.size.width - lSpreadFrame.size.width) / 2.0;
 lSpreadFrame.origin.y = (lViewBounds.size.height - lSpreadFrame.size.height) / 2.0;
 return lSpreadFrame;
}
},["CGRect"]), new objj_method(sel_getUid("drawRect:"), function $SSIImageView__drawRect_(self, _cmd, rect)
{ with(self)
{
   if(objj_msgSend(mImage, "loadStatus") != CPImageLoadStatusCompleted)
    {
            return;
    }
    var context = objj_msgSend(objj_msgSend(CPGraphicsContext, "currentContext"), "graphicsPort");
    var targetRect = objj_msgSend(self, "spreadFrame");
    CGContextDrawImage(context, targetRect, mImage);
}
},["void","CPRect"]), new objj_method(sel_getUid("setImageScaling:"), function $SSIImageView__setImageScaling_(self, _cmd, anImageScaling)
{ with(self)
{
}
},["void","CPImageScaling"])]);
}

