if not turtle then
    print("Must be a turtle!")
    return
end
local args = {...}
local InputChest = ""
local OutputChest = ""


--#region Basic functionality
local function itemName(slot)
    local details = turtle.getItemDetail(slot)
    return details and details.name
end
local function FindItem(Name) --searches inventory and returns item slot
    
end

--#endregion Basic functionality
