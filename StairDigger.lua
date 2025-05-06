if not turtle then
    print("Must be a turtle!")
    return
end
local args = {...}

local fuelSources = {         -- table with valid fuel source items
["minecraft:coal"] = true,
["minecraft:lava_bucket"] = true
}

-- Relative to starting position
local xPos = 0  --Left/Right
local yPos = 0  --Up/Down
local zPos = 0  --forward/backward
local direction = {front=0, right=1, back=2, left=3}
local facing = direction.front


local function forward()
    while not turtle.forward() do
    _ = select(1)
    turtle.dig()
    turtle.attack()
    end
    if facing == direction.front then
        yPos = yPos + 1
    elseif facing == direction.back then
        yPos = yPos - 1
    elseif facing == direction.right then
        xPos = xPos + 1
    else
        xPos = xPos - 1
    end
    end
local function up()
    while not turtle.up() do
        _ = select(1)
        turtle.digUp()
        turtle.attackUp()
    end
    end
local function down()
    while not turtle.down() do
      _ = select(1)
      turtle.digDown()
      turtle.attackDown()
    end
    end
  local function turnRight()
    turtle.turnRight()
    facing = facing+1
    if (facing > 3) then
      facing = 0
    end
    end
  local function turnLeft()
    turtle.turnLeft()
    facing = facing-1
    if (facing < 0) then
      facing = 3
    end
    end
local offsetdown = false
local function DigColumn()
    forward()
    if offsetdown then
        offsetdown = false
        down()
    end
    up()
    up()
    down()
    down()
    down()

    up()
end

local function MineStair(Width)
    while true do
            DigColumn()
            --Handle Next column or next stair level
            if facing == direction.front and xPos == 0 then
                turnRight()
            else if facing == direction.front and xPos == Width then
                turnLeft()
            else if facing == direction.right then
                if xPos == Width then
                turnLeft()
                offsetdown = true
                end
            else if facing == direction.left then
                if xPos == 0 then
                turnRight()
                offsetdown = true
                end
                end
            end
            end
        end
end
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
    print("starting...")
    if not CheckFuelState() then
        return
    end
    print("Starting to mine stairs...")
    MineStair(tonumber(args[1])-1)
end


main()
