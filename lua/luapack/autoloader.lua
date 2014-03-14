local function RemoveExtension(filename)
	return filename:match("([^%.]+).lua")
end

local function LoadAutorun()
	local files = file.Find("autorun/*.lua", "LUA")
	for i = 1, #files do
		include("autorun/" .. files[i])
	end

	local files = file.Find("autorun/client/*.lua", "LUA")
	for i = 1, #files do
		include("autorun/client/" .. files[i])
	end
end

local function LoadVGUI()
	include("derma/init.lua")
	local files = file.Find("vgui/*.lua", "LUA")
	for i = 1, #files do
		include("vgui/" .. files[i])
	end
end

local function LoadBases()
	ENT = {
		Base = "base_entity",
		Type = "anim",
		ClassName = "base_anim"
	}

	include("base/entities/entities/base_anim.lua")

	scripted_ents.Register(ENT, "base_anim")
end

local function LoadEntities(path)
	local files, folders = file.Find(path .. "*", "LUA")
	for i = 1, #files do
		local file = files[i]

		ENT = {
			Base = "base_anim",
			Type = "anim",
			ClassName = RemoveExtension(file)
		}

		include(path .. file)
		scripted_ents.Register(ENT, RemoveExtension(file))
	end

	for i = 1, #folders do
		local folder = folders[i]

		ENT = {
			Base = "base_anim",
			Type = "anim",
			ClassName = folder
		}

		include(path .. folder .. "/cl_init.lua")

		scripted_ents.Register(ENT, folder)
	end
end

local function LoadWeapons(path)
	local files, folders = file.Find(path .. "*", "LUA")
	for i = 1, #files do
		local file = files[i]

		SWEP = {
			Primary = {},
			Secondary = {},
			Base = "weapon_base",
			ClassName = RemoveExtension(file)
		}

		include(path .. file)

		weapons.Register(SWEP, RemoveExtension(file))
	end

	for i = 1, #folders do
		local folder = folders[i]

		SWEP = {
			Primary = {},
			Secondary = {},
			Base = "weapon_base",
			ClassName = folder
		}

		include(path .. folder .. "/cl_init.lua")

		weapons.Register(SWEP, folder)
	end
end

local function LoadEffects(path)
	local files, folders = file.Find(path .. "*", "LUA")
	for i = 1, #files do
		local file = files[i]

		EFFECT = {}

		include(path .. file)

		effects.Register(EFFECT, RemoveExtension(file))
	end

	for i = 1, #folders do
		local folder = folders[i]

		EFFECT = {}

		include(path .. folder .. "/cl_init.lua")

		effects.Register(EFFECT, folder)
	end
end

LoadVGUI()
LoadAutorun()
LoadBases()
LoadEntities("entities/")
LoadWeapons("weapons/")
LoadEffects("effects/")

local gms = {}
local gm = GAMEMODE
while gm do
	print("GAMEMODE FOLDER", gm.FolderName)
	table.insert(gms, 1, gm.FolderName)
	gm = gm.BaseClass
end

for i = 1, #gms do
	local gm = gms[i]

	LoadEntities(gm .. "/entities/entities/")
	LoadWeapons(gm .. "/entities/weapons/")
	LoadEffects(gm .. "/entities/effects/")
end

--LoadGamemode(gms[#gms])