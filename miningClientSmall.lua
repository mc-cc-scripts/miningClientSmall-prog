---@class scm
local scm = require("scm")
---@class HelperFunctions
local helper = scm:load("helperFunctions")
---@class miningLib
local miningLib = scm:load("miningClient")

---@class MiningSettings
local miningSettings = { miningDepth = -50, miningHight = 3, miningDiameter = 9, scanRadius = 4 };

--Args
args = { ... }


--Functions
local function facingPostition()
    ---TODO: GPS
    term.clear()
    print("Unequip everything")
    print("on the turtle!")
    print("")
    print("requires in inventory:")
    print("1x geoscanner")
    print("1x chunkloader")
    print("1x pickaxe (diamond)")
    print("")
    print("")
    print("Facing: X|Z|-X|-Z?")

    return read()
end
--- sets the config for the Miner
local function config()

    print('Settings: ')
    print('miningDepth miningHight miningDiameter scanRadius')
    local input = {}
    local r = read()
    if #r > 0 then
        for w in r:gmatch("%S+") do
            table.insert(input, w)
        end
        miningSettings = {
            miningDepth = tonumber(input[1]),
            miningHight = tonumber(input[2]),
            miningDiameter = tonumber(input[3]),
            scanRadius = tonumber(input[4])
        };
        miningSettings = sM.setget('MiningSettings', miningSettings, miningSettings);
    end
end

---main script Function
local function main()
    --TODO: GPS support
    -- term.clear()

    --settings
    miningSettings = sM.setget('MiningSettings', nil, miningSettings)
    if args and (args[1] == "config" or args[1] == "Config") then
        config()
        return
    end
    miningLib.scanStartFacingTo = facingPostition()

    --Manuell Distance selection
    print("How far in Blocks?")
    local areas = read()
    areas = tonumber(areas)

    --calc AreaPoints for mining
    ---@type ScanDataTable
    local points = {}
    areas = areas / (miningSettings.miningDiameter)
    areas = math.floor(areas)
    table.insert(points, { x = 0, y = 0, z = 0 })
    for i = 1, areas do
        --TODO facing! the createpath does not take absolute points!
        table.insert(points, { x = miningSettings.miningDiameter, y = 0, z = 0 })
    end
    miningLib:main(points);
end

main()
