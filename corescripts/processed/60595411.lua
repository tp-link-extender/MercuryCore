local a,b,c,d,e,f,g,h,i,j,k,l,m,n={},string,math,table,error,tonumber,tostring,
type,setmetatable,pairs,ipairs,assert,Chipmunk,{buffer={}}function n:New()local
o={}i(o,self)self.__index=self o.buffer={}return o end function n:Append(o)self.
buffer[#self.buffer+1]=o end function n:ToString()return d.concat(self.buffer)
end local o={backslashes={['\b']='\\b',['\t']='\\t',['\n']='\\n',['\f']='\\f',[
'\r']='\\r',['"']='\\"',['\\']='\\\\',['/']='\\/'}}function o:New()local p={}p.
writer=n:New()i(p,self)self.__index=self return p end function o:Append(p)self.
writer:Append(p)end function o:ToString()return self.writer:ToString()end
function o:Write(p)local q=h(p)if q=='nil'then self:WriteNil()elseif q==
'boolean'then self:WriteString(p)elseif q=='number'then self:WriteString(p)
elseif q=='string'then self:ParseString(p)elseif q=='table'then self:WriteTable(
p)elseif q=='function'then self:WriteFunction(p)elseif q=='thread'then self:
WriteError(p)elseif q=='userdata'then self:WriteError(p)end end function o:
WriteNil()self:Append'null'end function o:WriteString(p)self:Append(g(p))end
function o:ParseString(p)self:Append'"'self:Append(b.gsub(p,'[%z%c\\"/]',
function(q)local r=self.backslashes[q]if r then return r end return b.format(
'\\u%.4X',b.byte(q))end))self:Append'"'end function o:IsArray(p)local q,r=0,
function(q)if h(q)=='number'and q>0 then if c.floor(q)==q then return true end
end return false end for s,t in j(p)do if not r(s)then return false,'{','}'else
q=c.max(q,s)end end return true,'[',']',q end function o:WriteTable(p)local q,r,
s,t=self:IsArray(p)self:Append(r)if q then for u=1,t do self:Write(p[u])if u<t
then self:Append','end end else local u=true for v,w in j(p)do if not u then
self:Append','end u=false self:ParseString(v)self:Append':'self:Write(w)end end
self:Append(s)end function o:WriteError(p)e(b.format(
'Encoding of %s unsupported',g(p)))end function o:WriteFunction(p)if p==Null
then self:WriteNil()else self:WriteError(p)end end local p={s='',i=0}function p:
New(q)local r={}i(r,self)self.__index=self r.s=q or r.s return r end function p:
Peek()local q=self.i+1 if q<=#self.s then return b.sub(self.s,q,q)end return nil
end function p:Next()self.i=self.i+1 if self.i<=#self.s then return b.sub(self.s
,self.i,self.i)end return nil end function p:All()return self.s end local q={
escapes={['t']='\t',['n']='\n',['f']='\f',['r']='\r',['b']='\b'}}function q:New(
r)local s={}s.reader=p:New(r)i(s,self)self.__index=self return s end function q:
Read()self:SkipWhiteSpace()local r=self:Peek()if r==nil then e(b.format(
"Nil string: '%s'",self:All()))elseif r=='{'then return self:ReadObject()elseif
r=='['then return self:ReadArray()elseif r=='"'then return self:ReadString()
elseif b.find(r,'[%+%-%d]')then return self:ReadNumber()elseif r=='t'then return
self:ReadTrue()elseif r=='f'then return self:ReadFalse()elseif r=='n'then return
self:ReadNull()elseif r=='/'then self:ReadComment()return self:Read()else return
nil end end function q:ReadTrue()self:TestReservedWord{'t','r','u','e'}return
true end function q:ReadFalse()self:TestReservedWord{'f','a','l','s','e'}return
false end function q:ReadNull()self:TestReservedWord{'n','u','l','l'}return nil
end function q:TestReservedWord(r)for s,t in k(r)do if self:Next()~=t then e(b.
format("Error reading '%s': %s",d.concat(r),self:All()))end end end function q:
ReadNumber()local r,s=self:Next(),self:Peek()while s~=nil and b.find(s,
'[%+%-%d%.eE]')do r=r..self:Next()s=self:Peek()end r=f(r)if r==nil then e(b.
format("Invalid number: '%s'",r))else return r end end function q:ReadString()
local r=''l(self:Next()=='"')while self:Peek()~='"'do local s=self:Next()if s==
'\\'then s=self:Next()if self.escapes[s]then s=self.escapes[s]end end r=r..s end
l(self:Next()=='"')local s=function(s)return b.char(f(s,16))end return b.gsub(r,
'u%x%x(%x%x)',s)end function q:ReadComment()l(self:Next()=='/')local r=self:
Next()if r=='/'then self:ReadSingleLineComment()elseif r=='*'then self:
ReadBlockComment()else e(b.format('Invalid comment: %s',self:All()))end end
function q:ReadBlockComment()local r=false while not r do local s=self:Next()if
s=='*'and self:Peek()=='/'then r=true end if not r and s=='/'and self:Peek()==
'*'then e(b.format("Invalid comment: %s, '/*' illegal.",self:All()))end end self
:Next()end function q:ReadSingleLineComment()local r=self:Next()while r~='\r'and
r~='\n'do r=self:Next()end end function q:ReadArray()local r={}l(self:Next()==
'[')local s=false if self:Peek()==']'then s=true end while not s do local t=self
:Read()r[#r+1]=t self:SkipWhiteSpace()if self:Peek()==']'then s=true end if not
s then local u=self:Next()if u~=','then e(b.format(
"Invalid array: '%s' due to: '%s'",self:All(),u))end end end l(']'==self:Next())
return r end function q:ReadObject()local r={}l(self:Next()=='{')local s=false
if self:Peek()=='}'then s=true end while not s do local t=self:Read()if h(t)~=
'string'then e(b.format('Invalid non-string object key: %s',t))end self:
SkipWhiteSpace()local u=self:Next()if u~=':'then e(b.format(
"Invalid object: '%s' due to: '%s'",self:All(),u))end self:SkipWhiteSpace()local
v=self:Read()r[t]=v self:SkipWhiteSpace()if self:Peek()=='}'then s=true end if
not s then u=self:Next()if u~=','then e(b.format(
"Invalid array: '%s' near: '%s'",self:All(),u))end end end l(self:Next()=='}')
return r end function q:SkipWhiteSpace()local r=self:Peek()while r~=nil and b.
find(r,'[%s/]')do if r=='/'then self:ReadComment()else self:Next()end r=self:
Peek()end end function q:Peek()return self.reader:Peek()end function q:Next()
return self.reader:Next()end function q:All()return self.reader:All()end
function Encode(r)local s=o:New()s:Write(r)return s:ToString()end function
Decode(r)local s=q:New(r)return s:Read()end function Null()return Null end a.
DecodeJSON=function(r)if h(r)=='string'then return Decode(r)end print
'RbxUtil.DecodeJSON expects string argument!'return nil end a.EncodeJSON=
function(r)return Encode(r)end a.MakeWedge=function(r,s,t,u)return game:
GetService'Terrain':AutoWedgeCell(r,s,t)end a.SelectTerrainRegion=function(r,s,t
,u)local v=game.Workspace:FindFirstChild'Terrain'if not v then return end l(r)l(
s)if not h(r)=='Region3'then e(
[[regionToSelect (first arg), should be of type Region3, but is type]],h(r))end
if not h(s)=='BrickColor'then e(
[[color (second arg), should be of type BrickColor, but is type]],h(s))end local
w,x,y,z,A=v.GetCell,v.WorldToCellPreferSolid,v.CellCenterToWorld,Enum.
CellMaterial.Empty,Instance.new'Model'A.Name='SelectionContainer'A.Archivable=
false if u then A.Parent=u else A.Parent=game.Workspace end local B,C,D,E,F,G,H=
nil,nil,0,nil,{},{},Instance.new'Part'H.Name='SelectionPart'H.Transparency=1 H.
Anchored=true H.Locked=true H.CanCollide=false H.FormFactor=Enum.FormFactor.
Custom H.Size=Vector3.new(4.2,4.2,4.2)local I=Instance.new'SelectionBox'function
createAdornment(J)local K,L=nil,nil if#G>0 then K=G[1]['part']L=G[1]['box']d.
remove(G,1)L.Visible=true else K=H:Clone()K.Archivable=false L=I:Clone()L.
Archivable=false L.Adornee=K L.Parent=A L.Adornee=K L.Parent=A end if J then L.
Color=J end return K,L end function cleanUpAdornments()for J,K in j(F)do if K.
KeepAlive~=C then K.SelectionBox.Visible=false d.insert(G,{part=K.SelectionPart,
box=K.SelectionBox})F[J]=nil end end end function incrementAliveCounter()D=D+1
if D>1000000 then D=0 end return D end function adornFullCellsInRegion(J,K)local
L,M=J.CFrame.p-(J.Size/2)+Vector3.new(2,2,2),J.CFrame.p+(J.Size/2)-Vector3.new(2
,2,2)local N,O=x(v,L),x(v,M)C=incrementAliveCounter()for P=N.y,O.y do for Q=N.z,
O.z do for R=N.x,O.x do local S=w(v,R,P,Q)if S~=z then local T,U,V=y(v,R,P,Q),
Vector3int16.new(R,P,Q),false for W,X in j(F)do if W==U then X.KeepAlive=C if K
then X.SelectionBox.Color=K end V=true break end end if not V then local Y,Z=
createAdornment(K)Y.Size=Vector3.new(4,4,4)Y.CFrame=CFrame.new(T)local _={
SelectionPart=Y,SelectionBox=Z,KeepAlive=C}F[U]=_ end end end end end
cleanUpAdornments()end E=r if t then local J,K=createAdornment(s)J.Size=r.Size J
.CFrame=r.CFrame F.SelectionPart=J F.SelectionBox=K B=function(L,M)if L and L~=E
then E=L J.Size=L.Size J.CFrame=L.CFrame end if M then K.Color=M end end else
adornFullCellsInRegion(r,s)B=function(J,K)if J and J~=E then E=J
adornFullCellsInRegion(J,K)end end end local J=function()B=nil if A then A:
Destroy()end F=nil end return B,J end function a.CreateSignal()local r,s,t={},
Instance.new'BindableEvent',{}function r:connect(u)if self~=r then e(
'connect must be called with `:`, not `.`',2)end if h(u)~='function'then e(
'Argument #1 of connect must be a function, got a '..h(u),2)end local v=s.Event:
connect(u)t[v]=true local w={}function w:disconnect()v:disconnect()t[v]=nil end
return w end function r:disconnect()if self~=r then e(
'disconnect must be called with `:`, not `.`',2)end for u,v in j(t)do u:
disconnect()t[u]=nil end end function r:wait()if self~=r then e(
'wait must be called with `:`, not `.`',2)end return s.Event:wait()end function
r:fire(...)if self~=r then e('fire must be called with `:`, not `.`',2)end s:
Fire(...)end return r end local function Create_PrivImpl(r)if h(r)~='string'then
e('Argument of Create must be a string',2)end return function(s)s=s or{}local t,
u=Instance.new(r),nil for v,w in j(s)do if h(v)=='string'then t[v]=w elseif h(v)
=='number'then if h(w)~='userdata'then e(
[[Bad entry in Create body: Numeric keys must be paired with children, got a: ]]
..h(w),2)end w.Parent=t elseif h(v)=='table'and v.__eventname then if h(w)~=
'function'then e("Bad entry in Create body: Key `[Create.E'"..v.__eventname..
"']` must have a function value, got: "..g(w),2)end t[v.__eventname]:connect(w)
elseif v==a.Create then if h(w)~='function'then e(
[[Bad entry in Create body: Key `[Create]` should be paired with a constructor function, got: ]]
..g(w),2)elseif u then e(
[[Bad entry in Create body: Only one constructor function is allowed]],2)end u=w
else e('Bad entry ('..g(v)..' => '..g(w)..') in Create body',2)end end if u then
u(t)end return t end end a.Create=i({},{__call=function(r,...)return
Create_PrivImpl(...)end})a.Create.E=function(r)return{__eventname=r}end a.Help=
function(r)if r=='DecodeJSON'or r==a.DecodeJSON then return
[[Function DecodeJSON.  Arguments: (string).  Side effect: returns a table with all parsed JSON values]]
end if r=='EncodeJSON'or r==a.EncodeJSON then return
[[Function EncodeJSON.  Arguments: (table).  Side effect: returns a string composed of argument table in JSON data format]]
end if r=='MakeWedge'or r==a.MakeWedge then return
[[Function MakeWedge. Arguments: (x, y, z, [default material]). Description: Makes a wedge at location x, y, z. Sets cell x, y, z to default material if parameter is provided, if not sets cell x, y, z to be whatever material it previously was. Returns true if made a wedge, false if the cell remains a block ]]
end if r=='SelectTerrainRegion'or r==a.SelectTerrainRegion then return
[[Function SelectTerrainRegion. Arguments: (regionToSelect, color, selectEmptyCells, selectionParent). Description: Selects all terrain via a series of selection boxes within the regionToSelect (this should be a region3 value). The selection box color is detemined by the color argument (should be a brickcolor value). SelectionParent is the parent that the selection model gets placed to (optional).SelectEmptyCells is bool, when true will select all cells in the region, otherwise we only select non-empty cells. Returns a function that can update the selection,arguments to said function are a new region3 to select, and the adornment color (color arg is optional). Also returns a second function that takes no arguments and destroys the selection]]
end if r=='CreateSignal'or r==a.CreateSignal then return
[[Function CreateSignal. Arguments: None. Returns: The newly created Signal object. This object is identical to the RBXScriptSignal class used for events in Objects, but is a Lua-side object so it can be used to create custom events inLua code. Methods of the Signal object: :connect, :wait, :fire, :disconnect. For more info you can pass the method name to the Help function, or view the wiki page for this library. EG: Help('Signal:connect').]]
end if r=='Signal:connect'then return
[[Method Signal:connect. Arguments: (function handler). Return: A connection object which can be used to disconnect the connection to this handler. Description: Connectes a handler function to this Signal, so that when |fire| is called the handler function will be called with the arguments passed to |fire|.]]
end if r=='Signal:wait'then return
[[Method Signal:wait. Arguments: None. Returns: The arguments passed to the next call to |fire|. Description: This call does not return until the next call to |fire| is made, at which point it will return the values which were passed as arguments to that |fire| call.]]
end if r=='Signal:fire'then return
[[Method Signal:fire. Arguments: Any number of arguments of any type. Returns: None. Description: This call will invoke any connected handler functions, and notify any waiting code attached to this Signal to continue, with the arguments passed to this function. Note: The calls to handlers are made asynchronously, so this call will return immediately regardless of how long it takes the connected handler functions to complete.]]
end if r=='Signal:disconnect'then return
[[Method Signal:disconnect. Arguments: None. Returns: None. Description: This call disconnects all handlers attacched to this function, note however, it does NOT make waiting code continue, as is the behavior of normal Roblox events. This method can also be called on the connection object which is returned from Signal:connect to only disconnect a single handler, as opposed to this method, which will disconnect all handlers.]]
end if r=='Create'then return
[[Function Create. Arguments: A table containing information about how to construct a collection of objects. Returns: The constructed objects. Descrition: Create is a very powerfull function, whose description is too long to fit here, and is best described via example, please see the wiki page for a description of how to use it.]]
end end return a