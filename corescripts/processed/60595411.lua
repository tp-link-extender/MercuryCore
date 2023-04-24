print'[Mercury]: Loaded corescript 60595411'local a,b={},nil b=function(c,d,e)if
not(e~=nil)then e=d d=nil end local f=Instance.new(c)if d then f.Name=d end
local g for h,i in pairs(e)do if type(h)=='string'then if h=='Parent'then g=i
else f[h]=i end elseif type(h)=='number'and type(i)=='userdata'then i.Parent=f
end end f.Parent=g return f end local c,d=assert,nil d=function()return d end
local e={buffer={}}e.New=function(f)local g=setmetatable({},f)f.__index=f g.
buffer={}return g end e.Append=function(f,g)do local h=f.buffer h[#h+1]=g end
end e.ToString=function(f)return table.concat(f.buffer)end local f={backslashes=
{['\b']='\\b',['\t']='\\t',['\n']='\\n',['\f']='\\f',['\r']='\\r',['"']='\\"',[
'\\']='\\\\',['/']='\\/'}}f.New=function(g)local h=setmetatable({},g)h.writer=e:
New()g.__index=g return h end f.Append=function(g,h)return g.writer:Append(h)end
f.ToString=function(g)return g.writer:ToString()end f.Write=function(g,h)local i
=type(h)if'nil'==i then return g:WriteNil()elseif'boolean'==i or'number'==i then
return g:WriteString(h)elseif'string'==i then return g:ParseString(h)elseif
'table'==i then return g:WriteTable(h)elseif'function'==i then return g:
WriteFunction(h)elseif'thread'==i or'userdata'==i then return g:WriteError(h)end
end f.WriteNil=function(g)return g:Append'null'end f.WriteString=function(g,h)
return g:Append(tostring(h))end f.ParseString=function(g,h)g:Append'"'g:Append(
string.gsub(h,'[%z%c\\"/]',function(i)local j=g.backslashes[i]if j then return j
end return string.format('\\u%.4X',string.byte(i))end))return g:Append'"'end f.
IsArray=function(g,h)local i,j=0,nil j=function(k)if type(k)=='number'and k>0
and math.floor(k)==k then return true end return false end for k,l in pairs(h)do
if not j(k)then return false,'{','}'else i=math.max(i,k)end end return true,'[',
']',i end f.WriteTable=function(g,h)local i,j,k,l=g:IsArray(h)g:Append(j)if i
then for m=1,l do g:Write(h[m])if m<l then g:Append','end end else local m=true
for n,o in pairs(h)do if not m then g:Append','end m=false g:ParseString(n)g:
Append':'g:Write(o)end end return g:Append(k)end f.WriteError=function(g,h)
return error(string.format('Encoding of %s unsupported',tostring(h)))end f.
WriteFunction=function(g,h)if h==d then return g:WriteNil()else return g:
WriteError(h)end end local g={s='',i=0}g.New=function(h,i)local j=setmetatable({
},h)h.__index=h j.s=i or j.s return j end g.Peek=function(h)local i=h.i+1 if i<=
#h.s then return string.sub(h.s,i,i)end return nil end g.Next=function(h)h.i=h.i
+1 if h.i<=#h.s then return string.sub(h.s,h.i,h.i)end return nil end g.All=
function(h)return h.s end local h={escapes={['t']='\t',['n']='\n',['f']='\f',[
'r']='\r',['b']='\b'}}h.New=function(i,j)local k=setmetatable({},i)k.reader=g:
New(j)i.__index=i return k end h.Read=function(i)i:SkipWhiteSpace()local j=i:
Peek()if not(j~=nil)then return error(string.format("Nil string: '%s'",i:All()))
elseif j=='{'then return i:ReadObject()elseif j=='['then return i:ReadArray()
elseif j=='"'then return i:ReadString()elseif string.find(j,'[%+%-%d]')then
return i:ReadNumber()elseif j=='t'then return i:ReadTrue()elseif j=='f'then
return i:ReadFalse()elseif j=='n'then return i:ReadNull()elseif j=='/'then i:
ReadComment()return i:Read()else return nil end end h.ReadTrue=function(i)i:
TestReservedWord{'t','r','u','e'}return true end h.ReadFalse=function(i)i:
TestReservedWord{'f','a','l','s','e'}return false end h.ReadNull=function(i)i:
TestReservedWord{'n','u','l','l'}return nil end h.TestReservedWord=function(i,j)
for k,l in ipairs(j)do if i:Next()~=l then error(string.format(
"Error reading '%s': %s",table.concat(j),i:All()))end end end h.ReadNumber=
function(i)local j,k=i:Next(),i:Peek()while(k~=nil)and string.find(k,
'[%+%-%d%.eE]')do j=j..i:Next()k=i:Peek()end j=tonumber(j)if not(j~=nil)then
return error(string.format("Invalid number: '%s'",j))else return j end end h.
ReadString=function(i)local j=''c(i:Next()=='"')while i:Peek()~='"'do local k=i:
Next()if k=='\\'then k=i:Next()if i.escapes[k]then k=i.escapes[k]end end j=j..k
end c(i:Next()=='"')local k k=function(l)return string.char(tonumber(l,16))end
return string.gsub(j,'u%x%x(%x%x)',k)end h.ReadComment=function(i)c(i:Next()==
'/')local j=i:Next()if j=='/'then return i:ReadSingleLineComment()elseif j=='*'
then return i:ReadBlockComment()else return error(string.format(
'Invalid comment: %s',i:All()))end end h.ReadBlockComment=function(i)local j=
false while not j do local k=i:Next()if k=='*'and i:Peek()=='/'then j=true end
if not j and k=='/'and i:Peek()=='*'then error(string.format(
"Invalid comment: %s, '/*' illegal.",i:All()))end end return i:Next()end h.
ReadSingleLineComment=function(i)local j=i:Next()while j~='\r'and j~='\n'do j=i:
Next()end end h.ReadArray=function(i)local j={}c(i:Next()=='[')local k=false if
i:Peek()==']'then k=true end while not k do local l=i:Read()j[#j+1]=l i:
SkipWhiteSpace()if i:Peek()==']'then k=true end if not k then local m=i:Next()if
m~=','then error(string.format("Invalid array: '%s' due to: '%s'",i:All(),m))end
end end c(']'==i:Next())return j end h.ReadObject=function(i)local j={}c(i:Next(
)=='{')local k=false if i:Peek()=='}'then k=true end while not k do local l=i:
Read()if type(l)~='string'then error(string.format(
'Invalid non-string object key: %s',l))end i:SkipWhiteSpace()local m=i:Next()if
m~=':'then error(string.format("Invalid object: '%s' due to: '%s'",i:All(),m))
end i:SkipWhiteSpace()local n=i:Read()j[l]=n i:SkipWhiteSpace()if i:Peek()=='}'
then k=true end if not k then m=i:Next()if m~=','then error(string.format(
"Invalid array: '%s' near: '%s'",i:All(),m))end end end c(i:Next()=='}')return j
end h.SkipWhiteSpace=function(i)local j=i:Peek()while(j~=nil)and string.find(j,
'[%s/]')do if j=='/'then i:ReadComment()else i:Next()end j=i:Peek()end end h.
Peek=function(i)return i.reader:Peek()end h.Next=function(i)return i.reader:
Next()end h.All=function(i)return i.reader:All()end local i i=function(j)local k
=f:New()k:Write(j)k:ToString()return k end local j j=function(k)local l=h:New(k)
l:Read()return l end a.DecodeJSON=function(k)pcall(function()return warn
[[RbxUtility.DecodeJSON is deprecated, please use Game:GetService("HttpService"):JSONDecode() instead.]]
end)if type(k)=='string'then return j(k)end print
'RbxUtil.DecodeJSON expects string argument!'return nil end a.EncodeJSON=
function(k)pcall(function()return warn
[[RbxUtility.EncodeJSON is deprecated, please use Game:GetService("HttpService"):JSONEncode() instead.]]
end)return i(k)end a.MakeWedge=function(k,l,m,n)return game:GetService'Terrain':
AutoWedgeCell(k,l,m)end a.SelectTerrainRegion=function(k,l,m,n)local o=game.
Workspace:FindFirstChild'Terrain'if not o then return end c(k)c(l)if not type(k)
=='Region3'then error(
[[regionToSelect (first arg), should be of type Region3, but is type]],type(k))
end if not type(l)=='BrickColor'then error(
[[color (second arg), should be of type BrickColor, but is type]],type(l))end
local p,q,r,s,t,u,v,w,x,y,z,A,B,C=o.GetCell,o.WorldToCellPreferSolid,o.
CellCenterToWorld,Enum.CellMaterial.Empty,b('Model','SelectionContainer',{
Archivable=false,Parent=(function()if n then return n else return game.Workspace
end end)()}),nil,nil,0,nil,{},{},b('Part','SelectionPart',{Transparency=1,
Anchored=true,Locked=true,CanCollide=false,Size=Vector3.new(4.2,4.2,4.2)}),
Instance.new'SelectionBox',nil C=function(D)local E,F if#z>0 then E=z[1]['part']
F=z[1]['box']table.remove(z,1)F.Visible=true else E=A:Clone()E.Archivable=false
F=B:Clone()F.Archivable=false F.Adornee=E F.Parent=t F.Adornee=E F.Parent=t end
if D then F.Color=D end return E,F end local D D=function()for E,F in pairs(y)do
if F.KeepAlive~=v then F.SelectionBox.Visible=false table.insert(z,{part=F.
SelectionPart,box=F.SelectionBox})y[E]=nil end end end local E E=function()w=w+1
if w>1000000 then w=0 end return w end local F F=function(G,H)local I,J=G.CFrame
.p-G.Size/2+Vector3.new(2,2,2),G.CFrame.p+G.Size/2-Vector3.new(2,2,2)local K,L=
q(o,I),q(o,J)v=E()for M=K.y,L.y do for N=K.z,L.z do for O=K.x,L.x do local P=p(o
,O,M,N)if P~=s then local Q,R,S=r(o,O,M,N),Vector3int16.new(O,M,N),false for T,U
in pairs(y)do if T==R then U.KeepAlive=v if H then U.SelectionBox.Color=H end S=
true break end end if not S then local V,W V,W=C(H)V.Size=Vector3.new(4,4,4)V.
CFrame=CFrame.new(Q)local X={SelectionPart=V,SelectionBox=W,KeepAlive=v}y[R]=X
end end end end end return D()end x=k if m then local G,H G,H=C(l)G.Size=k.Size
G.CFrame=k.CFrame y.SelectionPart=G y.SelectionBox=H u=function(I,J)if I and I~=
x then x=I G.Size=I.Size G.CFrame=I.CFrame end if J then H.Color=J end end else
F(k,l)u=function(G,H)if G and G~=x then x=G return F(G,H)end end end local G G=
function()u=nil if t~=nil then t:Destroy()end y=nil end return u,G end a.
CreateSignal=function()local k,l,m={},Instance.new'BindableEvent',{}k.connect=
function(n,o)if n~=k then error('connect must be called with `:`, not `.`',2)end
if type(o)~='function'then error(
'Argument #1 of connect must be a function, got a '..tostring(type(o)),2)end
local p=l.Event:connect(o)m[p]=true local q={}q.disconnect=function(r)p:
disconnect()m[p]=nil end q.Disconnect=q.disconnect return q end k.disconnect=
function(n)if n~=k then error('disconnect must be called with `:`, not `.`',2)
end for o,p in pairs(m)do o:disconnect()m[o]=nil end end k.wait=function(n)if n
~=k then error('wait must be called with `:`, not `.`',2)end return l.Event:
wait()end k.fire=function(n,...)if n~=k then error(
'fire must be called with `:`, not `.`',2)end return l:Fire(...)end k.Connect=k.
connect k.Disconnect=k.disconnect k.Wait=k.wait k.Fire=k.fire return k end local
k k=function(l)if type(l)~='string'then error(
'Argument of Create must be a string',2)end return function(m)m=m or{}local n,o,
p=Instance.new(l),nil,nil for q,r in pairs(m)do if type(q)=='string'then if q==
'Parent'then o=r else n[q]=r end elseif type(q)=='number'then if type(r)~=
'userdata'then error(
[[Bad entry in Create body: Numeric keys must be paired with children, got a: ]]
..tostring(type(r)),2)end r.Parent=n elseif type(q)=='table'and q.__eventname
then if type(r)~='function'then error(
"Bad entry in Create body: Key `[Create.E'"..tostring(q.__eventname)..
"']` must have a function value, got: "..tostring(r),2)end n[q.__eventname]:
connect(r)elseif q==a.Create then if type(r)~='function'then error(
[[Bad entry in Create body: Key `[Create]` should be paired with a constructor function, got: ]]
..tostring(r),2)elseif p then error(
[[Bad entry in Create body: Only one constructor function is allowed]],2)end p=r
else error('Bad entry ('..tostring(q)..' => '..tostring(r)..') in Create body',2
)end end if p~=nil then p(n)end if o then n.Parent=o end return n end end a.
Create=setmetatable({},{['__call']=function(l,...)return k(...)end})a.Create.E=
function(l)return{__eventname=l}end a.Help=function(l)if'DecodeJSON'==l or a.
DecodeJSON==l then return
[[Function DecodeJSON.  Arguments: (string).  Side effect: returns a table with all parsed JSON values]]
elseif'EncodeJSON'==l or a.EncodeJSON==l then return
[[Function EncodeJSON.  Arguments: (table).  Side effect: returns a string composed of argument table in JSON data format]]
elseif'MakeWedge'==l or a.MakeWedge==l then return
[[Function MakeWedge. Arguments: (x, y, z, [default material]). Description: Makes a wedge at location x, y, z. Sets cell x, y, z to default material if parameter is provided, if not sets cell x, y, z to be whatever material it previously was. Returns true if made a wedge, false if the cell remains a block ]]
elseif'SelectTerrainRegion'==l or a.SelectTerrainRegion==l then return
[[Function SelectTerrainRegion. Arguments: (regionToSelect, color, selectEmptyCells, selectionParent). Description: Selects all terrain via a series of selection boxes within the regionToSelect (this should be a region3 value). The selection box color is detemined by the color argument (should be a brickcolor value). SelectionParent is the parent that the selection model gets placed to (optional).SelectEmptyCells is bool, when true will select all cells in the region, otherwise we only select non-empty cells. Returns a function that can update the selection,arguments to said function are a new region3 to select, and the adornment color (color arg is optional). Also returns a second function that takes no arguments and destroys the selection]]
elseif'CreateSignal'==l or a.CreateSignal==l then return
[[Function CreateSignal. Arguments: None. Returns: The newly created Signal object. This object is identical to the RBXScriptSignal class used for events in Objects, but is a Lua-side object so it can be used to create custom events inLua code. Methods of the Signal object: :connect, :wait, :fire, :disconnect. For more info you can pass the method name to the Help function, or view the wiki page for this library. EG: Help('Signal:connect').]]
elseif'Signal:connect'==l then return
[[Method Signal:connect. Arguments: (function handler). Return: A connection object which can be used to disconnect the connection to this handler. Description: Connectes a handler function to this Signal, so that when |fire| is called the handler function will be called with the arguments passed to |fire|.]]
elseif'Signal:wait'==l then return
[[Method Signal:wait. Arguments: None. Returns: The arguments passed to the next call to |fire|. Description: This call does not return until the next call to |fire| is made, at which point it will return the values which were passed as arguments to that |fire| call.]]
elseif'Signal:fire'==l then return
[[Method Signal:fire. Arguments: Any number of arguments of any type. Returns: None. Description: This call will invoke any connected handler functions, and notify any waiting code attached to this Signal to continue, with the arguments passed to this function. Note: The calls to handlers are made asynchronously, so this call will return immediately regardless of how long it takes the connected handler functions to complete.]]
elseif'Signal:disconnect'==l then return
[[Method Signal:disconnect. Arguments: None. Returns: None. Description: This call disconnects all handlers attacched to this function, note however, it does NOT make waiting code continue, as is the behavior of normal Roblox events. This method can also be called on the connection object which is returned from Signal:connect to only disconnect a single handler, as opposed to this method, which will disconnect all handlers.]]
elseif'Create'==l then return
[[Function Create. Arguments: A table containing information about how to construct a collection of objects. Returns: The constructed objects. Descrition: Create is a very powerfull function, whose description is too long to fit here, and is best described via example, please see the wiki page for a description of how to use it.]]
end end return a