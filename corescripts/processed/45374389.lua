local a={}a.Foo=function()return print'foo'end a.Bar=function()return print'bar'
end a.Help=function(b)if'Foo'==b or a.Foo==b then return
'Function Foo.  Arguments: None.  Side effect: prints foo'elseif'Bar'==b or a.
Bar==b then return'Function Bar.  Arguments: None.  Side effect: prints bar'end
end return a