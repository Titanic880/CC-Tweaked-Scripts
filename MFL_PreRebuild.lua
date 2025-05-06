local args = {...}
--Adjust direction to where your versions are
local monitor = peripheral.find("monitor")
local playerdetector = peripheral.wrap("top")
local ManualShutdown = peripheral.wrap("left")
--Variables to change
local inputDirection = "front"
local outputDirection = "top"
local playerrange = 20
--State based information
local shutdown = false
local grinderstate = false
--List of ingame relays and their "partner"
local RelayOverlay = {
    --Source : Destination
    AncientKnight = {"redstone_relay_19", "redstone_relay_22"},
    WitherSkeleton = {"redstone_relay_18", "redstone_relay_9"},
    Witch = {"redstone_relay_5","redstone_relay_21"},
    --To be replaced with another mob
    Enderman = {"redstone_relay_4","redstone_relay_11"},
    Creeper = {"redstone_relay_6","redstone_relay_20"},
    Spider = {"redstone_relay_7","redstone_relay_13"},
    Blaze = {"redstone_relay_24","redstone_relay_23"}
}
local Fans = {
    "redstone_relay_25",
    "redstone_relay_26",
    "redstone_relay_27",
    "redstone_relay_28"
}
local GrinderKiller = "redstone_relay_29"

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
monitorreset()
monitorwrite("Good morning farmers!")

local function SetAllSides(RelayName, OnOff)
    local peri = peripheral.wrap(RelayName)
    peri.setOutput("top", OnOff)
    peri.setOutput("bottom", OnOff)
    peri.setOutput("left", OnOff)
    peri.setOutput("right", OnOff)
    peri.setOutput("front", OnOff)
    peri.setOutput("back", OnOff)
end

local function FansToggle(inbool)
    for _,relay in pairs(Fans) do
        SetAllSides(relay,inbool)
    end
    grinderstate = inbool
end

--Takes in a RelayOverlay entry and sends the source to destination
local function TransmitSignal(mob)
    monitorwrite(mob[1]) --DEBUG prints
    monitorwrite(mob[2])
    local UserToggle = peripheral.wrap(mob[1])
    local recieve = UserToggle.getInput(inputDirection)
    SetAllSides(mob[2],recieve)
    --SpawnerToggle.setOutput(outputDirection,recieve)
    return recieve
end

local function GetTableLength(input)
    if type(input) ~="table" then
        return 0
    end
    local count = 0
    for _ in pairs(input) do count = count + 1 end
    return count
end

local function PlayerDetection()
    local detector = playerdetector.getPlayersInRange(playerrange)
    local function ManualshutdownTrigger()
        monitorreset()
        Shutdown()
        monitorwrite("Manual override activated...")
        return false
    end

    if GetTableLength(detector) == 0 then
        Shutdown()
        monitorwrite("No player found shutdown...")
        return false
    end
    if ManualShutdown.getInput("front") then
        return ManualshutdownTrigger()
    end
    if ManualShutdown.getInput("back") then
        return ManualshutdownTrigger()
    end
    shutdown = false
    return true
end

function Shutdown()
    shutdown = true
    for _,n in pairs(RelayOverlay) do
        SetAllSides(n[2],false)
    end
    FansToggle(false)
    SetAllSides(GrinderKiller,false)
end

function Main()
    while true do
        if PlayerDetection() then
            if not grinderstate then
                FansToggle(true)
                SetAllSides(GrinderKiller, grinderstate)
            end
            for _,n in pairs(RelayOverlay) do
                --monitorwrite(v)
                --monitorwrite(n)
                monitorwrite(TransmitSignal(n))
            end
        end
        sleep(5)
        monitorreset()
    end
end
function Main_NoGrinder()
    while true do
        if PlayerDetection() then
            if not grinderstate then
                FansToggle(true)
            end
            monitorwrite("FAN ONLY MODE")
            for v,n in pairs(RelayOverlay) do
                monitorwrite(v)
                --monitorwrite(n)
                monitorwrite(TransmitSignal(n))
            end
        end
        sleep(5)
        monitorreset()
    end
end

if args[1] == "shutdown" then
    Shutdown()
else if args[1] == "fanonly" then
    Main_NoGrinder()
else
    Main()
end end