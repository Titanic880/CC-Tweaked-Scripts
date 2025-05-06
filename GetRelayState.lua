local args = {...}
local relay = peripheral.wrap(args[1])

--Check input
if args[2] == 1 then
    print("top",relay.getInput("top"))
    print("bottom",relay.getInput("bottom"))
    print("left",relay.getInput("left"))
    print("right",relay.getInput("right"))
    print("front",relay.getInput("front"))
    print("back",relay.getInput("back"))
else --Check output
    print("top",relay.getOutput("top"))
    print("bottom",relay.getOutput("bottom"))
    print("left",relay.getOutput("left"))
    print("right",relay.getOutput("right"))
    print("front",relay.getOutput("front"))
    print("back",relay.getOutput("back"))
end
if args[2] == 3 then
        print("top",relay.getAnalogInput("top"))
        print("bottom",relay.getAnalogInput("bottom"))
        print("left",relay.getAnalogInput("left"))
        print("right",relay.getAnalogInput("right"))
        print("front",relay.getAnalogInput("front"))
        print("back",relay.getAnalogInput("back"))
else if args[2] == 4 then --Check output
        print("top",relay.getAnalogOutput("top"))
        print("bottom",relay.getAnalogOutput("bottom"))
        print("left",relay.getAnalogOutput("left"))
        print("right",relay.getAnalogOutput("right"))
        print("front",relay.getAnalogOutput("front"))
        print("back",relay.getAnalogOutput("back"))
    end
end

if args[3] == "set" then
        relay.setOutput("top", not relay.getOutput("top"))
        relay.setOutput("bottom", not relay.getOutput("bottom"))
        relay.setOutput("left", not relay.getOutput("left"))
        relay.setOutput("right", not relay.getOutput("right"))
        relay.setOutput("front", not relay.getOutput("front"))
        relay.setOutput("back", not relay.getOutput("back"))
        print("outputs set to: ",relay.getOutput("top"))
end


