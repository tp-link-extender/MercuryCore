local a,b,c={},assert,{buffer={}}function c:New()local d={}setmetatable(d,self)
self.__index=self d.buffer={}return d end function c:Append(d)self.buffer[#self.
buffer+1]=d end function c:ToString()return table.concat(self.buffer)end local d
={backslashes={['\b']='\\b',['\t']='\\t',['\n']='\\n',['\f']='\\f',['\r']='\\r',
['"']='\\"',['\\']='\\\\',['/']='\\/'}}function d:New()local e={}e.writer=c:New(
)setmetatable(e,self)self.__index=self return e end function d:Append(e)self.
writer:Append(e)end function d:ToString()return self.writer:ToString()end
function d:Write(e)local f=type(e)if f=='nil'then self:WriteNil()elseif f==
'boolean'or f=='number'then self:WriteString(e)elseif f=='string'then self:
ParseString(e)elseif f=='table'then self:WriteTable(e)elseif f=='function'then
self:WriteFunction(e)elseif f=='thread'or f=='userdata'then self:WriteError(e)
end end function d:WriteNil()self:Append'null'end function d:WriteString(e)self:
Append(tostring(e))end function d:ParseString(e)self:Append'"'self:Append(string
.gsub(e,'[%z%c\\"/]',function(f)local g=self.backslashes[f]if g then return g
end return string.format('\\u%.4X',string.byte(f))end))self:Append'"'end
function d:IsArray(e)local f,g=0,function(f)if type(f)=='number'and f>0 then if
math.floor(f)==f then return true end end return false end for h,i in pairs(e)do
if not g(h)then return false,'{','}'else f=math.max(f,h)end end return true,'[',
']',f end function d:WriteTable(e)local f,g,h,i=self:IsArray(e)self:Append(g)if
f then for j=1,i do self:Write(e[j])if j<i then self:Append','end end else local
j=true for k,l in pairs(e)do if not j then self:Append','end j=false self:
ParseString(k)self:Append':'self:Write(l)end end self:Append(h)end function d:
WriteError(e)error(string.format('Encoding of %s unsupported',tostring(e)))end
function d:WriteFunction(e)if e==Null then self:WriteNil()else self:WriteError(e
)end end local e={s='',i=0}function e:New(f)local g={}setmetatable(g,self)self.
__index=self g.s=f or g.s return g end function e:Peek()local f=self.i+1 if f<=#
self.s then return string.sub(self.s,f,f)end return nil end function e:Next()
self.i=self.i+1 if self.i<=#self.s then return string.sub(self.s,self.i,self.i)
end return nil end function e:All()return self.s end local f={escapes={['t']=
'\t',['n']='\n',['f']='\f',['r']='\r',['b']='\b'}}function f:New(g)local h={}h.
reader=e:New(g)setmetatable(h,self)self.__index=self return h end function f:
Read()self:SkipWhiteSpace()local g=self:Peek()if g==nil then error(string.
format("Nil string: '%s'",self:All()))elseif g=='{'then return self:ReadObject()
elseif g=='['then return self:ReadArray()elseif g=='"'then return self:
ReadString()elseif string.find(g,'[%+%-%d]')then return self:ReadNumber()elseif
g=='t'then return self:ReadTrue()elseif g=='f'then return self:ReadFalse()elseif
g=='n'then return self:ReadNull()elseif g=='/'then self:ReadComment()return self
:Read()else return nil end end function f:ReadTrue()self:TestReservedWord{'t',
'r','u','e'}return true end function f:ReadFalse()self:TestReservedWord{'f','a',
'l','s','e'}return false end function f:ReadNull()self:TestReservedWord{'n','u',
'l','l'}return nil end function f:TestReservedWord(g)for h,i in ipairs(g)do if
self:Next()~=i then error(string.format("Error reading '%s': %s",table.concat(g)
,self:All()))end end end function f:ReadNumber()local g,h=self:Next(),self:Peek(
)while h~=nil and string.find(h,'[%+%-%d%.eE]')do g=g..self:Next()h=self:Peek()
end g=tonumber(g)if g==nil then error(string.format("Invalid number: '%s'",g))
else return g end end function f:ReadString()local g=''b(self:Next()=='"')while
self:Peek()~='"'do local h=self:Next()if h=='\\'then h=self:Next()if self.
escapes[h]then h=self.escapes[h]end end g=g..h end b(self:Next()=='"')local h=
function(h)return string.char(tonumber(h,16))end return string.gsub(g,
'u%x%x(%x%x)',h)end function f:ReadComment()b(self:Next()=='/')local g=self:
Next()if g=='/'then self:ReadSingleLineComment()elseif g=='*'then self:
ReadBlockComment()else error(string.format('Invalid comment: %s',self:All()))end
end function f:ReadBlockComment()local g=false while not g do local h=self:Next(
)if h=='*'and self:Peek()=='/'then g=true end if not g and h=='/'and self:Peek()
=='*'then error(string.format("Invalid comment: %s, '/*' illegal.",self:All()))
end end self:Next()end function f:ReadSingleLineComment()local g=self:Next()
while g~='\r'and g~='\n'do g=self:Next()end end function f:ReadArray()local g={}
b(self:Next()=='[')local h=false if self:Peek()==']'then h=true end while not h
do local i=self:Read()g[#g+1]=i self:SkipWhiteSpace()if self:Peek()==']'then h=
true end if not h then local j=self:Next()if j~=','then error(string.format(
"Invalid array: '%s' due to: '%s'",self:All(),j))end end end b(']'==self:Next())
return g end function f:ReadObject()local g={}b(self:Next()=='{')local h=false
if self:Peek()=='}'then h=true end while not h do local i=self:Read()if type(i)
~='string'then error(string.format('Invalid non-string object key: %s',i))end
self:SkipWhiteSpace()local j=self:Next()if j~=':'then error(string.format(
"Invalid object: '%s' due to: '%s'",self:All(),j))end self:SkipWhiteSpace()local
k=self:Read()g[i]=k self:SkipWhiteSpace()if self:Peek()=='}'then h=true end if
not h then j=self:Next()if j~=','then error(string.format(
"Invalid array: '%s' near: '%s'",self:All(),j))end end end b(self:Next()=='}')
return g end function f:SkipWhiteSpace()local g=self:Peek()while g~=nil and
string.find(g,'[%s/]')do if g=='/'then self:ReadComment()else self:Next()end g=
self:Peek()end end function f:Peek()return self.reader:Peek()end function f:Next
()return self.reader:Next()end function f:All()return self.reader:All()end
function Encode(g)local h=d:New()h:Write(g)return h:ToString()end function
Decode(g)local h=f:New(g)return h:Read()end function Null()return Null end a.
DecodeJSON=function(g)pcall(function()warn
[[RbxUtility.DecodeJSON is deprecated, please use Game:GetService('HttpService'):JSONDecode() instead.]]
end)if type(g)=='string'then return Decode(g)end print
'RbxUtil.DecodeJSON expects string argument!'return nil end a.EncodeJSON=
function(g)pcall(function()warn
[[RbxUtility.EncodeJSON is deprecated, please use Game:GetService('HttpService'):JSONEncode() instead.]]
end)return Encode(g)end a.MakeWedge=function(g,h,i,j)return game:GetService
'Terrain':AutoWedgeCell(g,h,i)end a.SelectTerrainRegion=function(g,h,i,j)local k
=game.Workspace:FindFirstChild'Terrain'if not k then return end b(g)b(h)if not
type(g)=='Region3'then error(
[[regionToSelect (first arg), should be of type Region3, but is type]],type(g))
end if not type(h)=='BrickColor'then error(
[[color (second arg), should be of type BrickColor, but is type]],type(h))end
local l,m,n,o,p=k.GetCell,k.WorldToCellPreferSolid,k.CellCenterToWorld,Enum.
CellMaterial.Empty,Instance.new'Model'p.Name='SelectionContainer'p.Archivable=
false if j then p.Parent=j else p.Parent=game.Workspace end local q,r,s,t,u,v,w=
nil,nil,0,nil,{},{},Instance.new'Part'w.Name='SelectionPart'w.Transparency=1 w.
Anchored=true w.Locked=true w.CanCollide=false w.Size=Vector3.new(4.2,4.2,4.2)
local x=Instance.new'SelectionBox'function createAdornment(y)local z,A=nil,nil
if#v>0 then z=v[1]['part']A=v[1]['box']table.remove(v,1)A.Visible=true else z=w:
Clone()z.Archivable=false A=x:Clone()A.Archivable=false A.Adornee=z A.Parent=p A
.Adornee=z A.Parent=p end if y then A.Color=y end return z,A end function
cleanUpAdornments()for y,z in pairs(u)do if z.KeepAlive~=r then z.SelectionBox.
Visible=false table.insert(v,{part=z.SelectionPart,box=z.SelectionBox})u[y]=nil
end end end function incrementAliveCounter()s=s+1 if s>1000000 then s=0 end
return s end function adornFullCellsInRegion(y,z)local A,B=y.CFrame.p-(y.Size/2)
+Vector3.new(2,2,2),y.CFrame.p+(y.Size/2)-Vector3.new(2,2,2)local C,D=m(k,A),m(k
,B)r=incrementAliveCounter()for E=C.y,D.y do for F=C.z,D.z do for G=C.x,D.x do
local H=l(k,G,E,F)if H~=o then local I,J,K=n(k,G,E,F),Vector3int16.new(G,E,F),
false for L,M in pairs(u)do if L==J then M.KeepAlive=r if z then M.SelectionBox.
Color=z end K=true break end end if not K then local N,O=createAdornment(z)N.
Size=Vector3.new(4,4,4)N.CFrame=CFrame.new(I)local P={SelectionPart=N,
SelectionBox=O,KeepAlive=r}u[J]=P end end end end end cleanUpAdornments()end t=g
if i then local y,z=createAdornment(h)y.Size=g.Size y.CFrame=g.CFrame u.
SelectionPart=y u.SelectionBox=z q=function(A,B)if A and A~=t then t=A y.Size=A.
Size y.CFrame=A.CFrame end if B then z.Color=B end end else
adornFullCellsInRegion(g,h)q=function(y,z)if y and y~=t then t=y
adornFullCellsInRegion(y,z)end end end local y=function()q=nil if p then p:
Destroy()end u=nil end return q,y end function a.CreateSignal()local g,h,i={},
Instance.new'BindableEvent',{}function g:connect(j)if self~=g then error(
'connect must be called with `:`, not `.`',2)end if type(j)~='function'then
error('Argument #1 of connect must be a function, got a '..type(j),2)end local k
=h.Event:connect(j)i[k]=true local l={}function l:disconnect()k:disconnect()i[k]
=nil end l.Disconnect=l.disconnect return l end function g:disconnect()if self~=
g then error('disconnect must be called with `:`, not `.`',2)end for j,k in
pairs(i)do j:disconnect()i[j]=nil end end function g:wait()if self~=g then
error('wait must be called with `:`, not `.`',2)end return h.Event:wait()end
function g:fire(...)if self~=g then error(
'fire must be called with `:`, not `.`',2)end h:Fire(...)end g.Connect=g.connect
g.Disconnect=g.disconnect g.Wait=g.wait g.Fire=g.fire return g end
local function Create_PrivImpl(g)if type(g)~='string'then error(
'Argument of Create must be a string',2)end return function(h)h=h or{}local i,j,
k=Instance.new(g),nil,nil for l,m in pairs(h)do if type(l)=='string'then if l==
'Parent'then j=m else i[l]=m end elseif type(l)=='number'then if type(m)~=
'userdata'then error(
[[Bad entry in Create body: Numeric keys must be paired with children, got a: ]]
..type(m),2)end m.Parent=i elseif type(l)=='table'and l.__eventname then if
type(m)~='function'then error("Bad entry in Create body: Key `[Create.E'"..l.
__eventname.."']` must have a function value, got: "..tostring(m),2)end i[l.
__eventname]:connect(m)elseif l==a.Create then if type(m)~='function'then error(
[[Bad entry in Create body: Key `[Create]` should be paired with a constructor function, got: ]]
..tostring(m),2)elseif k then error(
[[Bad entry in Create body: Only one constructor function is allowed]],2)end k=m
else error('Bad entry ('..tostring(l)..' => '..tostring(m)..') in Create body',2
)end end if k then k(i)end if j then i.Parent=j end return i end end a.Create=
setmetatable({},{__call=function(g,...)return Create_PrivImpl(...)end})a.Create.
E=function(g)return{__eventname=g}end a.Help=function(g)if g=='DecodeJSON'or g==
a.DecodeJSON then return
[[Function DecodeJSON.  Arguments: (string).  Side effect: returns a table with all parsed JSON values]]
end if g=='EncodeJSON'or g==a.EncodeJSON then return
[[Function EncodeJSON.  Arguments: (table).  Side effect: returns a string composed of argument table in JSON data format]]
end if g=='MakeWedge'or g==a.MakeWedge then return
[[Function MakeWedge. Arguments: (x, y, z, [default material]). Description: Makes a wedge at location x, y, z. Sets cell x, y, z to default material if parameter is provided, if not sets cell x, y, z to be whatever material it previously was. Returns true if made a wedge, false if the cell remains a block ]]
end if g=='SelectTerrainRegion'or g==a.SelectTerrainRegion then return
[[Function SelectTerrainRegion. Arguments: (regionToSelect, color, selectEmptyCells, selectionParent). Description: Selects all terrain via a series of selection boxes within the regionToSelect (this should be a region3 value). The selection box color is detemined by the color argument (should be a brickcolor value). SelectionParent is the parent that the selection model gets placed to (optional).SelectEmptyCells is bool, when true will select all cells in the region, otherwise we only select non-empty cells. Returns a function that can update the selection,arguments to said function are a new region3 to select, and the adornment color (color arg is optional). Also returns a second function that takes no arguments and destroys the selection]]
end if g=='CreateSignal'or g==a.CreateSignal then return
[[Function CreateSignal. Arguments: None. Returns: The newly created Signal object. This object is identical to the RBXScriptSignal class used for events in Objects, but is a Lua-side object so it can be used to create custom events inLua code. Methods of the Signal object: :connect, :wait, :fire, :disconnect. For more info you can pass the method name to the Help function, or view the wiki page for this library. EG: Help('Signal:connect').]]
end if g=='Signal:connect'then return
[[Method Signal:connect. Arguments: (function handler). Return: A connection object which can be used to disconnect the connection to this handler. Description: Connectes a handler function to this Signal, so that when |fire| is called the handler function will be called with the arguments passed to |fire|.]]
end if g=='Signal:wait'then return
[[Method Signal:wait. Arguments: None. Returns: The arguments passed to the next call to |fire|. Description: This call does not return until the next call to |fire| is made, at which point it will return the values which were passed as arguments to that |fire| call.]]
end if g=='Signal:fire'then return
[[Method Signal:fire. Arguments: Any number of arguments of any type. Returns: None. Description: This call will invoke any connected handler functions, and notify any waiting code attached to this Signal to continue, with the arguments passed to this function. Note: The calls to handlers are made asynchronously, so this call will return immediately regardless of how long it takes the connected handler functions to complete.]]
end if g=='Signal:disconnect'then return
[[Method Signal:disconnect. Arguments: None. Returns: None. Description: This call disconnects all handlers attacched to this function, note however, it does NOT make waiting code continue, as is the behavior of normal Roblox events. This method can also be called on the connection object which is returned from Signal:connect to only disconnect a single handler, as opposed to this method, which will disconnect all handlers.]]
end if g=='Create'then return
[[Function Create. Arguments: A table containing information about how to construct a collection of objects. Returns: The constructed objects. Descrition: Create is a very powerfull function, whose description is too long to fit here, and is best described via example, please see the wiki page for a description of how to use it.]]
end end return a