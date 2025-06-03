#!/bin/env lua

local utils = require("myutils")
local bash = require("bash")
local server = "shen"
require("mylfs").chdir(utils.get_dir() .. "/..")

if bash.shRet("echo $TMUX") == "" then
	os.execute("tmux -L " .. server .. ' new-session "' .. table.concat(arg, " ", 0) .. '; bash"')
	return
elseif not bash.shRet("tmux display -p '#{socket_path}'"):match(".*/" .. server .. "$") then
	os.execute('tmux detach -E "' .. table.concat(arg, " ", 0) .. '"')
	return
end

local cmd = "nvim ./matchups"
if arg[1] then
	utils.set_package_path()
	local name = require("names")(arg[1])
	if name then
		cmd = 'nvim "./matchups/' .. name .. '"'
	else
		cmd = 'echo "didnt find name"'
	end
end
os.execute('tmux neww -d "' .. cmd .. '"')
os.execute('nvim "./reference-points"')
