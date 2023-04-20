local t = { }
local New
New = function(className, name, props)
	if not (props ~= nil) then
		props = name
		name = nil
	end
	local obj = Instance.new(className)
	if name then
		obj.Name = name
	end
	local parent
	for k, v in pairs(props) do
		if type(k) == "string" then
			if k == "Parent" then
				parent = v
			else
				obj[k] = v
			end
		elseif type(k) == "number" and type(v) == "userdata" then
			v.Parent = obj
		end
	end
	obj.Parent = parent
	return obj
end
local assert = assert
local Null
Null = function()
	return Null
end
local StringBuilder = {
	buffer = { }
}
StringBuilder.New = function(self)
	local o = setmetatable({ }, self)
	self.__index = self
	o.buffer = { }
	return o
end
StringBuilder.Append = function(self, s)
	do
		local _obj_0 = self.buffer
		_obj_0[#_obj_0 + 1] = s
	end
end
StringBuilder.ToString = function(self)
	return table.concat(self.buffer)
end
local JsonWriter = {
	backslashes = {
		["\b"] = "\\b",
		["\t"] = "\\t",
		["\n"] = "\\n",
		["\f"] = "\\f",
		["\r"] = "\\r",
		['"'] = '\\"',
		["\\"] = "\\\\",
		["/"] = "\\/"
	}
}
JsonWriter.New = function(self)
	local o = setmetatable({ }, self)
	o.writer = StringBuilder:New()
	self.__index = self
	return o
end
JsonWriter.Append = function(self, s)
	return self.writer:Append(s)
end
JsonWriter.ToString = function(self)
	return self.writer:ToString()
end
JsonWriter.Write = function(self, o)
	local _exp_0 = type(o)
	if "nil" == _exp_0 then
		return self:WriteNil()
	elseif "boolean" == _exp_0 or "number" == _exp_0 then
		return self:WriteString(o)
	elseif "string" == _exp_0 then
		return self:ParseString(o)
	elseif "table" == _exp_0 then
		return self:WriteTable(o)
	elseif "function" == _exp_0 then
		return self:WriteFunction(o)
	elseif "thread" == _exp_0 or "userdata" == _exp_0 then
		return self:WriteError(o)
	end
end
JsonWriter.WriteNil = function(self)
	return self:Append("null")
end
JsonWriter.WriteString = function(self, o)
	return self:Append(tostring(o))
end
JsonWriter.ParseString = function(self, s)
	self:Append('"')
	self:Append(string.gsub(s, '[%z%c\\"/]', function(n)
		local c = self.backslashes[n]
		if c then
			return c
		end
		return string.format("\\u%.4X", string.byte(n))
	end))
	return self:Append('"')
end
JsonWriter.IsArray = function(self, t)
	local count = 0
	local isindex
	isindex = function(k)
		if type(k) == "number" and k > 0 and math.floor(k) == k then
			return true
		end
		return false
	end
	for k, _ in pairs(t) do
		if not isindex(k) then
			return false, "{", "}"
		else
			count = math.max(count, k)
		end
	end
	return true, "[", "]", count
end
JsonWriter.WriteTable = function(self, t)
	local ba, st, et, n = self:IsArray(t)
	self:Append(st)
	if ba then
		for i = 1, n do
			self:Write(t[i])
			if i < n then
				self:Append(",")
			end
		end
	else
		local first = true
		for k, v in pairs(t) do
			if not first then
				self:Append(",")
			end
			first = false
			self:ParseString(k)
			self:Append(":")
			self:Write(v)
		end
	end
	return self:Append(et)
end
JsonWriter.WriteError = function(self, o)
	return error(string.format("Encoding of %s unsupported", tostring(o)))
end
JsonWriter.WriteFunction = function(self, o)
	if o == Null then
		return self:WriteNil()
	else
		return self:WriteError(o)
	end
end
local StringReader = {
	s = "",
	i = 0
}
StringReader.New = function(self, s)
	local o = setmetatable({ }, self)
	self.__index = self
	o.s = s or o.s
	return o
end
StringReader.Peek = function(self)
	local i = self.i + 1
	if i <= #self.s then
		return string.sub(self.s, i, i)
	end
	return nil
end
StringReader.Next = function(self)
	self.i = self.i + 1
	if self.i <= #self.s then
		return string.sub(self.s, self.i, self.i)
	end
	return nil
end
StringReader.All = function(self)
	return self.s
end
local JsonReader = {
	escapes = {
		["t"] = "\t",
		["n"] = "\n",
		["f"] = "\f",
		["r"] = "\r",
		["b"] = "\b"
	}
}
JsonReader.New = function(self, s)
	local o = setmetatable({ }, self)
	o.reader = StringReader:New(s)
	self.__index = self
	return o
end
JsonReader.Read = function(self)
	self:SkipWhiteSpace()
	local peek = self:Peek()
	if not (peek ~= nil) then
		return error(string.format("Nil string: '%s'", self:All()))
	elseif peek == "{" then
		return self:ReadObject()
	elseif peek == "[" then
		return self:ReadArray()
	elseif peek == '"' then
		return self:ReadString()
	elseif string.find(peek, "[%+%-%d]") then
		return self:ReadNumber()
	elseif peek == "t" then
		return self:ReadTrue()
	elseif peek == "f" then
		return self:ReadFalse()
	elseif peek == "n" then
		return self:ReadNull()
	elseif peek == "/" then
		self:ReadComment()
		return self:Read()
	else
		return nil
	end
end
JsonReader.ReadTrue = function(self)
	self:TestReservedWord({
		't',
		'r',
		'u',
		'e'
	})
	return true
end
JsonReader.ReadFalse = function(self)
	self:TestReservedWord({
		'f',
		'a',
		'l',
		's',
		'e'
	})
	return false
end
JsonReader.ReadNull = function(self)
	self:TestReservedWord({
		'n',
		'u',
		'l',
		'l'
	})
	return nil
end
JsonReader.TestReservedWord = function(self, t)
	for _, v in ipairs(t) do
		if self:Next() ~= v then
			error(string.format("Error reading '%s': %s", table.concat(t), self:All()))
		end
	end
end
JsonReader.ReadNumber = function(self)
	local result = self:Next()
	local peek = self:Peek()
	while (peek ~= nil) and string.find(peek, "[%+%-%d%.eE]") do
		result = result .. self:Next()
		peek = self:Peek()
	end
	result = tonumber(result)
	if not (result ~= nil) then
		return error(string.format("Invalid number: '%s'", result))
	else
		return result
	end
end
JsonReader.ReadString = function(self)
	local result = ""
	assert(self:Next() == '"')
	while self:Peek() ~= '"' do
		local ch = self:Next()
		if ch == "\\" then
			ch = self:Next()
			if self.escapes[ch] then
				ch = self.escapes[ch]
			end
		end
		result = result .. ch
	end
	assert(self:Next() == '"')
	local fromunicode
	fromunicode = function(m)
		return string.char(tonumber(m, 16))
	end
	return string.gsub(result, "u%x%x(%x%x)", fromunicode)
end
JsonReader.ReadComment = function(self)
	assert(self:Next() == "/")
	local second = self:Next()
	if second == "/" then
		return self:ReadSingleLineComment()
	elseif second == "*" then
		return self:ReadBlockComment()
	else
		return error(string.format("Invalid comment: %s", self:All()))
	end
end
JsonReader.ReadBlockComment = function(self)
	local done = false
	while not done do
		local ch = self:Next()
		if ch == "*" and self:Peek() == "/" then
			done = true
		end
		if not done and ch == "/" and self:Peek() == "*" then
			error(string.format("Invalid comment: %s, '/*' illegal.", self:All()))
		end
	end
	return self:Next()
end
JsonReader.ReadSingleLineComment = function(self)
	local ch = self:Next()
	while ch ~= "\r" and ch ~= "\n" do
		ch = self:Next()
	end
end
JsonReader.ReadArray = function(self)
	local result = { }
	assert(self:Next() == "[")
	local done = false
	if self:Peek() == "]" then
		done = true
	end
	while not done do
		local item = self:Read()
		result[#result + 1] = item
		self:SkipWhiteSpace()
		if self:Peek() == "]" then
			done = true
		end
		if not done then
			local ch = self:Next()
			if ch ~= "," then
				error(string.format("Invalid array: '%s' due to: '%s'", self:All(), ch))
			end
		end
	end
	assert("]" == self:Next())
	return result
end
JsonReader.ReadObject = function(self)
	local result = { }
	assert(self:Next() == "{")
	local done = false
	if self:Peek() == "}" then
		done = true
	end
	while not done do
		local key = self:Read()
		if type(key) ~= "string" then
			error(string.format("Invalid non-string object key: %s", key))
		end
		self:SkipWhiteSpace()
		local ch = self:Next()
		if ch ~= ":" then
			error(string.format("Invalid object: '%s' due to: '%s'", self:All(), ch))
		end
		self:SkipWhiteSpace()
		local val = self:Read()
		result[key] = val
		self:SkipWhiteSpace()
		if self:Peek() == "}" then
			done = true
		end
		if not done then
			ch = self:Next()
			if ch ~= "," then
				error(string.format("Invalid array: '%s' near: '%s'", self:All(), ch))
			end
		end
	end
	assert(self:Next() == "}")
	return result
end
JsonReader.SkipWhiteSpace = function(self)
	local p = self:Peek()
	while (p ~= nil) and string.find(p, "[%s/]") do
		if p == "/" then
			self:ReadComment()
		else
			self:Next()
		end
		p = self:Peek()
	end
end
JsonReader.Peek = function(self)
	return self.reader:Peek()
end
JsonReader.Next = function(self)
	return self.reader:Next()
end
JsonReader.All = function(self)
	return self.reader:All()
end
local Encode
Encode = function(o)
	local _with_0 = JsonWriter:New()
	_with_0:Write(o)
	_with_0:ToString()
	return _with_0
end
local Decode
Decode = function(s)
	local _with_0 = JsonReader:New(s)
	_with_0:Read()
	return _with_0
end
t.DecodeJSON = function(jsonString)
pcall(function()
		return warn('RbxUtility.DecodeJSON is deprecated, please use Game:GetService("HttpService"):JSONDecode() instead.')
	end)
	if type(jsonString) == "string" then
		return Decode(jsonString)
	end
	print("RbxUtil.DecodeJSON expects string argument!")
	return nil
end
t.EncodeJSON = function(jsonTable)
pcall(function()
		return warn('RbxUtility.EncodeJSON is deprecated, please use Game:GetService("HttpService"):JSONEncode() instead.')
	end)
	return Encode(jsonTable)
end
t.MakeWedge = function(x, y, z, _)
	return game:GetService("Terrain"):AutoWedgeCell(x, y, z)
end
t.SelectTerrainRegion = function(regionToSelect, color, selectEmptyCells, selectionParent)
	local terrain = game.Workspace:FindFirstChild("Terrain")
	if not terrain then
		return
	end
	assert(regionToSelect)
	assert(color)
	if not type(regionToSelect) == "Region3" then
		error("regionToSelect (first arg), should be of type Region3, but is type", type(regionToSelect))
	end
	if not type(color) == "BrickColor" then
		error("color (second arg), should be of type BrickColor, but is type", type(color))
	end
	local GetCell = terrain.GetCell
	local WorldToCellPreferSolid = terrain.WorldToCellPreferSolid
	local CellCenterToWorld = terrain.CellCenterToWorld
	local emptyMaterial = Enum.CellMaterial.Empty
	local selectionContainer = New("Model", "SelectionContainer", {
		Archivable = false,
		Parent = (function()
			if selectionParent then
				return selectionParent
			else
				return game.Workspace
			end
		end)()
	})
	local updateSelection
	local currentKeepAliveTag
	local aliveCounter = 0
	local lastRegion
	local adornments = { }
	local reusableAdorns = { }
	local selectionPart = New("Part", "SelectionPart", {
		Transparency = 1,
		Anchored = true,
		Locked = true,
		CanCollide = false,
		Size = Vector3.new(4.2, 4.2, 4.2)
	})
	local selectionBox = Instance.new("SelectionBox")
	local createAdornment
	createAdornment = function(theColor)
		local selectionPartClone
		local selectionBoxClone
		if #reusableAdorns > 0 then
			selectionPartClone = reusableAdorns[1]["part"]
			selectionBoxClone = reusableAdorns[1]["box"]
			table.remove(reusableAdorns, 1)
			selectionBoxClone.Visible = true
		else
			selectionPartClone = selectionPart:Clone()
			selectionPartClone.Archivable = false
			selectionBoxClone = selectionBox:Clone()
			selectionBoxClone.Archivable = false
			selectionBoxClone.Adornee = selectionPartClone
			selectionBoxClone.Parent = selectionContainer
			selectionBoxClone.Adornee = selectionPartClone
			selectionBoxClone.Parent = selectionContainer
		end
		if theColor then
			selectionBoxClone.Color = theColor
		end
		return selectionPartClone, selectionBoxClone
	end
	local cleanUpAdornments
	cleanUpAdornments = function()
		for cellPos, adornTable in pairs(adornments) do
			if adornTable.KeepAlive ~= currentKeepAliveTag then
				adornTable.SelectionBox.Visible = false
				table.insert(reusableAdorns, {
					part = adornTable.SelectionPart,
					box = adornTable.SelectionBox
				})
				adornments[cellPos] = nil
			end
		end
	end
	local incrementAliveCounter
	incrementAliveCounter = function()
		aliveCounter = aliveCounter + 1
		if aliveCounter > 1000000 then
			aliveCounter = 0
		end
		return aliveCounter
	end
	local adornFullCellsInRegion
	adornFullCellsInRegion = function(region, color)
		local regionBegin = region.CFrame.p - region.Size / 2 + Vector3.new(2, 2, 2)
		local regionEnd = region.CFrame.p + region.Size / 2 - Vector3.new(2, 2, 2)
		local cellPosBegin = WorldToCellPreferSolid(terrain, regionBegin)
		local cellPosEnd = WorldToCellPreferSolid(terrain, regionEnd)
		currentKeepAliveTag = incrementAliveCounter()
		for y = cellPosBegin.y, cellPosEnd.y do
			for z = cellPosBegin.z, cellPosEnd.z do
				for x = cellPosBegin.x, cellPosEnd.x do
					local cellMaterial = GetCell(terrain, x, y, z)
					if cellMaterial ~= emptyMaterial then
						local cframePos = CellCenterToWorld(terrain, x, y, z)
						local cellPos = Vector3int16.new(x, y, z)
						local updated = false
						for cellPosAdorn, adornTable in pairs(adornments) do
							if cellPosAdorn == cellPos then
								adornTable.KeepAlive = currentKeepAliveTag
								if color then
									adornTable.SelectionBox.Color = color
								end
								updated = true
								break
							end
						end
						if not updated then
							local selectionPart, selectionBox
							selectionPart, selectionBox = createAdornment(color)
							selectionPart.Size = Vector3.new(4, 4, 4)
							selectionPart.CFrame = CFrame.new(cframePos)
							local adornTable = {
								SelectionPart = selectionPart,
								SelectionBox = selectionBox,
								KeepAlive = currentKeepAliveTag
							}
							adornments[cellPos] = adornTable
						end
					end
				end
			end
		end
		return cleanUpAdornments()
	end
	lastRegion = regionToSelect
	if selectEmptyCells then
		local selectionPart, selectionBox
		selectionPart, selectionBox = createAdornment(color)
		selectionPart.Size = regionToSelect.Size
		selectionPart.CFrame = regionToSelect.CFrame
		adornments.SelectionPart = selectionPart
		adornments.SelectionBox = selectionBox
		updateSelection = function(newRegion, color)
			if newRegion and newRegion ~= lastRegion then
				lastRegion = newRegion
				selectionPart.Size = newRegion.Size
				selectionPart.CFrame = newRegion.CFrame
			end
			if color then
				selectionBox.Color = color
			end
		end
	else
		adornFullCellsInRegion(regionToSelect, color)
		updateSelection = function(newRegion, color)
			if newRegion and newRegion ~= lastRegion then
				lastRegion = newRegion
				return adornFullCellsInRegion(newRegion, color)
			end
		end
	end
	local destroyFunc
	destroyFunc = function()
		updateSelection = nil
		if selectionContainer ~= nil then
			selectionContainer:Destroy()
		end
		adornments = nil
	end
	return updateSelection, destroyFunc
end
t.CreateSignal = function()
	local this = { }
	local mBindableEvent = Instance.new("BindableEvent")
	local mAllCns = { }
	this.connect = function(self, func)
		if self ~= this then
			error("connect must be called with `:`, not `.`", 2)
		end
		if type(func) ~= "function" then
			error("Argument #1 of connect must be a function, got a " .. tostring(type(func)), 2)
		end
		local cn = mBindableEvent.Event:connect(func)
		mAllCns[cn] = true
		local pubCn = { }
		pubCn.disconnect = function(self)
			cn:disconnect()
			mAllCns[cn] = nil
		end
		pubCn.Disconnect = pubCn.disconnect
		return pubCn
	end
	this.disconnect = function(self)
		if self ~= this then
			error("disconnect must be called with `:`, not `.`", 2)
		end
		for cn, _ in pairs(mAllCns) do
			cn:disconnect()
			mAllCns[cn] = nil
		end
	end
	this.wait = function(self)
		if self ~= this then
			error("wait must be called with `:`, not `.`", 2)
		end
		return mBindableEvent.Event:wait()
	end
	this.fire = function(self, ...)
		if self ~= this then
			error("fire must be called with `:`, not `.`", 2)
		end
		return mBindableEvent:Fire(...)
	end
	this.Connect = this.connect
	this.Disconnect = this.disconnect
	this.Wait = this.wait
	this.Fire = this.fire
	return this
end
local Create_PrivImpl
Create_PrivImpl = function(objectType)
	if type(objectType) ~= "string" then
		error("Argument of Create must be a string", 2)
	end
	return function(dat)
		dat = dat or { }
		local obj = Instance.new(objectType)
		local parent
		local ctor
		for k, v in pairs(dat) do
			if type(k) == "string" then
				if k == "Parent" then
					parent = v
				else
					obj[k] = v
				end
			elseif type(k) == "number" then
				if type(v) ~= "userdata" then
					error("Bad entry in Create body: Numeric keys must be paired with children, got a: " .. tostring(type(v)), 2)
				end
				v.Parent = obj
			elseif type(k) == "table" and k.__eventname then
				if type(v) ~= "function" then
					error("Bad entry in Create body: Key `[Create.E'" .. tostring(k.__eventname) .. "']` must have a function value, got: " .. tostring(v), 2)
				end
				obj[k.__eventname]:connect(v)
			elseif k == t.Create then
				if type(v) ~= "function" then
					error("Bad entry in Create body: Key `[Create]` should be paired with a constructor function, got: " .. tostring(v), 2)
				elseif ctor then
					error("Bad entry in Create body: Only one constructor function is allowed", 2)
				end
				ctor = v
			else
				error("Bad entry (" .. tostring(k) .. " => " .. tostring(v) .. ") in Create body", 2)
			end
		end
		if ctor ~= nil then
			ctor(obj)
		end
		if parent then
			obj.Parent = parent
		end
		return obj
	end
end
t.Create = setmetatable({ }, {
	["__call"] = function(_, ...)
		return Create_PrivImpl(...)
	end
})
t.Create.E = function(eventName)
	return {
		__eventname = eventName
	}
end
t.Help = function(funcNameOrFunc)
	if "DecodeJSON" == funcNameOrFunc or t.DecodeJSON == funcNameOrFunc then
		return "Function DecodeJSON.  " .. "Arguments: (string).  " .. "Side effect: returns a table with all parsed JSON values"
	elseif "EncodeJSON" == funcNameOrFunc or t.EncodeJSON == funcNameOrFunc then
		return "Function EncodeJSON.  " .. "Arguments: (table).  " .. "Side effect: returns a string composed of argument table in JSON data format"
	elseif "MakeWedge" == funcNameOrFunc or t.MakeWedge == funcNameOrFunc then
		return "Function MakeWedge. " .. "Arguments: (x, y, z, [default material]). " .. "Description: Makes a wedge at location x, y, z. Sets cell x, y, z to default material if " .. "parameter is provided, if not sets cell x, y, z to be whatever material it previously was. " .. "Returns true if made a wedge, false if the cell remains a block "
	elseif "SelectTerrainRegion" == funcNameOrFunc or t.SelectTerrainRegion == funcNameOrFunc then
		return "Function SelectTerrainRegion. " .. "Arguments: (regionToSelect, color, selectEmptyCells, selectionParent). " .. "Description: Selects all terrain via a series of selection boxes within the regionToSelect " .. "(this should be a region3 value). The selection box color is detemined by the color argument " .. "(should be a brickcolor value). SelectionParent is the parent that the selection model gets placed to (optional)." .. "SelectEmptyCells is bool, when true will select all cells in the " .. "region, otherwise we only select non-empty cells. Returns a function that can update the selection," .. "arguments to said function are a new region3 to select, and the adornment color (color arg is optional). " .. "Also returns a second function that takes no arguments and destroys the selection"
	elseif "CreateSignal" == funcNameOrFunc or t.CreateSignal == funcNameOrFunc then
		return "Function CreateSignal. " .. "Arguments: None. " .. "Returns: The newly created Signal object. This object is identical to the RBXScriptSignal class " .. "used for events in Objects, but is a Lua-side object so it can be used to create custom events in" .. "Lua code. " .. "Methods of the Signal object: :connect, :wait, :fire, :disconnect. " .. "For more info you can pass the method name to the Help function, or view the wiki page " .. "for this library. EG: Help('Signal:connect')."
	elseif "Signal:connect" == funcNameOrFunc then
		return "Method Signal:connect. " .. "Arguments: (function handler). " .. "Return: A connection object which can be used to disconnect the connection to this handler. " .. "Description: Connectes a handler function to this Signal, so that when |fire| is called the " .. "handler function will be called with the arguments passed to |fire|."
	elseif "Signal:wait" == funcNameOrFunc then
		return "Method Signal:wait. " .. "Arguments: None. " .. "Returns: The arguments passed to the next call to |fire|. " .. "Description: This call does not return until the next call to |fire| is made, at which point it " .. "will return the values which were passed as arguments to that |fire| call."
	elseif "Signal:fire" == funcNameOrFunc then
		return "Method Signal:fire. " .. "Arguments: Any number of arguments of any type. " .. "Returns: None. " .. "Description: This call will invoke any connected handler functions, and notify any waiting code " .. "attached to this Signal to continue, with the arguments passed to this function. Note: The calls " .. "to handlers are made asynchronously, so this call will return immediately regardless of how long " .. "it takes the connected handler functions to complete."
	elseif "Signal:disconnect" == funcNameOrFunc then
		return "Method Signal:disconnect. " .. "Arguments: None. " .. "Returns: None. " .. "Description: This call disconnects all handlers attacched to this function, note however, it " .. "does NOT make waiting code continue, as is the behavior of normal Roblox events. This method " .. "can also be called on the connection object which is returned from Signal:connect to only " .. "disconnect a single handler, as opposed to this method, which will disconnect all handlers."
	elseif "Create" == funcNameOrFunc then
		return "Function Create. " .. "Arguments: A table containing information about how to construct a collection of objects. " .. "Returns: The constructed objects. " .. "Descrition: Create is a very powerfull function, whose description is too long to fit here, and " .. "is best described via example, please see the wiki page for a description of how to use it."
	end
end
return t
