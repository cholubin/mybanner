
@import <Foundation/CPObject.j>

var ProgressStyleMask = CPBorderlessWindowMask;



var sharedProgressWindow = nil;

@implementation ProgressWindow : CPWindow
{
}



+ (id)sharedWindow
{
	if(!sharedProgressWindow) {
		sharedProgressWindow = [[ProgressWindow alloc] init];
	}
	return sharedProgressWindow;
}

- (id)init
{
	var lRect = CPRectMake(0, 0, 300, 200);
    if (self = [super initWithContentRect:lRect styleMask:ProgressStyleMask])
    {
        var lImgView = [[CPImageView alloc] initWithFrame:lRect];
		var lImage = [[CPImage alloc] initWithContentsOfFile:"Resources/spinner.gif"];
		[lImgView setImageScaling:CPScaleNone]
		[lImgView setImage:lImage];
		[[self contentView] addSubview:lImgView];
		[lImage release];
		[lImgView release];
    }
    return self;
}

- (void)show
{
	var lMainWin = [[[CPApplication sharedApplication] delegate] mainWindow];
	var lBoundsRect = [[lMainWin contentView] bounds];
	var lSelfFrame = [self frame];
	var lPoint = CPPointMake(0, 0);
	var lBoundsSize = lBoundsRect.size;
	var lSelfSize = lSelfFrame.size;
	
	lPoint.x = (lBoundsSize.width - lSelfSize.width) / 2.0;
	lPoint.y = (lBoundsSize.height - lSelfSize.height) / 2.0;
	
	[self setFrameOrigin:lPoint];
	[self makeKeyAndOrderFront:self];
}

- (void)hide
{
	[self orderOut:self];
	
}
@end
