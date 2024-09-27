local spath =
    debug.getinfo(1,'S').source:sub(2):gsub("/+", "/"):gsub("[^/]*$","")
package.path = spath.."?.lua;"
    .. spath.."libs/miningClient-lib/?.lua;"
    .. spath.."testSuit/?.lua;"
    .. spath.."turtleController-lib/?.lua;"
    .. spath.."scanner-lib/?.lua;"
    ..package.path

require(spath.."turtleEmulator-lib/ccPackage")