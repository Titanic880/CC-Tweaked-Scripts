if fs.exists("MobFarmLogic.lua") then

    if os.run("","MobFarmLogic.lua") then error() do
        os.reboot()
        end
    end
end
if os.exists("ReactorController.lua") then
    if Reactor_Main() then error() do
        os.reboot()
        end
    end
end
