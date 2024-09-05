--- This simulates the files requried from the SCM module
local scm = {}

local settingsManager = {settings = {}}

local require2 = require

local function required(name)
    print("Required: " .. name)
    if (name == "settingsManager") then
        return settingsManager
    end
    if (name == "cc.pretty") then
        return print
    end
    return require2(name)
end


_G.require = required


function settingsManager:setget(name, value, default)
    if value ~= nil then 
        self.settings[name] = value
    end
    value = self.settings[name]
    return value or default
end

    function scm:load(name)
        return required(name)
    end

return scm