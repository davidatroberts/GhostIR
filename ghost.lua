local irsend = require('irsend')
local ffi    = require('ffi')
ffi.cdef[[
	typedef unsigned int useconds_t;
	int usleep(useconds_t usec);
]]

local ghost = {}

local cmds = {
	on        = 'KEY_0',
	off       = 'KEY_1',
	red       = 'KEY_3',
	green     = 'KEY_4',
	blue      = 'KEY_5',
	white     = 'KEY_6',
	orange    = 'KEY_7',
	lgreen    = 'KEY_8',
	lpurple   = 'KEY_9',
	lorange   = 'KEY_AB',
	turquoise = 'KEY_ADDRESSBOOK',
	purple    = 'KEY_AGAIN',
	yellow    = 'KEY_ANGLE',
	llblue    = 'KEY_APOSTROPHE',
	lpink     = 'KEY_ARCHIVE',
	lyellow   = 'KEY_AUX',
	lblue     = 'KEY_B',
	pink      = 'KEY_BACK',
	strobe    = 'KEY_ALTERASE',
	flash     = 'KEY_A',
	smooth    = 'KEY_BACKSLASH',
	fade      = 'KEY_AUDIO'
}

local status = ""

local function send(cmd)
	return irsend.send_once('ghost', cmd)
end

local function alternate_cmds(cmd1, cmd2)
	while true do
		send(cmds[cmd1])
		local stop = coroutine.yield()
		if stop then
			break
		end

		send(cmds[cmd2])
		stop = coroutine.yield()
		if stop then
			break
		end
	end
end

function ghost.on()
	status = 'on'
	return send(cmds['on'])
end

function ghost.off()
	status = 'off'
	return send(cmds['off'])
end

function ghost.colour(col)
	status = col
	return send(cmds[col])
end

function ghost.strobe()
	status = 'strobe'
	return send(cmds['strobe'])
end

function ghost.flash()
	status = 'flash'
	return send(cmds['flash'])
end

function ghost.alternate(cmd1, cmd2, period)
	local co = coroutine.create(alternate_cmds)

	-- loop
	while true do
		coroutine.resume(co)
		ffi.C.usleep(period)
		coroutine.resume(co)
		ffi.C.usleep(period)
	end
end

function ghost.smooth()
	status = 'smooth'
	return send(cmds['smooth'])
end

function ghost.fade()
	status = 'fade'
	return send(cmds['fade'])
end

function ghost.status()
	return status
end

return ghost
