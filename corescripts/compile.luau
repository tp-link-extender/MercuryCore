--!strict
-- There's issues with running this file from windows so idk

local fs = require "@lune/fs"
local process = require "@lune/process"
local stdio = require "@lune/stdio"
local task = require "@lune/task"

local colour = stdio.color

local green = colour "green"
local red = colour "red"
local reset = colour "reset"

local normalCores = {}
local libraryCores = {
	"Fusion/init.luau",
	"Red/init.luau",
}
local otherCores = {}
local plugins = {}

-- Allow for running from the base or corescripts directories
local cwd = process.cwd
local fromCoresDir = not not string.match(cwd, "corescripts/$")
local normalCoresDir = if fromCoresDir then "./luau" else "./corescripts/luau"
local normalPluginsDir = if fromCoresDir
	then "./terrain plugins"
	else "./corescripts/terrain plugins"

for _, core in ipairs(fs.readDir(normalCoresDir)) do
	table.insert(
		-- normalCores should be ones with numbers
		if string.match(core, "%d+%.lua") then normalCores else otherCores,
		core
	)
end
for _, core in ipairs(fs.readDir(normalPluginsDir)) do
	print(core)
	table.insert(plugins, core)
end

local coresDir = if fromCoresDir then "." else "./corescripts"
local pluginsDir = if fromCoresDir
	then "../Client deployer"
	else "./Client deployer"

local function processCores(
	scripts: { string },
	startDir: string,
	endDir: string,
	config: "lines" | "dense",
	libraries: boolean?
)
	local configFile = if fromCoresDir
		then `../{config}.json5`
		else `{config}.json5`

	for i, core in ipairs(scripts) do
		local newCore = if libraries
			then `{10000000 + i}.lua`
			else string.gsub(core, "%.luau$", ".lua")

		print(`{coresDir}/{startDir}/{core}`, `{endDir}/{newCore}`)

		task.spawn(function()
			local cmd = process.spawn("darklua", {
				"process",
				"-c",
				configFile,
				`{coresDir}/{startDir}/{core}`,
				`{endDir}/{newCore}`,
			})

			print(
				if cmd.ok
					then `{green}Processed {core}{reset}`
					else `{red}Error processing {core}: {cmd.stderr}{reset}`
			)
		end)
	end
end

task.spawn(function()
	processCores(
		libraryCores,
		"Libraries",
		`{coresDir}/processed`,
		"dense",
		true
	)
end)

task.spawn(function()
	processCores(
		plugins,
		"terrain plugins",
		`{pluginsDir}/staging/BuiltInPlugins/terrain`,
		"lines"
	)
end)

task.spawn(function()
	processCores(normalCores, "luau", `{coresDir}/processed`, "dense")
end)

task.spawn(function()
	processCores(otherCores, "luau", `{coresDir}/processed`, "lines")
end)
