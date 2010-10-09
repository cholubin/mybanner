@STATIC;1.0;I;21;Foundation/CPObject.ji;13;DrawingView.ji;16;ProgressWindow.jt;5379;

objj_executeFile("Foundation/CPObject.j", NO);

objj_executeFile("DrawingView.j", YES);
objj_executeFile("ProgressWindow.j", YES);


{var the_class = objj_allocateClassPair(CPView, "SpreadEditView"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mDrawingView"), new objj_ivar("mImageView"), new objj_ivar("mEditController"), new objj_ivar("mEditMode"), new objj_ivar("mScaleFactor"), new objj_ivar("mImageSize")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $SpreadEditView__initWithFrame_(self, _cmd, frame)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("SpreadEditView").super_class }, "initWithFrame:", frame);
 if(self) {

  mImageView = objj_msgSend(objj_msgSend(CPImageView, "alloc"), "initWithFrame:", frame);

  objj_msgSend(mImageView, "setImageScaling:", CPScaleToFit);
  objj_msgSend(self, "addSubview:", mImageView);
  objj_msgSend(mImageView, "release");

   mDrawingView = objj_msgSend(objj_msgSend(DrawingView, "alloc"), "initWithFrame:", frame);

  objj_msgSend(self, "addSubview:", mDrawingView);
  objj_msgSend(mDrawingView, "release");

  mEditMode = YES;
  mScaleFactor = 1.0;
 }
 return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("imageView"), function $SpreadEditView__imageView(self, _cmd)
{ with(self)
{
 return mImageView;
}
},["CPImageView"]), new objj_method(sel_getUid("drawingView"), function $SpreadEditView__drawingView(self, _cmd)
{ with(self)
{
 return mDrawingView;
}
},["DrawingView"]), new objj_method(sel_getUid("editMode"), function $SpreadEditView__editMode(self, _cmd)
{ with(self)
{
 return mEditMode;
}
},["BOOL"]), new objj_method(sel_getUid("setEditMode:"), function $SpreadEditView__setEditMode_(self, _cmd, flag)
{ with(self)
{
 mEditMode = flag;
}
},["void","BOOL"]), new objj_method(sel_getUid("setScaleFactor:"), function $SpreadEditView__setScaleFactor_(self, _cmd, aFactor)
{ with(self)
{
 mScaleFactor = aFactor;
}
},["void","float"]), new objj_method(sel_getUid("scaleFactor"), function $SpreadEditView__scaleFactor(self, _cmd)
{ with(self)
{
 return mScaleFactor;
}
},["float"]), new objj_method(sel_getUid("setSpreadImage:"), function $SpreadEditView__setSpreadImage_(self, _cmd, anImage)
{ with(self)
{
 if(anImage) {
  objj_msgSend(anImage, "setDelegate:", self);
     if(objj_msgSend(anImage, "loadStatus") == CPImageLoadStatusCompleted)
         objj_msgSend(self, "imageDidLoad:", anImage);
     else {

  }
 }
 else {
        objj_msgSend(mImageView, "setImage:", nil);
 }
}
},["void","CPImage"]), new objj_method(sel_getUid("reposition:"), function $SpreadEditView__reposition_(self, _cmd, notification)
{ with(self)
{
 debugger;
 var lNewViewFrame = objj_msgSend(self, "frame");
 var lScrollView = objj_msgSend(self, "enclosingScrollView");
 var lContentSize = objj_msgSend(objj_msgSend(lScrollView, "contentView"), "frame").size;
 var xMargin = (lContentSize.width - lNewViewFrame.size.width) / 2.0;
 var yMargin = (lContentSize.height - lNewViewFrame.size.height) / 2.0;
 lNewViewFrame.origin.x = 0;
 lNewViewFrame.origin.y = 0;
 if(xMargin > 0) {
  lNewViewFrame.origin.x = xMargin;
 }
 if(yMargin > 0) {
  lNewViewFrame.origin.y = yMargin;
 }
 objj_msgSend(self, "setFrame:", lNewViewFrame);
}
},["void","CPNotification"]), new objj_method(sel_getUid("rescale"), function $SpreadEditView__rescale(self, _cmd)
{ with(self)
{
 var lImageSize = objj_msgSend(objj_msgSend(mImageView, "image"), "size");
 lImageSize.width = mImageSize.width * mScaleFactor;
 lImageSize.height = mImageSize.height * mScaleFactor;
 var lNewImageFrame = CGRectMake(0, 0, 0, 0);

 var lScrollView = objj_msgSend(self, "enclosingScrollView");
 var lContentSize = objj_msgSend(objj_msgSend(lScrollView, "contentView"), "frame").size;
 var xMargin = (lContentSize.width - lImageSize.width) / 2.0;
 var yMargin = (lContentSize.height - lImageSize.height) / 2.0;
 lNewImageFrame.size = lImageSize;

 objj_msgSend(mImageView, "setFrame:", lNewImageFrame);
 if(mDrawingView) {
  objj_msgSend(mDrawingView, "setFrame:", lNewImageFrame);
 }
 var lNewViewFrame = objj_msgSend(self, "frame");
 lNewViewFrame.origin.x = 0;
 lNewViewFrame.origin.y = 0;
 if(xMargin > 0) {
  lNewViewFrame.origin.x = xMargin;
 }
 if(yMargin > 0) {
  lNewViewFrame.origin.y = yMargin;
 }

 lNewViewFrame.size = lNewImageFrame.size;
 objj_msgSend(self, "setFrame:", lNewViewFrame);
}
},["void"]), new objj_method(sel_getUid("imageDidLoad:"), function $SpreadEditView__imageDidLoad_(self, _cmd, anImage)
{ with(self)
{
 if(anImage != objj_msgSend(mImageView, "image")) {
  var lImageSize = objj_msgSend(anImage, "size");
  mImageSize = CGSizeMake(lImageSize.width, lImageSize.height);
  lImageSize.width = mImageSize.width * mScaleFactor;
  lImageSize.height = mImageSize.height * mScaleFactor;
  var lNewImageFrame = CGRectMake(0, 0, 0, 0);
  lNewImageFrame.size = lImageSize;
  objj_msgSend(mImageView, "setFrame:", lNewImageFrame);
  if(mDrawingView) {
   objj_msgSend(mDrawingView, "setFrame:", lNewImageFrame);
  }
  var lNewViewFrame = objj_msgSend(self, "frame");
  lNewViewFrame.size = lNewImageFrame.size;
  objj_msgSend(self, "setFrame:", lNewViewFrame);


 }
    objj_msgSend(mImageView, "setImage:", anImage);
 objj_msgSend(objj_msgSend(ProgressWindow, "sharedWindow"), "hide");
}
},["void","CPImage"])]);
}

