@STATIC;1.0;I;21;Foundation/CPObject.ji;16;SpreadEditView.ji;20;CollectionViewItem.ji;16;ProgressWindow.ji;20;CollectionViewItem.jt;21782;objj_executeFile("Foundation/CPObject.j", NO);
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

