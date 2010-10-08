@STATIC;1.0;t;12097;




{var the_class = objj_allocateClassPair(CPView, "SDImageView"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mImageView"), new objj_ivar("mTextField"), new objj_ivar("mIsSelected")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $SDImageView__initWithFrame_(self, _cmd, frame)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("SDImageView").super_class }, "initWithFrame:", frame);
 if(self) {






 }
 return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("buildSubviews"), function $SDImageView__buildSubviews(self, _cmd)
{ with(self)
{
 var lInRect = CPRectInset(objj_msgSend(self, "bounds"), 10, 10);
 mImageView = objj_msgSend(objj_msgSend(CPImageView, "alloc"), "initWithFrame:", lInRect);


 objj_msgSend(mImageView, "setImageScaling:", CPScaleProportionally);
 objj_msgSend(self, "addSubview:", mImageView);
 objj_msgSend(mImageView, "release");
}
},["void"]), new objj_method(sel_getUid("deleteImageView"), function $SDImageView__deleteImageView(self, _cmd)
{ with(self)
{


}
},["void"]), new objj_method(sel_getUid("imageView"), function $SDImageView__imageView(self, _cmd)
{ with(self)
{
 return mImageView;
}
},["id"]), new objj_method(sel_getUid("drawRect:"), function $SDImageView__drawRect_(self, _cmd, rect)
{ with(self)
{
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("SDImageView").super_class }, "drawRect:", rect);

 if(mIsSelected) {
  objj_msgSend(objj_msgSend(CPColor, "colorWithRed:green:blue:alpha:", 1, 0, 0, 0.3), "set");
  objj_msgSend(CPBezierPath, "fillRect:", objj_msgSend(self, "bounds"));
 }
 else{

  objj_msgSend(objj_msgSend(CPColor, "lightGrayColor"), "set");
  objj_msgSend(CPBezierPath, "fillRect:", objj_msgSend(self, "bounds"));
 }

}
},["void","CGRect"]), new objj_method(sel_getUid("setImage:"), function $SDImageView__setImage_(self, _cmd, image)
{ with(self)
{
 objj_msgSend(image, "setDelegate:", self);
    if(objj_msgSend(image, "loadStatus") == CPImageLoadStatusCompleted)
        objj_msgSend(mImageView, "setImage:", image);
    else
        objj_msgSend(mImageView, "setImage:", nil);
}
},["void","id"]), new objj_method(sel_getUid("imageDidLoad:"), function $SDImageView__imageDidLoad_(self, _cmd, anImage)
{ with(self)
{
    objj_msgSend(mImageView, "setImage:", anImage);
}
},["void","CPImage"]), new objj_method(sel_getUid("setSelected:"), function $SDImageView__setSelected_(self, _cmd, shouldBeSelected)
{ with(self)
{
 mIsSelected = shouldBeSelected;
 objj_msgSend(self, "display");
}
},["void","BOOL"])]);
}







{var the_class = objj_allocateClassPair(CPCollectionViewItem, "SDCollectionViewItem"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setRepresentedObject:"), function $SDCollectionViewItem__setRepresentedObject_(self, _cmd, representedObject)
{ with(self)
{
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("SDCollectionViewItem").super_class }, "setRepresentedObject:", representedObject);
 if(!objj_msgSend(objj_msgSend(self, "view"), "imageView"))
  objj_msgSend(objj_msgSend(self, "view"), "buildSubviews");
 var image = objj_msgSend(representedObject, "objectForKey:", "image");
 objj_msgSend(image, "setDelegate:", self);
 objj_msgSend(objj_msgSend(self, "view"), "setImage:", image);
    if(objj_msgSend(image, "loadStatus") == CPImageLoadStatusCompleted)
        objj_msgSend(objj_msgSend(self, "view"), "setImage:", image);
    else
        objj_msgSend(objj_msgSend(self, "view"), "setImage:", nil);

}
},["void","id"]), new objj_method(sel_getUid("imageDidLoad:"), function $SDCollectionViewItem__imageDidLoad_(self, _cmd, anImage)
{ with(self)
{
    objj_msgSend(objj_msgSend(self, "view"), "setImage:", anImage);
}
},["void","CPImage"]), new objj_method(sel_getUid("setSelected:"), function $SDCollectionViewItem__setSelected_(self, _cmd, shouldBeSelected)
{ with(self)
{
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("SDCollectionViewItem").super_class }, "setSelected:", shouldBeSelected);
 objj_msgSend(objj_msgSend(self, "view"), "setSelected:", shouldBeSelected);
}
},["void","BOOL"])]);
}
{var the_class = objj_allocateClassPair(CPAnimation, "ModeChangeAnimation"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mController"), new objj_ivar("mStart"), new objj_ivar("mEnd"), new objj_ivar("reverse")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setController:"), function $ModeChangeAnimation__setController_(self, _cmd, anObject)
{ with(self)
{
 if(mController)
  objj_msgSend(mController, "release");
 mController = objj_msgSend(anObject, "retain");
}
},["void","id"]), new objj_method(sel_getUid("setReverse:"), function $ModeChangeAnimation__setReverse_(self, _cmd, flag)
{ with(self)
{
 reverse = flag;
}
},["void","var"]), new objj_method(sel_getUid("setStart:"), function $ModeChangeAnimation__setStart_(self, _cmd, aValue)
{ with(self)
{
 mStart = aValue;
}
},["void","var"]), new objj_method(sel_getUid("start"), function $ModeChangeAnimation__start(self, _cmd)
{ with(self)
{
 return mStart;
}
},["id"]), new objj_method(sel_getUid("setEnd:"), function $ModeChangeAnimation__setEnd_(self, _cmd, aValue)
{ with(self)
{
 mEnd = aValue;
}
},["void","var"]), new objj_method(sel_getUid("end"), function $ModeChangeAnimation__end(self, _cmd)
{ with(self)
{
 return mEnd;
}
},["id"]), new objj_method(sel_getUid("setCurrentProgress:"), function $ModeChangeAnimation__setCurrentProgress_(self, _cmd, progress)
{ with(self)
{
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ModeChangeAnimation").super_class }, "setCurrentProgress:", progress);
 progress = objj_msgSend(self, "currentValue");
    var lXpos = (progress * (mEnd - mStart)) + mStart;
 var lFrame = objj_msgSend(objj_msgSend(mController, "spreadScrollView"), "frame");
 var lWidthDiff = lFrame.origin.x - lXpos;
 lFrame.origin.x = lXpos;
 lFrame.size.width += lWidthDiff;
 objj_msgSend(objj_msgSend(mController, "spreadScrollView"), "setFrame:", lFrame);
 lFrame = objj_msgSend(objj_msgSend(mController, "spreadListScrollView"), "frame");
 lWidthDiff = lFrame.origin.x - lXpos;
 lFrame.origin.x = lXpos;
 lFrame.size.width += lWidthDiff;
 objj_msgSend(objj_msgSend(mController, "spreadListScrollView"), "setFrame:", lFrame);
 lFrame = objj_msgSend(objj_msgSend(mController, "spreadTitle"), "frame");
 lFrame.origin.x = lXpos;
 objj_msgSend(objj_msgSend(mController, "spreadTitle"), "setFrame:", lFrame);
 lFrame = objj_msgSend(objj_msgSend(mController, "controlBox"), "frame");
 lFrame.origin.x = lXpos;
 lFrame.size.width += lWidthDiff;
 objj_msgSend(objj_msgSend(mController, "controlBox"), "setFrame:", lFrame);
 if(reverse) {
  objj_msgSend(objj_msgSend(mController, "documentListScrollView"), "setAlphaValue:", progress);
  objj_msgSend(objj_msgSend(mController, "docListTitle"), "setAlphaValue:", progress);
  objj_msgSend(objj_msgSend(mController, "deleteBtn"), "setAlphaValue:", progress);
  objj_msgSend(objj_msgSend(mController, "generatePDFBtn"), "setAlphaValue:", progress);
 }
 else {
  objj_msgSend(objj_msgSend(mController, "documentListScrollView"), "setAlphaValue:", 1 - progress);
  objj_msgSend(objj_msgSend(mController, "docListTitle"), "setAlphaValue:", 1 - progress);
  objj_msgSend(objj_msgSend(mController, "deleteBtn"), "setAlphaValue:", 1 - progress);
  objj_msgSend(objj_msgSend(mController, "generatePDFBtn"), "setAlphaValue:", 1 - progress);
 }
}
},["void","float"])]);
}
{var the_class = objj_allocateClassPair(CPAnimation, "HideSpreadListViewAnimation"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mStart"), new objj_ivar("mEnd"), new objj_ivar("mControlBoxDistance"), new objj_ivar("mSpreadViewDistance")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setStart:"), function $HideSpreadListViewAnimation__setStart_(self, _cmd, aValue)
{ with(self)
{
 mStart = aValue;
}
},["void","var"]), new objj_method(sel_getUid("start"), function $HideSpreadListViewAnimation__start(self, _cmd)
{ with(self)
{
 return mStart;
}
},["id"]), new objj_method(sel_getUid("setEnd:"), function $HideSpreadListViewAnimation__setEnd_(self, _cmd, aValue)
{ with(self)
{
 mEnd = aValue;
}
},["void","var"]), new objj_method(sel_getUid("end"), function $HideSpreadListViewAnimation__end(self, _cmd)
{ with(self)
{
 return mEnd;
}
},["id"]), new objj_method(sel_getUid("setControlBoxDistance:"), function $HideSpreadListViewAnimation__setControlBoxDistance_(self, _cmd, aValue)
{ with(self)
{
 mControlBoxDistance = aValue;
}
},["void","var"]), new objj_method(sel_getUid("controlBoxDistance"), function $HideSpreadListViewAnimation__controlBoxDistance(self, _cmd)
{ with(self)
{
 return mControlBoxDistance;
}
},["id"]), new objj_method(sel_getUid("setSpreadViewDistance:"), function $HideSpreadListViewAnimation__setSpreadViewDistance_(self, _cmd, aValue)
{ with(self)
{
 mSpreadViewDistance = aValue;
}
},["void","var"]), new objj_method(sel_getUid("spreadViewDistance"), function $HideSpreadListViewAnimation__spreadViewDistance(self, _cmd)
{ with(self)
{
 return mSpreadViewDistance;
}
},["id"]), new objj_method(sel_getUid("setCurrentProgress:"), function $HideSpreadListViewAnimation__setCurrentProgress_(self, _cmd, progress)
{ with(self)
{
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("HideSpreadListViewAnimation").super_class }, "setCurrentProgress:", progress);
 progress = objj_msgSend(self, "currentValue");
  var lOrgHeight = mEnd - mStart;
 var lYInc = (progress * lOrgHeight);
    var lYpos = lYInc + mStart;
 var lHeight = lOrgHeight - lYInc;
 var lFrame = objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadListScrollView"), "frame");
 lFrame.origin.y = lYpos;
 lFrame.size.height = lHeight;
 objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadListScrollView"), "setFrame:", lFrame);
 var lTFrame = objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "controlBox"), "frame");
 lTFrame.origin.y = lFrame.origin.y - mControlBoxDistance;
 objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "controlBox"), "setFrame:", lTFrame);
 lTFrame = objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadScrollView"), "frame");
 lTFrame.size.height = lFrame.origin.y - mSpreadViewDistance - lTFrame.origin.y;
 objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadScrollView"), "setFrame:", lTFrame);
}
},["void","float"])]);
}
{var the_class = objj_allocateClassPair(HideSpreadListViewAnimation, "ShowSpreadListViewAnimation"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setCurrentProgress:"), function $ShowSpreadListViewAnimation__setCurrentProgress_(self, _cmd, progress)
{ with(self)
{
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ShowSpreadListViewAnimation").super_class }, "setCurrentProgress:", progress);
 progress = objj_msgSend(self, "currentValue");
  var lOrgHeight = mStart - mEnd;
 var lYInc = (progress * lOrgHeight);
    var lYpos = mStart - lYInc;
 var lHeight = lYInc;
 var lFrame = objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadListScrollView"), "frame");
 lFrame.origin.y = lYpos;
 lFrame.size.height = lHeight;
 objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadListScrollView"), "setFrame:", lFrame);
 var lTFrame = objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "controlBox"), "frame");
 lTFrame.origin.y = lFrame.origin.y - mControlBoxDistance;
 objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "controlBox"), "setFrame:", lTFrame);
 lTFrame = objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadScrollView"), "frame");
 lTFrame.size.height = lFrame.origin.y - mSpreadViewDistance - lTFrame.origin.y;
 objj_msgSend(objj_msgSend(objj_msgSend(self, "delegate"), "spreadScrollView"), "setFrame:", lTFrame);
}
},["void","float"])]);
}

