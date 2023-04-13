local a,b,c,d,e,f,g,h,i,j,k,l,m={},string,math,table,error,tonumber,tostring,
type,setmetatable,pairs,ipairs,assert,{buffer={}}function m:New()local n={}i(n,
self)self.__index=self n.buffer={}return n end function m:Append(n)self.buffer[#
self.buffer+1]=n end function m:ToString()return d.concat(self.buffer)end local
n={backslashes={['\b']='\\b',['\t']='\\t',['\n']='\\n',['\f']='\\f',['\r']='\\r'
,['"']='\\"',['\\']='\\\\',['/']='\\/'}}function n:New()local o={}o.writer=m:
New()i(o,self)self.__index=self return o end function n:Append(o)self.writer:
Append(o)end function n:ToString()return self.writer:ToString()end function n:
Write(o)local p=h(o)if p=='nil'then self:WriteNil()elseif p=='boolean'or p==
'number'then self:WriteString(o)elseif p=='string'then self:ParseString(o)elseif
p=='table'then self:WriteTable(o)elseif p=='function'then self:WriteFunction(o)
elseif p=='thread'or p=='userdata'then self:WriteError(o)end end function n:
WriteNil()self:Append'null'end function n:WriteString(o)self:Append(g(o))end
function n:ParseString(o)self:Append'"'self:Append(b.gsub(o,'[%z%c\\"/]',
function(p)local q=self.backslashes[p]if q then return q end return b.format(
'\\u%.4X',b.byte(p))end))self:Append'"'end function n:IsArray(o)local p,q=0,
function(p)if h(p)=='number'and p>0 then if c.floor(p)==p then return true end
end return false end for r,s in j(o)do if not q(r)then return false,'{','}'else
p=c.max(p,r)end end return true,'[',']',p end function n:WriteTable(o)local p,q,
r,s=self:IsArray(o)self:Append(q)if p then for t=1,s do self:Write(o[t])if t<s
then self:Append','end end else local t=true for u,v in j(o)do if not t then
self:Append','end t=false self:ParseString(u)self:Append':'self:Write(v)end end
self:Append(r)end function n:WriteError(o)e(b.format(
'Encoding of %s unsupported',g(o)))end function n:WriteFunction(o)if o==Null
then self:WriteNil()else self:WriteError(o)end end local o={s='',i=0}function o:
New(p)local q={}i(q,self)self.__index=self q.s=p or q.s return q end function o:
Peek()local p=self.i+1 if p<=#self.s then return b.sub(self.s,p,p)end return nil
end function o:Next()self.i=self.i+1 if self.i<=#self.s then return b.sub(self.s
,self.i,self.i)end return nil end function o:All()return self.s end local p={
escapes={['t']='\t',['n']='\n',['f']='\f',['r']='\r',['b']='\b'}}function p:New(
q)local r={}r.reader=o:New(q)i(r,self)self.__index=self return r end function p:
Read()self:SkipWhiteSpace()local q=self:Peek()if q==nil then e(b.format(
"Nil string: '%s'",self:All()))elseif q=='{'then return self:ReadObject()elseif
q=='['then return self:ReadArray()elseif q=='"'then return self:ReadString()
elseif b.find(q,'[%+%-%d]')then return self:ReadNumber()elseif q=='t'then return
self:ReadTrue()elseif q=='f'then return self:ReadFalse()elseif q=='n'then return
self:ReadNull()elseif q=='/'then self:ReadComment()return self:Read()else return
nil end end function p:ReadTrue()self:TestReservedWord{'t','r','u','e'}return
true end function p:ReadFalse()self:TestReservedWord{'f','a','l','s','e'}return
false end function p:ReadNull()self:TestReservedWord{'n','u','l','l'}return nil
end function p:TestReservedWord(q)for r,s in k(q)do if self:Next()~=s then e(b.
format("Error reading '%s': %s",d.concat(q),self:All()))end end end function p:
ReadNumber()local q,r=self:Next(),self:Peek()while r~=nil and b.find(r,
'[%+%-%d%.eE]')do q=q..self:Next()r=self:Peek()end q=f(q)if q==nil then e(b.
format("Invalid number: '%s'",q))else return q end end function p:ReadString()
local q=''l(self:Next()=='"')while self:Peek()~='"'do local r=self:Next()if r==
'\\'then r=self:Next()if self.escapes[r]then r=self.escapes[r]end end q=q..r end
l(self:Next()=='"')local r=function(r)return b.char(f(r,16))end return b.gsub(q,
'u%x%x(%x%x)',r)end function p:ReadComment()l(self:Next()=='/')local q=self:
Next()if q=='/'then self:ReadSingleLineComment()elseif q=='*'then self:
ReadBlockComment()else e(b.format('Invalid comment: %s',self:All()))end end
function p:ReadBlockComment()local q=false while not q do local r=self:Next()if
r=='*'and self:Peek()=='/'then q=true end if not q and r=='/'and self:Peek()==
'*'then e(b.format("Invalid comment: %s, '/*' illegal.",self:All()))end end self
:Next()end function p:ReadSingleLineComment()local q=self:Next()while q~='\r'and
q~='\n'do q=self:Next()end end function p:ReadArray()local q={}l(self:Next()==
'[')local r=false if self:Peek()==']'then r=true end while not r do local s=self
:Read()q[#q+1]=s self:SkipWhiteSpace()if self:Peek()==']'then r=true end if not
r then local t=self:Next()if t~=','then e(b.format(
"Invalid array: '%s' due to: '%s'",self:All(),t))end end end l(']'==self:Next())
return q end function p:ReadObject()local q={}l(self:Next()=='{')local r=false
if self:Peek()=='}'then r=true end while not r do local s=self:Read()if h(s)~=
'string'then e(b.format('Invalid non-string object key: %s',s))end self:
SkipWhiteSpace()local t=self:Next()if t~=':'then e(b.format(
"Invalid object: '%s' due to: '%s'",self:All(),t))end self:SkipWhiteSpace()local
u=self:Read()q[s]=u self:SkipWhiteSpace()if self:Peek()=='}'then r=true end if
not r then t=self:Next()if t~=','then e(b.format(
"Invalid array: '%s' near: '%s'",self:All(),t))end end end l(self:Next()=='}')
return q end function p:SkipWhiteSpace()local q=self:Peek()while q~=nil and b.
find(q,'[%s/]')do if q=='/'then self:ReadComment()else self:Next()end q=self:
Peek()end end function p:Peek()return self.reader:Peek()end function p:Next()
return self.reader:Next()end function p:All()return self.reader:All()end
function Encode(q)local r=n:New()r:Write(q)return r:ToString()end function
Decode(q)local r=p:New(q)return r:Read()end function Null()return Null end a.
DecodeJSON=function(q)pcall(function()warn
[[RbxUtility.DecodeJSON is deprecated, please use Game:GetService('HttpService'):JSONDecode() instead.]]
end)if h(q)=='string'then return Decode(q)end print
'RbxUtil.DecodeJSON expects string argument!'return nil end a.EncodeJSON=
function(q)pcall(function()warn
[[RbxUtility.EncodeJSON is deprecated, please use Game:GetService('HttpService'):JSONEncode() instead.]]
end)return Encode(q)end a.MakeWedge=function(q,r,s,t)return game:GetService
'Terrain':AutoWedgeCell(q,r,s)end a.SelectTerrainRegion=function(q,r,s,t)local u
=game.Workspace:FindFirstChild'Terrain'if not u then return end l(q)l(r)if not
h(q)=='Region3'then e(
[[regionToSelect (first arg), should be of type Region3, but is type]],h(q))end
if not h(r)=='BrickColor'then e(
[[color (second arg), should be of type BrickColor, but is type]],h(r))end local
v,w,x,y,z=u.GetCell,u.WorldToCellPreferSolid,u.CellCenterToWorld,Enum.
CellMaterial.Empty,Instance.new'Model'z.Name='SelectionContainer'z.Archivable=
false if t then z.Parent=t else z.Parent=game.Workspace end local A,B,C,D,E,F,G=
nil,nil,0,nil,{},{},Instance.new'Part'G.Name='SelectionPart'G.Transparency=1 G.
Anchored=true G.Locked=true G.CanCollide=false G.Size=Vector3.new(4.2,4.2,4.2)
local H=Instance.new'SelectionBox'function createAdornment(I)local J,K=nil,nil
if#F>0 then J=F[1]['part']K=F[1]['box']d.remove(F,1)K.Visible=true else J=G:
Clone()J.Archivable=false K=H:Clone()K.Archivable=false K.Adornee=J K.Parent=z K
.Adornee=J K.Parent=z end if I then K.Color=I end return J,K end function
cleanUpAdornments()for I,J in j(E)do if J.KeepAlive~=B then J.SelectionBox.
Visible=false d.insert(F,{part=J.SelectionPart,box=J.SelectionBox})E[I]=nil end
end end function incrementAliveCounter()C=C+1 if C>1000000 then C=0 end return C
end function adornFullCellsInRegion(I,J)local K,L=I.CFrame.p-(I.Size/2)+Vector3.
new(2,2,2),I.CFrame.p+(I.Size/2)-Vector3.new(2,2,2)local M,N=w(u,K),w(u,L)B=
incrementAliveCounter()for O=M.y,N.y do for P=M.z,N.z do for Q=M.x,N.x do local
R=v(u,Q,O,P)if R~=y then local S,T,U=x(u,Q,O,P),Vector3int16.new(Q,O,P),false
for V,W in j(E)do if V==T then W.KeepAlive=B if J then W.SelectionBox.Color=J
end U=true break end end if not U then local X,Y=createAdornment(J)X.Size=
Vector3.new(4,4,4)X.CFrame=CFrame.new(S)local Z={SelectionPart=X,SelectionBox=Y,
KeepAlive=B}E[T]=Z end end end end end cleanUpAdornments()end D=q if s then
local I,J=createAdornment(r)I.Size=q.Size I.CFrame=q.CFrame E.SelectionPart=I E.
SelectionBox=J A=function(K,L)if K and K~=D then D=K I.Size=K.Size I.CFrame=K.
CFrame end if L then J.Color=L end end else adornFullCellsInRegion(q,r)A=
function(I,J)if I and I~=D then D=I adornFullCellsInRegion(I,J)end end end local
I=function()A=nil if z then z:Destroy()end E=nil end return A,I end function a.
CreateSignal()local q,r,s={},Instance.new'BindableEvent',{}function q:connect(t)
if self~=q then e('connect must be called with `:`, not `.`',2)end if h(t)~=
'function'then e('Argument #1 of connect must be a function, got a '..h(t),2)end
local u=r.Event:connect(t)s[u]=true local v={}function v:disconnect()u:
disconnect()s[u]=nil end v.Disconnect=v.disconnect return v end function q:
disconnect()if self~=q then e('disconnect must be called with `:`, not `.`',2)
end for t,u in j(s)do t:disconnect()s[t]=nil end end function q:wait()if self~=q
then e('wait must be called with `:`, not `.`',2)end return r.Event:wait()end
function q:fire(...)if self~=q then e('fire must be called with `:`, not `.`',2)
end r:Fire(...)end q.Connect=q.connect q.Disconnect=q.disconnect q.Wait=q.wait q
.Fire=q.fire return q end local function Create_PrivImpl(q)if h(q)~='string'then
e('Argument of Create must be a string',2)end return function(r)r=r or{}local s,
t,u=Instance.new(q),nil,nil for v,w in j(r)do if h(v)=='string'then if v==
'Parent'then t=w else s[v]=w end elseif h(v)=='number'then if h(w)~='userdata'
then e(
[[Bad entry in Create body: Numeric keys must be paired with children, got a: ]]
..h(w),2)end w.Parent=s elseif h(v)=='table'and v.__eventname then if h(w)~=
'function'then e("Bad entry in Create body: Key `[Create.E'"..v.__eventname..
"']` must have a function value, got: "..g(w),2)end s[v.__eventname]:connect(w)
elseif v==a.Create then if h(w)~='function'then e(
[[Bad entry in Create body: Key `[Create]` should be paired with a constructor function, got: ]]
..g(w),2)elseif u then e(
[[Bad entry in Create body: Only one constructor function is allowed]],2)end u=w
else e('Bad entry ('..g(v)..' => '..g(w)..') in Create body',2)end end if u then
u(s)end if t then s.Parent=t end return s end end a.Create=i({},{__call=function
(q,...)return Create_PrivImpl(...)end})a.Create.E=function(q)return{__eventname=
q}end a.Help=function(q)if q=='DecodeJSON'or q==a.DecodeJSON then return
[[Function DecodeJSON.  Arguments: (string).  Side effect: returns a table with all parsed JSON values]]
end if q=='EncodeJSON'or q==a.EncodeJSON then return
[[Function EncodeJSON.  Arguments: (table).  Side effect: returns a string composed of argument table in JSON data format]]
end if q=='MakeWedge'or q==a.MakeWedge then return
[[Function MakeWedge. Arguments: (x, y, z, [default material]). Description: Makes a wedge at location x, y, z. Sets cell x, y, z to default material if parameter is provided, if not sets cell x, y, z to be whatever material it previously was. Returns true if made a wedge, false if the cell remains a block ]]
end if q=='SelectTerrainRegion'or q==a.SelectTerrainRegion then return
[[Function SelectTerrainRegion. Arguments: (regionToSelect, color, selectEmptyCells, selectionParent). Description: Selects all terrain via a series of selection boxes within the regionToSelect (this should be a region3 value). The selection box color is detemined by the color argument (should be a brickcolor value). SelectionParent is the parent that the selection model gets placed to (optional).SelectEmptyCells is bool, when true will select all cells in the region, otherwise we only select non-empty cells. Returns a function that can update the selection,arguments to said function are a new region3 to select, and the adornment color (color arg is optional). Also returns a second function that takes no arguments and destroys the selection]]
end if q=='CreateSignal'or q==a.CreateSignal then return
[[Function CreateSignal. Arguments: None. Returns: The newly created Signal object. This object is identical to the RBXScriptSignal class used for events in Objects, but is a Lua-side object so it can be used to create custom events inLua code. Methods of the Signal object: :connect, :wait, :fire, :disconnect. For more info you can pass the method name to the Help function, or view the wiki page for this library. EG: Help('Signal:connect').]]
end if q=='Signal:connect'then return
[[Method Signal:connect. Arguments: (function handler). Return: A connection object which can be used to disconnect the connection to this handler. Description: Connectes a handler function to this Signal, so that when |fire| is called the handler function will be called with the arguments passed to |fire|.]]
end if q=='Signal:wait'then return
[[Method Signal:wait. Arguments: None. Returns: The arguments passed to the next call to |fire|. Description: This call does not return until the next call to |fire| is made, at which point it will return the values which were passed as arguments to that |fire| call.]]
end if q=='Signal:fire'then return
[[Method Signal:fire. Arguments: Any number of arguments of any type. Returns: None. Description: This call will invoke any connected handler functions, and notify any waiting code attached to this Signal to continue, with the arguments passed to this function. Note: The calls to handlers are made asynchronously, so this call will return immediately regardless of how long it takes the connected handler functions to complete.]]
end if q=='Signal:disconnect'then return
[[Method Signal:disconnect. Arguments: None. Returns: None. Description: This call disconnects all handlers attacched to this function, note however, it does NOT make waiting code continue, as is the behavior of normal Roblox events. This method can also be called on the connection object which is returned from Signal:connect to only disconnect a single handler, as opposed to this method, which will disconnect all handlers.]]
end if q=='Create'then return
[[Function Create. Arguments: A table containing information about how to construct a collection of objects. Returns: The constructed objects. Descrition: Create is a very powerfull function, whose description is too long to fit here, and is best described via example, please see the wiki page for a description of how to use it.]]
end end return a