@import "CollectionViewItem.j"

gThumbSizeWidth = 100;
gThumbSizeHeight = 100;

@implementation ImagePickerWindow : CPWindow
//@implementation CPWindow (Added_Method_SetStyleMask)
{
	
}
- (void)setStyleMask:(unsigned int)newMask
{
	_styleMask = newMask;
}
@end

@implementation ImagePickerController : CPObject
{
	@outlet CPWindow 			mImagePickerWin;
	@outlet CPPopUpButton		mCategoryPopup;
	@outlet CPCollectionView 	mImageCollectionView;
	@outlet CPImageView 		mPreviewImageView;
	@outlet CPTextField 		mTotalField;
	@outlet CPTextField 		mNameField;
	@outlet CPTextField 		mSizeField;
	
	id 							mReceiver;
	CPURLConnection				mImageCategoryCon;
	CPURLConnection				mImageListCon;
	CPNotificationCenter		mNotiCenter;
}

- init
{
	self = [super init];
	if(self) {
		[CPBundle loadCibNamed:@"ImagePicker" owner:self];
	}
	return self;
}
- (void)dealloc
{
	[mReceiver release];
	[super dealloc];
}

- (void)cibDidFinishLoading:(id)anObj
{
}

- (void)awakeFromCib
{
//	var styleMask = [mImagePickerWin styleMask];
//	[mImagePickerWin setStyleMask:CPTitledWindowMask]
    var lItem = [[SDCollectionViewItem alloc] init];
//	[mImageCollectionView setMaxItemSize:CPSizeMake(gThumbSizeWidth, gThumbSizeHeight)];
  	[mImageCollectionView setMinItemSize:CPSizeMake(gThumbSizeWidth, gThumbSizeHeight)];
	[mImageCollectionView setSelectable:YES];
	[mImageCollectionView setDelegate:self];
	[mImageCollectionView setBackgroundColor:[CPColor lightGrayColor]];
	
	[[mPreviewImageView superview] setBackgroundColor:[CPColor lightGrayColor]];
	[mPreviewImageView setImageScaling:CPScaleProportionally];
	
    var lCellWidth = [mImageCollectionView minItemSize].width;
   	var lCellHeight = [mImageCollectionView minItemSize].height;
    var lCellFrame = CPRectMake(0, 0, lCellWidth, lCellHeight);
    var lDocThumbView = [[SDImageView alloc] initWithFrame:lCellFrame];
    var lItem = [[SDCollectionViewItem alloc] init];
    [lItem setView:lDocThumbView];
	[mImageCollectionView setItemPrototype:lItem];
	[mImagePickerWin setDelegate:self];
//	mNotiCenter = [[CPNotificationCenter alloc] init];
//	[mNotiCenter addObserver:self selector:@selector(windowWillCloseNotification:) name:CPWindowWillCloseNotification object:mImagePickerWin];
	
}

// - (@action)changeCategory:(id)sender
// {
// 	var category = [mCategoryPopup titleOfSelectedItem];
// 	[mCategoryPopup setEnabled:NO];
// 
// 	var lAppController = [[CPApplication sharedApplication] delegate];
//  	var lAdminUser = [lAppController adminUser];
// 	var lCurDocPath = [lAppController currentDocumentPath];
// 	var lFilename = [lCurDocPath lastPathComponent];
// 	var lRequest_CMD = @"request_mlayout";
// 	if(lAdminUser)
// 		lRequest_CMD = @"admin_request_mlayout";
//     var lDocWebImagePathStr = [CPString stringWithFormat:"%@/%@?requested_action=Filelist&docname=%@&userinfo=%@/images/%@/",gBaseURL , lRequest_CMD, lFilename,gUserPath,category];
//   	var lDocWebImageURL = [CPURL URLWithString:lDocWebImagePathStr];
//   	var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
// 
//     mImageListCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
// }

- (@action)changeCategory:(id)sender
{
	var category = [mCategoryPopup titleOfSelectedItem];
	[mCategoryPopup setEnabled:NO];

 	var lAdminUser = [[[CPApplication sharedApplication] delegate] adminUser];
	var lServerDocPath = [[[CPApplication sharedApplication] delegate] serverDocumentPath]
	var lFileList_CMD = @"filelist";
	if(lAdminUser) 
		lFileList_CMD = @"admin_filelist";
    var lDocWebImagePathStr = [CPString stringWithFormat:"%@/%@?request=/images/%@/&docpath=%@",gBaseURL ,lFileList_CMD ,category,lServerDocPath];
	var lDocWebImageURL = [CPURL URLWithString:lDocWebImagePathStr];
    var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
    mImageListCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
}

- (void)loadImages:(var)lFilename list:(var)lItemList
{
 	//var lUserid = [[[CPApplication sharedApplication] namedArguments] objectForKey:@"userid"]; 
//	var lFilename = [CPString stringWithString:lFilename];
	var ext = [lFilename pathExtension];
	if(ext.length < 3)
		return;
	if([lFilename isEqualToString:ext])
		return;
	var lThumbExt = ".jpg";
	if([[ext lowercaseString] isEqualToString:@"eps"] || [[ext lowercaseString] isEqualToString:@"pdf"]) 
		lThumbExt = ".png";
	var lCategory = [mCategoryPopup titleOfSelectedItem];
	var lImageName = [lFilename substringToIndex:[lFilename length] - [ext length] - 1];
	lImageName = lImageName + lThumbExt;
    var lImagePath = [CPString stringWithString:gUserPath+"/images/"+lCategory+"/"+lFilename];
    var lImageThumbPath = [CPString stringWithString:gBaseURL+gUserPath+"/images/"+lCategory+"/Thumb/"+lImageName];
    var lThumbImage = [[CPImage alloc] initWithContentsOfFile:lImageThumbPath];
	var dict = [[CPDictionary alloc] init]; //dictionaryWithObjectsAndKeys:lThumbImage ,@"image",lImagePath,@"path", nil];
	[dict setObject:lThumbImage forKey:@"image"];
	[dict setObject:lImagePath forKey:@"path"];
    [lItemList addObject:dict];
}

- (@action)ok:(id)sender
{
	var lIdx = [[mImageCollectionView selectionIndexes] firstIndex];
	if(lIdx >= 0) {
		var lImgList = [mImageCollectionView content];
		if([lImgList count] > 0) {
			var lDict = [lImgList objectAtIndex:lIdx];
			var lImagePath = [lDict objectForKey:@"path"];
			[mReceiver setNewImagePathToImageView:lImagePath];			
		}
	}
//	[[CPApplication sharedApplication] stopModalWithCode:[sender tag]];
	[mImagePickerWin close];
}

- (@action)cancel:(id)sender
{
//	[[CPApplication sharedApplication] stopModalWithCode:[sender tag]];
	[mImagePickerWin close];
}

// - (void)runModalForReceiver:(id)aReceiver
// {
// 	if(mReceiver)
// 		[mReceiver release];
// 	mReceiver = [aReceiver retain];
// 	
// 	var lAppController = [[CPApplication sharedApplication] delegate];
//  	var lAdminUser = [lAppController adminUser];
// 	var lCurDocPath = [lAppController currentDocumentPath];
// 	var lFilename = [lCurDocPath lastPathComponent];
// 	var lRequest_CMD = @"request_mlayout";
// 	if(lAdminUser)
// 		lRequest_CMD = @"admin_request_mlayout";
//     var lDocWebImagePathStr = [CPString stringWithFormat:"%@/%@?requested_action=Filelist&docname=%@&userinfo=%@/images/",gBaseURL , lRequest_CMD, lFilename, gUserPath];
//   	var lDocWebImageURL = [CPURL URLWithString:lDocWebImagePathStr];
//   	var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
//     mImageCategoryCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
// 
// 	[mCategoryPopup setEnabled:NO];
// 	
// 	[mImagePickerWin makeKeyAndOrderFront:self];
// 	[[CPApplication sharedApplication] runModalForWindow:mImagePickerWin];
// }

- (void)runModalForReceiver:(id)aReceiver
{
	if(mReceiver)
		[mReceiver release];
	mReceiver = [aReceiver retain];
	
 	var lAdminUser = [[[CPApplication sharedApplication] delegate] adminUser];
	var lServerDocPath = [[[CPApplication sharedApplication] delegate] serverDocumentPath]
	var lFileList_CMD = @"filelist";
	if(lAdminUser) 
		lFileList_CMD = @"admin_filelist";

   	var lDocWebImageURL = [CPString stringWithFormat:"%@/%@?request=/images/&docpath=%@",gBaseURL,lFileList_CMD,lServerDocPath];
    var lRequest = [CPURLRequest requestWithURL:lDocWebImageURL];
    mImageCategoryCon = [CPURLConnection connectionWithRequest:lRequest delegate:self];
	[mCategoryPopup setEnabled:NO];
	
	[mImagePickerWin makeKeyAndOrderFront:self];
	[[CPApplication sharedApplication] runModalForWindow:mImagePickerWin];
}

- (void)connection:(CPURLConnection)connection didFailWithError:(CPString)error
{
    alert("Connection did fail with error : " + error) ;
}

- (void)connectionDidFinishLoading:(CPURLConnection)aConnection
{
   // console.log("Connection did finish loading.") ;
}
- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    if (connection === mImageCategoryCon)
    {
		debugger;
		[mCategoryPopup removeAllItems];
	    var lPathList = [data componentsSeparatedByString:@"\n"]; 
		var i;
		for(i=0;i<[lPathList count];i++) {
			var lCatName = [lPathList objectAtIndex:i];
			if([lCatName length])
				[mCategoryPopup addItemWithTitle:lCatName];
		}
		[mCategoryPopup selectItemAtIndex:0];
		[self changeCategory:mCategoryPopup];
	}
	else if(connection === mImageListCon) {
	    var lPathList = [data componentsSeparatedByString:@"\n"]; // [[CPArray alloc] init];
	    var lItemList = [[CPArray alloc] init];
	   	var i;
	    for(i=0;i<lPathList.length; i++) {
			var lImageName = [lPathList objectAtIndex:i];
			if([lImageName length])
	       		[self loadImages:lImageName list:lItemList];
	    }
		
		[mImageCollectionView setContent:lItemList];
		[mCategoryPopup setEnabled:YES];
	}
}

-(void)collectionViewDidChangeSelection:(CPCollectionView)collectionView
{
	if(collectionView === mImageCollectionView) {
		
		var lIdx = [[mImageCollectionView selectionIndexes] firstIndex];
		var lDict = [[mImageCollectionView content] objectAtIndex:lIdx];
	    var lImagePath = [lDict objectForKey:"path"];
		var lFilename = [lImagePath lastPathComponent];
		var ext = [lFilename pathExtension];
		if(ext.length < 3) {
			[mPreviewImageView setImage:nil];
			return;
		}
		var lImageName = [lFilename substringToIndex:[lFilename length] - [ext length] - 1];
		var lPreviewExt = ".jpg";
		if([[ext lowercaseString] isEqualToString:@"eps"] || [[ext lowercaseString] isEqualToString:@"pdf"]) 
			lPreviewExt = ".png";
		
		var lPreviewFilename = lImageName + lPreviewExt;
		var lImageFolder = [lImagePath stringByDeletingLastPathComponent];
		
	    var lImagePreviewPath = gBaseURL + lImageFolder+"/Preview/"+lPreviewFilename;
	    var lPreviewImage = [[CPImage alloc] initWithContentsOfFile:lImagePreviewPath];
		[mPreviewImageView setImage:lPreviewImage];
		[lPreviewImage release];
	}
}
- (void)windowWillCloseNotification:(CPNotification)notification
{
	if([notification object] == mImagePickerWin) {
		debugger;
		[[CPApplication sharedApplication] stopModal];
	//	[mImagePickerWin orderOut:self];
	}
	
}

- (void)windowWillClose:(id)aWin
{
	if(aWin == mImagePickerWin) {
		debugger;
		[[CPApplication sharedApplication] stopModal];
//		[mImagePickerWin orderOut:self];
	}
	
}
@end
