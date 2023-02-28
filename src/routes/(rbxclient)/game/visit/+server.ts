import type { RequestHandler } from './$types';
import { SignData } from '$lib/server/sign';
export const GET: RequestHandler = async () => {
    return new Response(
        SignData(
            `-- Prepended to Edit.lua and Visit.lua and Studio.lua and PlaySolo.lua--

            if true then
                pcall(function() game:SetPlaceID(${0}) end)
            else
                if 0>0 then
                    pcall(function() game:SetPlaceID(${0}) end)
                end
            end
            
            visit = game:GetService("Visit")
            
            local message = Instance.new("Message")
            message.Parent = workspace
            message.archivable = false
            
            game:GetService("ScriptInformationProvider"):SetAssetUrl("http://${"banland.xyz"}/Asset/")
            game:GetService("ContentProvider"):SetThreadPool(16)
            pcall(function() game:GetService("InsertService"):SetFreeModelUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?type=fm&q=%s&pg=%d&rs=%d") end) -- Used for free model search (insert tool)
            pcall(function() game:GetService("InsertService"):SetFreeDecalUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?type=fd&q=%s&pg=%d&rs=%d") end) -- Used for free decal search (insert tool)
            
            settings().Diagnostics:LegacyScriptMode()
            
            game:GetService("InsertService"):SetBaseSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
            game:GetService("InsertService"):SetUserSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
            game:GetService("InsertService"):SetCollectionUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?sid=%d")
            game:GetService("InsertService"):SetAssetUrl("http://${"banland.xyz"}/Asset/?id=%d")
            game:GetService("InsertService"):SetAssetVersionUrl("http://www.roblox.com/Asset/?assetversionid=%d")
            
            pcall(function() game:GetService("SocialService"):SetFriendUrl("http://${"banland.xyz"}/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d") end)
            pcall(function() game:GetService("SocialService"):SetBestFriendUrl("http://${"banland.xyz"}/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d") end)
            pcall(function() game:GetService("SocialService"):SetGroupUrl("http://${"banland.xyz"}/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d") end)
            pcall(function() game:GetService("SocialService"):SetGroupRankUrl("http://${"banland.xyz"}/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d") end)
            pcall(function() game:GetService("SocialService"):SetGroupRoleUrl("http://${"banland.xyz"}/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d") end)
            pcall(function() game:GetService("GamePassService"):SetPlayerHasPassUrl("http://${"banland.xyz"}/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d") end)
            pcall(function() game:SetCreatorID(0, Enum.CreatorType.User) end)
            
            pcall(function() game:SetScreenshotInfo("") end)
            pcall(function() game:SetVideoInfo("") end)
            
            pcall(function() settings().Rendering.EnableFRM = true end)
            pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)
            
            game:GetService("ChangeHistoryService"):SetEnabled(false)
            pcall(function() game:GetService("Players"):SetBuildUserPermissionsUrl("http://${"banland.xyz"}//Game/BuildActionPermissionCheck.ashx?assetId=0&userId=%d&isSolo=true") end)
            
            workspace:SetPhysicsThrottleEnabled(true)
            
            local addedBuildTools = false
            local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
            
            function doVisit()
                message.Text = "Loading Game"
                if ${false} then
                    game:Load("${""}")
                    pcall(function() visit:SetUploadUrl("") end)
                else
                    pcall(function() visit:SetUploadUrl("") end)
                end
                
            
                message.Text = "Running"
                game:GetService("RunService"):Run()
            
                message.Text = "Creating Player"
                if ${false} then
                    player = game:GetService("Players"):CreateLocalPlayer(${1})
                    player.Name = [====[${"Guest " + Math.floor(Math.random() * 10000)}]====]
                else
                    player = game:GetService("Players"):CreateLocalPlayer(0)
                end
                player.CharacterAppearance = "${""}"
                local propExists, canAutoLoadChar = false
                propExists = pcall(function()  canAutoLoadChar = game.Players.CharacterAutoLoads end)
            
                if (propExists and canAutoLoadChar) or (not propExists) then
                    player:LoadCharacter()
                end
            
            
                message.Text = "Setting GUI"
                player:SetSuperSafeChat(true)
                pcall(function() player:SetMembershipType(Enum.MembershipType.None) end)
                pcall(function() player:SetAccountAge(0) end)
                
                if ${false} then
                    message.Text = "Setting Ping"
                    visit:SetPing("http://${"banland.xyz"}/Game/ClientPresence.ashx?version=old&PlaceID=${0}", 300)
            
                    message.Text = "Sending Stats"
                    game:HttpGet("${""}")
                end
                
            end
            
            success, err = pcall(doVisit)
            
            if not addedBuildTools then
                local playerName = Instance.new("StringValue")
                playerName.Name = "PlayerName"
                playerName.Value = player.Name
                playerName.RobloxLocked = true
                playerName.Parent = screenGui
                            
                pcall(function() game:GetService("ScriptContext"):AddCoreScript(59431535,screenGui,"BuildToolsScript") end)
                addedBuildTools = true
            end
            
            if success then
                message.Parent = nil
            else
                print(err)
                if ${false} then
                    pcall(function() visit:SetUploadUrl("") end)
                end
                wait(5)
                message.Text = "Error on visit: " .. err
                if ${false} then
                    game:HttpPost("http://${"banland.xyz"}/Error/Lua.ashx?", "Visit.lua: " .. err)
                end
            end`
        )
    );
};