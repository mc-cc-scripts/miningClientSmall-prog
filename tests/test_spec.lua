
local spath =
    debug.getinfo(1,'S').source:sub(2):gsub("/+", "/"):gsub("[^/]*$",""):gsub("/tests", ""):gsub("tests","")
if spath == "" then
  spath = "./"
end
require(spath.."ccPackage")
--#region Globals

---@type TurtleEmulator
local turtleEmulator = require("turtleEmulator")
_G.turtle = turtleEmulator:createTurtle()
-- local miner = require("miningClientSmall")

--#endregion

describe("test_spec", function()
  it("should be able to run tests", function()
    assert.is_true(true)
  end)
end)