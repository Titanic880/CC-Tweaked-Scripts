--init & User adjustable values
local rsoutput = "left"
local rsReactorOutput = "bottom"
local energysource = "back"
local rsInput = "top"
local LoopSleepDur = 5
local energyLevelCheckInterval = 4 --# of loops to clear before checking
local PowerCutoffPerc = 90

local monitor = peripheral.find("monitor")
local rsrelay = peripheral.wrap(rsoutput)
local energycube = peripheral.wrap(energysource)
function monitorreset()
    monitor.clear()
    monitor.setCursorPos(1,1)
end
function monitorwrite(inputtext)
    monitor.write(inputtext)
    a,b = monitor.getCursorPos()
    monitor.setCursorPos(1,b+1)
end

--Catch no monitor break early
monitorreset()
monitorwrite("Good morning Reactor!")

function handleReactor() --Check energy level and adjust accordingly
    monitorreset()
    c_energy = energycube.getEnergyFilledPercentage()*100
    if c_energy > PowerCutoffPerc then 
        rsrelay.setOutput(rsReactorOutput,true)
        monitorwrite("Reactor shutdown")
    else
        rsrelay.setOutput(rsReactorOutput,false)
        monitorwrite("Reactor Active")
    end
    monitorwrite(c_energy .. "%")
end
function OutofFuel() --Hold the system requiring user input to reboot reactor
    monitorreset()
    monitorwrite("Reactor Offline - Reactor Fault Tripped...")
    monitorwrite("Please press enter on PC to attempt Reactor reboot.")
    rsrelay.setOutput(rsReactorOutput,true)
    syshold = read()
    monitorwrite("Rebooted...")
    monitorwrite("Please wait...")
    rsrelay.setOutput(rsReactorOutput,false)
end

--Main Logic Loop
function Reactor_Main()
    local inc = 1
    while true do
        if rsrelay.getInput(rsInput) == true then
            OutofFuel()
        end
        --seperate statement for readability
        if rsrelay.getInput(rsInput) == false then
            if inc >= energyLevelCheckInterval then
                handleReactor()
                inc = 1    
            end
        end
        inc = inc + 1
        sleep(LoopSleepDur)
    end
end

Reactor_Main()