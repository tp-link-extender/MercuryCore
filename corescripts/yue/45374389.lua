local t = { }
t.Foo = function()
	return print("foo")
end
t.Bar = function()
	return print("bar")
end
t.Help = function(funcNameOrFunc)
	if funcNameOrFunc == "Foo" or funcNameOrFunc == t.Foo then
		return "Function Foo.  Arguments: None.  Side effect: prints foo"
	elseif funcNameOrFunc == "Bar" or funcNameOrFunc == t.Bar then
		return "Function Bar.  Arguments: None.  Side effect: prints bar"
	end
end
return t
