local settingsManager = {}
function settingsManager:setget(name, value, default)
    if not self.settings then
        self.settings = {}
    end
    if value ~= nil then 
        self.settings[name] = value
    end
    value = self.settings[name]
    return value or default
end
local proxy = {}
local mt = {
    __index = function (_, key)
        local value = settingsManager[key]
        return function(...)
            return value(settingsManager, ...)
        end
    end
}
-- create Proxy
setmetatable(proxy, mt)
return proxy