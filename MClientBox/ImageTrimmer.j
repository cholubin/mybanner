
@import <Foundation/CPObject.j>

@implementation ImageClipper : CPView
{
	CPRect mBoxFrame;
	CPSize mServerBoxSize;
}

- (id)initWithFrame:(CPRect)rect
{
	self = [super initWithFrame:rect];
	if(self){
		var lBounds = [self bounds];
		mBoxFrame = CPRectInset(lBounds, 50, 50);
		mServerBoxSize = CPSizeMake(0, 0);
	}
	return self;
}
- (void)drawRect:(CPRect)rect
{
	if(mServerBoxSize.width == 0 || mServerBoxSize.height == 0)
		return;
	[self resetBoxFrame];
	var lBounds = [self bounds];
	var bpath = [CPBezierPath bezierPath];
	[bpath moveToPoint:mBoxFrame.origin];
	[bpath lineToPoint:CPMakePoint(CPRectGetMaxX(mBoxFrame), mBoxFrame.origin.y)];
	[bpath lineToPoint:CPMakePoint(CPRectGetMaxX(mBoxFrame), CPRectGetMaxY(mBoxFrame))];
	[bpath lineToPoint:CPMakePoint(mBoxFrame.origin.x, CPRectGetMaxY(mBoxFrame))];
	[bpath lineToPoint:mBoxFrame.origin];
	[bpath lineToPoint:lBounds.origin];
//	[bpath lineToPoint:CPMakePoint(mBoxFrame.origin.x, mBoxFrame.origin.y-1)];
//	[bpath lineToPoint:CPMakePoint(lBounds.origin.x, lBounds.origin.y-1)];
	[bpath lineToPoint:CPMakePoint(lBounds.origin.x, CPRectGetMaxY(lBounds))];
	[bpath lineToPoint:CPMakePoint(CPRectGetMaxX(lBounds), CPRectGetMaxY(lBounds))];
	[bpath lineToPoint:CPMakePoint(CPRectGetMaxX(lBounds), lBounds.origin.y)];
	[bpath lineToPoint:lBounds.origin];
	[bpath closePath];
	

//	[[CPColor colorWithRed:1 green:1 blue:1 alpha:0.7] set];
	[[CPColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7] set];
	[bpath fill];
	
}


- (void)resetBoxFrame
{
	if(mServerBoxSize.width == 0 || mServerBoxSize.height == 0)
		return;
	var lBounds = [self bounds];
	var lMaxWidth = lBounds.size.width - 60; // (30+30);
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

- (void)setServerBoxSize:(CPSize)server_boxsize
{

	mServerBoxSize = server_boxsize;
	[self setNeedsDisplay:YES];
}

- (CPSize)serverBoxSize
{
	return mServerBoxSize;
}

- (CPRect)boxFrame
{
	
	return mBoxFrame;
}

- (float)factor
{
	if(mServerBoxSize.width == 0)
		return 0.1;
	return mBoxFrame.size.width / mServerBoxSize.width;
}
@end

//
//
//          ImageTrimmer
//
//////////////////////////////////////
@implementation ImageTrimmer : CPView
{
	ImageClipper mClipView;
	CPImageView mImageView;
	CPRect orgImageFrame;
	CPPoint mPointInView;
	BOOL mImageGrabed;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self) {
		var lSelfBounds = [self bounds];
        var lClipViewFrame = CPRectInset(lSelfBounds, 10, 10);
		mImageView = [[CPImageView alloc] initWithFrame:lClipViewFrame];
		[mImageView setImageScaling:CPScaleToFit];
		//[mImageView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];  //| CPViewMaxYMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMinXMargin 
		[self addSubview:mImageView];
		
		mClipView = [[ImageClipper alloc] initWithFrame:lSelfBounds];
  		[mClipView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];  //| CPViewMaxYMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMinXMargin 
		[self addSubview:mClipView];
		[self setAutoresizesSubviews:YES];
		mPointInView = CPPointMake(0, 0);
		orgImageFrame = lClipViewFrame;
	  	
  }
    return self;
}

- (void)dealloc
{
	[mImageView release];
	[super dealloc];
}


// CPScaleProportionally   = 0;
// CPScaleToFit            = 1;
// CPScaleNone
- (void)setImage:(CPImage)aImage
{
	var imgrect = [mImageView imageRect];
	var imgsize = [aImage size];
	if(imgrect) {
//		console.log("img size before = "+CPStringFromSize(imgrect.size));
		
	}
	//[mImageView setImageScaling:CPScaleProportionally];
	[mImageView setImage:aImage];
	//[mImageView display];
	imgsize = [[mImageView image] size];
	imgrect = [mImageView imageRect];
	if(imgrect) {
//		console.log("img size after = "+CPStringFromSize(imgrect.size));
		
	}
}

- (void)setServerBoxSize:(CPSize)aSize
{
	[mClipView setServerBoxSize:aSize];
}

- (CPSize)serverBoxSize
{
	return [mClipView serverBoxSize];
}

- (void)resetImageViewFrame
{
	var lNewImageFrame = CPRectMake(0,0,0,0);
	var lBoxFrame = [mClipView boxFrame];
	var lScaleFactor = [mClipView factor];
	lNewImageFrame.origin.x = lScaleFactor * orgImageFrame.origin.x + lBoxFrame.origin.x;
	lNewImageFrame.origin.y = lScaleFactor * orgImageFrame.origin.y + lBoxFrame.origin.y;
	lNewImageFrame.size.width = lScaleFactor * orgImageFrame.size.width;
	lNewImageFrame.size.height = lScaleFactor * orgImageFrame.size.height;
	[mImageView setFrame:lNewImageFrame];
}

- (void)setServerBoxImageFrame:(CPRect)image_frame
{
	orgImageFrame = image_frame;
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(CPRect)rect
{
	[self resetImageViewFrame];
	[[CPColor colorWithRed:0 green:0 blue:0.5 alpha:1] set];
	[CPBezierPath fillRect:[self bounds]];
	
	var lBoxFrame = [mClipView boxFrame];
	[[CPColor colorWithRed:1 green:0 blue:0 alpha:1] set];
	[CPBezierPath fillRect:lBoxFrame];
	[super drawRect:rect];
}

- (BOOL)isEventInFrame:(CPEvent)anEvent view:(CPView)aView
{
	var lPtInWindow = [anEvent locationInWindow];
	var lWin = [aView window];
	var lWincontentview = [lWin contentView];
	var lPtInView = [aView convertPoint:lPtInWindow fromView:lWincontentview];
	var lScaledRect = [aView scaledRectFrom:mRect];
	return CPRectContainsPoint(lScaledRect, lPtInView);
}

- (void)mouseDragged:(CPEvent)anEvent  
{
	if(!mImageGrabed)
		return;
	var lBoxFrame = [mClipView boxFrame];
	var lPtInWindow = [anEvent locationInWindow];
	var lWin = [self window];
	var lWincontentview = [lWin contentView];
	var contentOrgY = [lWincontentview frame].origin.y;
	var lPtInView = [self convertPoint:lPtInWindow fromView:lWincontentview];
	lPtInView.y -= contentOrgY;
	var dx = lPtInView.x - mPointInView.x;
	var dy = lPtInView.y - mPointInView.y;
	var lScaleFactor = [mClipView factor];
	
	if([anEvent modifierFlags] == 131072)  {  // shift key only
		var max = dx / lScaleFactor;
		//if(dy > dx) {
		//	max = dy;
	//	}
		//max = dx / lScaleFactor;
		var imgFactor = orgImageFrame.size.width / orgImageFrame.size.height; 
		if(imgFactor > 1.0) { // orgImageFrame.size.width > orgImageFrame.size.height	
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
		
/*
			max = dy;
		var lImgScaleFactor = 1.0 + max / lScaleFactor;
		orgImageFrame.size.width *= lImgScaleFactor;
		orgImageFrame.size.height *= lImgScaleFactor;
		*/
	}
	else {
		orgImageFrame.origin.x += dx / lScaleFactor;
		orgImageFrame.origin.y += dy / lScaleFactor;
	}
	[self setNeedsDisplay:YES];
	mPointInView = lPtInView;
//	console.log("keycode = "+[anEvent modifierFlags]);
}

- (void)mouseDown:(CPEvent)anEvent
{
	var lBoxFrame = [mClipView boxFrame];
	var lPtInWindow = [anEvent locationInWindow];
	var lWin = [self window];
	var lWincontentview = [lWin contentView];
	var contentOrgY = [lWincontentview frame].origin.y;
	// console.log("title height = "+contentOrgY);  // 26 pixel
	var lPtInView = [self convertPoint:lPtInWindow fromView:lWincontentview];
	lPtInView.y -= contentOrgY;
	if(CPRectContainsPoint(lBoxFrame, lPtInView)) {
		mImageGrabed = YES;
		mPointInView = lPtInView;
	}
	
}
- (void)mouseUp:(CPEvent)anEvent
{
	mImageGrabed = NO;
}

- (CPRect)orgImageFrame
{
	return orgImageFrame;
}
@end
