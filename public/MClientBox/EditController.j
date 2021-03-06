////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

var gXMLInspectorView = null;
var gSlideMax	= 1.9;
var gSlideMin	= 0.1;
function TextMonitor()
{
	var itemViewList = [gXMLInspectorView itemViewList]; 
	var i, icnt = [itemViewList count];
	for(i=0;i<icnt;i++) {
		var anItemView = [itemViewList objectAtIndex:i];  // StyledTextItemView
		var editView = [anItemView textEditView];
	}
}


@implementation EditController : CPObject
{
	@outlet CPWindow				mInspectorWin;
	@outlet CPPopUpButton 			mSelectPopupBtn;
	@outlet CPView					mInspectorViewContainer;
	@outlet CPView					mImageInspectorView;
	@outlet CPImageView 			mImageImageView;
	@outlet ImagePickerController 	mImagePicker;
	@outlet CPSlider 				mScaleSlider;

	@outlet CPView		mTextInspectorView;
	@outlet CPView		mXMLInspectorView;
	@outlet CPView		mArticleInspectorView;
	
	CPURLConnection 	mGetContentsCon;
	CPURLConnection		mSetContentsCon;
	CPURLConnection		mCreateObjectCon;
	DrawingView			mDrawingView;
	CPString 			mDocumentName;
	CPString 			mDocumentPath;
	id 					mAppController;
	var					mGID;
	CPString			mOrgImagePath;
	CPString			mImagePath;
	BOOL				mIsVisible;
	CPString			mTextContent;
	var					mClock;
}

- (void)dealloc
{
	if(mImagePath) 
		[mImagePath release];
	[super dealloc];
}
- (void)awakeFromCib
{
	
	var args = [[CPApplication sharedApplication] namedArguments];
	var lUseImageTextPopup = [args objectForKey:@"select_content"];
	if(lUseImageTextPopup && [[lUseImageTextPopup lowercaseString] isEqualToString:@"yes"]) {
		[mAppController setUseImageTextPopup:YES];
	}
	if([mAppController useImageTextPopup]) {
		[mSelectPopupBtn removeAllItems];
		[mSelectPopupBtn addItemWithTitle:"Text"];
		[mSelectPopupBtn addItemWithTitle:"Image"];
		[mSelectPopupBtn selectItemAtIndex:0];
	}
	else {
		[mSelectPopupBtn removeFromSuperview];
	}
	
	var lFrame = CPRectInset([mTextInspectorView frame], 3, 3);
	var lAutoMask = [mTextInspectorView autoresizingMask];
	var lSView = [mTextInspectorView superview];

	[mTextInspectorView removeFromSuperview];
	mTextInspectorView = [[CSEditorWebView alloc] initWithFrame:lFrame];// [[CPScrollView alloc] initWithFrame:lFrame];
 	[mTextInspectorView setAutoresizesSubviews:YES];
	[mTextInspectorView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];  //| CPViewMaxYMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMinXMargin 
	[lSView addSubview:mTextInspectorView];
  	[lSView setAutoresizesSubviews:YES];
	
	 //## StyledTextEditView 
	 mXMLInspectorView = [[StyledTextEditView alloc] initWithFrame:lFrame];// [[CPScrollView alloc] initWithFrame:lFrame];
	 [mXMLInspectorView setAutoresizesSubviews:YES];
	 [mXMLInspectorView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];  //| CPViewMaxYMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMinXMargin 
	 [mXMLInspectorView setController:self];
	 [mXMLInspectorView retain];
	
	mArticleInspectorView = mTextInspectorView;
	
//	[self changeInspector:mSelectPopupBtn];
	[self changeInspectorAtIndex:0];
	[mTextInspectorView retain];
	var newImageViewFrame = [mImageImageView frame];
	[mImageImageView removeFromSuperview];
	mImageImageView = [[ImageTrimmer alloc] initWithFrame:newImageViewFrame];
	[mImageImageView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];  //| CPViewMaxYMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMinXMargin 
	[mImageInspectorView addSubview:mImageImageView];
	[mImageInspectorView retain];
	mIsVisible = NO;
	[mInspectorWin setAcceptsMouseMovedEvents:YES];
	[mInspectorWin setDelegate:self];
	
//	[mScaleSlider setContinuous:YES];
	[mScaleSlider setMaxValue:gSlideMax];
	[mScaleSlider setMinValue:gSlideMin];
	[mScaleSlider setValue:1.0];
}

- (void)startTextMonitor
{
	gXMLInspectorView = mXMLInspectorView;
	mClock = window.setInterval("TextMonitor()",500);
}
- (void)windowWillClose:(id)aWin
{
 	if(aWin == mInspectorWin) {
		mIsVisible = NO;
		if(mClock) {
			window.clearInterval(mClock);
		}
		mClock = null;
		
 	}
 }

- (void)setDocumentName:(CPString)aString
{
	mDocumentName = aString;
}
- (void)setDocumentPath:(CPString)aString
{
	mDocumentPath = aString;
}
- (void)setImagePath:(CPString)aImagePath
{
	if(mImagePath) 
		[mImagePath release];
	mImagePath = [aImagePath retain];
}

- (BOOL)isWindowVisible
{
	return mIsVisible; //[mmInspectorWin isKeyWindow];
}

- (void)setModalMode:(BOOL)flag
{
	mIsVisible = flag;
}
- (id)styledTextEditView
{
	return mXMLInspectorView;
}

- (void)setDrawingView:(id)aView
{
	if(mDrawingView) {
		[mDrawingView release];		
	}
	mDrawingView = [aView retain];
}

- (var)drawingView
{
	return mDrawingView;
}

- (void)setNewImage:(CPImage)anImage
{
	var boxSize = [mImageImageView serverBoxSize];
	var imgSize = [anImage size];
	var imgFrame = CPRectMake(0, 0, 0, 0);
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
	[mImageImageView setServerBoxImageFrame:imgFrame];
	[mImageImageView setImage:anImage];
	[mScaleSlider setValue:1.0];
}

- (void)setImagePathToImageView:(CPString)aImagePath
{
	[self setImagePath:aImagePath];
	if(aImagePath) {
		var ext = [mImagePath pathExtension];
		var lExtLen = [ext length];
		var lPreviewExt = ".jpg";
		if([[ext lowercaseString] isEqualToString:@"eps"] || [[ext lowercaseString] isEqualToString:@"pdf"]) 
			lPreviewExt = ".png";
		var lImgPathNoExt = [mImagePath substringToIndex:[mImagePath length]-lExtLen-1];
		var lImgName = [lImgPathNoExt lastPathComponent];
		var lOrgPath = [lImgPathNoExt stringByDeletingLastPathComponent];
		var lPreviewPath = gBaseURL + lOrgPath + "/Preview/"+lImgName+lPreviewExt;
		var lImage = [[CPImage alloc] initWithContentsOfFile:lPreviewPath];
		[mImageImageView setImage:lImage];
		[lImage release];
	}
	else
		[mImageImageView setImage:nil];
	
}

- (void)setNewImagePathToImageView:(CPString)aImagePath
{
	[self setImagePath:aImagePath];
	var ext = [mImagePath pathExtension];
	var lExtLen = [ext length];
	var lPreviewExt = ".jpg";
	if([[ext lowercaseString] isEqualToString:@"eps"] || [[ext lowercaseString] isEqualToString:@"pdf"]) 
		lPreviewExt = ".png";
	
	var lImgPathNoExt = [mImagePath substringToIndex:[mImagePath length]-lExtLen-1];
	var lImgName = [lImgPathNoExt lastPathComponent];
	var lOrgPath = [lImgPathNoExt stringByDeletingLastPathComponent];
	var lPreviewPath = gBaseURL + lOrgPath + "/Preview/"+lImgName+lPreviewExt;
	var lImage = [[CPImage alloc] initWithContentsOfFile:lPreviewPath];
	if(lImage) {
	 	[lImage setDelegate:self];
	    if([lImage loadStatus] == CPImageLoadStatusCompleted) {
			[self setNewImage:lImage];
		}
	}
	[lImage release];
}

- (void)imageDidLoad:(CPImage)anImage
{
	[self setNewImage:anImage];
}

- (@action)selectImage:(id)sender
{
	if(!mImagePicker) {
		mImagePicker = [[ImagePickerController alloc] init];
	}
	[mImagePicker runModalForReceiver:self];
	
}
- (@action)takeFloatValueFrom:(id)sender  // mScaleSlider
{
	var scale = [mScaleSlider floatValue];
	var newRect = CPRectMake(0,0,0,0);
	var curRect = [mImageImageView curImageFrame];
	var orgRect = [mImageImageView orgImageFrame];
	newRect.origin.x = curRect.origin.x;
	newRect.origin.y = curRect.origin.y;
	newRect.size.width = orgRect.size.width * scale;
	newRect.size.height = orgRect.size.height * scale;
	[mImageImageView setCurImageFrame:newRect];
}
- (void)setAppController:(id)aController
{
	mAppController = aController;
}

- (CPString)stringFromHTML:(CPSTring)htmlStr
{
	var retstr = "";
	var paralist = [htmlStr componentsSeparatedByString:@"</p>"];
	var i, icnt = [paralist count];
	for(i=0;i<icnt;i++) {
		var pstr = [paralist objectAtIndex:i];
		var strlist = [pstr componentsSeparatedByString:@"<p>"];
		pstr = [strlist componentsJoinedByString:@""];
		retstr += pstr + "\n";
	}
	return retstr;
}

- (CPURLConnection)sendJSONRequest:(CPString)command data:(CPString)datastr delegate:(var)dele
{
	var lPost_CMD = @"post_mlayout";
	if([mAppController adminUser]) {
		lPost_CMD = @"admin_post_mlayout";
	}
    var lDocOpenURL = [CPString stringWithFormat:"%@/%@",gBaseURL, lPost_CMD];
  	var JSONString = '{"requested_action":"'+command+'","docname":"'+mDocumentName+'","docpath":"'+mDocumentPath+'","userinfo":"'+datastr+'"}';
	
    var lRequest = [CPURLRequest requestWithURL:lDocOpenURL];
	[lRequest setHTTPMethod:@"POST"];
	[lRequest setHTTPBody:JSONString];
	[lRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"] ;
	[lRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"] ;

    var lConnection = [CPURLConnection connectionWithRequest:lRequest delegate:dele];
	return lConnection;
}

- (CPURLConnection)sendJSONRequest:(CPString)command data:(CPString)datastr
{
	return [self sendJSONRequest:command data:datastr delegate:self];
}

- (void)sendJSONRequestAndRefresh:(CPString)command data:(CPString)datastr
{
	mSetContentsCon = [self sendJSONRequest:command data:datastr];
}

- (void)sendCreateRequestAndRefresh:(CPString)command data:(CPString)datastr
{
	mCreateObjectCon = [self sendJSONRequest:command data:datastr];
}


- (CPString)parsebleStringFrom:(CPString)str
{
	var lRetStr = "";
	var i, icnt = [str length];
	for(i=0;i<icnt;i++) {
		var ch = [str characterAtIndex:i];
		if(ch == '&') {
			ch = "{[em}";
		}
		else if(ch == '"') {
			ch = "{[qt}";
		}
		else if(ch == '<') {
			ch = "{[lt}";
		}
		else if(ch == '>') {
			ch = "{[gt}";
		}
		else if(ch == '©') {
			ch = "{[cp}";
		}
		else if(ch == '®') {
			ch = "{[rg}";
		}
		
		lRetStr += ch;
	}
	return lRetStr;
}

- (@action)applyInspector:(id)sender
{
	var str = "";
	if(mArticleInspectorView == mTextInspectorView) {
		var win = [mTextInspectorView DOMWindow];
		if(win) {
			//	var str = [self stringFromHTML:win.document.body.innerHTML];
				var lInnerText = "Start";//win.document.body.innerText;
				if(win.document) {
					lInnerText = "win.doc";
				}
				if(win.document.body) {
					lInnerText = "win.doc.body";
				}
				if(win.document.body.innerText) {
					lInnerText = win.document.body.innerText;
				}
				else {
					lInnerText = win.document.body.innerHTML;
					lInnerText = lInnerText.replace(/(<br>)/ig," ");
					lInnerText = lInnerText.replace(/(<[^>]+>)/g,"");
				}
				lInnerText = [self parsebleStringFrom:lInnerText];
				str = "TEXT__FIELD_SEP__"+lInnerText;  // TEXT + __FIELD_SEP__
		}
	}
	else if(mArticleInspectorView == mXMLInspectorView) {
		var lServerStr = [mXMLInspectorView serverString];
		str = "XML__FIELD_SEP__"+lServerStr;  // XML + __FIELD_SEP__
	}
	if(mImagePath) {
		var lImgRect = CPStringFromRect([mImageImageView curImageFrame]);
		var lImgInfoStr = "Path__IMG_ATTR__"+mImagePath+"__ATTR_SEP__ImgRect__IMG_ATTR__"+lImgRect;
		if([str length])
			str = str + "__TYPE_SEP__";
		str = str + "IMAGE2__FIELD_SEP__" + lImgInfoStr;
		
	}
	var datastr = mGID+"__GIDSEP__"+str;

	mSetContentsCon = [self sendJSONRequest:@"SetContents" data:datastr];
	[mInspectorWin orderOut:self];
	mIsVisible = NO;
	[[ProgressWindow sharedWindow] show];
}

- (@action)closeInspector:(id)sender
{
	[mInspectorWin orderOut:self];
	mIsVisible = NO;
}
- (CPString)stringFromTextInspector
{
	var retstr = "";
	if(mArticleInspectorView == mTextInspectorView) {	
		var win = [mTextInspectorView DOMWindow];
		if(win) {
			//	var str = [self stringFromHTML:win.document.body.innerHTML];
			 retstr = win.document.body.innerHTML;
		}
	}
	return retstr;
}
- (void)setTextContent:(CPString)str
{
	if(mTextContent)
		[mTextContent release];
	mTextContent = [str retain];
}


- (void)changeInspectorAtIndex:(var)idx
{
	if([mTextInspectorView superview])
		[mTextInspectorView removeFromSuperview];
	if(mXMLInspectorView && [mXMLInspectorView superview])
		[mXMLInspectorView removeFromSuperview];
	if([mImageInspectorView superview])
		[mImageInspectorView removeFromSuperview];
		
	if(idx == 0) {
		var lFrame = CPRectInset([mInspectorViewContainer bounds], 3, 3);
		[mArticleInspectorView setFrame:lFrame];
		[mInspectorViewContainer addSubview:mArticleInspectorView];
		if(mTextContent) {
			if(mArticleInspectorView === mTextInspectorView) {
				[mTextInspectorView loadHTMLString:mTextContent];
			}
			else if(mXMLInspectorView){
				[mXMLInspectorView loadXMLString:mTextContent];
			}
		}
	}
	else {
		var lStrFromInspector = [self stringFromTextInspector];
		[self setTextContent:lStrFromInspector];
		[mImageInspectorView setFrame:[mInspectorViewContainer bounds]];
		[mInspectorViewContainer addSubview:mImageInspectorView];
	}
}

- (@action)changeInspector:(id)sender
{
	var idx = 0;
	if(sender)
		idx = [sender indexOfSelectedItem];
	[self changeInspectorAtIndex:idx];
}

- (void)drawingView:(DrawingView)aDrawingView frameSelected:(GraphicFrame)aFrame
{
	var lRequest_CMD = @"request_mlayout";
	if([mAppController adminUser])
		lRequest_CMD = @"admin_request_mlayout";
	var lDocOpenURL = [CPString stringWithFormat:"%@/%@?requested_action=GetContentsJSON&docname=%@&docpath=%@&userinfo=%d",gBaseURL , lRequest_CMD, mDocumentName, mDocumentPath, [aFrame GID]];
    var lRequest = [CPURLRequest requestWithURL:lDocOpenURL];
    mGetContentsCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
	mIsVisible = YES;
	[mScaleSlider setValue:1.0];
	[mInspectorWin makeKeyAndOrderFront:self];
	mGID = [aFrame GID];
	
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    if (connection === mGetContentsCon)
    {
		var lTextViewChanged = NO;
		[self setImagePath:nil];
		if(mOrgImagePath)
			[mOrgImagePath release];
		mOrgImagePath = nil;
		var hasImage = NO;
		var contentsDict = JSON.parse(data);
		var textContent = contentsDict["TEXT"];
		if(textContent) {
			var xmlContent = textContent["XML"]; //[contentsDict objectForKey:@"XML"];
			if(xmlContent) {
				if(mArticleInspectorView != mXMLInspectorView) {
					lTextViewChanged = YES;
					mArticleInspectorView = mXMLInspectorView;
				}
				[self setTextContent:xmlContent];
			}
			else {
				var plainContent = textContent["Plain"]; //[contentsDict objectForKey:@"TEXT"];
				if(plainContent) {
					var lHTMLText = @"<p>";
				 	var j, jcnt = [plainContent length];
					for(j=0;j<jcnt;j++) {
						var ch = [plainContent characterAtIndex:j];
						if(ch === '\n') {
							ch = "</p><p>";
						}
						lHTMLText += ch;
					}
					lHTMLText += @"</p>";
					lHTMLText = @"<html><head></head><body>"+lHTMLText+@"</body></html>";
					if(mArticleInspectorView != mTextInspectorView) {
						lTextViewChanged = YES;
						mArticleInspectorView = mTextInspectorView;
					}
					[self setTextContent:lHTMLText];
				}
			}
		}
		var imgContentDict = contentsDict["IMAGE"]; //[contentsDict objectForKey:@"IMAGE"];
		if(imgContentDict || textContent == nil) {
			var lGraphicDict = contentsDict["Graphic"];
			var lBoxFrame = CGRectFromString(lGraphicDict["Frame"]);
			[mImageImageView setServerBoxSize:lBoxFrame.size];
			var lImageRect = CGRectMakeZero();
			mOrgImagePath = nil;
			if(imgContentDict) {
				lImageRect = CGRectFromString(imgContentDict["Frame"]);
				mOrgImagePath = imgContentDict["Path"]; //[imgContentDict objectForKey:@"Path"];
			}
			[mImageImageView setServerBoxImageFrame:lImageRect];
			[self setImagePathToImageView:mOrgImagePath];
			hasImage = YES;
		}
		if([mAppController useImageTextPopup]) {
			if(hasImage && [mSelectPopupBtn indexOfSelectedItem] != 1) {
				[mSelectPopupBtn selectItemAtIndex:1];
			}
			else if(!hasImage) {
			 	if([mSelectPopupBtn indexOfSelectedItem] != 0){
					[mSelectPopupBtn selectItemAtIndex:0];
				}
				else if(lTextViewChanged){
				}
			}
			[self changeInspector:mSelectPopupBtn];
		}
		else {
			if(hasImage) {
				[mInspectorWin setTitle:@"이미지 수정"]
				[self changeInspectorAtIndex:1];
			}
			else {
				[mInspectorWin setTitle:@"텍스트 수정"]
				[self changeInspectorAtIndex:0];
			}
		}
		mIsVisible = YES;
 		[mInspectorWin makeKeyAndOrderFront:self];
   }
	else if(connection === mSetContentsCon) {
		if([data isEqualToString:@"OK"]) {
			//[mAppController refreshSpreadPreview];
			[mAppController refreshSpreadListView];
		}
		else {
			[mAppController refreshSpreadListView];
			
		}
		[[ProgressWindow sharedWindow] hide];
		
	}
	else if(connection === mCreateObjectCon) {
		[mAppController refreshSpreadListView];
		do {
			if([data length] < 10)
				break;
			lItemList = [data componentsSeparatedByString:@","];
			if([lItemList count] < 5)
				break;
			var lGID = [[lItemList objectAtIndex:0] intValue];
			var lLeft = [[lItemList objectAtIndex:1] floatValue];
			var lTop = [[lItemList objectAtIndex:2] floatValue];
			var lWidth = [[lItemList objectAtIndex:3] floatValue];
			var lHeight = [[lItemList objectAtIndex:4] floatValue];
			var lRect = CPRectMake(lLeft, lTop, lWidth, lHeight);
			var lGFrame = [[GraphicFrame alloc] initWithRect:lRect gid:lGID];
			[mDrawingView addFrame:lGFrame];
			[mDrawingView resetCreateFrame];
			[mDrawingView selectFrame:lGFrame];
			
		} while(0);
		[[ProgressWindow sharedWindow] hide];
		[self selectSelectionTool];		
	}
}

- (int)selectedTool
{
	return [mAppController selectedTool];
}

- (void)selectSelectionTool
{
	[mAppController selectSelectionTool];
}

- (int)currentSpreadIndex
{
	return [mAppController currentSpreadIndex];
}

- (void)connection:(CPURLConnection)connection didFailWithError:(CPString)error
{
    alert("Connection did fail with error : " + error) ;
}

- (void)connectionDidFinishLoading:(CPURLConnection)aConnection
{
    //console.log("Connection did finish loading.") ;
}

@end
