
@import <AppKit/CPView.j>
 @import "com/cetrasoft/components/formatbar/CSEditorWebView.j"
      
var STYLE_POPUP_WIDTH =	100;
var STYLE_POPUP_HEIGHT = 24;
var DEF_ITEM_VIEW_WIDTH	= 300;
var DEF_ITEM_VIEW_HEIGHT = 100;
var DEF_ADD_ITEM_HEIGHT = (STYLE_POPUP_HEIGHT + 10);



@implementation StyleInfo : CPObject
{
	CPString mStyleName;
	int mFontSize;
	int mTextRed;
	int mTextGreen;
	int mTextBlue;
}

- (id)initWithString:(CPString)styleInfoStr
{
	self = [super init];
	if(self) {
		var lFieldList = [styleInfoStr componentsSeparatedByString:@","];
		var i, icnt = [lFieldList count];
		if(icnt !== 5) {
			[self release];
			return nil;
		}
		mStyleName = 	[[lFieldList objectAtIndex:0] retain];
		mFontSize = 	[[lFieldList objectAtIndex:1] intValue];
		mTextRed = 		[[lFieldList objectAtIndex:2] intValue];
		mTextGreen = 	[[lFieldList objectAtIndex:3] intValue];
		mTextBlue = 	[[lFieldList objectAtIndex:4] intValue];
	}
	return self;
}

- (CPString)styleName
{
	return mStyleName;
}

- (int)fontSize
{
	return mFontSize;
}

- (int)textRed
{
	return mTextRed;
}

- (int)textGreen
{
	return mTextGreen;
}

- (int)textBlue
{
	return mTextBlue;
}
@end
@implementation AddStyledItemView : CPView
{
	CPButton mAddButton;
	StyledTextEditView mEditView;
}
- (id)initWithFrame:(CGRect)aRect
{
   if (self = [super initWithFrame:aRect])
    {
		var lAddBtnRect = CPRectMake(5, 5, STYLE_POPUP_HEIGHT, STYLE_POPUP_HEIGHT);
		mAddButton = [[CPButton alloc] initWithFrame:lAddBtnRect];
		[mAddButton setTitle:@"+"];
		[self addSubview:mAddButton];
    	[mAddButton setAction:@selector(addItem:)];
   		[mAddButton setTarget:self];
	}
	return self;
}

- (void)addItem:(id)sender
{
	[mEditView addNewAddItemView:self];
}  
 
- (void)setEditView:(StyledTextEditView)aEditView
{
	mEditView = aEditView;
}

@end
/* 																						 
			StyledTextItemView

*/

@implementation StyledTextItemView : CPView
{
	CPButton mAddButton;
	CPBUtton mDeleteButton;
	CPPopUpButton mStyleSelectPopup;
	CSEditorWebView mTextEditView;
	StyledTextEditView mEditView;
	 
}

- (id)initWithFrame:(CGRect)aRect
{
   if (self = [super initWithFrame:aRect])
    {
		var lSelfBounds = [self bounds];
		var lPopupRect = CPRectMake(CPRectGetMaxX(lSelfBounds)-(STYLE_POPUP_WIDTH+5), 5, STYLE_POPUP_WIDTH, STYLE_POPUP_HEIGHT);
        mStyleSelectPopup = [[CPPopUpButton alloc] initWithFrame:lPopupRect];
		[self addSubview:mStyleSelectPopup];
  		[mStyleSelectPopup setAction:@selector(changeStyle:)];
   		[mStyleSelectPopup setTarget:self];

		var lAddBtnRect = CPRectMake(5, 5, STYLE_POPUP_HEIGHT, STYLE_POPUP_HEIGHT);
		mAddButton = [[CPButton alloc] initWithFrame:lAddBtnRect];
		[mAddButton setTitle:@"+"];
		[self addSubview:mAddButton];
    	[mAddButton setAction:@selector(insertItemView:)];
   		[mAddButton setTarget:self];
  	
		var lDeleteBtnRect = CPRectMake(8+STYLE_POPUP_HEIGHT, 5, STYLE_POPUP_HEIGHT, STYLE_POPUP_HEIGHT);;
		mDeleteButton = [[CPButton alloc] initWithFrame:lDeleteBtnRect];
		[mDeleteButton setTitle:@"-"];
		[self addSubview:mDeleteButton];
     	[mDeleteButton setAction:@selector(deleteSelf:)];
   		[mDeleteButton setTarget:self];
   	
		var lEditViewRect = CPRectMake(5, 10+STYLE_POPUP_HEIGHT, CPRectGetMaxX(lSelfBounds)-10, CPRectGetMaxY(lSelfBounds)-(15+STYLE_POPUP_HEIGHT));
		mTextEditView = [[CSEditorWebView alloc] initWithFrame:lEditViewRect];// [[CPScrollView alloc] initWithFrame:lFrame];
		
	  	[mTextEditView setAutoresizesSubviews:YES];
		[mTextEditView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];  //| CPViewMaxYMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMinXMargin 
		[self addSubview:mTextEditView];
   }
    return self;
}

- (id)textEditView
{
	return mTextEditView;
}

- (id)styleSelectPopup
{
	return mStyleSelectPopup;
}

- (void)insertItemView:(id)sender
{
	[mEditView insertNewItemViewBefore:self];
}   

- (void)deleteSelf:(id)sender
{
	[mEditView deleteItemView:self];
}   

- (void)changeStyle:(id)sender
{
	
}   

- (void)setEditView:(StyledTextEditView)aEditView
{
	mEditView = aEditView;
}
@end

/* 																						 
			StyledTextEditView

*/
@implementation StyledTextEditView : CPScrollView
{
	CPArray mItemViewList;
	CPArray mStyleInfoList; 
	AddStyledItemView mAddStyleItemView;
}

- (id)initWithFrame:(CGRect)aRect
{
  if (self = [super initWithFrame:aRect])
    {
		var lSelfbounds = [self bounds];
        var lDocview = [[CPView alloc] initWithFrame:lSelfbounds];
		[self setDocumentView:lDocview];
		mStyleInfoList = [[CPArray alloc] init];    
		mItemViewList = [[CPArray alloc] init];
		var lAddItemFrame = CPRectMake(0, 0, DEF_ITEM_VIEW_WIDTH, DEF_ADD_ITEM_HEIGHT);
		mAddStyleItemView =  [[AddStyledItemView alloc] initWithFrame:lAddItemFrame];
		[mAddStyleItemView setEditView:self];
					
//		[lDocview addSubview:mAddStyleItemView];
		[self addItemView:mAddStyleItemView];
 		[lDocview release];
   }
    return self;
}

- (CPArray)itemViewList
{
	return mItemViewList
}

//- (void)drawRect:(CGRect)aRect
//{
    // Add drawing code here
//}


- (void)clearStyleInfoList
{
	[mStyleInfoList removeAllObjects];
}

- (void)addStyleInfo:(StyleInfo)styleInfo
{
	[mStyleInfoList addObject:styleInfo];
}

- (void)__layoutSubviews
{
  // Add layout code here
	var i, icnt = [mItemViewList count];
	var lYPos = 0, lMaxX = 0;
	for(i=0;i<icnt;i++){
		var lView = [mItemViewList objectAtIndex:i];
		var lViewFrame = [lView frame];
		lViewFrame.origin.y = lYPos;
		lViewFrame.origin.x = 0;
		if(lViewFrame.size.width > lMaxX) {
			lMaxX = lViewFrame.size.width;
		}
		[lView setFrame:lViewFrame];
		lYPos += lViewFrame.size.height;
	}
	var lSelfFrame = CPRectMake(0, 0, lMaxX, lYPos);
	[[self documentView] setFrame:lSelfFrame];
    //console.log("layoutSubviews ===== "+lYPos+", "+lMaxX) ;
}

- (void)_relayoutSubviews
{
   // Add layout code here
	var i, icnt = [mItemViewList count];
	var lYPos = 0, lMaxX = DEF_ITEM_VIEW_WIDTH;
	for(i=0;i<icnt;i++){
		var lView = [mItemViewList objectAtIndex:i];
		var lViewFrame = [lView frame];
		//if(lViewFrame.size.width > lMaxX) {
		//	lMaxX = lViewFrame.size.width;
		//}
		lYPos += lViewFrame.size.height;
	}
	if(mAddStyleItemView) {
		var lAddItemFrame = CPRectMake(0, lYPos, lMaxX, DEF_ADD_ITEM_HEIGHT);
		lYPos += lAddItemFrame.size.height;
	}
	var lSelfFrame = CPRectMake(0, 0, lMaxX, lYPos);
	[[self documentView] setFrame:lSelfFrame];

	lYPos = 0;
	lMaxX = DEF_ITEM_VIEW_WIDTH;
	for(i=0;i<icnt;i++){
		var lView = [mItemViewList objectAtIndex:i];
		var lViewFrame = [lView frame];
		lViewFrame.origin.y = lYPos;
		lViewFrame.origin.x = 0;
		lViewFrame.size.width = lMaxX;
		//if(lViewFrame.size.width > lMaxX) {
		//	lMaxX = lViewFrame.size.width;
		//}
		[lView setFrame:lViewFrame];

		lYPos += lViewFrame.size.height;
	}
	if(mAddStyleItemView) {
		var lAddItemFrame = CPRectMake(0, lYPos, lMaxX, DEF_ADD_ITEM_HEIGHT);
		[mAddStyleItemView setFrame:lAddItemFrame];
	}
	
   // console.log("layoutSubviews ===== "+lYPos+", "+lMaxX) ;
}

- (void)addItemView:(id)aItemView
{
	[aItemView setAutoresizingMask:CPViewWidthSizable | CPViewMaxYMargin];  //| CPViewMaxYMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMinXMargin 
	[aItemView setBackgroundColor:[CPColor lightGrayColor]];
	[aItemView setEditView:self];
	[[self documentView] addSubview:aItemView];
}
- (void)addStyledTextItemViewAsSubview:(StyledTextItemView)aItemView
{           
	var lStylePopupBtn = [aItemView styleSelectPopup];
	[lStylePopupBtn removeAllItems];
	var j, jcnt = [mStyleInfoList count];
	for(j=0;j<jcnt;j++) {
		var aStyleName = [[mStyleInfoList objectAtIndex:j] styleName];
		[lStylePopupBtn addItemWithTitle:aStyleName];
	}
	[self addItemView:aItemView];
}     

                    
- (void)removeAllItemViews
{
	var i, icnt = [mItemViewList count];
	for(i=0;i<icnt;i++) {
		var lView = [mItemViewList objectAtIndex:i];
		[lView removeFromSuperview];
	}   
	[mItemViewList removeAllObjects];
}              
         
- (void)insertNewItemViewBefore:(StyledTextItemView)aItemView
{
	var lItemViewFrame = CPRectMake(0, 0, DEF_ITEM_VIEW_WIDTH, DEF_ITEM_VIEW_HEIGHT);
	var lStyledTextItemView = [[StyledTextItemView alloc] initWithFrame:lItemViewFrame];
	[self addStyledTextItemViewAsSubview:lStyledTextItemView];
	var idx = [mItemViewList indexOfObject:aItemView];
	[mItemViewList insertObject:lStyledTextItemView atIndex:idx];
	[self _relayoutSubviews];
}    
          
- (void)addNewAddItemView:(id)sender
{
 	var lItemViewFrame = CPRectMake(0, 0, DEF_ITEM_VIEW_WIDTH, DEF_ITEM_VIEW_HEIGHT);
	var lStyledTextItemView = [[StyledTextItemView alloc] initWithFrame:lItemViewFrame];
	[self addStyledTextItemViewAsSubview:lStyledTextItemView];
	[mItemViewList addObject:lStyledTextItemView];
	[self _relayoutSubviews];
}
- (void)deleteItemView:(StyledTextItemView)aItemView
{                                           
	[aItemView removeFromSuperview];
	[mItemViewList removeObject:aItemView] 
	[self _relayoutSubviews];
}


var gParaLevel = 0;

- (CPString)toHTMLString:(CPString)serverString
{
	var lHTMLText = ""; //@"<p>";
 	var j, jcnt = [serverString length];
	for(j=0;j<jcnt;j++) {
		var ch = [serverString characterAtIndex:j];
		if(ch === '\n') {
			//ch = "</p><p>";
			ch = "<br>";
		}
		lHTMLText += ch;
	}
	// lHTMLText += @"</p>";
	return lHTMLText;
}


- (void)loadXMLString:(CPString)aStyledStr
{
	gParaLevel = 0;
	[self removeAllItemViews];
	var lParaSepStr = [CPString stringWithFormat:@"__PS%d__", gParaLevel]; // gParaLevel: for future enhancement
	var lParaList = [aStyledStr componentsSeparatedByString:lParaSepStr];
	var i, icnt = [lParaList count];
	for(i=0;i<icnt;i++) {
		var lParaStr = [lParaList objectAtIndex:i];
		var lParaRec = [lParaStr componentsSeparatedByString:@"__FS__"];  // Field Separator
		var lStyleName = [lParaRec objectAtIndex:0];
		var lContentText = [lParaRec objectAtIndex:1];
		var lItemViewFrame = CPRectMake(0, 0, DEF_ITEM_VIEW_WIDTH, DEF_ITEM_VIEW_HEIGHT);
		var lStyledTextItemView = [[StyledTextItemView alloc] initWithFrame:lItemViewFrame];
		[self addStyledTextItemViewAsSubview:lStyledTextItemView];
		[mItemViewList addObject:lStyledTextItemView];
		lContentText = [self toHTMLString:lContentText];
		var lTextEditView = [lStyledTextItemView textEditView];
		var lHTMLText = @"<html><head></head><body>"+lContentText+@"</body></html>";
		
		[lTextEditView loadHTMLString:lHTMLText];
		var textframe = [lTextEditView frame];
		var domDocument = [lTextEditView DOMWindow];
		var jsDocument = domDocument.document;
//		jsDocument.recalc();
//		var jsFrame = jsDocument.frames[0];
//		console.log("frame size width = "+textframe.size.width+"; frame size height = "+textframe.size.height+";") ;
//		console.log("frame size width = "+jsFrame.width+"; frame size height = "+jsFrame.height+";") ;
	    
		[lStyledTextItemView release];
		
		var lStylePopupBtn = [lStyledTextItemView styleSelectPopup];
		[lStylePopupBtn selectItemWithTitle:lStyleName];
	}
	[self _relayoutSubviews];
}

@end

@implementation StyledTextEditController : CPObject
@end
