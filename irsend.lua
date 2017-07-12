local irsend = {}

local function send(cmd)
	-- execute command
	local program_handle = io.popen(cmd)

	-- get the output from calling IRSend
	local output = {}
	for line in program_handle:lines() do
		table.insert(output, line)
	end

	-- no output from IRSend, it might have worked
	if #output < 1 then
		return true
	end

	-- IRSend has definitely failed, return false and message
	local error_msg = table.concat(output, ' ')
	return false, error_msg
end

local function send_once_single(remote, key)
	-- format and execute command
	local cmd_str = string.format('irsend SEND_ONCE %s %s', remote, key)

	-- execute command
	return send(cmd_str)
end

local function send_once_multiple(remote, keys)
	-- format the command
	local cmd = {}
	table.insert(string.format('irsend SEND_ONCE %s', remote))

	-- place keys into string buffer
	for _, key in ipairs(keys) do
		table.insert(cmd, key)
	end
	local cmd_str = table.concat(cmd, ' ')

	-- execute command
	return send(cmd_str)
end

function irsend.send_once(remote, keys)
	-- check if multiple keys have been sent
	local key_type = type(keys)
	if key_type == 'string' then
		return send_once_single(remote, keys)
	elseif key_type == 'table' then
		return send_once_multiple(remote, keys)
	end
	
	return false, 'Key type not recognised'
end

return irsend