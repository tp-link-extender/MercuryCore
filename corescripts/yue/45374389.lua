local t = { }
t.Foo = function()
	return print("foo")
end
t.Bar = function()
	return print("bar")
end
t.Help = function(funcNameOrFunc)
	if "Foo" == funcNameOrFunc or t.Foo == funcNameOrFunc then
		return "Function Foo.  Arguments: None.  Side effect: prints foo"
	elseif "Bar" == funcNameOrFunc or t.Bar == funcNameOrFunc then
		return "Function Bar.  Arguments: None.  Side effect: prints bar"
	end
end
return t
