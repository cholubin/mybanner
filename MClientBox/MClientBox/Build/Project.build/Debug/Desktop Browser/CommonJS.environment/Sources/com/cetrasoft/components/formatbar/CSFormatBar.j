@STATIC;1.0;I;21;Foundation/CPObject.ji;24;CSFormatBarPopUpButton.ji;28;CSFormatBarColorWellButton.ji;22;CSFormatBarSeparator.ji;21;CSFormatBarFontMenu.jt;16164;objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("CSFormatBarPopUpButton.j", YES);
objj_executeFile("CSFormatBarColorWellButton.j", YES);
objj_executeFile("CSFormatBarSeparator.j", YES);
objj_executeFile("CSFormatBarFontMenu.j", YES);
{var the_class = objj_allocateClassPair(CPView, "CSFormatBar"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("editor")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:editor:"), function $CSFormatBar__initWithFrame_editor_(self, _cmd, rect, richTextEditorView)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSFormatBar").super_class }, "initWithFrame:", rect)) {
  editor = richTextEditorView;
  var bimg = objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormatBarBackground.png", CGSizeMake(1,26));
  var bclr = objj_msgSend(CPColor, "colorWithPatternImage:", bimg);
  objj_msgSend(self, "setBackgroundColor:", bclr);
  var fontSelector = objj_msgSend(objj_msgSend(CSFormatBarPopUpButton, "alloc"), "initWithFrame:pullsDown:", CGRectMake(10,4,140,18), NO);
  objj_msgSend(CSFormatBarFontMenu, "fontMenuItems:", fontSelector);
  objj_msgSend(fontSelector, "setAction:", sel_getUid("fontName:"));
  objj_msgSend(fontSelector, "setTarget:", self);
  var sizeSelector = objj_msgSend(objj_msgSend(CSFormatBarPopUpButton, "alloc"), "initWithFrame:pullsDown:", CGRectMake(160,4,50,18), NO);
  objj_msgSend(sizeSelector, "addItemsWithTitles:", ["1","2","3","4","5","6","7"]);
  objj_msgSend(sizeSelector, "setAction:", sel_getUid("fontSize:"));
  objj_msgSend(sizeSelector, "setTarget:", self);
  var foreColorSelector = objj_msgSend(objj_msgSend(CSFormatBarColorWellButton, "alloc"), "initWithFrame:", CGRectMake(220,4,30,18));
  objj_msgSend(foreColorSelector.colorWell, "setAction:", sel_getUid("foreColor:"));
  objj_msgSend(foreColorSelector.colorWell, "setTarget:", self);
  var boldButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(271,4,20,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(boldButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormattingBold.png", CGSizeMake(6, 7)));
  objj_msgSend(boldButton, "setAction:", sel_getUid("bold"));
  objj_msgSend(boldButton, "setTarget:", self);
  var italicButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(290,4,20,18), CSFormatBarButtonNoRightMask | CSFormatBarButtonNoLeftMask);
  objj_msgSend(italicButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormattingItalic.png", CGSizeMake(4, 9)));
  objj_msgSend(italicButton, "setAction:", sel_getUid("italic"));
  objj_msgSend(italicButton, "setTarget:", self);
  var underlineButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(309,4,20,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(underlineButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/FormattingUnderline.png", CGSizeMake(6, 9)));
  objj_msgSend(underlineButton, "setAction:", sel_getUid("underline"));
  objj_msgSend(underlineButton, "setTarget:", self);
  var leftAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(350,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(leftAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentLeft.png", CGSizeMake(11, 9)));
  objj_msgSend(leftAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(leftAlignButton, "setAction:", sel_getUid("justifyLeft"));
  objj_msgSend(leftAlignButton, "setTarget:", self);
  var centerAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(372,4,23,18), CSFormatBarButtonNoRightMask | CSFormatBarButtonNoLeftMask);
  objj_msgSend(centerAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentCenter.png", CGSizeMake(12, 9)));
  objj_msgSend(centerAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(centerAlignButton, "setAction:", sel_getUid("justifyCenter"));
  objj_msgSend(centerAlignButton, "setTarget:", self);
  var rightAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(394,4,23,18), CSFormatBarButtonNoRightMask | CSFormatBarButtonNoLeftMask);
  objj_msgSend(rightAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentRight.png", CGSizeMake(11, 9)));
  objj_msgSend(rightAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(rightAlignButton, "setAction:", sel_getUid("justifyRight"));
  objj_msgSend(rightAlignButton, "setTarget:", self);
  var justifyAlignButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(416,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(justifyAlignButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/alignment/AlignmentJustified.png", CGSizeMake(12, 9)));
  objj_msgSend(justifyAlignButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 5.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  var indentButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(459,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(indentButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/indentation/BulletIndentationIncrease.png", CGSizeMake(15, 11)));
  objj_msgSend(indentButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(indentButton, "setAction:", sel_getUid("indent"));
  objj_msgSend(indentButton, "setTarget:", self);
  var outdentButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(481,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(outdentButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/indentation/BulletIndentationDecrease.png", CGSizeMake(15, 11)));
  objj_msgSend(outdentButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(outdentButton, "setAction:", sel_getUid("outdent"));
  objj_msgSend(outdentButton, "setTarget:", self);
  var dotButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(514,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(dotButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/bullets/BulletStyleDot.png", CGSizeMake(15, 11)));
  objj_msgSend(dotButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(dotButton, "setAction:", sel_getUid("insertUnorderedList"));
  objj_msgSend(dotButton, "setTarget:", self);
  var numberButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(536,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(numberButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/bullets/BulletStyleNumber.png", CGSizeMake(15, 11)));
  objj_msgSend(numberButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 4.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(numberButton, "setAction:", sel_getUid("insertOrderedList"));
  objj_msgSend(numberButton, "setTarget:", self);
  var fillLabel = objj_msgSend(objj_msgSend(CPTextField, "alloc"), "initWithFrame:", CGRectMake(579,4,23,18));
  objj_msgSend(fillLabel, "setStringValue:", "Fill:");
  objj_msgSend(fillLabel, "setFont:", objj_msgSend(CPFont, "systemFontOfSize:", 11.0));
  objj_msgSend(fillLabel, "sizeToFit");
  var backColorSelector = objj_msgSend(objj_msgSend(CSFormatBarColorWellButton, "alloc"), "initWithFrame:", CGRectMake(607,4,30,18));
  objj_msgSend(backColorSelector.colorWell, "setAction:", sel_getUid("backColor:"));
  objj_msgSend(backColorSelector.colorWell, "setTarget:", self);
  var undoButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(658,4,23,18), CSFormatBarButtonNoRightMask);
  objj_msgSend(undoButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/undo-redo/undo2.png", CGSizeMake(12, 7)));
  objj_msgSend(undoButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(undoButton, "setAction:", sel_getUid("undo"));
  objj_msgSend(undoButton, "setTarget:", self);
  var redoButton = objj_msgSend(objj_msgSend(CSFormatBarButton, "alloc"), "initWithFrame:styleMask:", CGRectMake(680,4,23,18), CSFormatBarButtonNoLeftMask);
  objj_msgSend(redoButton, "setImage:", objj_msgSend(objj_msgSend(CPImage, "alloc"), "initByReferencingFile:size:", "Resources/formatbar/buttons/undo-redo/redo2.png", CGSizeMake(12, 7)));
  objj_msgSend(redoButton, "setValue:forThemeAttribute:inState:", CGInsetMake(0.0, 0.0, 0.0, 6.0), "content-inset", CPThemeStateBordered);
  objj_msgSend(redoButton, "setAction:", sel_getUid("redo"));
  objj_msgSend(redoButton, "setTarget:", self);
  objj_msgSend(self, "addSubview:", fontSelector);
  objj_msgSend(self, "addSubview:", sizeSelector);
  objj_msgSend(self, "addSubview:", foreColorSelector);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 260));
  objj_msgSend(self, "addSubview:", boldButton);
  objj_msgSend(self, "addSubview:", italicButton);
  objj_msgSend(self, "addSubview:", underlineButton);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 339));
  objj_msgSend(self, "addSubview:", leftAlignButton);
  objj_msgSend(self, "addSubview:", centerAlignButton);
  objj_msgSend(self, "addSubview:", rightAlignButton);
  objj_msgSend(self, "addSubview:", justifyAlignButton);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 449));
  objj_msgSend(self, "addSubview:", indentButton);
  objj_msgSend(self, "addSubview:", outdentButton);
  objj_msgSend(self, "addSubview:", dotButton);
  objj_msgSend(self, "addSubview:", numberButton);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 569));
  objj_msgSend(self, "addSubview:", fillLabel);
  objj_msgSend(self, "addSubview:", backColorSelector);
  objj_msgSend(self, "addSubview:", objj_msgSend(objj_msgSend(CSFormatBarSeparator, "alloc"), "initWithX:", 647));
  objj_msgSend(self, "addSubview:", undoButton);
  objj_msgSend(self, "addSubview:", redoButton);
  objj_msgSend(self, "setAutoresizingMask:",  CPViewWidthSizable);
 }
 return self;
}
},["id","CGRect*",null]), new objj_method(sel_getUid("fontName:"), function $CSFormatBar__fontName_(self, _cmd, button)
{ with(self)
{
 objj_msgSend(objj_msgSend(button, "window"), "makeFirstResponder:", button);
 objj_msgSend(editor, "DOMWindow").document.execCommand('fontName', false, objj_msgSend(button, "titleOfSelectedItem"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPPopUpButton*"]), new objj_method(sel_getUid("fontSize:"), function $CSFormatBar__fontSize_(self, _cmd, button)
{ with(self)
{
 objj_msgSend(objj_msgSend(button, "window"), "makeFirstResponder:", button);
 objj_msgSend(editor, "DOMWindow").document.execCommand('fontSize', false, objj_msgSend(button, "titleOfSelectedItem"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPPopUpButton*"]), new objj_method(sel_getUid("foreColor:"), function $CSFormatBar__foreColor_(self, _cmd, colorWell)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('foreColor', false, objj_msgSend(objj_msgSend(colorWell, "color"), "hexString"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPColorWell*"]), new objj_method(sel_getUid("bold"), function $CSFormatBar__bold(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('bold', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("italic"), function $CSFormatBar__italic(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('italic', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("underline"), function $CSFormatBar__underline(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('underline', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("justifyLeft"), function $CSFormatBar__justifyLeft(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('justifyLeft', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("justifyCenter"), function $CSFormatBar__justifyCenter(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('justifyCenter', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("justifyRight"), function $CSFormatBar__justifyRight(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('justifyRight', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("indent"), function $CSFormatBar__indent(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('indent', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("outdent"), function $CSFormatBar__outdent(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('outdent', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("insertUnorderedList"), function $CSFormatBar__insertUnorderedList(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('insertUnorderedList', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("insertOrderedList"), function $CSFormatBar__insertOrderedList(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('insertOrderedList', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("backColor:"), function $CSFormatBar__backColor_(self, _cmd, colorWell)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('backColor', false, objj_msgSend(objj_msgSend(colorWell, "color"), "hexString"));
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void","CPColorWell*"]), new objj_method(sel_getUid("undo"), function $CSFormatBar__undo(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('undo', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"]), new objj_method(sel_getUid("redo"), function $CSFormatBar__redo(self, _cmd)
{ with(self)
{
 objj_msgSend(editor, "DOMWindow").document.execCommand('redo', false, null);
 objj_msgSend(editor, "DOMWindow").focus();
}
},["void"])]);
}

