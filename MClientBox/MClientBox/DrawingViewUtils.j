
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


@implementation Knob : CPObject
{
	CGRect mKnobRect;
	GraphicFrame mGFrame;
	int position;
}
- (id)initWithRect:(CGRect)aRect gFrame:(GraphicFrame)aGFrame position:(int)pos
{
	self = [super init];
	if(self) {
		mKnobRect = aRect;
		mGFrame = aGFrame;
		position = pos;
	}
	return self;
}

- (CGRect)rect
{
	return mKnobRect;
}

- (GraphicFrame)graphicFrame
{
	return mGFrame;
}

- (int)position
{
	return position;
}
@end


@implementation GraphicFrame : CPObject
{
	CGRect mRect;
	var mGID;
	CPArray mKnobList;
}

- (id)initWithRect:(CGRect)aRect gid:(var)aGID
{
	self = [super init];
	if(self) {
		mRect = aRect;
		mGID = aGID;
 		mKnobList = [[CPArray alloc] init]		
	}
	return self;
}

- (CGRect)rect
{
	return mRect;
}
- (var)GID
{
	return mGID;
}
- (BOOL)isEventInFrame:(CPEvent)anEvent view:(CPView)aView
{
	var lPtInWindow = [anEvent locationInWindow];
	var lWin = [aView window];
	//var lWincontentview = [lWin contentView];
	var lPtInView = [aView convertPoint:lPtInWindow fromView:nil];
	var lScaledRect = [aView scaledRectFrom:mRect];
	return CPRectContainsPoint(lScaledRect, lPtInView);
}

- (void)setOrigin:(CPPoint)point
{
	mRect.origin = point;
}

- (void)setRect:(CGRect)aRect
{
	mRect = aRect;
}

- (void)drawKnobsOnView:(CPView)aView
{
	var lScaledRect = [aView scaledRectFrom:mRect];
	var lOutRect = CPRectInset(lScaledRect, -3, -3);
	[[CPColor darkGrayColor] set];
	// left top
	[mKnobList removeAllObjects];
	var knobRect = CPRectMake(lOutRect.origin.x, lOutRect.origin.y, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionLeftTop];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	// top
	knobRect = CPRectMake(lOutRect.origin.x+(lOutRect.size.width-gKnobWidth)/2.0, lOutRect.origin.y, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionTop];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	// right top
	knobRect = CPRectMake(CPRectGetMaxX(lOutRect)-gKnobWidth, lOutRect.origin.y, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionRightTop];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	// right
	knobRect = CPRectMake(CPRectGetMaxX(lOutRect)-gKnobWidth, lOutRect.origin.y+(lOutRect.size.height-gKnobHeight)/2.0, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionRight];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	// right bottom
	knobRect = CPRectMake(CPRectGetMaxX(lOutRect)-gKnobWidth, CPRectGetMaxY(lOutRect)-gKnobHeight, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionRightBottom];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	// bottom
	knobRect = CPRectMake(lOutRect.origin.x+(lOutRect.size.width-gKnobWidth)/2.0, CPRectGetMaxY(lOutRect)-gKnobHeight, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionBottom];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	// left bottom
	knobRect = CPRectMake(lOutRect.origin.x, CPRectGetMaxY(lOutRect)-gKnobHeight, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionLeftBottom];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	// left
	knobRect = CPRectMake(lOutRect.origin.x, lOutRect.origin.y+(lOutRect.size.height-gKnobHeight)/2.0, gKnobWidth,gKnobHeight);
	[CPBezierPath fillRect:knobRect];
	var lKnobObj = [[Knob alloc] initWithRect:knobRect gFrame:self position:gKnobPostionLeft];
	[mKnobList addObject:lKnobObj];
	[lKnobObj release];
	//
	
}

- (Knob)knobMouseIn:(CPEvent)anEvent inView:(CPView)aView
{
	var lPtInWindow = [anEvent locationInWindow];
//	var lWin = [aView window];
//	var lWincontentview = [lWin contentView];
	var lPtInView = [aView convertPoint:lPtInWindow fromView:nil];
	var i = 0;
	for(;i<[mKnobList count];i++) {
		var lKnob = [mKnobList objectAtIndex:i];
		var lKnobRect = [lKnob rect];
		if(CPRectContainsPoint(lKnobRect, lPtInView)) {
			return lKnob;
		}
	}
	return nil;
}

@end

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

@implementation SSIImageView : CPView
{
	CPImage mImage;
	
}

- (void)setImage:(CPImage)anImage
{
	mImage = anImage;
	[mImage setDelegate:self];
}
- (CPImage)image
{
	return mImage;
}
-(void)imageDidLoad:(CPImage)image
{
	
	[self setNeedsDisplay:YES];
}
- (CGRect)spreadFrame
{
	var mSpreadSize = [mImage size];
	var lViewBounds = [self bounds];
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

- (void)drawRect:(CPRect)rect
{
   if([mImage loadStatus] != CPImageLoadStatusCompleted) 
    { 
            return; 
    } 
    var context    = [[CPGraphicsContext currentContext] graphicsPort]; 
    var targetRect = [self spreadFrame]; 
    CGContextDrawImage(context, targetRect, mImage); 

}

- (void)setImageScaling:(CPImageScaling)anImageScaling	
{
	
}
@end

