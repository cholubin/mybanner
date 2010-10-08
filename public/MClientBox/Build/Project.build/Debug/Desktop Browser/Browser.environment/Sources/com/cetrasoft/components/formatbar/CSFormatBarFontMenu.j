@STATIC;1.0;I;21;Foundation/CPObject.jt;876;objj_executeFile("Foundation/CPObject.j", NO);
{var the_class = objj_allocateClassPair(CPObject, "CSFormatBarFontMenu"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(meta_class, [new objj_method(sel_getUid("fontMenuItems:"), function $CSFormatBarFontMenu__fontMenuItems_(self, _cmd, button)
{ with(self)
{
 var availableFonts = objj_msgSend(objj_msgSend(CPFontManager, "sharedFontManager"), "availableFonts");
 for(var i = 0; i < objj_msgSend(availableFonts, "count"); i++) {
  var font = objj_msgSend(availableFonts, "objectAtIndex:", i);
  var menuItem = objj_msgSend(objj_msgSend(CPMenuItem, "alloc"), "initWithTitle:action:keyEquivalent:", font, NULL, nil);
  objj_msgSend(menuItem, "setFont:", objj_msgSend(CPFont, "fontWithName:size:", font, 11.0));
  objj_msgSend(button, "addItem:", menuItem);
 }
}
},["void","CPPopUpButton*"])]);
}

