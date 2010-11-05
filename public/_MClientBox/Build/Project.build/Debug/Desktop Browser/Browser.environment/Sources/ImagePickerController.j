@STATIC;1.0;i;20;CollectionViewItem.jt;10096;

objj_executeFile("CollectionViewItem.j", YES);

gThumbSizeWidth = 100;
gThumbSizeHeight = 100;

{var the_class = objj_allocateClassPair(CPWindow, "ImagePickerWindow"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setStyleMask:"), function $ImagePickerWindow__setStyleMask_(self, _cmd, newMask)
{ with(self)
{
 _styleMask = newMask;
}
},["void","unsignedint"])]);
}

{var the_class = objj_allocateClassPair(CPObject, "ImagePickerController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("mImagePickerWin"), new objj_ivar("mCategoryPopup"), new objj_ivar("mImageCollectionView"), new objj_ivar("mPreviewImageView"), new objj_ivar("mTotalField"), new objj_ivar("mNameField"), new objj_ivar("mSizeField"), new objj_ivar("mReceiver"), new objj_ivar("mImageCategoryCon"), new objj_ivar("mImageListCon"), new objj_ivar("mNotiCenter")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $ImagePickerController__init(self, _cmd)
{ with(self)
{
 self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ImagePickerController").super_class }, "init");
 if(self) {
  objj_msgSend(CPBundle, "loadCibNamed:owner:", "ImagePicker", self);
 }
 return self;
}
},[null]), new objj_method(sel_getUid("dealloc"), function $ImagePickerController__dealloc(self, _cmd)
{ with(self)
{
 objj_msgSend(mReceiver, "release");
 objj_msgSendSuper({ receiver:self, super_class:objj_getClass("ImagePickerController").super_class }, "dealloc");
}
},["void"]), new objj_method(sel_getUid("cibDidFinishLoading:"), function $ImagePickerController__cibDidFinishLoading_(self, _cmd, anObj)
{ with(self)
{
}
},["void","id"]), new objj_method(sel_getUid("awakeFromCib"), function $ImagePickerController__awakeFromCib(self, _cmd)
{ with(self)
{


    var lItem = objj_msgSend(objj_msgSend(SDCollectionViewItem, "alloc"), "init");

   objj_msgSend(mImageCollectionView, "setMinItemSize:", CPSizeMake(gThumbSizeWidth, gThumbSizeHeight));
 objj_msgSend(mImageCollectionView, "setSelectable:", YES);
 objj_msgSend(mImageCollectionView, "setDelegate:", self);
 objj_msgSend(mImageCollectionView, "setBackgroundColor:", objj_msgSend(CPColor, "lightGrayColor"));

 objj_msgSend(objj_msgSend(mPreviewImageView, "superview"), "setBackgroundColor:", objj_msgSend(CPColor, "lightGrayColor"));
 objj_msgSend(mPreviewImageView, "setImageScaling:", CPScaleProportionally);

    var lCellWidth = objj_msgSend(mImageCollectionView, "minItemSize").width;
    var lCellHeight = objj_msgSend(mImageCollectionView, "minItemSize").height;
    var lCellFrame = CPRectMake(0, 0, lCellWidth, lCellHeight);
    var lDocThumbView = objj_msgSend(objj_msgSend(SDImageView, "alloc"), "initWithFrame:", lCellFrame);
    var lItem = objj_msgSend(objj_msgSend(SDCollectionViewItem, "alloc"), "init");
    objj_msgSend(lItem, "setView:", lDocThumbView);
 objj_msgSend(mImageCollectionView, "setItemPrototype:", lItem);
 objj_msgSend(mImagePickerWin, "setDelegate:", self);



}
},["void"]), new objj_method(sel_getUid("changeCategory:"), function $ImagePickerController__changeCategory_(self, _cmd, sender)
{ with(self)
{
 var category = objj_msgSend(mCategoryPopup, "titleOfSelectedItem");
 objj_msgSend(mCategoryPopup, "setEnabled:", NO);

    var lDocWebImageURL = objj_msgSend(CPString, "stringWithFormat:", "%@/filelist?request=/images/%@/",gBaseURL ,category);
    var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocWebImageURL);
    mImageListCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
}
},["@action","id"]), new objj_method(sel_getUid("loadImages:list:"), function $ImagePickerController__loadImages_list_(self, _cmd, lFilename, lItemList)
{ with(self)
{


 var ext = objj_msgSend(lFilename, "pathExtension");
 if(ext.length < 3)
  return;
 if(objj_msgSend(lFilename, "isEqualToString:", ext))
  return;
 var lCategory = objj_msgSend(mCategoryPopup, "titleOfSelectedItem");
 var lImageName = objj_msgSend(lFilename, "substringToIndex:", objj_msgSend(lFilename, "length") - objj_msgSend(ext, "length") - 1);
 lImageName = lImageName + ".jpg";
    var lImagePath = objj_msgSend(CPString, "stringWithString:", gUserPath+"/images/"+lCategory+"/"+lFilename);
    var lImageThumbPath = objj_msgSend(CPString, "stringWithString:", gBaseURL+gUserPath+"/images/"+lCategory+"/Thumb/"+lImageName);
    var lThumbImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lImageThumbPath);
 var dict = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
 objj_msgSend(dict, "setObject:forKey:", lThumbImage, "image");
 objj_msgSend(dict, "setObject:forKey:", lImagePath, "path");
    objj_msgSend(lItemList, "addObject:", dict);
}
},["void","var","var"]), new objj_method(sel_getUid("ok:"), function $ImagePickerController__ok_(self, _cmd, sender)
{ with(self)
{
 var lIdx = objj_msgSend(objj_msgSend(mImageCollectionView, "selectionIndexes"), "firstIndex");
 if(lIdx >= 0) {
  var lImgList = objj_msgSend(mImageCollectionView, "content");
  if(objj_msgSend(lImgList, "count") > 0) {
   var lDict = objj_msgSend(lImgList, "objectAtIndex:", lIdx);
   var lImagePath = objj_msgSend(lDict, "objectForKey:", "path");
   objj_msgSend(mReceiver, "setNewImagePathToImageView:", lImagePath);
  }
 }

 objj_msgSend(mImagePickerWin, "close");
}
},["@action","id"]), new objj_method(sel_getUid("cancel:"), function $ImagePickerController__cancel_(self, _cmd, sender)
{ with(self)
{

 objj_msgSend(mImagePickerWin, "close");
}
},["@action","id"]), new objj_method(sel_getUid("runModalForReceiver:"), function $ImagePickerController__runModalForReceiver_(self, _cmd, aReceiver)
{ with(self)
{
 if(mReceiver)
  objj_msgSend(mReceiver, "release");
 mReceiver = objj_msgSend(aReceiver, "retain");

    var lDocWebImageURL = objj_msgSend(CPString, "stringWithFormat:", "%@/filelist?request=/images/",gBaseURL);
    var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocWebImageURL);
    mImageCategoryCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
 objj_msgSend(mCategoryPopup, "setEnabled:", NO);

 objj_msgSend(mImagePickerWin, "makeKeyAndOrderFront:", self);
 objj_msgSend(objj_msgSend(CPApplication, "sharedApplication"), "runModalForWindow:", mImagePickerWin);
}
},["void","id"]), new objj_method(sel_getUid("connection:didFailWithError:"), function $ImagePickerController__connection_didFailWithError_(self, _cmd, connection, error)
{ with(self)
{
    alert("Connection did fail with error : " + error) ;
}
},["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("connectionDidFinishLoading:"), function $ImagePickerController__connectionDidFinishLoading_(self, _cmd, aConnection)
{ with(self)
{

}
},["void","CPURLConnection"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $ImagePickerController__connection_didReceiveData_(self, _cmd, connection, data)
{ with(self)
{
    if (connection === mImageCategoryCon)
    {
  objj_msgSend(mCategoryPopup, "removeAllItems");
     var lPathList = objj_msgSend(data, "componentsSeparatedByString:", "\n");
  var i;
  for(i=0;i<objj_msgSend(lPathList, "count");i++) {
   var lCatName = objj_msgSend(lPathList, "objectAtIndex:", i);
   if(objj_msgSend(lCatName, "length"))
    objj_msgSend(mCategoryPopup, "addItemWithTitle:", lCatName);
  }
  objj_msgSend(mCategoryPopup, "selectItemAtIndex:", 0);
  objj_msgSend(self, "changeCategory:", mCategoryPopup);
 }
 else if(connection === mImageListCon) {
     var lPathList = objj_msgSend(data, "componentsSeparatedByString:", "\n");
     var lItemList = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
     var i;
     for(i=0;i<lPathList.length; i++) {
   var lImageName = objj_msgSend(lPathList, "objectAtIndex:", i);
   if(objj_msgSend(lImageName, "length"))
          objj_msgSend(self, "loadImages:list:", lImageName, lItemList);
     }

  objj_msgSend(mImageCollectionView, "setContent:", lItemList);
  objj_msgSend(mCategoryPopup, "setEnabled:", YES);
 }
}
},["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("collectionViewDidChangeSelection:"), function $ImagePickerController__collectionViewDidChangeSelection_(self, _cmd, collectionView)
{ with(self)
{
 if(collectionView === mImageCollectionView) {

  var lIdx = objj_msgSend(objj_msgSend(mImageCollectionView, "selectionIndexes"), "firstIndex");
  var lDict = objj_msgSend(objj_msgSend(mImageCollectionView, "content"), "objectAtIndex:", lIdx);
     var lImagePath = objj_msgSend(lDict, "objectForKey:", "path");
  var lFilename = objj_msgSend(lImagePath, "lastPathComponent");
  var ext = objj_msgSend(lFilename, "pathExtension");
  if(ext.length < 3) {
   objj_msgSend(mPreviewImageView, "setImage:", nil);
   return;
  }
  var lImageName = objj_msgSend(lFilename, "substringToIndex:", objj_msgSend(lFilename, "length") - objj_msgSend(ext, "length") - 1);
  var lPreviewFilename = lImageName + ".jpg";
  var lImageFolder = objj_msgSend(lImagePath, "stringByDeletingLastPathComponent");

     var lImagePreviewPath = gBaseURL + lImageFolder+"/Preview/"+lPreviewFilename;
     var lPreviewImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lImagePreviewPath);
  objj_msgSend(mPreviewImageView, "setImage:", lPreviewImage);
  objj_msgSend(lPreviewImage, "release");
 }
}
},["void","CPCollectionView"]), new objj_method(sel_getUid("windowWillCloseNotification:"), function $ImagePickerController__windowWillCloseNotification_(self, _cmd, notification)
{ with(self)
{
 if(objj_msgSend(notification, "object") == mImagePickerWin) {
  debugger;
  objj_msgSend(objj_msgSend(CPApplication, "sharedApplication"), "stopModal");

 }

}
},["void","CPNotification"]), new objj_method(sel_getUid("windowWillClose:"), function $ImagePickerController__windowWillClose_(self, _cmd, aWin)
{ with(self)
{
 if(aWin == mImagePickerWin) {
  debugger;
  objj_msgSend(objj_msgSend(CPApplication, "sharedApplication"), "stopModal");

 }

}
},["void","id"])]);
}

