if Workspace:FindFirstChild("Teleporter3") then
    Game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Blocked",
        Text = "Please join a game before executing this script.",
        Duration = 5,
        Button1 = "OK"
    })
    return
end

local WindUi = loadstring(Game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local WattyhubFolder = "Wattyhub"
local PlayerId = Game:GetService("Players").LocalPlayer.UserId
local MenuKeybind = { Key = Enum.KeyCode.RightShift }
WindUi:SetTheme("Amber")

local LuarmorRegularScriptId = "301e4b7fecc2d17f1d38d516d5fbdb42"
local LuarmorPremiumScriptId = "fc3608cd7244b37ab8ccf691066eeb78"
local LuarmorKeyUrl = "https://ads.luarmor.net/get_key?for=Wattyhub_12_hour_key-OjpQBKEWmykA"
local LuarmorPremiumKeyUrl = "https://ads.luarmor.net/get_key?for=Wattyhub_Premium_6_hour_key-xpWZWJvXrjxi"

local RegularProjectScriptId = "0c76b329bcae8b4134c5cbe433082e8a"
local PremiumProjectScriptId = "ab2b686887cbae9b3cd20705d42d646c"

local function OpenUrl(Url)
    local InviteCode = string.match(Url, "discord.gg/([%w%d]+)")
    local RequestFunc = http_request or (syn and syn.request) or request
    if InviteCode and RequestFunc then
        pcall(function()
            RequestFunc({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = { ['Content-Type'] = 'application/json', Origin = 'https://discord.com' },
                Body = Game:GetService("HttpService"):JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = Game:GetService("HttpService"):GenerateGUID(false),
                    args = { code = InviteCode }
                })
            })
        end)
        WindUi:Notify({ Title = "Opening Discord", Content = "Attempting to open the invite...", Duration = 4 })
        return
    end
    if openurl and pcall(openurl, Url) then
        WindUi:Notify({ Title = "Opening Link", Content = "Opening link in your browser...", Duration = 4 })
        return
    end
    if setclipboard then
        setclipboard(Url)
        WindUi:Notify({ Title = "Link Copied", Content = "Could not open URL directly. Link was copied to your clipboard.", Duration = 5 })
    end
end

local LuarmorRegularApi = loadstring(Game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
LuarmorRegularApi.script_id = LuarmorRegularScriptId

local LuarmorPremiumApi = loadstring(Game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
LuarmorPremiumApi.script_id = LuarmorPremiumScriptId

local LuarmorRegularProjectApi = loadstring(Game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
LuarmorRegularProjectApi.script_id = RegularProjectScriptId

local LuarmorPremiumProjectApi = loadstring(Game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
LuarmorPremiumProjectApi.script_id = PremiumProjectScriptId

WindUi.Services.luarmor = {
    Name = "Luarmor Key System",
    Icon = "key-round",
    Args = { "ScriptId", "Discord" },
    New = function(ScriptId, Discord)
        local function ValidateKey(Key)
            if not Key or Key == "" or #Key ~= 32 then
                return false, "Key is invalid format!"
            end
            local TempApi = loadstring(Game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
            TempApi.script_id = ScriptId
            local Status = TempApi.check_key(Key)
            if Status.code == "KEY_VALID" then
                return true, "Key is valid!"
            elseif Status.code == "KEY_EXPIRED" then
                return false, "Key has expired!"
            elseif Status.code == "KEY_HWID_LOCKED" then
                return false, "Key is locked to different HWID. Reset via Discord bot."
            elseif Status.code == "KEY_INCORRECT" then
                return false, "Key does not exist or is incorrect!"
            elseif Status.code == "KEY_BANNED" then
                return false, "Key is blacklisted!"
            else
                return false, "Key validation failed: " .. (Status.message or "Unknown error")
            end
        end
        local function CopyLink()
            OpenUrl(Discord)
        end
        return {
            Verify = ValidateKey,
            Copy = CopyLink
        }
    end
}

WindUi.Services.youtubetutorial = {
    Name = "YouTube Tutorial",
    Icon = "youtube",
    Args = { "Url" },
    New = function(Url)
        return {
            Copy = function()
                OpenUrl(Url)
            end
        }
    end
}

local function ExecuteMainScript(Key)
    script_key = Key
    WindUi:Notify({ Title = "Validating Key", Content = "Checking key status...", Duration = 3, Icon = "loader" })
    local PremiumStatus = LuarmorPremiumApi.check_key(Key)
    if PremiumStatus.code == "KEY_VALID" then
        WindUi:Notify({ Title = "Premium Key Detected", Content = "Loading premium script...", Duration = 4, Icon = "crown" })
        LuarmorPremiumProjectApi.load_script()
        return
    end
    local RegularStatus = LuarmorRegularApi.check_key(Key)
    if RegularStatus.code == "KEY_VALID" then
        WindUi:Notify({ Title = "Regular Key Detected", Content = "Loading regular script...", Duration = 4, Icon = "key-round" })
        LuarmorRegularProjectApi.load_script()
        return
    end
    local ErrorMsg = RegularStatus.message or PremiumStatus.message or "Key is invalid or expired."
    WindUi:Notify({ Title = "Key Invalid", Content = ErrorMsg .. " Please get a new key.", Icon = "lock-keyhole", Duration = 5 })
end

local function GetSavedKeyIfValid()
    local KeyFilePath = WattyhubFolder .. "/" .. PlayerId .. ".key"
    if not isfolder(WattyhubFolder) then
        makefolder(WattyhubFolder)
    end
    if isfile(KeyFilePath) then
        local Success, SavedKey = pcall(readfile, KeyFilePath)
        if not Success or not SavedKey or #SavedKey ~= 32 then
            return nil
        end
        local RegularStatus = LuarmorRegularApi.check_key(SavedKey)
        local PremiumStatus = LuarmorPremiumApi.check_key(SavedKey)
        if RegularStatus.code == "KEY_VALID" or PremiumStatus.code == "KEY_VALID" then
            WindUi:Notify({ Title = "Key Validated", Content = "Your saved key is valid. Loading script...", Icon = "key-round" })
            return SavedKey
        else
            local ErrorMsg = RegularStatus.message or PremiumStatus.message or "Key is invalid"
            WindUi:Notify({ Title = "Saved Key Invalid", Content = ErrorMsg .. ". Please get a new key.", Icon = "lock-keyhole" })
            return nil
        end
    end
    return nil
end

local SavedKey = GetSavedKeyIfValid()
local HasValidKey = (SavedKey ~= nil)

if HasValidKey then
    ExecuteMainScript(SavedKey)
else
    local KeyFilePath = WattyhubFolder .. "/" .. PlayerId .. ".key"
    while not isfile(KeyFilePath) do
        wait(1)
    end
    local NewKey = readfile(KeyFilePath)
    if NewKey and #NewKey == 32 then
        ExecuteMainScript(NewKey)
    else
        WindUi:Notify({ Title = "Error", Content = "Failed to read the newly saved key.", Duration = 5, Icon = "alert-triangle" })
    end
end
