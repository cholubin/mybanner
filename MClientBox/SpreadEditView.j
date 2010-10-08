@import <Foundation/CPObject.j>

@import "DrawingView.j"
@import "ProgressWindow.j"
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
@implementation SpreadEditView : CPView
{
	DrawingView mDrawingView;
	CPImageView mImageView;
	EditController mEditController;
	BOOL mEditMode;
	float mScaleFactor;
	CPSize mImageSize;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self) {
	//	mImageView = [[SSIImageView alloc] initWithFrame:frame];
		mImageView = [[CPImageView alloc] initWithFrame:frame];
		//[mImageView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[mImageView setImageScaling:CPScaleToFit];
		[self addSubview:mImageView];
		[mImageView release];
		
		 mDrawingView = [[DrawingView alloc] initWithFrame:frame];
		// //[mDrawingView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[self addSubview:mDrawingView];
		[mDrawingView release];
		
		mEditMode = YES;		
		mScaleFactor = 1.0;
	}
	return self;
}

- (CPImageView)imageView
{
	return mImageView;
}

- (DrawingView)drawingView
{
	return mDrawingView;
}

- (BOOL)editMode
{
	return mEditMode;
}

- (void)setEditMode:(BOOL)flag
{
	mEditMode = flag;
}

- (void)setScaleFactor:(float)aFactor
{
	mScaleFactor = aFactor;
}

- (float)scaleFactor
{
	return mScaleFactor;
}

- (void)setSpreadImage:(CPImage)anImage
{
	if(anImage) {
		[anImage setDelegate:self];
	    if([anImage loadStatus] == CPImageLoadStatusCompleted)
	        [self imageDidLoad:anImage];
	    else {
	        [mImageView setImage:nil];
		}
	}
	else {
        [mImageView setImage:nil];
	}
}


// - (void)setFrame:(CPRect)aRect
// {
// 	debugger;
// 	[super setFrame:aRect];
// }
- (void)reposition:(CPNotification)notification
{
	var lNewViewFrame = [self frame];
	var lScrollView = [self enclosingScrollView];
	var lContentSize = [[lScrollView contentView] frame].size;
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
	[self setFrame:lNewViewFrame];
}


- (void)rescale
{
	var lImageSize = [[mImageView image] size]; // CGSizeMake(0, 0); 
//	lImageSize.width = mImageSize.width * mScaleFactor;
//	lImageSize.height = mImageSize.height * mScaleFactor;
	var lSpreadSize = [mDrawingView spreadSize];
	lImageSize.width = lSpreadSize.width * mScaleFactor;
	lImageSize.height = lSpreadSize.height * mScaleFactor;
	var lNewImageFrame = CGRectMake(0, 0, 0, 0); 
	// 100614 by sishin
	var lScrollView = [self enclosingScrollView];
	var lContentSize = [[lScrollView contentView] frame].size;
	var xMargin = (lContentSize.width - lImageSize.width) / 2.0;
	var yMargin = (lContentSize.height - lImageSize.height) / 2.0;
	lNewImageFrame.size = lImageSize;
	
	[mImageView setFrame:lNewImageFrame];
	if(mDrawingView) {
		[mDrawingView setFrame:lNewImageFrame];
	}
	var lNewViewFrame = [self frame];
	lNewViewFrame.origin.x = 0;
	lNewViewFrame.origin.y = 0;
	if(xMargin > 0) {
		lNewViewFrame.origin.x = xMargin;
	}
	if(yMargin > 0) {
		lNewViewFrame.origin.y = yMargin;
	}
	
	lNewViewFrame.size = lNewImageFrame.size;
	[self setFrame:lNewViewFrame];
}

- (void)imageDidLoad:(CPImage)anImage
{
	if(anImage != [mImageView image]) {
		var lImageSize = [anImage size];
		mImageSize = CGSizeMake(lImageSize.width, lImageSize.height);
		// lImageSize.width = mImageSize.width * mScaleFactor;
		// lImageSize.height = mImageSize.height * mScaleFactor;
		
		var lSpreadSize = [mDrawingView spreadSize];
		lImageSize.width = lSpreadSize.width * mScaleFactor;
		lImageSize.height = lSpreadSize.height * mScaleFactor;
		
		var lNewImageFrame = CGRectMake(0, 0, 0, 0); 
		lNewImageFrame.size = lImageSize;
		[mImageView setFrame:lNewImageFrame];
		if(mDrawingView) {
			[mDrawingView setFrame:lNewImageFrame];
		}
		var lNewViewFrame = [self frame];
		lNewViewFrame.size = lNewImageFrame.size;
		
		var lScrollView = [self enclosingScrollView];
		var lContentSize = [[lScrollView contentView] frame].size;
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
		
		
		[self setFrame:lNewViewFrame];
		//[self setNeedsDisplay:YES];
		//[self setCenter:[[self superview] center]];
    	
	}
    [mImageView setImage:anImage];
	[[ProgressWindow sharedWindow] hide];
}

@end
