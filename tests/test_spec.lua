---@class are
---@field same function
---@field equal function
---@field equals function

---@class is
---@field truthy function
---@field falsy function
---@field not_true function
---@field not_false function

---@class has
---@field error function
---@field errors function

---@class assert
---@field are are
---@field is is
---@field are_not are
---@field is_not is
---@field has has
---@field has_no has
---@field True function
---@field False function
---@field has_error function
---@field is_false function
---@field is_true function
---@field equal function
assert = assert

package.path = "libs/?.lua;"
    .. "libs/inventory/?.lua;"
    .. "libs/peripherals/?.lua;"
    .. package.path


_G.settings = require("settings")
local Vector = require("vector")
local scanResultMock = require("scanResultMock")
---@type TurtleEmulator
local turtleEmulator = require("turtleEmulator")


-- require the files which depend on the globals
local geoScanner
local miningClient

local geoScannerPeripheral
local readOperationCounter = 0
_G.read = function ()
  readOperationCounter = readOperationCounter + 1
  if readOperationCounter == 1 then
    return "X"
  end
  if readOperationCounter == 2 then
    return "1"
  end
end

--#endregion

---comment
---@param turtle TurtleProxy
---@param distance number
---@return Vector[]
local function createPoints(turtle, distance, areaSize)
  local points = distance / areaSize
  local pointTable = {}
  local currentPositon = turtle.position * 1
  table.insert(pointTable, currentPositon)
  for i = 1, points,1 do
    currentPositon = currentPositon + (turtle.facing * areaSize)
    table.insert(pointTable, currentPositon)
  end
  return pointTable
end

local function countblocks(blockName)
  local count = 0
  local lastBlock
  for _, block in pairs(turtleEmulator.blocks) do
    if block.item.name == blockName then
      count = count + 1
      lastBlock = block
    end
  end
  return count
end

local function beforeEach()
  local geoScannerItem = {
    name = "advancedperipherals:geo_scanner",
    count = 1,
    equipable = true,
    placeAble = false
  }
  local chuckyItem = {
    name = "advancedperipherals:chunk_controller",
    count = 1,
    equipable = true,
    placeAble = false
  }
  local pickaxe = {
    name = "minecraft:diamond_pickaxe",
    count = 1,
    equipable = true,
    placeAble = false
  }
  local coal = {
    name = "minecraft:coal",
    count = 64,
    equipable = false,
    placeAble = false,
    fuelgain = 8
  }
  
  turtleEmulator:clearBlocks()
  turtleEmulator:clearTurtles()
  
  if package.loaded["turtleController"] ~= nil then
    package.loaded["turtleController"] = nil
    package.loaded["miningClient"] = nil
  end
    -- reset globals
  ---@type TurtleMock
  _G.turtle = turtleEmulator:createTurtle()
  local peripheral = turtle.getPeripheralModule()
  _G.peripheral = peripheral

  -- require the files which depend on the "new" globals
  geoScanner = require("geoScanner")
  miningClient = require("miningClient")
  geoScannerPeripheral = turtleEmulator:addPeripheralToItem(geoScannerItem, geoScanner, turtle)
  
  turtle.addItemToInventory(geoScannerItem, 1)
  turtle.addItemToInventory(chuckyItem, 2)
  turtle.addItemToInventory(pickaxe, 3)
  turtle.addItemToInventory(coal, 4)

  -- require the files which depend on the globals
end



describe("empty World", function()
  before_each(function()
    beforeEach()
  end)
  it(" - return to start", function()
    ---@cast geoScannerPeripheral GeoScanner
    geoScannerPeripheral.scanResult = {}
    miningClient.scanStartFacingTo = "X"
    miningClient:main(createPoints(turtle, 10, 1))
    assert.are.equal(Vector.new(0, 0, 0), turtle.position)
  end)
end)
describe("World with ores", function()
    before_each(function()
      beforeEach()
  end)
  it(" - cleared all Ores", function()
    for i = 5, 15, 1 do
      turtle.addItemToInventory({name = "minecraft:stone", count = 64, maxcount = 64, placeAble = true})
    end
    local tmpChest = {name = "enderchests:ender_chest", count = 1, maxcount = 1, placeAble = true}
    turtle.addItemToInventory(tmpChest, 16)
    local enderCHest = turtleEmulator:addInventoryToItem(tmpChest)

    
    local mappingFunc = function(scanData)
      return {
        item = {
          name = scanData.name,
          tags = scanData.tags
        },
        position = Vector.new(scanData.x, scanData.y, scanData.z),
        checkActionValidFunc = function()
          return false
        end
      }
    end
    turtleEmulator:readBlocks(scanResultMock, mappingFunc)
    ---@cast geoScannerPeripheral GeoScanner
    geoScannerPeripheral.scanEmulator = true
    miningClient.scanStartFacingTo = "X"
    assert.are.equal(15, countblocks("minecraft:deepslate_iron_ore"))
    miningClient:main(createPoints(turtle, 2, 1))
    local count = countblocks("minecraft:deepslate_iron_ore")
    local dirt = countblocks("minecraft:dirt")
    assert.are.equal(0, count)
    assert.are.equal(Vector.new(0, 0, 0), turtle.position)
    assert.are.equal(Vector.new(1, 0, 0), turtle.facing)
    assert.is.not_false(dirt)
    assert.is.falsy(turtle.getItemDetail(10))
  end)
end)