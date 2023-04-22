local a,b,c=3569749,game:GetService'ScriptContext',0 while not b and c<3 do c=c+
1 b=game:GetService'ScriptContext'wait(0.2)end if b then b:RegisterLibrary(
'Libraries/RbxGui','45284430')b:RegisterLibrary('Libraries/RbxGear','45374389')
if game.PlaceId==a then b:RegisterLibrary('Libraries/RbxStatus','52177566')end b
:RegisterLibrary('Libraries/RbxUtility','60595411')b:RegisterLibrary(
'Libraries/RbxStamper','73157242')b:LibraryRegistrationComplete()else print
'failed to find script context, libraries did not load'end