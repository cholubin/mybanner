@STATIC;1.0;I;21;Foundation/CPObject.jt;10444;


objj_executeFile("Foundation/CPObject.j", NO);

{var the_class = objj_allocateClassPair(CPView, "ImageClipper"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mBoxFrame"), new objj_ivar("mServerBoxSize")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $ImageClipper__initWithFrame_(self, _cmd, rect)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ImageClipper").super_class }, "initWithFrame:", rect);
 if(self){
  var lBounds = objj_msgSend(self, "bounds");
  mBoxFrame = CPRectInset(lBounds, 50, 50);
  mServerBoxSize = CPSizeMake(0, 0);
 }
 return self;
}
},["id","CPRect"]), new objj_method(sel_getUid("drawRect:"), function $ImageClipper__drawRect_(self, _cmd, rect)
{ with(self)
{
 if(mServerBoxSize.width == 0 || mServerBoxSize.height == 0)
  return;
 objj_msgSend(self, "resetBoxFrame");
 var lBounds = objj_msgSend(self, "bounds");
 var bpath = objj_msgSend(CPBezierPath, "bezierPath");
 objj_msgSend(bpath, "moveToPoint:", mBoxFrame.origin);
 objj_msgSend(bpath, "lineToPoint:", CPMakePoint(CPRectGetMaxX(mBoxFrame), mBoxFrame.origin.y));
 objj_msgSend(bpath, "lineToPoint:", CPMakePoint(CPRectGetMaxX(mBoxFrame), CPRectGetMaxY(mBoxFrame)));
 objj_msgSend(bpath, "lineToPoint:", CPMakePoint(mBoxFrame.origin.x, CPRectGetMaxY(mBoxFrame)));
 objj_msgSend(bpath, "lineToPoint:", mBoxFrame.origin);
 objj_msgSend(bpath, "lineToPoint:", lBounds.origin);


 objj_msgSend(bpath, "lineToPoint:", CPMakePoint(lBounds.origin.x, CPRectGetMaxY(lBounds)));
 objj_msgSend(bpath, "lineToPoint:", CPMakePoint(CPRectGetMaxX(lBounds), CPRectGetMaxY(lBounds)));
 objj_msgSend(bpath, "lineToPoint:", CPMakePoint(CPRectGetMaxX(lBounds), lBounds.origin.y));
 objj_msgSend(bpath, "lineToPoint:", lBounds.origin);
 objj_msgSend(bpath, "closePath");



 objj_msgSend(objj_msgSend(CPColor, "colorWithRed:green:blue:alpha:", 0.5, 0.5, 0.5, 0.7), "set");
 objj_msgSend(bpath, "fill");

}
},["void","CPRect"]), new objj_method(sel_getUid("resetBoxFrame"), function $ImageClipper__resetBoxFrame(self, _cmd)
{ with(self)
{
 if(mServerBoxSize.width == 0 || mServerBoxSize.height == 0)
  return;
 var lBounds = objj_msgSend(self, "bounds");
 var lMaxWidth = lBounds.size.width - 60;
 var lMaxHeight = lBounds.size.height - 60;
 if(mServerBoxSize.width / lMaxWidth > mServerBoxSize.height / lMaxHeight) {
  mBoxFrame.size.width = lMaxWidth;
  mBoxFrame.size.height = mServerBoxSize.height * lMaxWidth / mServerBoxSize.width;
 }
 else {
  mBoxFrame.size.width = mServerBoxSize.width * lMaxHeight / mServerBoxSize.height;
  mBoxFrame.size.height = lMaxHeight;
 }
 debugger;
 mBoxFrame.origin.x = (lBounds.size.width - mBoxFrame.size.width) / 2.0;
 mBoxFrame.origin.y = (lBounds.size.height - mBoxFrame.size.height) / 2.0;
}
},["void"]), new objj_method(sel_getUid("setServerBoxSize:"), function $ImageClipper__setServerBoxSize_(self, _cmd, server_boxsize)
{ with(self)
{

 mServerBoxSize = server_boxsize;
 objj_msgSend(self, "setNeedsDisplay:", YES);
}
},["void","CPSize"]), new objj_method(sel_getUid("serverBoxSize"), function $ImageClipper__serverBoxSize(self, _cmd)
{ with(self)
{
 return mServerBoxSize;
}
},["CPSize"]), new objj_method(sel_getUid("boxFrame"), function $ImageClipper__boxFrame(self, _cmd)
{ with(self)
{

 return mBoxFrame;
}
},["CPRect"]), new objj_method(sel_getUid("factor"), function $ImageClipper__factor(self, _cmd)
{ with(self)
{
 if(mServerBoxSize.width == 0)
  return 0.1;
 return mBoxFrame.size.width / mServerBoxSize.width;
}
},["float"])]);
}






{var the_class = objj_allocateClassPair(CPView, "ImageTrimmer"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mClipView"), new objj_ivar("mImageView"), new objj_ivar("orgImageFrame"), new objj_ivar("mPointInView"), new objj_ivar("mImageGrabed")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $ImageTrimmer__initWithFrame_(self, _cmd, frame)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ImageTrimmer").super_class }, "initWithFrame:", frame);
 if(self) {
  var lSelfBounds = objj_msgSend(self, "bounds");
        var lClipViewFrame = CPRectInset(lSelfBounds, 10, 10);
  mImageView = objj_msgSend(objj_msgSend(CPImageView, "alloc"), "initWithFrame:", lClipViewFrame);
  objj_msgSend(mImageView, "setImageScaling:", CPScaleToFit);

  objj_msgSend(self, "addSubview:", mImageView);

  mClipView = objj_msgSend(objj_msgSend(ImageClipper, "alloc"), "initWithFrame:", lSelfBounds);
    objj_msgSend(mClipView, "setAutoresizingMask:", CPViewWidthSizable | CPViewHeightSizable );
  objj_msgSend(self, "addSubview:", mClipView);
  objj_msgSend(self, "setAutoresizesSubviews:", YES);
  mPointInView = CPPointMake(0, 0);
  orgImageFrame = lClipViewFrame;

  }
    return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("dealloc"), function $ImageTrimmer__dealloc(self, _cmd)
{ with(self)
{
 objj_msgSend(mImageView, "release");
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ImageTrimmer").super_class }, "dealloc");
}
},["void"]), new objj_method(sel_getUid("setImage:"), function $ImageTrimmer__setImage_(self, _cmd, aImage)
{ with(self)
{
 var imgrect = objj_msgSend(mImageView, "imageRect");
 var imgsize = objj_msgSend(aImage, "size");
 if(imgrect) {


 }

 objj_msgSend(mImageView, "setImage:", aImage);

 imgsize = objj_msgSend(objj_msgSend(mImageView, "image"), "size");
 imgrect = objj_msgSend(mImageView, "imageRect");
 if(imgrect) {


 }
}
},["void","CPImage"]), new objj_method(sel_getUid("setServerBoxSize:"), function $ImageTrimmer__setServerBoxSize_(self, _cmd, aSize)
{ with(self)
{
 objj_msgSend(mClipView, "setServerBoxSize:", aSize);
}
},["void","CPSize"]), new objj_method(sel_getUid("serverBoxSize"), function $ImageTrimmer__serverBoxSize(self, _cmd)
{ with(self)
{
 return objj_msgSend(mClipView, "serverBoxSize");
}
},["CPSize"]), new objj_method(sel_getUid("resetImageViewFrame"), function $ImageTrimmer__resetImageViewFrame(self, _cmd)
{ with(self)
{
 var lNewImageFrame = CPRectMake(0,0,0,0);
 var lBoxFrame = objj_msgSend(mClipView, "boxFrame");
 var lScaleFactor = objj_msgSend(mClipView, "factor");
 lNewImageFrame.origin.x = lScaleFactor * orgImageFrame.origin.x + lBoxFrame.origin.x;
 lNewImageFrame.origin.y = lScaleFactor * orgImageFrame.origin.y + lBoxFrame.origin.y;
 lNewImageFrame.size.width = lScaleFactor * orgImageFrame.size.width;
 lNewImageFrame.size.height = lScaleFactor * orgImageFrame.size.height;
 objj_msgSend(mImageView, "setFrame:", lNewImageFrame);
}
},["void"]), new objj_method(sel_getUid("setServerBoxImageFrame:"), function $ImageTrimmer__setServerBoxImageFrame_(self, _cmd, image_frame)
{ with(self)
{
 orgImageFrame = image_frame;
 objj_msgSend(self, "setNeedsDisplay:", YES);
}
},["void","CPRect"]), new objj_method(sel_getUid("drawRect:"), function $ImageTrimmer__drawRect_(self, _cmd, rect)
{ with(self)
{
 objj_msgSend(self, "resetImageViewFrame");
 objj_msgSend(objj_msgSend(CPColor, "colorWithRed:green:blue:alpha:", 0, 0, 0.5, 1), "set");
 objj_msgSend(CPBezierPath, "fillRect:", objj_msgSend(self, "bounds"));

 var lBoxFrame = objj_msgSend(mClipView, "boxFrame");
 objj_msgSend(objj_msgSend(CPColor, "colorWithRed:green:blue:alpha:", 1, 0, 0, 1), "set");
 objj_msgSend(CPBezierPath, "fillRect:", lBoxFrame);
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ImageTrimmer").super_class }, "drawRect:", rect);
}
},["void","CPRect"]), new objj_method(sel_getUid("isEventInFrame:view:"), function $ImageTrimmer__isEventInFrame_view_(self, _cmd, anEvent, aView)
{ with(self)
{
 var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
 var lWin = objj_msgSend(aView, "window");
 var lWincontentview = objj_msgSend(lWin, "contentView");
 var lPtInView = objj_msgSend(aView, "convertPoint:fromView:", lPtInWindow, lWincontentview);
 var lScaledRect = objj_msgSend(aView, "scaledRectFrom:", mRect);
 return CPRectContainsPoint(lScaledRect, lPtInView);
}
},["BOOL","CPEvent","CPView"]), new objj_method(sel_getUid("mouseDragged:"), function $ImageTrimmer__mouseDragged_(self, _cmd, anEvent)
{ with(self)
{
 if(!mImageGrabed)
  return;
 var lBoxFrame = objj_msgSend(mClipView, "boxFrame");
 var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
 var lWin = objj_msgSend(self, "window");
 var lWincontentview = objj_msgSend(lWin, "contentView");
 var contentOrgY = objj_msgSend(lWincontentview, "frame").origin.y;
 var lPtInView = objj_msgSend(self, "convertPoint:fromView:", lPtInWindow, lWincontentview);
 lPtInView.y -= contentOrgY;
 var dx = lPtInView.x - mPointInView.x;
 var dy = lPtInView.y - mPointInView.y;
 var lScaleFactor = objj_msgSend(mClipView, "factor");

 if(objj_msgSend(anEvent, "modifierFlags") == 131072) {
  var max = dx / lScaleFactor;




  var imgFactor = orgImageFrame.size.width / orgImageFrame.size.height;
  if(imgFactor > 1.0) {
   var inc = max * imgFactor;
   orgImageFrame.size.width += inc;
   orgImageFrame.size.height += max
  }
  else {
   imgFactor = orgImageFrame.size.height / orgImageFrame.size.width
   var inc = max * imgFactor;
   orgImageFrame.size.width += max;
   orgImageFrame.size.height += inc
  }







 }
 else {
  orgImageFrame.origin.x += dx / lScaleFactor;
  orgImageFrame.origin.y += dy / lScaleFactor;
 }
 objj_msgSend(self, "setNeedsDisplay:", YES);
 mPointInView = lPtInView;

}
},["void","CPEvent"]), new objj_method(sel_getUid("mouseDown:"), function $ImageTrimmer__mouseDown_(self, _cmd, anEvent)
{ with(self)
{
 var lBoxFrame = objj_msgSend(mClipView, "boxFrame");
 var lPtInWindow = objj_msgSend(anEvent, "locationInWindow");
 var lWin = objj_msgSend(self, "window");
 var lWincontentview = objj_msgSend(lWin, "contentView");
 var contentOrgY = objj_msgSend(lWincontentview, "frame").origin.y;

 var lPtInView = objj_msgSend(self, "convertPoint:fromView:", lPtInWindow, lWincontentview);
 lPtInView.y -= contentOrgY;
 if(CPRectContainsPoint(lBoxFrame, lPtInView)) {
  mImageGrabed = YES;
  mPointInView = lPtInView;
 }

}
},["void","CPEvent"]), new objj_method(sel_getUid("mouseUp:"), function $ImageTrimmer__mouseUp_(self, _cmd, anEvent)
{ with(self)
{
 mImageGrabed = NO;
}
},["void","CPEvent"]), new objj_method(sel_getUid("orgImageFrame"), function $ImageTrimmer__orgImageFrame(self, _cmd)
{ with(self)
{
 return orgImageFrame;
}
},["CPRect"])]);
}

