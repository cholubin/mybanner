


@implementation SDImageView : CPView   // prefix 'SD'  means Sung-Do
{
	CPImageView mImageView;
	CPTextField mTextField;
	BOOL mIsSelected;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self) {
	//	[self setBackgroundColor:[CPColor lightGrayColor]];
		
//		var lInRect = CPRectInset([self bounds], 10, 10);
//		mImageView = [[CPImageView alloc] initWithFrame:lInRect];
//		[mImageView setImageScaling:CPScaleProportionally];
//		[self addSubview:mImageView];
	}
	return self;
}

- (void)buildSubviews // createImageView
{
	var lInRect = CPRectInset([self bounds], 10, 10);
	mImageView = [[CPImageView alloc] initWithFrame:lInRect];
	//[mImageView setBackgroundColor:[CPColor lightGrayColor]];
	//[mImageView setAutoresizeMask:CPViewHeightSizable | CPViewWidthSizable];
	[mImageView setImageScaling:CPScaleProportionally];
	[self addSubview:mImageView];
	[mImageView release];
}

- (void)deleteImageView
{
	
	
}
- (id)imageView
{
	return mImageView;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	if(mIsSelected) {
		[[CPColor colorWithRed:1 green:0 blue:0 alpha:0.3] set];
		[CPBezierPath fillRect:[self bounds]];
	}
	else{
		//[[CPColor whiteColor] set];
		[[CPColor lightGrayColor] set];
		[CPBezierPath fillRect:[self bounds]];
	}

}

- (void)setImage:(id)image
{
	[image setDelegate:self];
    if([image loadStatus] == CPImageLoadStatusCompleted)
        [mImageView setImage:image];
    else
        [mImageView setImage:nil];
}

- (void)imageDidLoad:(CPImage)anImage
{
    [mImageView setImage:anImage];
}

- (void)setSelected:(BOOL)shouldBeSelected
{
	mIsSelected = shouldBeSelected;
	[self display];
}

@end
////////////    ///////    //                ///         /////////    /////////   ///////////////
////////////  //      //   //               // //       //           //           ///////////////
////////////  //           //              //   //       ////////     ////////    
////////////  //           //             /////////             //           //   ///////////////
////////////  //      //   //            //       //    //      //   //      //   ///////////////
////////////   ///////     //////////   //         //    ////////     ////////    ///////////////

@implementation SDCollectionViewItem : CPCollectionViewItem
- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
	if(![[self view] imageView])
		[[self view] buildSubviews]; // createImageView];
	var image = [representedObject objectForKey:@"image"];
	[image setDelegate:self];
	[[self view] setImage:image];
    if([image loadStatus] == CPImageLoadStatusCompleted)
        [[self view] setImage:image];
    else
        [[self view] setImage:nil];
	
}
- (void)imageDidLoad:(CPImage)anImage
{
    [[self view] setImage:anImage];
}

- (void)setSelected:(BOOL)shouldBeSelected
{
	[super setSelected:shouldBeSelected];
	[[self view] setSelected:shouldBeSelected];
}


@end

////////////    ///////    //                ///         /////////    /////////   ///////////////
////////////  //      //   //               // //       //           //           ///////////////
////////////  //           //              //   //       ////////     ////////    ///////////////
////////////  //           //             /////////             //           //   
////////////  //      //   //            //       //    //      //   //      //   ///////////////
////////////   ///////     //////////   //         //    ////////     ////////    ///////////////

@implementation ModeChangeAnimation : CPAnimation
{
    @outlet AppController mController;
	var mStart;
	var mEnd;
	var reverse;
}

- (void)setController:(id)anObject
{
	if(mController)
		[mController release];
	mController = [anObject retain];
}
- (void)setReverse:(var)flag
{
	reverse = flag;
}
- (void)setStart:(var)aValue
{
	mStart = aValue;
}
 
- (id)start
{
	return mStart;
}
 
- (void)setEnd:(var)aValue
{
	mEnd = aValue;
}
 
- (id)end
{
	return mEnd;
}
 
//var frame1 = [mScrollView frame];
//[animation setStart:frame1.origin.x];
//var frame2 = [[mDocumentListView enclosingScrollView] frame];


- (void)setCurrentProgress:(float)progress
{
	[super setCurrentProgress:progress];
	progress = [self currentValue];
    var lXpos = (progress * (mEnd - mStart)) + mStart;
	var lFrame = [[mController spreadScrollView] frame];
	var lWidthDiff = lFrame.origin.x - lXpos;
	lFrame.origin.x = lXpos;
	lFrame.size.width += lWidthDiff;
	[[mController spreadScrollView] setFrame:lFrame];
	
	lFrame = [[mController spreadListScrollView] frame];
	lWidthDiff = lFrame.origin.x - lXpos;
	lFrame.origin.x = lXpos;
	lFrame.size.width += lWidthDiff;
	[[mController spreadListScrollView] setFrame:lFrame];
	
	lFrame = [[mController spreadTitle] frame];
	lFrame.origin.x = lXpos;
	[[mController spreadTitle] setFrame:lFrame];

	lFrame = [[mController controlBox] frame];
	lFrame.origin.x = lXpos;
	lFrame.size.width += lWidthDiff;
	[[mController controlBox] setFrame:lFrame];
	
	if(reverse) {
		[[mController documentListScrollView] setAlphaValue:progress];
		[[mController docListTitle] setAlphaValue:progress];
		[[mController deleteBtn] setAlphaValue:progress];
		[[mController generatePDFBtn] setAlphaValue:progress];
	}
	else {
		[[mController documentListScrollView] setAlphaValue:1 - progress];
		[[mController docListTitle] setAlphaValue:1 - progress];
		[[mController deleteBtn] setAlphaValue:1 - progress];
		[[mController generatePDFBtn] setAlphaValue:1 - progress];
	}
}
@end

@implementation HideSpreadListViewAnimation : CPAnimation
{
	var mStart;
	var mEnd;
	var mControlBoxDistance;
	var mSpreadViewDistance;
}

- (void)setStart:(var)aValue
{
	mStart = aValue;
}
 
- (id)start
{
	return mStart;
}
 
- (void)setEnd:(var)aValue
{
	mEnd = aValue;
}
 
- (id)end
{
	return mEnd;
}
 
- (void)setControlBoxDistance:(var)aValue
{
	mControlBoxDistance = aValue;
}
 
- (id)controlBoxDistance
{
	return mControlBoxDistance;
}

- (void)setSpreadViewDistance:(var)aValue
{
	mSpreadViewDistance = aValue;
}

- (id)spreadViewDistance
{
	return mSpreadViewDistance;
}

- (void)setCurrentProgress:(float)progress
{
	[super setCurrentProgress:progress];
 
	progress = [self currentValue];
 	var lOrgHeight = mEnd - mStart;
	var lYInc = (progress * lOrgHeight);
   	var lYpos = lYInc + mStart;
	var lHeight = lOrgHeight - lYInc;
	var lFrame = [[[self delegate] spreadListScrollView] frame];
	lFrame.origin.y = lYpos;
	lFrame.size.height = lHeight;
	[[[self delegate] spreadListScrollView] setFrame:lFrame];

	var lTFrame = [[[self delegate] controlBox] frame];
	lTFrame.origin.y = lFrame.origin.y - mControlBoxDistance;
	[[[self delegate] controlBox] setFrame:lTFrame];

	lTFrame = [[[self delegate] spreadScrollView] frame];
	lTFrame.size.height = lFrame.origin.y - mSpreadViewDistance - lTFrame.origin.y;
	[[[self delegate] spreadScrollView] setFrame:lTFrame];
}
@end

@implementation ShowSpreadListViewAnimation : HideSpreadListViewAnimation
{
}

 
- (void)setCurrentProgress:(float)progress
{
	[super setCurrentProgress:progress];
	progress = [self currentValue];
 	var lOrgHeight = mStart - mEnd;
	var lYInc = (progress * lOrgHeight);
   	var lYpos = mStart - lYInc;
	var lHeight = lYInc;
	var lFrame = [[[self delegate] spreadListScrollView] frame];
	lFrame.origin.y = lYpos;
	lFrame.size.height = lHeight;
	[[[self delegate] spreadListScrollView] setFrame:lFrame];
	
	var lTFrame = [[[self delegate] controlBox] frame];
	lTFrame.origin.y = lFrame.origin.y - mControlBoxDistance;
	[[[self delegate] controlBox] setFrame:lTFrame];
	

	lTFrame = [[[self delegate] spreadScrollView] frame];
	lTFrame.size.height = lFrame.origin.y - mSpreadViewDistance - lTFrame.origin.y;
	[[[self delegate] spreadScrollView] setFrame:lTFrame];
}
@end
