--#region Variables
local DEBUG = true
local args = {...}

local RelayTable = --Only need the numbers
{
    {"32","33","34"},
    {"35","36","37"},
    {"38","39","40"},
    {"41","42","43"},
    {"44","45","46"},
    {"47","48","49"},
    {"50"}
}
local playerrange = 20
local relay = "redstone_relay_"
local UserToggleRelay = "51"  --change to "" if not using user input to turn on/off
--endregion Variables
--#region Basic Functionality
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
local function PlayerDetection() --returns true if player found
    DEBUGPRINT("PlayerDetection","")
    local playerdetector = peripheral.find("playerDetector")
    local detector = playerdetector.getPlayersInRange(playerrange)
    if GetTableLength(detector) == 0 then
        Shutdown()
        return false
    end
    return true
end
local function UserToggleSwitch()
    if UserToggleRelay == "" then
        return false
    end
    local inputrelay = peripheral.wrap(relay..UserToggleRelay)
    if inputrelay.getInput("top") then
        return true
    else if inputrelay.getInput("bottom") then
    return true
else if inputrelay.getInput("left") then
    return true
else if inputrelay.getInput("right") then
    return true
else if inputrelay.getInput("front") then
    return true
else if inputrelay.getInput("back") then
    return true
end end end end end end
end
--#endregion Network Control
--#region Extended Functionality
local function SendSection(TableSignal, State, sleeptimer) --Sends State to all sides of provided then sleeps for the timer (seconds)
    for _,n in pairs(TableSignal) do
        SetAllSides(relay..n,State)
    end
end
--#endregion Extended Functionality
local function CustomLoop() --Do all your work in this function to adjust how your redstone works (or sub functions)
    for _,group in pairs(RelayTable) do --On
        SendSection(group,true)
        sleep(1)
    end
    for _,group in pairs(RelayTable) do --Off
        SendSection(group,false)
        sleep(1)
    end
end

function Main(SleepDuration)
    while true do
        if UserToggleRelay == "" or UserToggleSwitch() then
            CustomLoop()
        else
            print("Not running...")
            sleep(SleepDuration)
        end
    end
end

if args[1] == "on" then
    for _,group in pairs(RelayTable) do
        SendSection(group,true)
    end
    return
else if args[1] == "off" then
    for _,group in pairs(RelayTable) do
        SendSection(group,false)
    end
    return
end end

if type(args[1]) == "number" then
    Main(args[1])
else
    Main(1)
end

