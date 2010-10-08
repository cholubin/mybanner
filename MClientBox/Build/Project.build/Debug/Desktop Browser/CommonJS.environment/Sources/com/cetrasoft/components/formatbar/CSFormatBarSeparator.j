@STATIC;1.0;I;21;Foundation/CPObject.jt;625;objj_executeFile("Foundation/CPObject.j", NO);
{var the_class = objj_allocateClassPair(CPView, "CSFormatBarSeparator"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithX:"), function $CSFormatBarSeparator__initWithX_(self, _cmd, x)
{ with(self)
{
 if(self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CSFormatBarSeparator").super_class }, "initWithFrame:", CGRectMake(x, 2, 1, 21))) {
  objj_msgSend(self, "setBackgroundColor:", objj_msgSend(CPColor, "colorWithHexString:", "5f5f5f"));
 }
 return self;
}
},["id","int"])]);
}

