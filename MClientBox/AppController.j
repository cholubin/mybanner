/*
 * AppController.j
 * NewApplication
 *
 * Created by You on April 9, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "SpreadEditView.j"
@import "CollectionViewItem.j"
@import "ProgressWindow.j"
@import "CollectionViewItem.j"

var SliderToolbarItemIdentifier = "SliderToolbarItemIdentifier",
    PDFToolbarItemIdentifier = "PDFToolbarItemIdentifier",
    TestToolIdentifier = "TestToolIdentifier",
    SelectionToolIdentifier = "SelectionToolIdentifier",
    CreateRectBoxIdentifier = "CreateRectBoxIdentifier";
    CreateTextBoxIdentifier = "CreateTextBoxIdentifier";
    UseGridIdentifier = "UseGridIdentifier",
    UseGuideIdentifier = "UseGuideIdentifier",
    CharStyleIdentifier = "CharStyleIdentifier",
    FontSizeIdentifier = "FontSizeIdentifier";
//var CreateRectBoxIdentifier = "CreateRectBoxIdentifier";

// /user_files/demo/article_templates/4bf3a840317d491a82000137.mlayoutP
gDefBaseURL = "http://211.35.79.131:3000"; // "http://61.251.202.120:3000"; // "http://10.0.1.33:3000";
gBaseURL = ""; //"http://localhost:3000"; //"http://graphicartshub.com:4000";
gUserPath = "";

var gFactorList = Array(0.25, 0.5, 1.0, 2.0, 3.0);

gListViewHeight = 100;

gDocItemSizeWidth = 90;
gDocItemSizeHeight = 90;

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow; //this "outlet" is connected automatically by the Cib
    @outlet SpreadEditView mSpreadView;
    @outlet CPScrollView mScrollView;
	@outlet CPCollectionView mSpreadListView;
	@outlet CPPopupButton mPopupButton;
	@outlet CPPopupButton mCharStyleButton;
	@outlet CPPopupButton mFontSizeButton;
	@outlet EditController mEditController;
	
	CPArray toolItemImagesNormal;
	CPArray toolItemImagesSelect;
	CPArray mCharImageList;
	CPImage mUseGuideImage;
	CPImage mUseGuideImageSelected;
	CPImage mUseGridImage;
	CPImage mUseGridImageSelected;
	CPToolbar mToolbar;
	var mSelectedTool;
	BOOL mBoolSelectedByUser;
	
	CPString mCurDocPath;
	CPString mLocalDocPath;
    CPURLConnection mCurDocImageListCon;
	CPURLConnection mFrameListCon;
    CPURLConnection mDocumentInfoCon;
	CPURLConnection mCurDocImageRefreshCon;
	CPURLConnection mGeneratePDFCon;
	CPURLConnection mNewPreviewCon;
	
	CPNotificationCenter		mNotiCenter;
}

- (void)awakeFromCib
{
	//alert("Test awakeFromCib!!!");
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	mBoolSelectedByUser = YES;
	//[CPBundle loadCibNamed:@"Main" owner:[CPApplication sharedApplication]];
	mCharImageList = [[CPArray alloc] init];
	toolItemImagesNormal = [[CPArray alloc] init];
	toolItemImagesSelect = [[CPArray alloc] init];
	
	var lNormalImg = [[CPImage alloc] initWithContentsOfFile:"Resources/select.png" size:CPSizeMake(30, 25)];
	[toolItemImagesNormal addObject:lNormalImg];
	var lSelectImg = [[CPImage alloc] initWithContentsOfFile:"Resources/selectHighlighted.png" size:CPSizeMake(30, 25)];
	[toolItemImagesSelect addObject:lSelectImg];
	lNormalImg = [[CPImage alloc] initWithContentsOfFile:"Resources/imgbox.png" size:CPSizeMake(30, 25)];
	[toolItemImagesNormal addObject:lNormalImg];
	lSelectImg = [[CPImage alloc] initWithContentsOfFile:"Resources/imgboxHighlighted.png" size:CPSizeMake(30, 25)];
	[toolItemImagesSelect addObject:lSelectImg];
	lNormalImg = [[CPImage alloc] initWithContentsOfFile:"Resources/textbox.png" size:CPSizeMake(30, 25)];
	[toolItemImagesNormal addObject:lNormalImg];
	lSelectImg = [[CPImage alloc] initWithContentsOfFile:"Resources/textboxHighlighted.png" size:CPSizeMake(30, 25)];
	[toolItemImagesSelect addObject:lSelectImg];
	mSelectedTool = 0;
	
	mUseGuideImage = [[CPImage alloc] initWithContentsOfFile:"Resources/guideline.png" size:CPSizeMake(30, 25)];
	mUseGuideImageSelected = [[CPImage alloc] initWithContentsOfFile:"Resources/guidelineHighlighted.png" size:CPSizeMake(30, 25)];
	mUseGridImage = [[CPImage alloc] initWithContentsOfFile:"Resources/baseline.png" size:CPSizeMake(30, 25)];
	mUseGridImageSelected = [[CPImage alloc] initWithContentsOfFile:"Resources/baselineHighlighted.png" size:CPSizeMake(30, 25)];
	
   var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
        contentView = [theWindow contentView];
     mToolbar = [[CPToolbar alloc] initWithIdentifier:"Photos"];
	// [mToolbar setDelegate:self];
	[mToolbar setVisible:true];
	[theWindow setToolbar:mToolbar];
	[theWindow setAcceptsMouseMovedEvents:YES];

	if(location.protocol === "file:") {
		gBaseURL = gDefBaseURL; //"http://10.0.1.2:3000";
	}
	else {
		gBaseURL = "http://"+location.host;
	}
	var args = [[CPApplication sharedApplication] namedArguments];
	gUserPath = [args objectForKey:@"user_path"];
	if(!gUserPath) {
		alert("No 'user_path' parameter.");
	}
 	mLocalDocPath = [args objectForKey:@"doc_path"];
	if(!mLocalDocPath) {
		mLocalDocPath = gEncodedDocPath;
	}
	if(mLocalDocPath) {
		 mCurDocPath = [CPString stringWithFormat:"%@%@%@",gBaseURL, gUserPath, mLocalDocPath];
		var lFilename = [mLocalDocPath lastPathComponent];
		[mEditController setDocumentName:lFilename];
		[self sendDocumentInfoRequest];
		//[self sendCurDocImageListRequest];
		//		alert(@"doc_path = "+ mLocalDocPath);
		// var lDocWebImageURL = [CPString stringWithFormat:"%@/filelist?request=%@/web/",gBaseURL, mLocalDocPath];
		// var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
		// mCurDocImageListCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
	}
	var lboolUseSpreadList = NO;
	var lstrUseSpreadList = [args objectForKey:@"spread_list"];
	if(lstrUseSpreadList && [[lstrUseSpreadList uppercaseString] isEqualToString:@"YES"]) {
		lboolUseSpreadList = YES;
	}
	// Initialize main spread edit view 
	///////////////////////////////////////////////////////////////////////////
	var lScrollViewFrame = [contentView bounds];
	//lScrollViewFrame.origin.y = [[toolbar _toolbarView] frame].size.height;
	if(lboolUseSpreadList) {
		lScrollViewFrame.size.height -= gListViewHeight;
	}
	mScrollView = [[CPScrollView alloc] initWithFrame:lScrollViewFrame];
	[mScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	var lSpreadViewFrame = [mScrollView bounds];
	mSpreadView = [[SpreadEditView alloc] initWithFrame:lSpreadViewFrame];
	var lContentView = [mScrollView contentView];
	if(lContentView) {
    	[mSpreadView setCenter:[lContentView center]];
		[lContentView setBackgroundColor:[CPColor grayColor]];
	}
 //   [mSpreadView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
//	[mSpreadView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[mScrollView setDocumentView:mSpreadView];
	
	mNotiCenter = [CPNotificationCenter defaultCenter];
//	[mNotiCenter addObserver:self selector:@selector(repositionSpreadView:) name:CPViewFrameDidChangeNotification object:nil];
	[mNotiCenter addObserver:self selector:@selector(repositionSpreadView:) name:CPWindowDidResizeNotification object:theWindow];
	if([mSpreadView drawingView]) {
		[[mSpreadView drawingView] setController:mEditController];
		[mEditController setAppController:self];
	}
	[mSpreadView setBackgroundColor:[CPColor lightGrayColor]];
	[[mSpreadView imageView] setImageScaling:CPScaleProportionally];
	var lBounds = [[mScrollView contentView] bounds];
	[mSpreadView setFrame:lBounds];
	// Reordering view for animation
	[mScrollView removeFromSuperview];
	[contentView addSubview:mScrollView];
	
	
	// If use spread list view (spread_list=YES)
	///////////////////////////////////////////////////////////////////////////
	if(lboolUseSpreadList) {
		var lListViewFrame = CGRectMake(0, CPRectGetMaxY(lScrollViewFrame), lScrollViewFrame.size.width, gListViewHeight);
		mSpreadListView = [[CPCollectionView alloc] initWithFrame:lListViewFrame];
		[mSpreadListView setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
		[mSpreadListView setMaxItemSize:CPSizeMake(gDocItemSizeWidth, gDocItemSizeHeight)];
	  	[mSpreadListView setMinItemSize:CPSizeMake(gDocItemSizeWidth, gDocItemSizeHeight)];
		[mSpreadListView setSelectable:YES];
		[mSpreadListView setDelegate:self];
		[mSpreadListView setBackgroundColor:[CPColor lightGrayColor]];
		[mSpreadListView setAllowsMultipleSelection:NO];
		[mSpreadListView setAllowsEmptySelection:NO];
		
		
		[contentView addSubview:mSpreadListView];
		[mSpreadListView release];
		
	    var lCellFrame = CPRectMake(0, 0, gDocItemSizeWidth, gDocItemSizeHeight);
	    var lDocThumbView = [[SDImageView alloc] initWithFrame:lCellFrame];
	    var lItem = [[SDCollectionViewItem alloc] init];
	    [lItem setView:lDocThumbView];
		[mSpreadListView setItemPrototype:lItem];
		[lItem release];
		[lDocThumbView release];
		
	}

    [theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (void)repositionSpreadView:(CPNotification)notification
{
	[mSpreadView reposition:notification];
}

- (int)currentSpreadIndex
{
	var lSpreadIdx = 0;
	if(mSpreadListView) {
		lSpreadIdx = [[mSpreadListView selectionIndexes] firstIndex];
	}
	return lSpreadIdx;
}

- (id)localDocPath
{
	return mLocalDocPath;
}
- (CPString)spreadPreviewPathAtPage:(int)pgno filelist:(CPArray)lPathList
{
	var lTarFileFront = [CPString stringWithFormat:"spread_preview_%04d",pgno];
	var i;
	for(i=0;i<lPathList.length;i++) {
		var lFile = [lPathList objectAtIndex:i];
		var lExt = [lFile pathExtension];
		if(![lExt isEqualToString:@"jpg"])
			continue;
		if([lFile length] >= [lTarFileFront length] + 4) {
			var lFileFront = [lFile substringToIndex:[lTarFileFront length]];
			if([lFileFront isEqualToString:lTarFileFront]) {
				var lRetstr = [CPString stringWithFormat:"%@/web/%@",mCurDocPath,lFile];
				return lRetstr;
			}
		}
	}
	return nil;
}

- (CPString)spreadThumbnailPathAtPage:(int)pgno filelist:(CPArray)lPathList
{
	var lTarFileFront = [CPString stringWithFormat:"spread_thumb_%04d",pgno];
	var i;
	for(i=0;i<lPathList.length;i++) {
		var lFile = [lPathList objectAtIndex:i];
		var lExt = [lFile pathExtension];
		if(![lExt isEqualToString:@"jpg"])
			continue;
		if([lFile length] >= [lTarFileFront length] + 4) {
			var lFileFront = [lFile substringToIndex:[lTarFileFront length]];
			if([lFileFront isEqualToString:lTarFileFront]) {
				var lRetstr = [CPString stringWithFormat:"%@/web/%@",mCurDocPath,lFile];
				return lRetstr;
			}
		}
	}
	return nil;
}
/*
- (void)setSpreadImageViewImage:(CPImage)anImage
{
	if(anImage) {
		[anImage setDelegate:self];
	    if([anImage loadStatus] == CPImageLoadStatusCompleted) {
	        [mSpreadView:anImage];
		}
	    else
	        [mSpreadView setImage:nil];
	}
	else {
        [mSpreadView setImage:nil];
	}
}

- (void)imageDidLoad:(CPImage)anImage
{
    [mSpreadView setImage:anImage];
}
*/
- (void)loadSpreadThumbnails:(CPString)data
{
    var lPathList = [data componentsSeparatedByString:@"\n"];
	if(mSpreadListView) {
		var pgno = 1;
	    var lItemList = [[CPArray alloc] init];
		var lSpreadThumbPath = [self spreadThumbnailPathAtPage:pgno++ filelist:lPathList];
		while(lSpreadThumbPath) {
		    var lThumbImage = [[CPImage alloc] initWithContentsOfFile:lSpreadThumbPath];
			var dict = [CPDictionary dictionaryWithObject:lThumbImage forKey:@"image"];
		    [lItemList addObject:dict];
			[lThumbImage release];
		
			lSpreadThumbPath = [self spreadThumbnailPathAtPage:pgno++ filelist:lPathList];
		}
		/////////////////////
		// var lOrgItemPrototypeItem = [mSpreadListView itemPrototype];
		// var lCellFrame = [[lOrgItemPrototypeItem view] frame];
		// var lDocThumbView = [[SDImageView alloc] initWithFrame:lCellFrame];
		// 	    var lItem = [[SDCollectionViewItem alloc] init];
		// 	    [lItem setView:lDocThumbView];
		// [mSpreadListView setItemPrototype:lItem];
		/////////////////////
	    [mSpreadListView setContent:lItemList];
	
		var lIdx = [[mSpreadListView selectionIndexes] firstIndex];
		if(lIdx < 0) {
			var lSelectIdx = [[CPIndexSet alloc] initWithIndex:0];
			mBoolSelectedByUser = NO;
			[mSpreadListView setSelectionIndexes:lSelectIdx];
			mBoolSelectedByUser = YES;
			
			[lSelectIdx release];
			lIdx = 0;
		}
		var lSpreadPreviewPath = [self spreadPreviewPathAtPage:lIdx+1 filelist:lPathList];
		if(lSpreadPreviewPath) {
		    var lImage = [[CPImage alloc] initWithContentsOfFile:lSpreadPreviewPath];
			[mSpreadView setSpreadImage:lImage];
			[lImage release];
		}
	}
	else {
		var lSpreadPreviewPath = [self spreadPreviewPathAtPage:1 filelist:lPathList];
		if(lSpreadPreviewPath) {
		    var lImage = [[CPImage alloc] initWithContentsOfFile:lSpreadPreviewPath];
			[mSpreadView setSpreadImage:lImage];
			[lImage release];
		}
	}
//	[[ProgressWindow sharedWindow] hide];
}

- (id)mainWindow
{
	return theWindow;
}

- (void)sendCurDocImageListRequest
{
	var lFilename = [mLocalDocPath lastPathComponent];
	var lDocWebImageURL = [CPString stringWithFormat:"%@/filelist?request=%@/web/",gBaseURL, mLocalDocPath];
	var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
	mCurDocImageListCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];	
}

- (void)sendDocumentInfoRequest
{
	var lSpreadIdx = [[mSpreadListView selectionIndexes] firstIndex];
	if(lSpreadIdx >= 0) {
		var lFilename = [mCurDocPath lastPathComponent];
	    var lDocOpenURL = [CPString stringWithFormat:"%@/request_mlayout?requested_action=DocumentInfos&docname=%@&userinfo=%d",gBaseURL ,lFilename,lSpreadIdx];
	    var lRequest = [CPURLRequest requestWithURL:lDocOpenURL];
	    mDocumentInfoCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
	}
	
}

- (void)sendFrameListRequest
{
	var lSpreadIdx = [[mSpreadListView selectionIndexes] firstIndex];
	if(lSpreadIdx >= 0) {
		var lFilename = [mCurDocPath lastPathComponent];
	    var lDocOpenURL = [CPString stringWithFormat:"%@/request_mlayout?requested_action=FrameList&docname=%@&userinfo=%d",gBaseURL ,lFilename,lSpreadIdx];
	    var lRequest = [CPURLRequest requestWithURL:lDocOpenURL];
	    mFrameListCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
	}
}

- (void)loadFrameList:(CPString)data
{
	var lFrameList = [data componentsSeparatedByString:@"\n"];
	var i = 0, icnt = [lFrameList count];
//	alert("count = "+icnt);
	var drawingView = [mSpreadView drawingView] ;
	[drawingView clearFrameList];
	[drawingView resetDrawings];
	
	for(;i<icnt;i++) {
		var lFrameStr = [lFrameList objectAtIndex:i];
		if([lFrameStr length] < 10)
			continue;
		var lItemList = [lFrameStr componentsSeparatedByString:@","];
		if([lItemList count] < 2)
			continue;
		var typestr = [lItemList objectAtIndex:0];
		if([typestr isEqualToString:@"Spread"]) {
			var lWidth = [[lItemList objectAtIndex:3] floatValue];
			var lHeight = [[lItemList objectAtIndex:4] floatValue];
			var lSize = CPSizeMake(lWidth, lHeight);
			[drawingView setSpreadSize:lSize];
		}
		else if([typestr isEqualToString:@"hguide"]) {
			var j = 0, jcnt = [lItemList count];
			for(j=1;j<jcnt;j++) {
				var guidestr = [lItemList objectAtIndex:j];
				var guideItemList = [guidestr componentsSeparatedByString:@"#"];  // location,start,length
				var location = [[guideItemList objectAtIndex:0] floatValue];
				var start = [[guideItemList objectAtIndex:1] floatValue];
				var length = [[guideItemList objectAtIndex:2] floatValue];
				[drawingView addHGuideLineLocation:location start:start length:length];
				
			}
		}
		else if([typestr isEqualToString:@"vguide"]) {
			var j = 0, jcnt = [lItemList count];
			for(j=1;j<jcnt;j++) {
				var guidestr = [lItemList objectAtIndex:j];
				var guideItemList = [guidestr componentsSeparatedByString:@"#"];  // location,start,length
				var location = [[guideItemList objectAtIndex:0] floatValue];
				var start = [[guideItemList objectAtIndex:1] floatValue];
				var length = [[guideItemList objectAtIndex:2] floatValue];
				[drawingView addVGuideLineLocation:location start:start length:length];
				
			}
		}
		else if([typestr isEqualToString:@"Grid"]) {
			var m = 1;
		    var start = [[lItemList objectAtIndex:m++] floatValue];
		    var increment = [[lItemList objectAtIndex:m++] floatValue];
		    var leading = [[lItemList objectAtIndex:m++] floatValue];
			[drawingView setGridStart:start inclrement:increment leading:leading];
		}
		else {
			var m = 0;
			if([typestr isEqualToString:@"Graphic"]) {
				m = 1;
			}
			var lGID = [[lItemList objectAtIndex:m++] intValue];
			var lLeft = [[lItemList objectAtIndex:m++] floatValue];
			var lTop = [[lItemList objectAtIndex:m++] floatValue];
			var lWidth = [[lItemList objectAtIndex:m++] floatValue];
			var lHeight = [[lItemList objectAtIndex:m++] floatValue];
			var lRect = CPRectMake(lLeft, lTop, lWidth, lHeight);
			var lGFrame = [[GraphicFrame alloc] initWithRect:lRect gid:lGID];
			[drawingView addFrame:lGFrame];
		}
	}
	[drawingView setNeedsDisplay:YES];
	
}

- (void)loadStyleList:(CPString)data
{
	var lStyledEditView = [mEditController styledTextEditView];
	var lStyleList = [data componentsSeparatedByString:@"\n"];
	var i, icnt = [lStyleList count];
	[lStyledEditView clearStyleInfoList];
	for(i=0;i<icnt;i++) {
		var lStyleRecStr = [lStyleList objectAtIndex:i];
		var lStyleInfo = [[StyleInfo alloc] initWithString:lStyleRecStr];
		[lStyledEditView addStyleInfo:lStyleInfo];
	}
}

- (void)loadChatStyleList:(CPString)data
{
	debugger;
	var lStyleList = [data componentsSeparatedByString:@"\n"];
	var i, icnt = [lStyleList count];
	for(i=0;i<icnt;i++) {
		var lCharStyleName = [lStyleList objectAtIndex:i];
		if([lCharStyleName length] == 0)
			continue;
		 var lCharPreviewPath = [CPString stringWithFormat:@"%@/web/CharStyles/%@",mCurDocPath,lCharStyleName];
		 var lCharImg = [[CPImage alloc] initWithContentsOfFile:lCharPreviewPath size:CPSizeMake(120, 24)];
		// var lItem = [[CPMenuItem alloc] init];
		// [lItem setImage:lCharImg];
		// [mCharStyleButton addItem:lItem];
		// [lItem release];
		// [lCharImg release];
//		[mCharStyleButton addItemWithTitle:lCharStyleName];
		
		[mCharImageList addObject:lCharImg];
	}
	[mToolbar setDelegate:self];
}

- (void)loadDocumentInfos:(CPString)data
{
	var lInfoList = [data componentsSeparatedByString:@"__SEP__"];
	if([lInfoList count] >= 2) {
		[self loadStyleList:[lInfoList objectAtIndex:0]];
		[self loadFrameList:[lInfoList objectAtIndex:1]];
		if([lInfoList count] >= 3) {
			[self loadChatStyleList:[lInfoList objectAtIndex:2]];
		}
	}
	else {
		[self loadFrameList:[lInfoList objectAtIndex:0]];
	}
}

- (void)changeScale:(id)sender
{
	var scaleIdx = [sender indexOfSelectedItem];
	var factor = gFactorList[scaleIdx];
	[mSpreadView setScaleFactor:factor];
	[mSpreadView rescale];
}

- (@action)testToolitem:(id)sender
{
	
}

- (@action)generatePDF:(id)sender
{
	if(confirm("Are you sure?")) {
		var lFilename = [mCurDocPath lastPathComponent];

		//stringByDeletingPathExtension
		var lExtLen = [[lFilename pathExtension] length];
		var lFilenameNoExt = [lFilename substringToIndex:[lFilename length]-lExtLen-1];
	
		var lDocumentID = [lFilenameNoExt lastPathComponent];
	    var lDocOpenURL = [CPString stringWithFormat:"%@/publish/%@",gBaseURL ,lDocumentID];
	   	var lRequest = [CPURLRequest requestWithURL:lDocOpenURL];
		[[ProgressWindow sharedWindow] show];
	  	mGeneratePDFCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
	}
}

- (void)resetToolButtons
{
	var i = 0;
	for(i=0;i<3;i++) {
		var toolbarItem = [[mToolbar items] objectAtIndex:i];
        var image = [toolItemImagesNormal objectAtIndex:i];
        var highlighted = [toolItemImagesSelect objectAtIndex:i];
		if(i == mSelectedTool) {
		    [toolbarItem setImage:highlighted];
		    [toolbarItem setAlternateImage:image];
		}
		else {
	        [toolbarItem setImage:image];
	        [toolbarItem setAlternateImage:highlighted];
		}
	}
	[[mSpreadView drawingView] toolDidChanged];
}

- (@action)selectTool:(id)sender
{
	mSelectedTool = [sender tag];
	[self resetToolButtons];
}

- (@action)useGuide:(id)sender
{
	if([sender image] == mUseGuideImage) {
		[[mSpreadView drawingView] setUseGuide:YES];
		[sender setImage:mUseGuideImageSelected];
	}
	else {
		[[mSpreadView drawingView] setUseGuide:NO];
		[sender setImage:mUseGuideImage];
	}	
	[[mSpreadView drawingView] setNeedsDisplay:YES];
}

- (@action)useGrid:(id)sender
{
	if([sender image] == mUseGridImage) {
		[[mSpreadView drawingView] setUseGrid:YES];
		[sender setImage:mUseGridImageSelected];
	}
	else {
		[[mSpreadView drawingView] setUseGrid:NO];
		[sender setImage:mUseGridImage];
	}	
	[[mSpreadView drawingView] setNeedsDisplay:YES];
}

- (@action)changeCharStyle:(id)sender
{
	var idx = [sender indexOfSelectedItem];
	var gid = [[[mEditController drawingView] selectedFrame] GID];
	var charstyle_str = gid + "__GIDSEP__" + idx;
	[mEditController sendJSONRequestAndRefresh:@"SetCharStyle" data:charstyle_str];

}

- (@action)changeFontSize:(id)sender
{
	debugger;
	var size_str = [[sender selectedItem] title];
	if(size_str == " 0")
		return;
	var gid = [[[mEditController drawingView] selectedFrame] GID];
	var charstyle_str = gid + "__GIDSEP__" + size_str;
	[mEditController sendJSONRequestAndRefresh:@"ChangeFontSize" data:charstyle_str];
	[sender selectItemAtIndex:15];
}

- (void)selectSelectionTool
{
	mSelectedTool = 0; // Selection Tool
	[self resetToolButtons];
}
- (int)selectedTool
{
	return mSelectedTool;
}
- (void)refreshSpreadListView
{
    var lDocWebImageURL = [CPString stringWithFormat:"%@/filelist?request=%@/web/",gBaseURL, mLocalDocPath];
    var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
    mCurDocImageRefreshCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
}

- (void)loadSpreadPreview:(CPString)data
{
    var lPathList = [data componentsSeparatedByString:@"\n"];
	var lIdx = [[mSpreadListView selectionIndexes] firstIndex];
	var lSpreadPreviewPath = [self spreadPreviewPathAtPage:lIdx+1 filelist:lPathList]
    var lImage = [[CPImage alloc] initWithContentsOfFile:lSpreadPreviewPath];
//	[[mSpreadView imageView] setImage:lImage];
	[mSpreadView setSpreadImage:lImage];
	[lImage release];
}

//
//     Delegate Methods Collection
//
/////////////////////////////////////////////////////////////////////////////////////////

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	
 	if( connection === mCurDocImageListCon) {
		[self loadSpreadThumbnails:data];
	}
 	else if( connection === mCurDocImageRefreshCon) {
		[self loadSpreadThumbnails:data];
	}
	else if(connection === mFrameListCon) {		
		[self loadFrameList:data];
	}
	else if( connection === mDocumentInfoCon) {
		//alert("framelist = "+data);
		[self loadDocumentInfos:data];
		[self sendCurDocImageListRequest];
		
	}
	else if( connection === mNewPreviewCon) {
		[self loadSpreadPreview:data];
	}
	else if( connection === mGeneratePDFCon) {  
		[[ProgressWindow sharedWindow] hide];
		alert("PDF generated successfully.");
	}
	
}


// UseGridIdentifier = "UseGridIdentifier",
// UseGuideIdentifier = "UseGuideIdentifier";

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
   return [SelectionToolIdentifier, CreateRectBoxIdentifier,CreateTextBoxIdentifier,CPToolbarSpaceItemIdentifier, UseGuideIdentifier,
 UseGridIdentifier, CPToolbarSpaceItemIdentifier, PDFToolbarItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier, FontSizeIdentifier, 
 CharStyleIdentifier, SliderToolbarItemIdentifier];
}
//this delegate method returns the actual toolbar item for the given identifier

- (CPToolbarItem)toolbar:(CPToolbar)aToolbar itemForItemIdentifier:(CPString)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag
{
    var toolbarItem = [[CPToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];

    if (anItemIdentifier == SliderToolbarItemIdentifier)
    {
		mPopupButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
		[mPopupButton removeAllItems];
		[mPopupButton addItemWithTitle:@"25%"];
		[mPopupButton addItemWithTitle:@"50%"];
 		[mPopupButton addItemWithTitle:@"100%"];
		[mPopupButton addItemWithTitle:@"200%"];
 		[mPopupButton addItemWithTitle:@"300%"];
		[mPopupButton selectItemAtIndex:2];
        [toolbarItem setTarget:self];
		[mPopupButton setAction:@selector(changeScale:)];
      	[toolbarItem setView:mPopupButton];
        [toolbarItem setMinSize:CGSizeMake(100, 24)];
        [toolbarItem setMaxSize:CGSizeMake(100, 24)];
        [toolbarItem setLabel:"Scale"];
    }
    else if (anItemIdentifier == CharStyleIdentifier)
    {
		mCharStyleButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
		[mCharStyleButton removeAllItems];
		var i, icnt = [mCharImageList count];
		for(i=0;i<icnt;i++) {
			var lCharImg = [mCharImageList objectAtIndex:i];
			var lItem = [[CPMenuItem alloc] init];
			[lItem setImage:lCharImg];
			[mCharStyleButton addItem:lItem];
			[lItem release];
			[lCharImg release];
		}
		
        [mCharStyleButton setTarget:self];
		[mCharStyleButton setAction:@selector(changeCharStyle:)];
		
        [toolbarItem setTarget:self];
      	[toolbarItem setView:mCharStyleButton];
        [toolbarItem setMinSize:CGSizeMake(150, 24)];
        [toolbarItem setMaxSize:CGSizeMake(150, 24)];
        [toolbarItem setLabel:"CharStyle"];
    }
    else if (anItemIdentifier == FontSizeIdentifier)
    {
		mFontSizeButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
		[mFontSizeButton removeAllItems];
		var i;
		var m = -15
		for(i=0;i<31;i++) {
			var sign_str = " ";
			if(m > 0) 
				sign_str = "+";
			//else if(m < 0) 
			//	sign_str = "-";
			var size_str = sign_str+m;
			[mFontSizeButton addItemWithTitle:size_str];
			m++;
		}
		
        [mFontSizeButton setTarget:self];
		[mFontSizeButton setAction:@selector(changeFontSize:)];
		
        [toolbarItem setTarget:self];
      	[toolbarItem setView:mFontSizeButton];
        [toolbarItem setMinSize:CGSizeMake(80, 24)];
        [toolbarItem setMaxSize:CGSizeMake(80, 24)];
        [toolbarItem setLabel:"Font Size"];
    }
    else if (anItemIdentifier == PDFToolbarItemIdentifier )
    {
        var image = [[CPImage alloc] initWithContentsOfFile:"Resources/pdf.png" size:CPSizeMake(30, 25)];
        var highlighted = [[CPImage alloc] initWithContentsOfFile:"Resources/pdfHighlighted.png" size:CPSizeMake(30, 25)];
            
        [toolbarItem setImage:image];
        [toolbarItem setAlternateImage:highlighted];
        
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(generatePDF:)];
        [toolbarItem setLabel:"Generate PDF"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
    }
    else if (anItemIdentifier == TestToolIdentifier)
    {
        var image = [[CPImage alloc] initWithContentsOfFile:"Resources/pdf.png" size:CPSizeMake(30, 25)];
        var highlighted = [[CPImage alloc] initWithContentsOfFile:"Resources/pdfHighlighted.png" size:CPSizeMake(30, 25)];
        
		var lBtn = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        [lBtn setImage:image];
        [lBtn setAlternateImage:highlighted];
        
        [lBtn setTarget:self];
        [lBtn setAction:@selector(testToolitem:)];

		[toolbarItem setView:lBtn];
        [toolbarItem setLabel:"test"];

        [toolbarItem setMinSize:CGSizeMake(50, 50)];
        [toolbarItem setMaxSize:CGSizeMake(50, 50)];
    }
    else if (anItemIdentifier == SelectionToolIdentifier)
    {
        var image = [toolItemImagesNormal objectAtIndex:0];
        var highlighted = [toolItemImagesSelect objectAtIndex:0];
            
        [toolbarItem setImage:highlighted];
        [toolbarItem setAlternateImage:image];  // highlighted];
        
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(selectTool:)];
        [toolbarItem setLabel:"Sel"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
        [toolbarItem setTag:0];
    }
    else if (anItemIdentifier == CreateRectBoxIdentifier)
    {
        var image = [toolItemImagesNormal objectAtIndex:1];
        var highlighted = [toolItemImagesSelect objectAtIndex:1];
            
        [toolbarItem setImage:image];
        [toolbarItem setAlternateImage:highlighted];
        
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(selectTool:)];
        [toolbarItem setLabel:"Image"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
        [toolbarItem setTag:1];
    }
    else if (anItemIdentifier == CreateTextBoxIdentifier)
    {
        var image = [toolItemImagesNormal objectAtIndex:2];
        var highlighted = [toolItemImagesSelect objectAtIndex:2];
            
        [toolbarItem setImage:image];
        [toolbarItem setAlternateImage:highlighted];
        
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(selectTool:)];
        [toolbarItem setLabel:"Text"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
        [toolbarItem setTag:2];
    }
    else if (anItemIdentifier == UseGuideIdentifier)
    {
        [toolbarItem setImage:mUseGuideImage];
        [toolbarItem setAlternateImage:mUseGuideImageSelected];
        
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(useGuide:)];
        [toolbarItem setLabel:"Guide"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
        [toolbarItem setTag:10];
    }
    else if (anItemIdentifier == UseGridIdentifier)
    {
        [toolbarItem setImage:mUseGridImage];
        [toolbarItem setAlternateImage:mUseGridImageSelected];
        
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(useGrid:)];
        [toolbarItem setLabel:"Grid"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
        [toolbarItem setTag:11];
    }

	
    return toolbarItem;
}

- (void)refreshSpreadPreview
{
	    var lDocWebImageURL = [CPString stringWithFormat:"%@/filelist?request=%@/web/",gBaseURL, mLocalDocPath];
	    var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
	    mNewPreviewCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
}


-(void)collectionViewDidChangeSelection:(CPCollectionView)collectionView
{
	if(collectionView === mSpreadListView) {
		[[mSpreadView drawingView] resetDrawings];
		[[mSpreadView drawingView] clearFrameList];
		[[mSpreadView drawingView] setNeedsDisplay:YES];
		[self refreshSpreadPreview];
		if([mSpreadView drawingView] ) { // && mBoolSelectedByUser) {
			[self sendFrameListRequest];
		}
	}
	/*
	else if(collectionView === mDocumentListView) {
		var lIdx = [[mDocumentListView selectionIndexes] firstIndex];
		if(lIdx >= 0) {
			[[ProgressWindow sharedWindow] show];
			var lFilename = [mDocumentList objectAtIndex:lIdx];
			mCurDocPath = [CPString stringWithFormat:"%@%@%@",gBaseURL, mBasePath,lFilename];
		    var lDocWebImageURL = [CPString stringWithFormat:"%@/filelist?request=/article_templates/%@/web/",gBaseURL, lFilename];
		    var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
		    mCurDocImageListCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
		
			var lSelectIdx = [[CPIndexSet alloc] initWithIndex:0];
			[mSpreadListView setSelectionIndexes:lSelectIdx];
			[mEditController setDocumentName:lFilename];
		}
		else {
			var lSelectIdx = [[CPIndexSet alloc] initWithIndex:CPNotFound];
			[mSpreadListView setSelectionIndexes:lSelectIdx];
			var lSpreadList = [mSpreadListView content];
			[lSpreadList removeAllObjects];
			[mSpreadListView reloadContent];
			[mEditController setDocumentName:nil];
			[mSpreadView setSpreadImage:nil];
//			[[mSpreadView imageView] setImage:nil];
		}
		
	}
	*/
	
}

@end


/*
    This code demonstrates how to add a category to an existing class.
    In this case, we are adding the class method +flickr_labelWithText: to 
    the CPTextField class. Later on, we can call [CPTextField flickr_labelWithText:"foo"]
    to return a new text field with the string foo.
    
    Best practices suggest prefixing category methods with your unique prefix, to prevent collisions.
*/

@implementation CPTextField (CreateLabel)

+ (CPTextField)flickr_labelWithText:(CPString)aString
{
    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    
    [label setStringValue:aString];
    [label sizeToFit];
    [label setTextShadowColor:[CPColor whiteColor]];
    [label setTextShadowOffset:CGSizeMake(0, 1)];
    
    return label;
}


@end

// This class wraps our slider + labels combo

@implementation PhotoResizeView : CPView
{
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    var slider = [[CPSlider alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(aFrame)/2.0 - 8, CGRectGetWidth(aFrame) - 65, 24)];

    [slider setMinValue:50.0];
    [slider setMaxValue:250.0];
    [slider setIntValue:150.0];
    [slider setAction:@selector(adjustImageSize:)];
    
    [self addSubview:slider];
                                                             
    var label = [CPTextField flickr_labelWithText:"50"];
    [label setFrameOrigin:CGPointMake(0, CGRectGetHeight(aFrame)/2.0 - 4.0)];
    [self addSubview:label];

    label = [CPTextField flickr_labelWithText:"250"];
    [label setFrameOrigin:CGPointMake(CGRectGetWidth(aFrame) - CGRectGetWidth([label frame]), CGRectGetHeight(aFrame)/2.0 - 4.0)];
    [self addSubview:label];
    
    return self;
}

@end