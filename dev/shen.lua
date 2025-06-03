#!/bin/env lua

local utils = require("myutils")
local bash = require("bash")
require("mylfs").chdir(utils.get_dir() .. "/..")
utils.set_package_path()
local names = require("names")
local server = "shen"

if arg[1] == "add" then
	if not arg[2] or arg[3] then
		print("Command [add] has 1 argument")
		return
	end
	local _, err = names.add(arg[2])
	if err then
		print(err)
	end
	return
elseif arg[1] == "add_alias" then
	if not arg[2] or not arg[3] or arg[4] then
		print("Command [add_alias] has 2 arguments")
		return
	end
	local _, err = names.add_alias(arg[2], arg[3])
	if err then
		print(err)
	end
	return
end

local name
print("debug: " .. (name or "nil"))
if arg[1] == "--internal-call" then
	if arg[3] then
		error("Internal call mal-formated!")
	end
	name = arg[2]
elseif arg[1] then
	if arg[2] then
		print("Can only specify one character!")
		return
	end
	name = names.name(arg[1])
	if not name then
		print("Character not found!")
		return
	end
end

if bash.shRet("echo $TMUX") == "" then
	os.execute("tmux -L " .. server .. ' new-session "' .. arg[0] .. " --internal-call " .. (name or "") .. '"')
	return
elseif not bash.shRet("tmux display -p '#{socket_path}'"):match(".*/" .. server .. "$") then
	os.execute('tmux detach -E "' .. arg[0] .. " --internal-call " .. (name or "") .. '"')
	return
end

local cmd = name and 'nvim "./matchups/' .. name .. '"' or "nvim ./matchups"
os.execute('tmux neww -d "' .. cmd .. '"')
os.execute('nvim "./reference-points"')
