@import <Foundation/CPObject.j>
@import "ImagePickerController.j"
@import "StyledTextEditView.j"
@import "com/cetrasoft/components/formatbar/CSEditorWebView.j"
@import "ImageTrimmer.j"
@import "ProgressWindow.j"
@import "DrawingViewUtils.j"
@import "EditController.j"

var gSnapRange = 5;

gSideNone = 0;
gSideTop = 1;
gSideBottom = 2;
gSideLeft = 1;
gSideRight = 2;


@implementation GuideLine : CPView
{
	float mLocation;
	float mStart;
	float mLength;
}

- (id)initWithLocation:(float)location start:(float)start length:(float)length
{
	self = [super init];
	if(self) {
		mLocation = location;
		mStart = start;
		mLength = length;
	}
	return self;
}

- (float)location
{
	return mLocation;
}

- (float)start
{
	return mStart;
}

- (float)length
{
	return mLength;
}

- (float)end
{
	return (mStart+mLength);
}

@end

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////


@implementation DrawingView : CPView
{
	CGSize mSpreadSize;
	CPArray mFrameList;
	CPArray mVGuideList;
	CPArray mHGuideList;
	float mGridStart;
	float mGridHeight;
	float mGridLeading;
	
	GraphicFrame mFocusedFrame;
	CGRect mCreateFrame;
	CGRect mResizeRect;
	EditController mEditController;
	CPArray mSelectedFrameList;
	CPArray mStartFrameList;
	
	CPPoint mPointInView;
	CPPoint mStartPointInView;
	BOOL mFrameGrabed;
	BOOL mMouseMoved;
	BOOL mDrawGrid;
	BOOL mDrawGuide;
	BOOL mUseGrid;
	BOOL mUseGuide;
	
	Knob mKnobGrabed;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self) {
		mFrameList = [[CPArray alloc] init];
		mVGuideList = [[CPArray alloc] init];
		mHGuideList = [[CPArray alloc] init];
		mSelectedFrameList = [[CPArray alloc] init];
		mStartFrameList = [[CPArray alloc] init];
		selectedFrame = nil;
		mUseGrid = NO;
		mDrawGrid = NO;
		mUseGuide = NO;
		mDrawGuide = NO;

//		var lRect = CPRectMake(100, 100, 100, 100);
//		var lFrame = [[GraphicFrame alloc] initWithRect:lRect gid:0];
//		[mFrameList addObject:lFrame];
		
//		lRect = CPRectMake(300, 300, 100, 100);
//		lFrame = [[GraphicFrame alloc] initWithRect:lRect gid:0];
//		[mFrameList addObject:lFrame];
	}
	return self;
}
- (void)clearFrameList
{
	[mFrameList removeAllObjects];
	[mVGuideList removeAllObjects];
	[mHGuideList removeAllObjects];
}

- (void)addFrame:(id)anObject
{
	[mFrameList addObject:anObject];
}

- (void)selectFrame:(id)aFrame
{
	[mSelectedFrameList removeAllObjects];
	[mSelectedFrameList addObject:aFrame];
	[self setNeedsDisplay:YES];
}

- (CPArray)selectedFrameList
{
	return mSelectedFrameList
}

- (id)selectedFrame
{
	return [mSelectedFrameList objectAtIndex:0];
}

- (void)resetCreateFrame
{
	mCreateFrame = nil;
}

- (void)setSpreadSize:(CGSize)aSize
{
	mSpreadSize = aSize;

}

- (void)setUseGuide:(BOOL)flag
{
	mUseGuide = flag;
	mDrawGuide = flag;
}

- (void)setUseGrid:(BOOL)flag
{
	mUseGrid = flag;
	mDrawGrid = flag;
}

- (CGSize)spreadSize
{
	return mSpreadSize;
}
- (float)scaleFactor
{
	var lViewBounds = [self bounds];
	var rate;
	if(lViewBounds.size.width / mSpreadSize.width > lViewBounds.size.height / mSpreadSize.height) {
		rate = lViewBounds.size.height / mSpreadSize.height;
	}
	else {
		rate = lViewBounds.size.width / mSpreadSize.width;
	}
	return rate;
}

- (CGRect)scaledRectFrom:(CGRect)orgFrame
{
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
	
	var retFrame = CPMakeRect(0,0,0,0);
	retFrame.origin.x = lSpreadFrame.origin.x + orgFrame.origin.x * rate;
	retFrame.origin.y = lSpreadFrame.origin.y + orgFrame.origin.y * rate;
	retFrame.size.width = orgFrame.size.width * rate;
	retFrame.size.height = orgFrame.size.height * rate;
	return retFrame;
}
- (CGPoint)scaledPoint:(CGPoint)orgPoint
{
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
	
	var retPoint = CGPointMake(0,0);
	retPoint.x = lSpreadFrame.origin.x + orgPoint.x * rate;
	retPoint.y = lSpreadFrame.origin.y + orgPoint.y * rate;
	return retPoint;
}

- (CGRect)spreadFrame
{
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

- (void)resetDrawings
{
	mFocusedFrame = nil;
	[mSelectedFrameList removeAllObjects];
}
- (void)drawRect:(CGRect)aRect
{
	//[super drawRect:aRect];
	if([[self superview] editMode]) {
		if(mFocusedFrame) {
			var lOrgRect = [mFocusedFrame rect];
			var lScaledRect = [self scaledRectFrom:lOrgRect];
			[[CPColor whiteColor] set];
			[CPBezierPath setDefaultLineWidth:6];
			[CPBezierPath strokeRect:lScaledRect];
		
			[[CPColor colorWithRed:1 green:0 blue:0 alpha:0.3] set];
			[CPBezierPath setDefaultLineWidth:4];
			[CPBezierPath strokeRect:lScaledRect];
		}
		if([mSelectedFrameList count]) {
			var i = 0;
			var icnt = [mSelectedFrameList count];
			for(;i<icnt;i++) {
				var lSelectedFrame = [mSelectedFrameList objectAtIndex:i];
				var lOrgRect = [lSelectedFrame rect];
				var lScaledRect = [self scaledRectFrom:lOrgRect];
				[[CPColor whiteColor] set];
				[CPBezierPath setDefaultLineWidth:6];
				[CPBezierPath strokeRect:lScaledRect];

				[[CPColor colorWithRed:0 green:0 blue:1 alpha:0.3] set];
				[CPBezierPath setDefaultLineWidth:4];
				[CPBezierPath strokeRect:lScaledRect];

				// draw knobs
				[lSelectedFrame drawKnobsOnView:self];
				
			}
		}
		if(mCreateFrame) {
			[[CPColor whiteColor] set];
			[CPBezierPath setDefaultLineWidth:6];
			[CPBezierPath strokeRect:mCreateFrame];

			[[CPColor colorWithRed:0 green:0 blue:1 alpha:0.3] set];
			[CPBezierPath setDefaultLineWidth:4];
			[CPBezierPath strokeRect:mCreateFrame];
		}
		
		// float mGridStart;
		// float mGridHeight;
		// float mGridLeading;
		//
		//		draw grid  
		//
		/////////////////////////////
		if(mDrawGrid && mSpreadSize) {
			var lScaleFactor = [self scaleFactor];
			var lGridStart = mGridStart * lScaleFactor;
			var lGridHeight = mGridHeight * lScaleFactor;
			var lGridLeading = mGridLeading * lScaleFactor;
			var lSelfFrame = [self frame];
			var ypos = lGridStart;
			[[CPColor blueColor] set];
			[CPBezierPath setDefaultLineWidth:1];
			while(ypos < lSelfFrame.size.height) {
				var startpt = CGPointMake(0, ypos);
				var endpt = CGPointMake(lSelfFrame.size.width, ypos);
				[CPBezierPath strokeLineFromPoint:startpt toPoint:endpt];
				ypos += lGridHeight + lGridLeading;
			}
		}
		
		if (mDrawGuide) {
			var i, icnt = [mVGuideList count];
			if(icnt) {
				[[CPColor blueColor] set];
				[CPBezierPath setDefaultLineWidth:1];

				for(i=0;i<icnt;i++) {
					var guide = [mVGuideList objectAtIndex:i];

					var pt = CGPointMake([guide start], [guide location]);
					var startpt = [self scaledPoint:pt];
					pt = CGPointMake([guide end], [guide location]);
					var endpt = [self scaledPoint:pt];

					[CPBezierPath strokeLineFromPoint:startpt toPoint:endpt];
				}
			}
			icnt = [mHGuideList count];
			if(icnt) {
				[[CPColor blueColor] set];
				[CPBezierPath setDefaultLineWidth:1];

				for(i=0;i<icnt;i++) {
					var guide = [mHGuideList objectAtIndex:i];

					var pt = CGPointMake([guide location],[guide start]);
					var startpt = [self scaledPoint:pt];
					pt = CGPointMake([guide location],[guide end]);
					var endpt = [self scaledPoint:pt];

					[CPBezierPath strokeLineFromPoint:startpt toPoint:endpt];
				}
			}
		}
	}
}

- (BOOL)acceptsFirstResponder 
{ 
        return YES; 
} 

- (void)keyDown:(CPEvent)anEvent	
{
	var keycode = [anEvent keyCode];
	if(keycode == 8) { // back space key
		var frames_str = @"";
		var i = 0;
		var icnt = [mSelectedFrameList count];
		for(;i<icnt;i++) {
			var lSelectedFrame = [mSelectedFrameList objectAtIndex:i];
			var gid = [lSelectedFrame GID]; // mGID
			if(i > 0) {
				frames_str += "__GRAPHICSEP__";
			}
			frames_str += gid;
			[mFrameList removeObject:lSelectedFrame];
		}
		[mSelectedFrameList removeAllObjects];
		[[ProgressWindow sharedWindow] show];
		[mEditController sendJSONRequestAndRefresh:@"DeleteGraphics" data:frames_str];
		mFocusedFrame = nil;
		[self setNeedsDisplay:YES];
	}
}

- (id)frameAtEvent:(CPEvent)anEvent
{
	var i, icnt = [mFrameList count];
	for(i=0;i<icnt;i++) {
		var aFrame = [mFrameList objectAtIndex:icnt - i - 1];
		if([aFrame isEventInFrame:anEvent view:self]) {
			return aFrame;
		}
	}
	return nil;
}

- (void)mouseMoved:(CPEvent)anEvent
{
	if([mEditController selectedTool] != 0) {  // 0: selection tool
		return;
	}
	if(![[self superview] editMode])
		return;
	if(![mEditController isWindowVisible]) {
		mFocusedFrame = [self frameAtEvent:anEvent];
	}
	[self setNeedsDisplay:YES];
}

- (int)knobMouseIn:(CPEvent)anEvent
{
	var i = 0;
	var icnt = [mSelectedFrameList count];
	for(;i<icnt;i++) {
		var lSelectedFrame = [mSelectedFrameList objectAtIndex:i];
		var lKnob = [lSelectedFrame knobMouseIn:anEvent inView:self];
		return lKnob;
	}
	return nil;
}
- (void)mouseDown:(CPEvent)anEvent
{
	[[self window] makeFirstResponder:self];
	if(![[self superview] editMode])
		return;
	if(![mEditController isWindowVisible]) {
		if([mEditController selectedTool] == 1) {  // 1: image box create tool
			var lPtInWindow = [anEvent locationInWindow];
			var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
			[mSelectedFrameList removeAllObjects];
			mCreateFrame = CGRectMake(lPtInView.x, lPtInView.y, 0, 0);
			mResizeRect = CGRectMake(lPtInView.x, lPtInView.y, 0, 0);
			[self setNeedsDisplay:YES];
			return;
		}
		if([mEditController selectedTool] == 2) {  // 1: text box create tool
			var lPtInWindow = [anEvent locationInWindow];
			var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
			[mSelectedFrameList removeAllObjects];
			mCreateFrame = CGRectMake(lPtInView.x, lPtInView.y, 0, 0);
			mResizeRect = CGRectMake(lPtInView.x, lPtInView.y, 0, 0);
			[self setNeedsDisplay:YES];
			return;
		}
		mKnobGrabed = [self knobMouseIn:anEvent];
		if(mKnobGrabed) {
			var lPtInWindow = [anEvent locationInWindow];
			var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
			mPointInView = lPtInView;
			mStartPointInView = lPtInView;
			mMouseMoved = NO;
			
			var lCurFrame = [mKnobGrabed graphicFrame];
			var lOrgRect = [lCurFrame rect];
			mResizeRect = CPRectMake(lOrgRect.origin.x, lOrgRect.origin.y, lOrgRect.size.width, lOrgRect.size.height);		
		}
		else {
			[mSelectedFrameList removeAllObjects];
			[mStartFrameList removeAllObjects];
			var lSelFrame = [self frameAtEvent:anEvent];
			
			if(lSelFrame) {
				[mSelectedFrameList addObject:lSelFrame];
				var lSelRect = [lSelFrame rect];
				var lStartRect = CPRectMake(lSelRect.origin.x, lSelRect.origin.y, lSelRect.size.width, lSelRect.size.height);
				[mStartFrameList addObject:lStartRect];
				[self setNeedsDisplay:YES];
				//[mEditController drawingView:self frameSelected:lSelFrame];
		    	//alert("Graphic item selected. ");
				if([anEvent clickCount] == 2) {
					[mEditController drawingView:self frameSelected:lSelFrame];
				}
				else {
					var lPtInWindow = [anEvent locationInWindow];
					var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
					mPointInView = lPtInView;
					mStartPointInView = lPtInView;
					mKnobGrabed = [self knobMouseIn:anEvent];
					mMouseMoved = NO;
					if(mKnobGrabed) {
						//alert("knob clicked at = "+[mKnobGrabed position]);
					}
					else {
						mFrameGrabed = YES;
					}				
				}
			}
		}
	}
}

- (float)snapXpointFrom:(float)x startY:(float)sy endY:(float)ey //side:(int)side  // side: Left(0) or Right(1)
{
	// V GuideLine
	if(mUseGuide) {
		var lScaleFactor = [self scaleFactor];
		var xpos = x; // * lScaleFactor;
		var starty = sy; // * lScaleFactor;
		var endy = ey; // * lScaleFactor;
		var i, icnt = [mHGuideList count];
		for(i=0;i<icnt;i++) {
			var guide = [mHGuideList objectAtIndex:i];
		
			var pt = CGPointMake([guide location], [guide start]);
			var startpt = pt; //[self scaledPoint:pt];
			pt = CGPointMake([guide location], [guide end]);
			var endpt = pt; //[self scaledPoint:pt];
		
			if((startpt.y <= starty && endpt.y >= starty)  
			|| (startpt.y <= endy && endpt.y >= endy)
			|| (startpt.y >= starty && endpt.y <= endy))  {  // check horizontal range
				if(startpt.x + gSnapRange >= xpos && startpt.x - gSnapRange <= xpos) {
					return startpt.x;
				}
			}
		}
	}	
	return x;
}

- (float)snapYpointFrom:(float)y startX:(float)sx endX:(float)ex //side:(int)side
{
	// H GuideLine
	if(mUseGuide) {
		var lScaleFactor = [self scaleFactor];
		var ypos = y; // * lScaleFactor;
		var startx = sx; //  * lScaleFactor;
		var endx = ex; // * lScaleFactor;
		var i, icnt = [mVGuideList count];
		for(i=0;i<icnt;i++) {
			var guide = [mVGuideList objectAtIndex:i];

			var pt = CGPointMake([guide start], [guide location]);
			var startpt = pt; //[self scaledPoint:pt];
			pt = CGPointMake([guide end], [guide location]);
			var endpt = pt; //[self scaledPoint:pt];

			if((startpt.x <= startx && endpt.x >= startx)  
			|| (startpt.x <= endx && endpt.x >= endx)
			|| (startpt.x >= startx && endpt.x <= endx))  {  // check horizontal range
				if(startpt.y + gSnapRange >= ypos && startpt.y - gSnapRange <= ypos) {
					return startpt.y;
				}
			}
		}
	}
	// Grid 

	// float mGridStart;
	// float mGridHeight;
	// float mGridLeading;
	//
	//		snap grid  
	//
	/////////////////////////////
	if(mUseGrid) {
		var lLineHeight = mGridHeight + mGridLeading;
		var ypos = Math.floor((y - mGridStart) / lLineHeight) * lLineHeight + mGridStart;
		if(y - ypos < gSnapRange) {
			return ypos;
		}
		ypos = Math.ceil((y - mGridStart) / lLineHeight) * lLineHeight + mGridStart;
		if(ypos - y < gSnapRange) {
			return ypos;
		}

	}
	return y;
}


- (CGRect)snappedRectFromRect:(CGRect)aRect  //  use when object move
{
	var retRect = CPRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
	var xpos = [self snapXpointFrom:aRect.origin.x startY:aRect.origin.y endY:CPRectGetMaxY(aRect)];
	if(aRect.origin.x == xpos) {
		xpos = [self snapXpointFrom:CPRectGetMaxX(aRect) startY:aRect.origin.y endY:CPRectGetMaxY(aRect)] - aRect.size.width;
	}
	var ypos = [self snapYpointFrom:aRect.origin.y startX:aRect.origin.y endX:CPRectGetMaxX(aRect)];
	if(aRect.origin.y == ypos) {
		ypos = [self snapYpointFrom:CPRectGetMaxY(aRect) startX:aRect.origin.y endX:CPRectGetMaxX(aRect)] - aRect.size.height;
	}
	retRect.origin.x = xpos;
	retRect.origin.y = ypos;
	return retRect;
}

- (CGRect)snappedRectFromRect:(CGRect)aRect sideX:(int)sideX sideY:(int)sideY // use when object resize
{
	var retRect = CPRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
	
	if(sideX > 0) {
		if(sideX == gSideLeft) {
			var xpos = [self snapXpointFrom:aRect.origin.x startY:aRect.origin.y endY:CPRectGetMaxY(aRect)];
			retRect.size.width += retRect.origin.x - xpos;
			retRect.origin.x = xpos;
		}
		else {
			var xpos = [self snapXpointFrom:CPRectGetMaxX(aRect) startY:aRect.origin.y endY:CPRectGetMaxY(aRect)];
			retRect.size.width = xpos - retRect.origin.x;
		}
	}
	if(sideY > 0) {
		if(sideY == gSideTop) {
			var ypos = [self snapYpointFrom:aRect.origin.y startX:aRect.origin.x endX:CPRectGetMaxX(aRect)];
			retRect.size.height += retRect.origin.y - ypos;
			retRect.origin.y = ypos;
		}
		else {
			var ypos = [self snapYpointFrom:CPRectGetMaxY(aRect) startX:aRect.origin.x endX:CPRectGetMaxX(aRect)];
			retRect.size.height = ypos - retRect.origin.y;
		}
	}
	return retRect;
}

- (void)mouseDragged:(CPEvent)anEvent  
{
	if(mMouseMoved == NO ) {
		var lPtInWindow = [anEvent locationInWindow];
		var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
		var dx = mPointInView.x - lPtInView.x;
		var dy = mPointInView.y - lPtInView.y;
		if(dx > 5 || dx < -5 || dy > 5 || dy < -5) {
			mMouseMoved = YES;
		}
		else 
			return;
	}
	
	if(mFrameGrabed) {
		var lPtInWindow = [anEvent locationInWindow];
		var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
		var dx = lPtInView.x - mPointInView.x;
		var dy = lPtInView.y - mPointInView.y;
		var i = 0;
		var icnt = [mSelectedFrameList count];
		var scaleFactor = [self scaleFactor];
		for(;i<icnt;i++) {
			var lStartRect = [mStartFrameList objectAtIndex:i];
			var lSelectedFrame = [mSelectedFrameList objectAtIndex:i];
			//var lOrgRect = [lSelectedFrame rect];
			lStartRect.origin.x += (dx / scaleFactor);
			lStartRect.origin.y += (dy / scaleFactor);
			var lLastRect = [self snappedRectFromRect:lStartRect];
			[lSelectedFrame setOrigin:lLastRect.origin];
//			var lOrgRect = [lSelectedFrame rect];
//			console.log("coord:"+lStartRect.origin.x+","+lStartRect.origin.y+" : "+lOrgRect.origin.x+","+lOrgRect.origin.y);
		}
		[self setNeedsDisplay:YES];
		mPointInView = lPtInView;
	}
	else if(mKnobGrabed) {
		var lPtInWindow = [anEvent locationInWindow];
		var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
		var scaleFactor = [self scaleFactor];
		var dx = (lPtInView.x - mPointInView.x) / scaleFactor;
		var dy = (lPtInView.y - mPointInView.y) / scaleFactor;
		var lCurFrame = [mKnobGrabed graphicFrame];
		var lOrgRect = [lCurFrame rect];
		var lSideX = gSideNone;
		var lSideY = gSideNone;
		
		switch([mKnobGrabed position]) {
			case gKnobPostionLeftTop:
				mResizeRect.origin.x += dx;
				mResizeRect.size.width -= dx;
				mResizeRect.origin.y += dy;
				mResizeRect.size.height -= dy;
				lSideX = gSideLeft;
				lSideY = gSideTop;
				break;
			case gKnobPostionTop:
				mResizeRect.origin.y += dy;
				mResizeRect.size.height -= dy;
				lSideY = gSideTop;
				break;
			case gKnobPostionRightTop:
				mResizeRect.size.width += dx;
				mResizeRect.origin.y += dy;
				mResizeRect.size.height -= dy;
				lSideX = gSideRight;
				lSideY = gSideTop;
				break;
			case gKnobPostionRight:
				mResizeRect.size.width += dx;
				lSideX = gSideRight;
				break;
			case gKnobPostionRightBottom:
				mResizeRect.size.width += dx;
				mResizeRect.size.height += dy;
				lSideX = gSideRight;
				lSideY = gSideBottom;
				break;
			case gKnobPostionBottom:
				mResizeRect.size.height += dy;
				lSideY = gSideBottom;
				break;
			case gKnobPostionLeftBottom:
				mResizeRect.origin.x += dx;
				mResizeRect.size.width -= dx;
				mResizeRect.size.height += dy;
				lSideX = gSideLeft;
				lSideY = gSideBottom;
				break;
			case gKnobPostionLeft:
				mResizeRect.origin.x += dx;
				mResizeRect.size.width -= dx;
				lSideX = gSideLeft;
				break;
			
		}
		lOrgRect = [self snappedRectFromRect:mResizeRect sideX:lSideX sideY:lSideY];
		
		
		[lCurFrame setRect:lOrgRect]; 	// You don't need to set frame. lCurFrame has lOrgRect
											// and mSelectedFrames has lCurFrame.
		[self setNeedsDisplay:YES];
		mPointInView = lPtInView;
	}
	if(mCreateFrame) {
		var lPtInWindow = [anEvent locationInWindow];
		var lPtInView = [self convertPoint:lPtInWindow fromView:nil];
		//var scaleFactor = [self scaleFactor];
		mCreateFrame.size.width = lPtInView.x - mCreateFrame.origin.x;
		mCreateFrame.size.height = lPtInView.y - mCreateFrame.origin.y;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseUp:(CPEvent)anEvent
{
	[mStartFrameList removeAllObjects];
	if(mMouseMoved == NO) {
		mFrameGrabed = NO;
		mKnobGrabed = nil;
		return;
	}
	
	if(mFrameGrabed || mKnobGrabed) {
		mFrameGrabed = NO;
		var frames_str = @"";
		var i = 0;
		var icnt = [mSelectedFrameList count];
		var scaleFactor = [self scaleFactor];
		for(;i<icnt;i++) {
			var lSelectedFrame = [mSelectedFrameList objectAtIndex:i];
			var lOrgRect = [lSelectedFrame rect];
			var framestr = CPStringFromRect(lOrgRect);
			var gid = [lSelectedFrame GID]; // mGID
			if(i > 0) {
				frames_str += "__GRAPHICSEP__";
			}
			frames_str += gid + "__GIDSEP__" + framestr;
		}
		
		[[ProgressWindow sharedWindow] show];
		[mEditController sendJSONRequestAndRefresh:@"SetFrames" data:frames_str];
	}
	if(mCreateFrame) {
		var scaleFactor = [self scaleFactor];
		var lOrgRect = mCreateFrame;
		lOrgRect.origin.x = mCreateFrame.origin.x / scaleFactor;
		lOrgRect.origin.y = mCreateFrame.origin.y / scaleFactor;
		lOrgRect.size.width = mCreateFrame.size.width / scaleFactor;
		lOrgRect.size.height = mCreateFrame.size.height / scaleFactor;
		var framestr = CPStringFromRect(lOrgRect);
		var spreadIdx = [mEditController currentSpreadIndex];
		var infostr = [CPString stringWithFormat:@"%d__SPREAD__%@",spreadIdx,framestr];
		[[ProgressWindow sharedWindow] show];
		if([mEditController selectedTool] == 1) {
			[mEditController sendCreateRequestAndRefresh:@"MakeGraphic" data:infostr];
		}
		else if([mEditController selectedTool] == 2) {
			[mEditController sendCreateRequestAndRefresh:@"MakeTextGraphic" data:infostr];
		}
		//mCreateFrame = nil;
		//[mEditController selectSelectionTool];
	}
	mMouseMoved = NO;
	mKnobGrabed = nil;
	[self setNeedsDisplay:YES];
}

- (void)setController:(id)anObject
{
	if(mEditController)
		[mEditController release];
	mEditController = [anObject retain];
	[mEditController setDrawingView:self];
}

- (void)toolDidChanged
{
	mFocusedFrame = nil;
	[self setNeedsDisplay:YES];
}

- (void)addVGuideLineLocation:(float)location start:(float)start length:(float)length
{
	var pt = CGPointMake(location, start);
	var startpt = [self scaledPoint:pt];
	var end = start + length;
	pt = CGPointMake(location, end);
	var endpt = [self scaledPoint:pt];
	var lGuideLine = [[GuideLine alloc] initWithLocation:location start:start length:length];
	[mVGuideList addObject:lGuideLine];
	[lGuideLine release];
//	mUseGuide = YES;
}

- (void)addHGuideLineLocation:(float)location start:(float)start length:(float)length
{
	var pt = CGPointMake(start, location);
	var startpt = [self scaledPoint:pt];
	var end = start + length;
	pt = CGPointMake(end, location);
	var endpt = [self scaledPoint:pt];
	var lGuideLine = [[GuideLine alloc] initWithLocation:location start:start length:length];
	[mHGuideList addObject:lGuideLine];
	[lGuideLine release];
//	mUseGuide = YES;
	
}

- (void)setGridStart:(float)start inclrement:(float)increment leading:(float)leading
{
	mGridStart = start;
	mGridHeight = increment;
	mGridLeading = leading;
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	

}
@end
