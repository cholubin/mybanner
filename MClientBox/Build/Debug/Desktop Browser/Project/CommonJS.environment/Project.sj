@STATIC;1.0;p;15;AppController.jt;21920;@STATIC;1.0;I;21;Foundation/CPObject.ji;16;SpreadEditView.ji;20;CollectionViewItem.ji;16;ProgressWindow.ji;20;CollectionViewItem.jt;21782;objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("SpreadEditView.j", YES);
objj_executeFile("CollectionViewItem.j", YES);
objj_executeFile("ProgressWindow.j", YES);
objj_executeFile("CollectionViewItem.j", YES);
var SliderToolbarItemIdentifier = "SliderToolbarItemIdentifier",
    PDFToolbarItemIdentifier = "PDFToolbarItemIdentifier",
    RemoveToolbarItemIdentifier = "RemoveToolbarItemIdentifier";
gDefBaseURL = "http://211.35.79.131:3000";
gBaseURL = "";
gUserPath = "";
var gFactorList = Array(0.25, 0.5, 1.0, 2.0, 3.0);
gListViewHeight = 100;
gDocItemSizeWidth = 90;
gDocItemSizeHeight = 90;
{var the_class = objj_allocateClassPair(CPObject, "AppController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("theWindow"), new objj_ivar("mSpreadView"), new objj_ivar("mScrollView"), new objj_ivar("mSpreadListView"), new objj_ivar("mPopupButton"), new objj_ivar("mEditController"), new objj_ivar("mCurDocPath"), new objj_ivar("mLocalDocPath"), new objj_ivar("mCurDocImageListCon"), new objj_ivar("mFrameListCon"), new objj_ivar("mCurDocImageRefreshCon"), new objj_ivar("mGeneratePDFCon"), new objj_ivar("mNewPreviewCon"), new objj_ivar("mNotiCenter")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("awakeFromCib"), function $AppController__awakeFromCib(self, _cmd)
{ with(self)
{
}
},["void"]), new objj_method(sel_getUid("applicationDidFinishLaunching:"), function $AppController__applicationDidFinishLaunching_(self, _cmd, aNotification)
{ with(self)
{
   var theWindow = objj_msgSend(objj_msgSend(CPWindow, "alloc"), "initWithContentRect:styleMask:", CGRectMakeZero(), CPBorderlessBridgeWindowMask);
        contentView = objj_msgSend(theWindow, "contentView");
    var toolbar = objj_msgSend(objj_msgSend(CPToolbar, "alloc"), "initWithIdentifier:", "Photos");
 objj_msgSend(toolbar, "setDelegate:", self);
 objj_msgSend(toolbar, "setVisible:", true);
 objj_msgSend(theWindow, "setToolbar:", toolbar);
 objj_msgSend(theWindow, "setAcceptsMouseMovedEvents:", YES);
 if(location.protocol === "file:") {
  gBaseURL = gDefBaseURL;
 }
 else {
  gBaseURL = "http://"+location.host;
 }
 var args = objj_msgSend(objj_msgSend(CPApplication, "sharedApplication"), "namedArguments");
 gUserPath = objj_msgSend(args, "objectForKey:", "user_path");
 if(!gUserPath) {
  alert("No 'user_path' parameter.");
 }
  mLocalDocPath = objj_msgSend(args, "objectForKey:", "doc_path");
 if(mLocalDocPath) {
  var lFilename = objj_msgSend(mLocalDocPath, "lastPathComponent");
  mCurDocPath = objj_msgSend(CPString, "stringWithFormat:", "%@%@%@",gBaseURL, gUserPath, mLocalDocPath);
  var lDocWebImageURL = objj_msgSend(CPString, "stringWithFormat:", "%@/filelist?request=%@/web/",gBaseURL, mLocalDocPath);
  var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocWebImageURL);
  objj_msgSend(mEditController, "setDocumentName:", lFilename);
  mCurDocImageListCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
 }
 var lboolUseSpreadList = NO;
 var lstrUseSpreadList = objj_msgSend(args, "objectForKey:", "spread_list");
 if(lstrUseSpreadList && objj_msgSend(objj_msgSend(lstrUseSpreadList, "uppercaseString"), "isEqualToString:", "YES")) {
  lboolUseSpreadList = YES;
 }
 var lScrollViewFrame = objj_msgSend(contentView, "bounds");
 if(lboolUseSpreadList) {
  lScrollViewFrame.size.height -= gListViewHeight;
 }
 mScrollView = objj_msgSend(objj_msgSend(CPScrollView, "alloc"), "initWithFrame:", lScrollViewFrame);
 objj_msgSend(mScrollView, "setAutoresizingMask:", CPViewWidthSizable | CPViewHeightSizable);
 var lSpreadViewFrame = objj_msgSend(mScrollView, "bounds");
 mSpreadView = objj_msgSend(objj_msgSend(SpreadEditView, "alloc"), "initWithFrame:", lSpreadViewFrame);
 var lContentView = objj_msgSend(mScrollView, "contentView");
 if(lContentView) {
     objj_msgSend(mSpreadView, "setCenter:", objj_msgSend(lContentView, "center"));
  objj_msgSend(lContentView, "setBackgroundColor:", objj_msgSend(CPColor, "grayColor"));
 }
 objj_msgSend(mScrollView, "setDocumentView:", mSpreadView);
 mNotiCenter = objj_msgSend(CPNotificationCenter, "defaultCenter");
 objj_msgSend(mNotiCenter, "addObserver:selector:name:object:", self, sel_getUid("repositionSpreadView:"), CPWindowDidResizeNotification, theWindow);
 if(objj_msgSend(mSpreadView, "drawingView")) {
  objj_msgSend(objj_msgSend(mSpreadView, "drawingView"), "setController:", mEditController);
  objj_msgSend(mEditController, "setAppController:", self);
 }
 objj_msgSend(mSpreadView, "setBackgroundColor:", objj_msgSend(CPColor, "lightGrayColor"));
 objj_msgSend(objj_msgSend(mSpreadView, "imageView"), "setImageScaling:", CPScaleProportionally);
 var lBounds = objj_msgSend(objj_msgSend(mScrollView, "contentView"), "bounds");
 objj_msgSend(mSpreadView, "setFrame:", lBounds);
 objj_msgSend(mScrollView, "removeFromSuperview");
 objj_msgSend(contentView, "addSubview:", mScrollView);
 if(lboolUseSpreadList) {
  var lListViewFrame = CGRectMake(0, CPRectGetMaxY(lScrollViewFrame), lScrollViewFrame.size.width, gListViewHeight);
  mSpreadListView = objj_msgSend(objj_msgSend(CPCollectionView, "alloc"), "initWithFrame:", lListViewFrame);
  objj_msgSend(mSpreadListView, "setAutoresizingMask:", CPViewWidthSizable | CPViewMinYMargin);
  objj_msgSend(mSpreadListView, "setMaxItemSize:", CPSizeMake(gDocItemSizeWidth, gDocItemSizeHeight));
    objj_msgSend(mSpreadListView, "setMinItemSize:", CPSizeMake(gDocItemSizeWidth, gDocItemSizeHeight));
  objj_msgSend(mSpreadListView, "setSelectable:", YES);
  objj_msgSend(mSpreadListView, "setDelegate:", self);
  objj_msgSend(mSpreadListView, "setBackgroundColor:", objj_msgSend(CPColor, "lightGrayColor"));
  objj_msgSend(mSpreadListView, "setAllowsMultipleSelection:", NO);
  objj_msgSend(mSpreadListView, "setAllowsEmptySelection:", NO);
  objj_msgSend(contentView, "addSubview:", mSpreadListView);
  objj_msgSend(mSpreadListView, "release");
     var lCellFrame = CPRectMake(0, 0, gDocItemSizeWidth, gDocItemSizeHeight);
     var lDocThumbView = objj_msgSend(objj_msgSend(SDImageView, "alloc"), "initWithFrame:", lCellFrame);
     var lItem = objj_msgSend(objj_msgSend(SDCollectionViewItem, "alloc"), "init");
     objj_msgSend(lItem, "setView:", lDocThumbView);
  objj_msgSend(mSpreadListView, "setItemPrototype:", lItem);
  objj_msgSend(lItem, "release");
  objj_msgSend(lDocThumbView, "release");
 }
    objj_msgSend(theWindow, "orderFront:", self);
}
},["void","CPNotification"]), new objj_method(sel_getUid("repositionSpreadView:"), function $AppController__repositionSpreadView_(self, _cmd, notification)
{ with(self)
{
 objj_msgSend(mSpreadView, "reposition:", notification);
}
},["void","CPNotification"]), new objj_method(sel_getUid("spreadPreviewPathAtPage:filelist:"), function $AppController__spreadPreviewPathAtPage_filelist_(self, _cmd, pgno, lPathList)
{ with(self)
{
 var lTarFileFront = objj_msgSend(CPString, "stringWithFormat:", "spread_preview_%04d",pgno);
 var i;
 for(i=0;i<lPathList.length;i++) {
  var lFile = objj_msgSend(lPathList, "objectAtIndex:", i);
  var lExt = objj_msgSend(lFile, "pathExtension");
  if(!objj_msgSend(lExt, "isEqualToString:", "jpg"))
   continue;
  if(objj_msgSend(lFile, "length") >= objj_msgSend(lTarFileFront, "length") + 4) {
   var lFileFront = objj_msgSend(lFile, "substringToIndex:", objj_msgSend(lTarFileFront, "length"));
   if(objj_msgSend(lFileFront, "isEqualToString:", lTarFileFront)) {
    var lRetstr = objj_msgSend(CPString, "stringWithFormat:", "%@/web/%@",mCurDocPath,lFile);
    return lRetstr;
   }
  }
 }
 return nil;
}
},["CPString","int","CPArray"]), new objj_method(sel_getUid("spreadThumbnailPathAtPage:filelist:"), function $AppController__spreadThumbnailPathAtPage_filelist_(self, _cmd, pgno, lPathList)
{ with(self)
{
 var lTarFileFront = objj_msgSend(CPString, "stringWithFormat:", "spread_thumb_%04d",pgno);
 var i;
 for(i=0;i<lPathList.length;i++) {
  var lFile = objj_msgSend(lPathList, "objectAtIndex:", i);
  var lExt = objj_msgSend(lFile, "pathExtension");
  if(!objj_msgSend(lExt, "isEqualToString:", "jpg"))
   continue;
  if(objj_msgSend(lFile, "length") >= objj_msgSend(lTarFileFront, "length") + 4) {
   var lFileFront = objj_msgSend(lFile, "substringToIndex:", objj_msgSend(lTarFileFront, "length"));
   if(objj_msgSend(lFileFront, "isEqualToString:", lTarFileFront)) {
    var lRetstr = objj_msgSend(CPString, "stringWithFormat:", "%@/web/%@",mCurDocPath,lFile);
    return lRetstr;
   }
  }
 }
 return nil;
}
},["CPString","int","CPArray"]), new objj_method(sel_getUid("loadSpreadThumbnails:"), function $AppController__loadSpreadThumbnails_(self, _cmd, data)
{ with(self)
{
    var lPathList = objj_msgSend(data, "componentsSeparatedByString:", "\n");
 if(mSpreadListView) {
  var pgno = 1;
     var lItemList = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
  var lSpreadThumbPath = objj_msgSend(self, "spreadThumbnailPathAtPage:filelist:", pgno++, lPathList);
  while(lSpreadThumbPath) {
      var lThumbImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lSpreadThumbPath);
   var dict = objj_msgSend(CPDictionary, "dictionaryWithObject:forKey:", lThumbImage, "image");
      objj_msgSend(lItemList, "addObject:", dict);
   objj_msgSend(lThumbImage, "release");
   lSpreadThumbPath = objj_msgSend(self, "spreadThumbnailPathAtPage:filelist:", pgno++, lPathList);
  }
     objj_msgSend(mSpreadListView, "setContent:", lItemList);
  var lIdx = objj_msgSend(objj_msgSend(mSpreadListView, "selectionIndexes"), "firstIndex");
  if(lIdx < 0) {
   var lSelectIdx = objj_msgSend(objj_msgSend(CPIndexSet, "alloc"), "initWithIndex:", 0);
   objj_msgSend(mSpreadListView, "setSelectionIndexes:", lSelectIdx);
   objj_msgSend(lSelectIdx, "release");
   lIdx = 0;
  }
  var lSpreadPreviewPath = objj_msgSend(self, "spreadPreviewPathAtPage:filelist:", lIdx+1, lPathList);
  if(lSpreadPreviewPath) {
      var lImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lSpreadPreviewPath);
   objj_msgSend(mSpreadView, "setSpreadImage:", lImage);
   objj_msgSend(lImage, "release");
  }
 }
 else {
  var lSpreadPreviewPath = objj_msgSend(self, "spreadPreviewPathAtPage:filelist:", 1, lPathList);
  if(lSpreadPreviewPath) {
      var lImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lSpreadPreviewPath);
   objj_msgSend(mSpreadView, "setSpreadImage:", lImage);
   objj_msgSend(lImage, "release");
  }
 }
}
},["void","CPString"]), new objj_method(sel_getUid("mainWindow"), function $AppController__mainWindow(self, _cmd)
{ with(self)
{
 return theWindow;
}
},["id"]), new objj_method(sel_getUid("sendFrameListRequest"), function $AppController__sendFrameListRequest(self, _cmd)
{ with(self)
{
 var lSpreadIdx = objj_msgSend(objj_msgSend(mSpreadListView, "selectionIndexes"), "firstIndex");
 if(lSpreadIdx >= 0) {
  var lFilename = objj_msgSend(mCurDocPath, "lastPathComponent");
     var lDocOpenURL = objj_msgSend(CPString, "stringWithFormat:", "%@/request_mlayout?requested_action=FrameList&docname=%@&userinfo=%d",gBaseURL ,lFilename,lSpreadIdx);
     var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocOpenURL);
     mFrameListCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
 }
}
},["void"]), new objj_method(sel_getUid("loadFrameList:"), function $AppController__loadFrameList_(self, _cmd, data)
{ with(self)
{
 debugger;
 var lFrameList = objj_msgSend(data, "componentsSeparatedByString:", "\n");
 var i = 0, icnt = objj_msgSend(lFrameList, "count");
 var drawingView = objj_msgSend(mSpreadView, "drawingView") ;
 objj_msgSend(drawingView, "clearFrameList");
 var lFrameStr = objj_msgSend(lFrameList, "objectAtIndex:", i++);
 if(objj_msgSend(lFrameStr, "length") === 0)
  lFrameStr = objj_msgSend(lFrameList, "objectAtIndex:", i++);
 var lItemList = objj_msgSend(lFrameStr, "componentsSeparatedByString:", ",");
 var lWidth = objj_msgSend(objj_msgSend(lItemList, "objectAtIndex:", 3), "floatValue");
 var lHeight = objj_msgSend(objj_msgSend(lItemList, "objectAtIndex:", 4), "floatValue");
 var lSize = CPSizeMake(lWidth, lHeight);
 objj_msgSend(drawingView, "setSpreadSize:", lSize);
 for(;i<icnt;i++) {
  lFrameStr = objj_msgSend(lFrameList, "objectAtIndex:", i);
  if(objj_msgSend(lFrameStr, "length") < 10)
   continue;
  lItemList = objj_msgSend(lFrameStr, "componentsSeparatedByString:", ",");
  if(objj_msgSend(lItemList, "count") < 5)
   continue;
  var lGID = objj_msgSend(objj_msgSend(lItemList, "objectAtIndex:", 0), "intValue");
  var lLeft = objj_msgSend(objj_msgSend(lItemList, "objectAtIndex:", 1), "floatValue");
  var lTop = objj_msgSend(objj_msgSend(lItemList, "objectAtIndex:", 2), "floatValue");
  lWidth = objj_msgSend(objj_msgSend(lItemList, "objectAtIndex:", 3), "floatValue");
  lHeight = objj_msgSend(objj_msgSend(lItemList, "objectAtIndex:", 4), "floatValue");
  var lRect = CPRectMake(lLeft, lTop, lWidth, lHeight);
  var lGFrame = objj_msgSend(objj_msgSend(GraphicFrame, "alloc"), "initWithRect:gid:", lRect, lGID);
  objj_msgSend(drawingView, "addFrame:", lGFrame);
 }
}
},["void","CPString"]), new objj_method(sel_getUid("changeScale:"), function $AppController__changeScale_(self, _cmd, sender)
{ with(self)
{
 var scaleIdx = objj_msgSend(sender, "indexOfSelectedItem");
 var factor = gFactorList[scaleIdx];
 objj_msgSend(mSpreadView, "setScaleFactor:", factor);
 objj_msgSend(mSpreadView, "rescale");
}
},["void","id"]), new objj_method(sel_getUid("generatePDF:"), function $AppController__generatePDF_(self, _cmd, sender)
{ with(self)
{
 if(confirm("Are you sure?")) {
  var lFilename = objj_msgSend(mCurDocPath, "lastPathComponent");
  var lExtLen = objj_msgSend(objj_msgSend(lFilename, "pathExtension"), "length");
  var lFilenameNoExt = objj_msgSend(lFilename, "substringToIndex:", objj_msgSend(lFilename, "length")-lExtLen-1);
  var lDocumentID = objj_msgSend(lFilenameNoExt, "lastPathComponent");
     var lDocOpenURL = objj_msgSend(CPString, "stringWithFormat:", "%@/publish/%@",gBaseURL ,lDocumentID);
     var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocOpenURL);
  objj_msgSend(objj_msgSend(ProgressWindow, "sharedWindow"), "show");
    mGeneratePDFCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
 }
}
},["@action","id"]), new objj_method(sel_getUid("refreshSpreadListView"), function $AppController__refreshSpreadListView(self, _cmd)
{ with(self)
{
    var lDocWebImageURL = objj_msgSend(CPString, "stringWithFormat:", "%@/filelist?request=%@/web/",gBaseURL, mLocalDocPath);
    var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocWebImageURL);
    mCurDocImageRefreshCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
}
},["void"]), new objj_method(sel_getUid("loadSpreadPreview:"), function $AppController__loadSpreadPreview_(self, _cmd, data)
{ with(self)
{
    var lPathList = objj_msgSend(data, "componentsSeparatedByString:", "\n");
 var lIdx = objj_msgSend(objj_msgSend(mSpreadListView, "selectionIndexes"), "firstIndex");
 var lSpreadPreviewPath = objj_msgSend(self, "spreadPreviewPathAtPage:filelist:", lIdx+1, lPathList)
    var lImage = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:", lSpreadPreviewPath);
 objj_msgSend(mSpreadView, "setSpreadImage:", lImage);
 objj_msgSend(lImage, "release");
}
},["void","CPString"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $AppController__connection_didReceiveData_(self, _cmd, connection, data)
{ with(self)
{
  if( connection === mCurDocImageListCon) {
  objj_msgSend(self, "loadSpreadThumbnails:", data);
  if(objj_msgSend(mSpreadView, "drawingView")) {
   objj_msgSend(self, "sendFrameListRequest");
  }
 }
  else if( connection === mCurDocImageRefreshCon) {
  objj_msgSend(self, "loadSpreadThumbnails:", data);
 }
 else if(connection === mFrameListCon) {
  objj_msgSend(self, "loadFrameList:", data);
 }
 else if( connection === mNewPreviewCon) {
  objj_msgSend(self, "loadSpreadPreview:", data);
 }
 else if( connection === mGeneratePDFCon) {
  objj_msgSend(objj_msgSend(ProgressWindow, "sharedWindow"), "hide");
  alert("PDF generated successfully.");
 }
}
},["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("toolbarDefaultItemIdentifiers:"), function $AppController__toolbarDefaultItemIdentifiers_(self, _cmd, aToolbar)
{ with(self)
{
   return [PDFToolbarItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier, SliderToolbarItemIdentifier];
}
},["CPArray","CPToolbar"]), new objj_method(sel_getUid("toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:"), function $AppController__toolbar_itemForItemIdentifier_willBeInsertedIntoToolbar_(self, _cmd, aToolbar, anItemIdentifier, aFlag)
{ with(self)
{
    var toolbarItem = objj_msgSend(objj_msgSend(CPToolbarItem, "alloc"), "initWithItemIdentifier:", anItemIdentifier);
    if (anItemIdentifier == SliderToolbarItemIdentifier)
    {
  mPopupButton = objj_msgSend(objj_msgSend(CPPopUpButton, "alloc"), "initWithFrame:", CGRectMake(0, 0, 80, 24));
  objj_msgSend(mPopupButton, "removeAllItems");
  objj_msgSend(mPopupButton, "addItemWithTitle:", "25%");
  objj_msgSend(mPopupButton, "addItemWithTitle:", "50%");
   objj_msgSend(mPopupButton, "addItemWithTitle:", "100%");
  objj_msgSend(mPopupButton, "addItemWithTitle:", "200%");
   objj_msgSend(mPopupButton, "addItemWithTitle:", "300%");
  objj_msgSend(mPopupButton, "selectItemAtIndex:", 2);
        objj_msgSend(toolbarItem, "setTarget:", self);
  objj_msgSend(mPopupButton, "setAction:", sel_getUid("changeScale:"));
       objj_msgSend(toolbarItem, "setView:", mPopupButton);
        objj_msgSend(toolbarItem, "setMinSize:", CGSizeMake(100, 24));
        objj_msgSend(toolbarItem, "setMaxSize:", CGSizeMake(100, 24));
        objj_msgSend(toolbarItem, "setLabel:", "Scale");
    }
    else if (anItemIdentifier == PDFToolbarItemIdentifier)
    {
        var image = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:size:", "Resources/pdf.png", CPSizeMake(30, 25));
        var highlighted = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:size:", "Resources/pdfHighlighted.png", CPSizeMake(30, 25));
        objj_msgSend(toolbarItem, "setImage:", image);
        objj_msgSend(toolbarItem, "setAlternateImage:", highlighted);
        objj_msgSend(toolbarItem, "setTarget:", self);
        objj_msgSend(toolbarItem, "setAction:", sel_getUid("generatePDF:"));
        objj_msgSend(toolbarItem, "setLabel:", "Generate PDF");
        objj_msgSend(toolbarItem, "setMinSize:", CGSizeMake(32, 32));
        objj_msgSend(toolbarItem, "setMaxSize:", CGSizeMake(32, 32));
    }
    return toolbarItem;
}
},["CPToolbarItem","CPToolbar","CPString","BOOL"]), new objj_method(sel_getUid("refreshSpreadPreview"), function $AppController__refreshSpreadPreview(self, _cmd)
{ with(self)
{
     var lDocWebImageURL = objj_msgSend(CPString, "stringWithFormat:", "%@/filelist?request=%@/web/",gBaseURL, mLocalDocPath);
     var lRequest = objj_msgSend(CPURLRequest, "requestWithURL:", lDocWebImageURL);
     mNewPreviewCon = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", lRequest, self);
}
},["void"]), new objj_method(sel_getUid("collectionViewDidChangeSelection:"), function $AppController__collectionViewDidChangeSelection_(self, _cmd, collectionView)
{ with(self)
{
 if(collectionView === mSpreadListView) {
  objj_msgSend(self, "refreshSpreadPreview");
  if(objj_msgSend(mSpreadView, "drawingView")) {
   objj_msgSend(self, "sendFrameListRequest");
  }
 }
}
},["void","CPCollectionView"])]);
}
{
var the_class = objj_getClass("CPTextField")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPTextField\"");
var meta_class = the_class.isa;class_addMethods(meta_class, [new objj_method(sel_getUid("flickr_labelWithText:"), function $CPTextField__flickr_labelWithText_(self, _cmd, aString)
{ with(self)
{
    var label = objj_msgSend(objj_msgSend(CPTextField, "alloc"), "initWithFrame:", CGRectMakeZero());
    objj_msgSend(label, "setStringValue:", aString);
    objj_msgSend(label, "sizeToFit");
    objj_msgSend(label, "setTextShadowColor:", objj_msgSend(CPColor, "whiteColor"));
    objj_msgSend(label, "setTextShadowOffset:", CGSizeMake(0, 1));
    return label;
}
},["CPTextField","CPString"])]);
}
{var the_class = objj_allocateClassPair(CPView, "PhotoResizeView"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $PhotoResizeView__initWithFrame_(self, _cmd, aFrame)
{ with(self)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("PhotoResizeView").super_class }, "initWithFrame:", aFrame);
    var slider = objj_msgSend(objj_msgSend(CPSlider, "alloc"), "initWithFrame:", CGRectMake(30, CGRectGetHeight(aFrame)/2.0 - 8, CGRectGetWidth(aFrame) - 65, 24));
    objj_msgSend(slider, "setMinValue:", 50.0);
    objj_msgSend(slider, "setMaxValue:", 250.0);
    objj_msgSend(slider, "setIntValue:", 150.0);
    objj_msgSend(slider, "setAction:", sel_getUid("adjustImageSize:"));
    objj_msgSend(self, "addSubview:", slider);
    var label = objj_msgSend(CPTextField, "flickr_labelWithText:", "50");
    objj_msgSend(label, "setFrameOrigin:", CGPointMake(0, CGRectGetHeight(aFrame)/2.0 - 4.0));
    objj_msgSend(self, "addSubview:", label);
    label = objj_msgSend(CPTextField, "flickr_labelWithText:", "250");
    objj_msgSend(label, "setFrameOrigin:", CGPointMake(CGRectGetWidth(aFrame) - CGRectGetWidth(objj_msgSend(label, "frame")), CGRectGetHeight(aFrame)/2.0 - 4.0));
    objj_msgSend(self, "addSubview:", label);
    return self;
}
},["id","CGRect"])]);
}

p;20;CollectionViewItem.jt;12117;@STATIC;1.0;t;12097;




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

p;13;DrawingView.jt;39855;@STATIC;1.0;I;21;Foundation/CPObject.ji;23;ImagePickerController.ji;20;StyledTextEditView.ji;52;com/cetrasoft/components/formatbar/CSEditorWebView.ji;14;ImageTrimmer.ji;16;ProgressWindow.jt;39659;

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

p;23;ImagePickerController.jt;10141;@STATIC;1.0;i;20;CollectionViewItem.jt;10096;

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

p;14;ImageTrimmer.jt;10490;@STATIC;1.0;I;21;Foundation/CPObject.jt;10444;


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

p;6;main.jt;295;@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.ji;15;AppController.jt;209;objj_executeFile("Foundation/Foundation.j", NO);
objj_executeFile("AppKit/AppKit.j", NO);
objj_executeFile("AppController.j", YES);
main= function(args, namedArgs)
{
    CPApplicationMain(args, namedArgs);
}

p;16;ProgressWindow.jt;2289;@STATIC;1.0;I;21;Foundation/CPObject.jt;2244;


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

p;16;SpreadEditView.jt;5463;@STATIC;1.0;I;21;Foundation/CPObject.ji;13;DrawingView.ji;16;ProgressWindow.jt;5379;

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

p;20;StyledTextEditView.jt;15665;@STATIC;1.0;I;15;AppKit/CPView.ji;52;com/cetrasoft/components/formatbar/CSEditorWebView.jt;15568;


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

p;52;com/cetrasoft/components/formatbar/CSEditorWebView.jt;984;@STATIC;1.0;I;21;Foundation/CPObject.jt;940;objj_executeFile("Foundation/CPObject.j", NO);
{var the_class = objj_allocateClassPair(CPWebView, "CSEditorWebView"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $CSEditorWebView__initWithFrame_(self, _cmd, rect)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSEditorWebView").super_class }, "initWithFrame:", rect)) {
  objj_msgSend(self, "loadHTMLString:", "");
  objj_msgSend(self, "setFrameLoadDelegate:", self);
 }
 return self;
}
},["id","CGRect*"]), new objj_method(sel_getUid("webView:didFinishLoadForFrame:"), function $CSEditorWebView__webView_didFinishLoadForFrame_(self, _cmd, aWebView, aFrame)
{ with(self)
{
 CPLog.debug("webView: " + aWebView + " didFinishLoadForFrame: " + aFrame);
 objj_msgSend(self, "DOMWindow").document.designMode = "On";
}
},["void","CPWebView","id"])]);
}

p;48;com/cetrasoft/components/formatbar/CSFormatBar.jt;16325;@STATIC;1.0;I;21;Foundation/CPObject.ji;24;CSFormatBarPopUpButton.ji;28;CSFormatBarColorWellButton.ji;22;CSFormatBarSeparator.ji;21;CSFormatBarFontMenu.jt;16164;objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("CSFormatBarPopUpButton.j", YES);
objj_executeFile("CSFormatBarColorWellButton.j", YES);
objj_executeFile("CSFormatBarSeparator.j", YES);
objj_executeFile("CSFormatBarFontMenu.j", YES);
{var the_class = objj_allocateClassPair(CPView, "CSFormatBar"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("editor")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:editor:"), function $CSFormatBar__initWithFrame_editor_(self, _cmd, rect, richTextEditorView)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSFormatBar").super_class }, "initWithFrame:", rect)) {
  editor = richTextEditorView;
  var bimg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarBackground.png", CGSizeMake(1,26));
  var bclr = objj_msgSend(CPColor, "colorWithPatternImage:", bimg);
  objj_msgSend(self, "setBackgroundColor:", bclr);
  var fontSelector = objj_msgSend(objj_msgSend(CSFormatBarPopUpButton, "alloc"), "initWithFrame:pullsDown:", CGRectMake(10,4,140,18), NO);
  objj_msgSend(CSFormatBarFontMenu, "fontMenuItems:", fontSelector);
  objj_msgSend(fontSelector, "setAction:", sel_getUid("fontName:"));
  objj_msgSend(fontSelector, "setTarget:", self);
  var sizeSelector = objj_msgSend(objj_msgSend(CSFormatBarPopUpButton, "alloc"), "initWithFrame:pullsDown:", CGRectMake(160,4,50,18), NO);
  objj_msgSend(sizeSelector, "addItemsWithTitles:", ["1","2","3","4","5","6","7"]);
  objj_msgSend(sizeSelector, "setAction:", sel_getUid("fontSize:"));
  objj_msgSend(sizeSelector, "setTarget:", self);
  var foreColorSelector = objj_msgSend(objj_msgSend(CSFormatBarColorWellButton, "alloc"), "initWithFrame:", CGRectMake(220,4,30,18));
  objj_msgSend(foreColorSelector.colorWell, "setAction:", sel_getUid("foreColor:"));
  objj_msgSend(foreColorSelector.colorWell, "setTarget:", self);
  var boldButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(271,4,20,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(boldButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormattingBold.png", CGSizeMake(6, 7)));
  objj_msgSend(boldButton, "setAction:", sel_getUid("bold"));
  objj_msgSend(boldButton, "setTarget:", self);
  var italicButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(290,4,20,18), CSFormatBarButtonNoRightMask | CSFormatBarButtonNoLeftMask);
  objj_msgSend(italicButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormattingItalic.png", CGSizeMake(4, 9)));
  objj_msgSend(italicButton, "setAction:", sel_getUid("italic"));
  objj_msgSend(italicButton, "setTarget:", self);
  var underlineButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(309,4,20,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(underlineButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormattingUnderline.png", CGSizeMake(6, 9)));
  objj_msgSend(underlineButton, "setAction:", sel_getUid("underline"));
  objj_msgSend(underlineButton, "setTarget:", self);
  var leftAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(350,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(leftAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentLeft.png", CGSizeMake(11, 9)));
  objj_msgSend(leftAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(leftAlignButton, "setAction:", sel_getUid("justifyLeft"));
  objj_msgSend(leftAlignButton, "setTarget:", self);
  var centerAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(372,4,23,18), CSFormatBarButtonNoRightMask | CSFormatBarButtonNoLeftMask);
  objj_msgSend(centerAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentCenter.png", CGSizeMake(12, 9)));
  objj_msgSend(centerAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(centerAlignButton, "setAction:", sel_getUid("justifyCenter"));
  objj_msgSend(centerAlignButton, "setTarget:", self);
  var rightAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(394,4,23,18), CSFormatBarButtonNoRightMask | CSFormatBarButtonNoLeftMask);
  objj_msgSend(rightAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentRight.png", CGSizeMake(11, 9)));
  objj_msgSend(rightAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(rightAlignButton, "setAction:", sel_getUid("justifyRight"));
  objj_msgSend(rightAlignButton, "setTarget:", self);
  var justifyAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(416,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(justifyAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentJustified.png", CGSizeMake(12, 9)));
  objj_msgSend(justifyAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  var indentButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(459,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(indentButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/indentation/BulletIndentationIncrease.png", CGSizeMake(15, 11)));
  objj_msgSend(indentButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(indentButton, "setAction:", sel_getUid("indent"));
  objj_msgSend(indentButton, "setTarget:", self);
  var outdentButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(481,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(outdentButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/indentation/BulletIndentationDecrease.png", CGSizeMake(15, 11)));
  objj_msgSend(outdentButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(outdentButton, "setAction:", sel_getUid("outdent"));
  objj_msgSend(outdentButton, "setTarget:", self);
  var dotButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(514,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(dotButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/bullets/BulletStyleDot.png", CGSizeMake(15, 11)));
  objj_msgSend(dotButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(dotButton, "setAction:", sel_getUid("insertUnorderedList"));
  objj_msgSend(dotButton, "setTarget:", self);
  var numberButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(536,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(numberButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/bullets/BulletStyleNumber.png", CGSizeMake(15, 11)));
  objj_msgSend(numberButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(numberButton, "setAction:", sel_getUid("insertOrderedList"));
  objj_msgSend(numberButton, "setTarget:", self);
  var fillLabel = objj_msgSend(objj_msgSend(CPTextField, "alloc"), "initWithFrame:", CGRectMake(579,4,23,18));
  objj_msgSend(fillLabel, "setStringValue:", "Fill:");
  objj_msgSend(fillLabel, "setFont:", objj_msgSend(CPFont, "systemFontOfSize:", 11.0));
  objj_msgSend(fillLabel, "sizeToFit");
  var backColorSelector = objj_msgSend(objj_msgSend(CSFormatBarColorWellButton, "alloc"), "initWithFrame:", CGRectMake(607,4,30,18));
  objj_msgSend(backColorSelector.colorWell, "setAction:", sel_getUid("backColor:"));
  objj_msgSend(backColorSelector.colorWell, "setTarget:", self);
  var undoButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(658,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(undoButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/undo-redo/undo2.png", CGSizeMake(12, 7)));
  objj_msgSend(undoButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(undoButton, "setAction:", sel_getUid("undo"));
  objj_msgSend(undoButton, "setTarget:", self);
  var redoButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(680,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(redoButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/undo-redo/redo2.png", CGSizeMake(12, 7)));
  objj_msgSend(redoButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(redoButton, "setAction:", sel_getUid("redo"));
  objj_msgSend(redoButton, "setTarget:", self);
  objj_msgSend(self, "addSubview:", fontSelector);
  objj_msgSend(self, "addSubview:", sizeSelector);
  objj_msgSend(self, "addSubview:", foreColorSelector);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 260));
  objj_msgSend(self, "addSubview:", boldButton);
  objj_msgSend(self, "addSubview:", italicButton);
  objj_msgSend(self, "addSubview:", underlineButton);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 339));
  objj_msgSend(self, "addSubview:", leftAlignButton);
  objj_msgSend(self, "addSubview:", centerAlignButton);
  objj_msgSend(self, "addSubview:", rightAlignButton);
  objj_msgSend(self, "addSubview:", justifyAlignButton);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 449));
  objj_msgSend(self, "addSubview:", indentButton);
  objj_msgSend(self, "addSubview:", outdentButton);
  objj_msgSend(self, "addSubview:", dotButton);
  objj_msgSend(self, "addSubview:", numberButton);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 569));
  objj_msgSend(self, "addSubview:", fillLabel);
  objj_msgSend(self, "addSubview:", backColorSelector);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 647));
  objj_msgSend(self, "addSubview:", undoButton);
  objj_msgSend(self, "addSubview:", redoButton);
  objj_msgSend(self, "setAutoresizingMask:",  CPViewWidthSizable);
 }
 return self;
}
},["id","CGRect*",null]), new objj_method(sel_getUid("fontName:"), function $CSFormatBar__fontName_(self, _cmd, button)
{ with(self)
{
 objj_msgSend(objj_msgSend(button, "window"), "makeFirstResponder:", button);
 objj_msgSend(editor, "DOMWindow").document.execCommand('fontName', false, objj_msgSend(button, "titleOfSelectedItem"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPPopUpButton*"]), new objj_method(sel_getUid("fontSize:"), function $CSFormatBar__fontSize_(self, _cmd, button)
{ with(self)
{
 objj_msgSend(objj_msgSend(button, "window"), "makeFirstResponder:", button);
 objj_msgSend(editor, "DOMWindow").document.execCommand('fontSize', false, objj_msgSend(button, "titleOfSelectedItem"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPPopUpButton*"]), new objj_method(sel_getUid("foreColor:"), function $CSFormatBar__foreColor_(self, _cmd, colorWell)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('foreColor', false, objj_msgSend(objj_msgSend(colorWell, "color"), "hexString"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPColorWell*"]), new objj_method(sel_getUid("bold"), function $CSFormatBar__bold(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('bold', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("italic"), function $CSFormatBar__italic(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('italic', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("underline"), function $CSFormatBar__underline(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('underline', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("justifyLeft"), function $CSFormatBar__justifyLeft(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('justifyLeft', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("justifyCenter"), function $CSFormatBar__justifyCenter(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('justifyCenter', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("justifyRight"), function $CSFormatBar__justifyRight(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('justifyRight', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("indent"), function $CSFormatBar__indent(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('indent', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("outdent"), function $CSFormatBar__outdent(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('outdent', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("insertUnorderedList"), function $CSFormatBar__insertUnorderedList(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('insertUnorderedList', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("insertOrderedList"), function $CSFormatBar__insertOrderedList(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('insertOrderedList', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("backColor:"), function $CSFormatBar__backColor_(self, _cmd, colorWell)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('backColor', false, objj_msgSend(objj_msgSend(colorWell, "color"), "hexString"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPColorWell*"]), new objj_method(sel_getUid("undo"), function $CSFormatBar__undo(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('undo', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("redo"), function $CSFormatBar__redo(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('redo', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"])]);
}

p;54;com/cetrasoft/components/formatbar/CSFormatBarButton.jt;3571;@STATIC;1.0;I;21;Foundation/CPObject.jt;3526;objj_executeFile("Foundation/CPObject.j", NO);
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

p;63;com/cetrasoft/components/formatbar/CSFormatBarColorWellButton.jt;1457;@STATIC;1.0;I;21;Foundation/CPObject.ji;19;CSFormatBarButton.jt;1388;objj_executeFile("Foundation/CPObject.j", NO);
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

p;56;com/cetrasoft/components/formatbar/CSFormatBarFontMenu.jt;920;@STATIC;1.0;I;21;Foundation/CPObject.jt;876;objj_executeFile("Foundation/CPObject.j", NO);
{var the_class = objj_allocateClassPair(CPObject, "CSFormatBarFontMenu"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(meta_class, [new objj_method(sel_getUid("fontMenuItems:"), function $CSFormatBarFontMenu__fontMenuItems_(self, _cmd, button)
{ with(self)
{
 var availableFonts = objj_msgSend(objj_msgSend(CPFontManager, "sharedFontManager"), "availableFonts");
 for(var i = 0; i < objj_msgSend(availableFonts, "count"); i++) {
  var font = objj_msgSend(availableFonts, "objectAtIndex:", i);
  var menuItem = objj_msgSend(objj_msgSend(CPMenuItem, "alloc"), "initWithTitle:action:keyEquivalent:", font, NULL, nil);
  objj_msgSend(menuItem, "setFont:", objj_msgSend(CPFont, "fontWithName:size:", font, 11.0));
  objj_msgSend(button, "addItem:", menuItem);
 }
}
},["void","CPPopUpButton*"])]);
}

p;59;com/cetrasoft/components/formatbar/CSFormatBarPopUpButton.jt;2436;@STATIC;1.0;I;21;Foundation/CPObject.jt;2391;objj_executeFile("Foundation/CPObject.j", NO);
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

p;57;com/cetrasoft/components/formatbar/CSFormatBarSeparator.jt;669;@STATIC;1.0;I;21;Foundation/CPObject.jt;625;objj_executeFile("Foundation/CPObject.j", NO);
{var the_class = objj_allocateClassPair(CPView, "CSFormatBarSeparator"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithX:"), function $CSFormatBarSeparator__initWithX_(self, _cmd, x)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSFormatBarSeparator").super_class }, "initWithFrame:", CGRectMake(x, 2, 1, 21))) {
  objj_msgSend(self, "setBackgroundColor:", objj_msgSend(CPColor, "colorWithHexString:", "5f5f5f"));
 }
 return self;
}
},["id","int"])]);
}

p;53;com/cetrasoft/components/formatbar/CSRichTextEditor.jt;1087;@STATIC;1.0;I;21;Foundation/CPObject.ji;13;CSFormatBar.ji;17;CSEditorWebView.jt;1002;objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("CSFormatBar.j", YES);
objj_executeFile("CSEditorWebView.j", YES);
{var the_class = objj_allocateClassPair(CPView, "CSRichTextEditor"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $CSRichTextEditor__initWithFrame_(self, _cmd, rect)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSRichTextEditor").super_class }, "initWithFrame:", rect)) {
  var richTextEditorWebView = objj_msgSend(objj_msgSend(CSEditorWebView, "alloc"), "initWithFrame:", CGRectMake(0, 26, CGRectGetWidth(rect), CGRectGetHeight(rect) - 26));
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBar, "alloc"), "initWithFrame:editor:", CGRectMake(0, 0, CGRectGetWidth(rect), 26), richTextEditorWebView));
  objj_msgSend(self, "addSubview:", richTextEditorWebView);
 }
 return self;
}
},["id","CGRect*"])]);
}

e;