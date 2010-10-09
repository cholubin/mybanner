@STATIC;1.0;I;21;Foundation/CPObject.jt;2244;


objj_executeFile("Foundation/CPObject.j", NO);

var ProgressStyleMask = CPBorderlessWindowMask;



var sharedProgressWindow = nil;

{var the_class = objj_allocateClassPair(CPWindow, "ProgressWindow"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $ProgressWindow__init(self, _cmd)
{ with(self)
{
 var lRect = CPRectMake(0, 0, 300, 200);
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ProgressWindow").super_class }, "initWithContentRect:styleMask:", lRect, ProgressStyleMask))
    {
        var lImgView = objj_msgSend(objj_msgSend(CPImageView, "alloc"), "initWithFrame:", lRect);
  var lImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", "Resources/spinner.gif");
  objj_msgSend(lImgView, "setImageScaling:", CPScaleNone)
  objj_msgSend(lImgView, "setImage:", lImage);
  objj_msgSend(objj_msgSend(self, "contentView"), "addSubview:", lImgView);
  objj_msgSend(lImage, "release");
  objj_msgSend(lImgView, "release");
    }
    return self;
}
},["id"]), new objj_method(sel_getUid("show"), function $ProgressWindow__show(self, _cmd)
{ with(self)
{
 var lMainWin = objj_msgSend(objj_msgSend(objj_msgSend(CPApplication, "sharedApplication"), "delegate"), "mainWindow");
 var lBoundsRect = objj_msgSend(objj_msgSend(lMainWin, "contentView"), "bounds");
 var lSelfFrame = objj_msgSend(self, "frame");
 var lPoint = CPPointMake(0, 0);
 var lBoundsSize = lBoundsRect.size;
 var lSelfSize = lSelfFrame.size;

 lPoint.x = (lBoundsSize.width - lSelfSize.width) / 2.0;
 lPoint.y = (lBoundsSize.height - lSelfSize.height) / 2.0;

 objj_msgSend(self, "setFrameOrigin:", lPoint);
 objj_msgSend(self, "makeKeyAndOrderFront:", self);
}
},["void"]), new objj_method(sel_getUid("hide"), function $ProgressWindow__hide(self, _cmd)
{ with(self)
{
 objj_msgSend(self, "orderOut:", self);

}
},["void"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("sharedWindow"), function $ProgressWindow__sharedWindow(self, _cmd)
{ with(self)
{
 if(!sharedProgressWindow) {
  sharedProgressWindow = objj_msgSend(objj_msgSend(ProgressWindow, "alloc"), "init");
 }
 return sharedProgressWindow;
}
},["id"])]);
}

