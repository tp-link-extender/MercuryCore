print("[Mercury]: Loaded corescript 60595695")
local deepakTestingPlace = 3569749
local sc = game:GetService("ScriptContext")
local tries = 0
while not (sc or tries > 2) do
	tries = tries + 1
	sc = game:GetService("ScriptContext")
	wait(0.2)
end
if sc then
	sc:RegisterLibrary("Libraries/RbxGui", "45284430")
	sc:RegisterLibrary("Libraries/RbxGear", "45374389")
	if game.PlaceId == deepakTestingPlace then
		sc:RegisterLibrary("Libraries/RbxStatus", "52177566")
	end
	sc:RegisterLibrary("Libraries/RbxUtility", "60595411")
	sc:RegisterLibrary("Libraries/RbxStamper", "73157242")
	sc:LibraryRegistrationComplete()
else
	print("failed to find script context, libraries did not load")
end
return sc
