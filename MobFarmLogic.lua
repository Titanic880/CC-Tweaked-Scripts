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
--List of ingame relays and their "partner"
local RelayOverlay = {
    --Mob            =   Source            ,  Destination
    Ancient_Knight   = {"redstone_relay_19", "redstone_relay_22"},
    Wither_Skeleton  = {"redstone_relay_18", "redstone_relay_9" },
    Witch            = {"redstone_relay_5" , "redstone_relay_21"},
    Enderman         = {"redstone_relay_4" , "redstone_relay_11"},
    Creeper          = {"redstone_relay_6" , "redstone_relay_20"},
    Spider           = {"redstone_relay_7" , "redstone_relay_13"},
    Blaze            = {"redstone_relay_24", "redstone_relay_23"},
    Cow              = {"redstone_relay_30", "redstone_relay_31"}
}
local Fans = {
    "redstone_relay_25",
    "redstone_relay_26",
    "redstone_relay_27",
    "redstone_relay_28"
}
local GrinderKiller = "redstone_relay_29"
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

    local UserToggle = peripheral.wrap(mob[1])
    local recieve = UserToggle.getInput(inputDirection)
    SetAllSides(mob[2],recieve)
    --SpawnerToggle.setOutput(outputDirection,recieve)
    return recieve
end
--#endregion Network Control
--#region Controller Functionality
local function FansToggle(inbool)
    for _,relay in pairs(Fans) do
        SetAllSides(relay,inbool)
    end
end

function Shutdown()
    for _,n in pairs(RelayOverlay) do
        SetAllSides(n[2],false)
    end
    FansToggle(false)
    SetAllSides(GrinderKiller,false)
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
        SetAllSides(GrinderKiller,inbool)
    end
    for v,n in pairs(Fans) do
        SetAllSides(n,inbool)
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