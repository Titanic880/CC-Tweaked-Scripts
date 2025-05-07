--#region Variables
local args = {...}
local DEBUG = true
--Adjust direction to where your devices are
local monitor        = peripheral.find("monitor")
local playerdetector = peripheral.wrap("top")
local ManualShutdown = peripheral.wrap("left")
--Variables to change
local inputDirection = "front"
local FanOnly = false
local playerrange = 20
local relayShort = "redstone_relay_"
--List of ingame relays and their "partner"
local RelayOverlay = {
    --Mob            =   Source,  Destination
    Ancient_Knight   = {"19", "22"},
    Wither_Skeleton  = {"18", "9" },
    Witch            = {"5" , "21"},
    Enderman         = {"4" , "11"},
    Creeper          = {"6" , "20"},
    Spider           = {"7" , "13"},
    Blaze            = {"24", "23"},
    Cow              = {"30", "31"},
    Skeleton         = {"52", "10"}
}
local Fans = {
    "25",
    "26",
    "27",
    "28"
}
local GrinderKiller = "29"
--#endregion Variables
--#region Basic Functionality
--Monitor api wrapper
local function monitorreset()
    monitor.clear()
    monitor.setCursorPos(1,1)
end
local function monitorwrite(inputtext)
    monitor.write(inputtext)
    local a,b = monitor.getCursorPos()
    monitor.setCursorPos(1,b+1)
end
local function DEBUGPRINT(Source,ExtraItem)
    if not DEBUG then
        return
    end
    print(Source)
    if type(ExtraItem) == "table" then
        for a,b in pairs(ExtraItem) do
            print(a)
            print(b)
        end
    else
        print(ExtraItem)
    end
end
local function GetTableLength(input)
    if type(input) ~="table" then
        return 0
    end
    local count = 0
    for _ in pairs(input) do count = count + 1 end
    return count
end
--#endregion Basic Functionality
--#region Network Control
local function SetAllSides(RelayName, OnOff)
    DEBUGPRINT("SetAllSides",RelayName)

    local peri = peripheral.wrap(RelayName)
    peri.setOutput("top", OnOff)
    peri.setOutput("bottom", OnOff)
    peri.setOutput("left", OnOff)
    peri.setOutput("right", OnOff)
    peri.setOutput("front", OnOff)
    peri.setOutput("back", OnOff)
end

local function TransmitSignal(mob)
    DEBUGPRINT("TransmitSignal",mob)

    local UserToggle = peripheral.wrap(relayShort..mob[1])
    local recieve = UserToggle.getInput(inputDirection)
    SetAllSides(relayShort..mob[2],recieve)
    --SpawnerToggle.setOutput(outputDirection,recieve)
    return recieve
end
--#endregion Network Control
--#region Controller Functionality
local function FansToggle(inbool)
    for _,relay in pairs(Fans) do
        SetAllSides(relayShort..relay,inbool)
    end
end

function Shutdown()
    for _,n in pairs(RelayOverlay) do
        SetAllSides(relayShort..n[2],false)
    end
    FansToggle(false)
    SetAllSides(relayShort..GrinderKiller,false)
end

local function PlayerDetection() --returns true if player found
    DEBUGPRINT("PlayerDetection","")

    local detector = playerdetector.getPlayersInRange(playerrange)
    if GetTableLength(detector) == 0 then
        Shutdown()
        monitorwrite("No player found shutdown...")
        return false
    end
    return true
end

local function ManualOverride() --returns true on override
    local function ManualshutdownTrigger()
        monitorreset()
        Shutdown()
        monitorwrite("Manual override activated...")
        return true
    end
    DEBUGPRINT("ManualOverride","")

    if ManualShutdown.getInput("front") then
        return ManualshutdownTrigger()
    end
    if ManualShutdown.getInput("back") then
        return ManualshutdownTrigger()
    end
    return false
end

local function UpdateGrinder(inbool) --Takes the state action
    if not FanOnly then
        SetAllSides(relayShort..GrinderKiller,inbool)
    end
    for _,n in pairs(Fans) do
        SetAllSides(relayShort..n,inbool)
    end
end
local function UpdateActiveMobs()
    for name,n in pairs(RelayOverlay) do
        monitorwrite(name .. " : " .. tostring(TransmitSignal(n)))
    end
end
--#endregion Controller Functionality
--#region Main System Loop
function Main()
    while true do
        if PlayerDetection() then        --Check for player
            if not ManualOverride() then --Check for override
                UpdateGrinder(true)
                UpdateActiveMobs()
            else
                Shutdown()
            end
        else
            Shutdown()
        end
        sleep(5)
        monitorreset()
    end
end
--#endregion Main System Loop

if args[1] == "shutdown" then
    Shutdown()
    return
else if args[1] == "fanonly" then
    Shutdown()
    FanOnly = true
end end
monitorreset()
Main()