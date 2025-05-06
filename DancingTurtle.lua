if not turtle then
    print("Only Turtles can dance!")
    return
    end
local args = {...}

local zoffset = 0 --+forward -back
local xoffset = 0 --+Right -Left
local yoffset = 0 --updown
local rotationoffset = 0 -- +Right -Left

local fuelSources = {         -- table with valid fuel source items
["minecraft:coal"] = true,
["minecraft:lava_bucket"] = true
}

local function SpinRight()
    turtle.turnRight()
    turtle.turnRight()
    turtle.turnRight()
    turtle.turnRight()
    end
local function SpinLeft()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.turnLeft()
    end

local function LookBackRight()
    turtle.turnRight()
    turtle.turnRight()
end
local function LookBackLeft()
    turtle.turnLeft()
    turtle.turnLeft()
end

local function TurnRightCenter()
    turtle.turnRight()
    turtle.turnLeft()
    end
local function TurnLeftCenter()
    turtle.turnLeft()
    turtle.turnRight()
    end
local function TurnRight(Amount)
    for i=1,Amount do
        turtle.turnRight()
        rotationoffset = rotationoffset+1
    end
end
local function TurnLeft(Amount)
    for i=1,Amount do
        turtle.turnLeft()
        rotationoffset = rotationoffset-1
    end
end

--debug
local function MoveUp(Amount)
    for i=1,Amount do
        turtle.up()
    end
    yoffset = yoffset+Amount
    end
local function MoveDown(Amount)
    for i=1,Amount do
        turtle.down()
    end
    yoffset = yoffset-Amount
    end
local function MoveRight(Amount)
    turtle.turnRight()
    for i=1,Amount do
        turtle.forward()
    end
    turtle.turnLeft()
    xoffset = xoffset+Amount
end
local function MoveLeft(Amount)
    turtle.turnLeft()
    for i=1,Amount do
        turtle.forward()
    end
    turtle.turnRight()
    xoffset = xoffset-Amount
end
local function MoveBack(Amount)
    for i=1,Amount do
        turtle.back()
    end
    zoffset = zoffset-Amount
end
local function MoveForward(Amount)
    for i=1,Amount do
        turtle.forward()
    end
    zoffset = zoffset+Amount
end
local function ReturnToStart()
    print("Returning Home...")
    print("Offsets: "..rotationoffset..":"..zoffset..":"..yoffset..":"..xoffset)
        if rotationoffset < 0 then
            TurnLeft(rotationoffset*-1)
        else
            TurnRight(rotationoffset)
        end
        if zoffset < 0 then
            MoveForward(zoffset)
        else
            MoveBack(zoffset)
        end
        if yoffset < 0 then
            MoveUp(yoffset*-1)
        else
            MoveDown(yoffset)
        end
        if xoffset < 0 then
            MoveRight(xoffset)
        else
            MoveLeft(xoffset)
        end
end

local function DanceOne()
    SpinLeft()
    SpinRight()
    TurnLeftCenter()
    TurnRightCenter()
    MoveUp(1)
    TurnRightCenter()
    MoveDown(1)
    TurnLeftCenter()
    MoveBack(1)
    MoveForward(2)
    MoveLeft(1)
    MoveRight(2)
    MoveBack(1)
    MoveLeft(1)
end
local function DanceTwo()
    MoveUp(1)
    TurnRight(2)
    TurnLeftCenter()
    MoveForward(1)
    MoveLeft(1)
    MoveBack(1)
    SpinRight()
    SpinLeft()
    MoveRight(1)
end
local function DanceThree()
    MoveForward(1)
    MoveBack(2)
    TurnLeftCenter()
    TurnRightCenter()
    LookBackRight()
    MoveBack(2)
    SpinRight()
    MoveUp(1)
    MoveLeft(1)
    MoveDown(1)
    MoveRight(1)
    MoveForward(1)
    LookBackLeft()
end
local function itemName(slot)
    local details = turtle.getItemDetail(slot)
    return details and details.name
    end

local function Refuel()
        for i=1,16 do
            if fuelSources[itemName(i)] then
                turtle.select(i)
                turtle.refuel()
                turtle.select(1)
                return true
            end
        end
        return false
end

local function CheckFuelState()
    --Check for unlimited/unhandled response
    if type(turtle.fuellevel) == type("string") then
        if turtle.fuellevel ~= "unlimited" then
            print("Unhandled case"..turtle.fuellevel)
        end
    else
        --Handle fuel usage
        if turtle.getFuelLevel() < 100 then
            if not Refuel() then
            print("Turtle is out of fuel & could not refuel")
            return false
            end
        end
    return true
    end
end


local function main()
    if CheckFuelState() == false then
        return
    end
    print("It's Time to Boogie!!!")
    if args[1] == "1" then
        print("My first Dance!")
        DanceOne()
        ReturnToStart()
    elseif args[1] == "2" then
        print("My second Dance!")
        DanceTwo()
        ReturnToStart()
    elseif args[1] == "3" then
        print("My third Dance!")
        DanceThree()
        ReturnToStart()
    else
        while CheckFuelState() do
            print("All together now!")
            DanceOne()
            ReturnToStart()
            print("We getting into it now!")
            DanceTwo()
            ReturnToStart()
            print("Oh yeah!!!")
            DanceThree()
            ReturnToStart()
        end
    end
end


main()