-- Script Context./Libraries/LibraryRegistration/LibraryRegist
print "[Graphictoria]: Loaded corescript 60595695"

local RunService = game:GetService "RunService"

-- Library Registration Script
-- This script is used to register RbxLua libraries on game servers, so game scripts have
-- access to all of the libraries (otherwise only local scripts do)

local ScriptContext

for i = 1, 4 do
	ScriptContext = game:GetService "ScriptContext"
	if ScriptContext then
		break
	end
	RunService.Heartbeat:wait()
end

if ScriptContext then
	for name, id in pairs {
		Fusion = 10000001,
		Red = 10000002,
		Load = 10000003,
		Gui = 45284430,
		Utility = 60595411,
		Stamper = 73157242,
	} do
		ScriptContext:RegisterLibrary("Libraries/Rbx" .. name, tostring(id))
	end
	ScriptContext:LibraryRegistrationComplete()
else
	print "[Graphictoria]: Failed to find ScriptContext, libraries did not load"
end
