local ghost = require('ghost')
local lapp  = require('pl.lapp')

local methods = {
    on     = ghost.on,
    off    = ghost.off,
    colour = ghost.colour,
    strobe = ghost.strobe,
    flash  = ghost.flash,
    smooth = ghost.smooth,
    fade   = ghost.fade
}

local args = lapp [[
Cmd line utility to control the PACMAN ghost
    <cmds...> (default on)  The cmd to send to the ghost
]]

if #args.cmds == 0 then
    print(string.format("No cmds entered"))
    os.exit()
end

local method = methods[args.cmds[1]]
if not method then
    print(string.format("Cmd %s not recognised", args.cmds[1]))
    os.exit()
end

if args.cmds[1] == "colour" then
    local colour = "white"
    if #args.cmds > 1 then
        colour = args.cmds[2]
    end
    method(colour)
else
    method()
end