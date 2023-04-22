local a={}a.Foo=function()print'foo'end a.Bar=function()print'bar'end a.Help=
function(b)if b=='Foo'or b==a.Foo then return
'Function Foo.  Arguments: None.  Side effect: prints foo'elseif b=='Bar'or b==a
.Bar then return'Function Bar.  Arguments: None.  Side effect: prints bar'end
end return a