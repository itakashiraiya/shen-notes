local M = {}

local names = "./dev/names"
local aliases = "./dev/aliases"

local function escape(text)
	return text:gsub("([^%w])", "%%%1")
end

local function get_alias(alias)
	io.open(aliases, "a"):close()
	local file, err = io.open(aliases, "r")
	if not file then
		print("get_alias: " .. err)
		return
	end
	local name
	for line in file:lines() do
		name = line:match("^" .. escape(alias) .. "=(.*)")
		if name then
			break
		end
	end
	file:close()
	return name
end

local function get_name(name)
	io.open(names, "a"):close()
	local file, err = io.open(names, "r")
	if not file then
		print("get_name: " .. err)
		return
	end
	for line in file:lines() do
		if line:match("^" .. escape(name) .. "$") then
			file:close()
			return name
		end
	end
	file:close()
	return nil
end

M.name = function(name)
	return get_alias(name) or get_name(name)
end

M.add = function(name)
	if get_name(name) then
		return nil, "This character is already added!"
	end

	local file, err = io.open(names, "a")
	if not file then
		print("add: " .. err)
		return nil
	end
	file:write(name .. "\n")
	file:close()
	return name
end

M.add_alias = function(alias, name)
	if not get_name(name) then
		return nil, "There is no such character :("
	end
	if get_alias(alias) then
		return nil, "This alias is already defined!"
	end

	local file, err = io.open(aliases, "a")
	if not file then
		print("add_alias: " .. err)
		return nil
	end
	file:write(alias .. "=" .. name .. "\n")
	file:close()
	return name
end

return M
