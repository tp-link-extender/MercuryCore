local t = { }
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
		"t",
		"r",
		"u",
		"e"
	})
	return true
end
JsonReader.ReadFalse = function(self)
	self:TestReservedWord({
		"f",
		"a",
		"l",
		"s",
		"e"
	})
	return false
end
JsonReader.ReadNull = function(self)
	self:TestReservedWord({
		"n",
		"u",
		"l",
		"l"
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
