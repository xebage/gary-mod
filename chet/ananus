/*
	ananus pk script
  
	TODO:
		make viewmodel chams customizable
		fix chams, they are broke af rn
		add 180 shot (falcos idea)
		add tracers
*/

jit.flush()

local Cache = {
	ScrW = ScrW(),
	ScrH = ScrH(),
	
	Menu = nil,
	
	LocalPlayer = LocalPlayer(),
	
	_R = debug.getregistry(),
	
	Players = {},
	Entities = {},
	
	EntityClasses = {},
	AvatarFrames = {},
	
	Colors = {
		Black = Color(0, 0, 0),
	    Red = Color(255, 0, 0),
	    Blue = Color(0, 0, 255),
	    Green = Color(0, 255, 0),
	    Aqua = Color(0, 255, 255),	
	    Pink = Color(255, 0, 200),
	    Crimson = Color(175, 0, 42),
	    Greener = Color(132, 222, 2),
	    Gray = Color(155, 155, 155),
	    Orange = Color(255, 126, 0),
	    Violet = Color(178, 132, 190),
	    RedA = Color(255, 0, 0, 100),		
	    Purple = Color(160, 32, 240),
	    Seafoam = Color(201, 255, 229),
	    White = Color(255, 255, 255),
	    Yellow = Color(255, 255, 0, 255),
	    
	    Chams = {		
	    	Invisible = Color(255, 0, 0),
	    	Visible = Color(0, 255, 255),
	    	
	    	Props = {
	    		Base = Color(0, 255, 255),
	    		OverLay = Color(255, 40, 10)
	    	}
	    },
	    
	    Hitboxes = {
	    	Hitbox = Color(0, 0, 0),
	    	BoundingBox = Color(0, 255, 255)
	    }
	},

	Materials = { -- if you wanna add your own cham materials, then add the option on line 1005 or somewhere around there
		Visible = { -- if you know basic lua then you can do it, you got this	
			DebugWhite = CreateMaterial("@@@@@@@@@@@@@@@@@@@@@", "VertexLitGeneric", {
				["$basetexture"] = "models/debug/debugwhite",
				["$model"] = 1,
				["$ignorez"] = 0
			}),
		
			Cherry = CreateMaterial("@@@@@@@@@@@@@@@@@@@@@", "VertexLitGeneric", {
				["$basetexture"] = "vgui/white_additive",
				["$additive"] = 1,
				["$envmap"] = "",
				["$nofog"] = 1,
				["$model"] = 1,
				["$nocull"] = 1,
				["$selfillum"] = 1,
				["$halflambert"] = 1,
				["$znearer"] = 0,
				["$flat"] = 1,
				["$reflectivity"] = "[1 1 1]",
				["$ignorez"] = 0,
			}),
			
			 Waterish = CreateMaterial("@@@@@@@@@@@@@@@@@@", "VertexLitGeneric", {
				["$basetexture"] = "water/island_water01_normal",
				["$model"] = 1,
				["$additive"] = 1,
				["$nocull"] = 1,
				["$alpha"] = 1,
				["Proxies"] = {
					["TextureScroll"] = {
						["texturescrollvar"] = "$basetexturetransform",
						["texturescrollrate"] = 1,
						["texturescrollangle"] = math.abs(math.sin(SysTime() * 25) * 360),
					},
				},
			}),
		
			Woa = CreateMaterial("@@@@@@@@@@@@@@@@@@@@", "UnlitGeneric", { 
				["$basetexture"] = "props/tvscreen005a", 
				["$ignorez"] = 1, 		
				["$model"] = 1,
				["$detail"] = "models/debug/debugwhite`",
				["$translucent" ] = 0,
				["$wireframe"] = 1,
				["$selfillum"] = 144,
			})
		},

		Invisible = {
			DebugWhite = CreateMaterial("@@@@@@@@@@@@@@@@@@@@", "VertexLitGeneric", {
				["$basetexture"] = "models/debug/debugwhite",
				["$model"] = 1,
				["$ignorez"] = 1
			}),
		
			Woa = CreateMaterial("@@@@@@@@@@@@@@@@@@@@", "UnlitGeneric", { 
				["$basetexture"] = "props/tvscreen005a", 
				["$ignorez"] = 1, 		
				["$model"] = 1,
				["$detail"] = "models/debug/debugwhite`",
				["$translucent" ] = 0,
				["$wireframe"] = 1,
				["$selfillum"] = 144,
			})
		},
	
		Overlay = {
			Wireframe = CreateMaterial("@@@@@@@@@@@@@@@@@@@@", "", {
				["$basetexture"] = "models/wireframe",
				["$ignorez"] = 1
			}),
			
			Glow = CreateMaterial("@@@@@@@@@@@@@@@@@@@@", "VertexLitGeneric", { -- Wireframe Glow Federal HeMovin
				["$additive"] = "1", 
				["$basetexture"] = "vgui/white_additive",
				["$bumpmap"] = "vgui/white_additive",
				["$selfillum"] = "1",
				["$selfIllumFresnel"] = "1",
				["$selfIllumFresnelMinMaxExp"] = "[0 0.15 0.1]",
				["$selfillumtint"] = "[0 0 0]",
				["$ignorez"] = 1,
			}),
		
			Federal = CreateMaterial("@@@@@@@@@@@@@@@@@@@@", "UnlitGeneric", {
				["$basetexture"] = "Models/effects/comball_tape",
				["$nodecal"] = 1,
				["$model"] = 1,
				["$additive"] = 1,
				["$selfillum" ] = 144,
				["$wireframe" ] = 1,
				["$selfillum" ] = 54,
			
				Proxies = {
					TextureScroll = {
						texturescrollvar = "$basetexturetransform",
						texturescrollrate = 0.2,
						texturescrollangle = 70,
			        }
			    }
			}),
		
			HeMovin = CreateMaterial("@@@@@@@@@@@@@@@@@@@@", "UnlitGeneric", {
				["$basetexture"] = "models/debug/debugwhite",
				["$nodecal"] = 1,
				["$model"] = 1,
				["$selfillum"] = 144,
				["$additive"] = 1,
				["$wireframe"] = 1,
				["$selfillum"] = 61,
			
			    Proxies = {
			        TextureScroll = {
			            texturescrollvar = "$basetexturetransform",
			            texturescrollrate = 0.2,
			            texturescrollangle = 50,
			        }
			    }
			})
		}
	},
	
	NetVars = {
		BuildMode = { "BuildMode","buildmode", "_Kyle_Buildmode", "BuildMode" },
		GodMode = { "has_god" },
		Protected = { "LibbyProtectedSpawn", "SH_SZ.Safe", "spawn_protect", "InSpawnZone" }
	},

	ConVars = {
		cl_sidespeed = GetConVar("cl_sidespeed"),
		cl_forwardspeed = GetConVar("cl_forwardspeed")
	},
	
	BitFlags = {
		Enabled = bit.lshift(1, 0),
		Box = bit.lshift(1, 1),
		BoxTD = bit.lshift(1, 2),
		Name = bit.lshift(1, 3),
		Weapon = bit.lshift(1, 4),
		Skeleton = bit.lshift(1, 5),
		HealthBar = bit.lshift(1, 6),
		Flags = bit.lshift(1, 7),
		Avatar = bit.lshift(1, 8)
	}
}

local Vars = {
	ESP = {
		PlayerFlags = bit.bor(Cache.BitFlags.Enabled, Cache.BitFlags.Name),
		EntityFlags = bit.bor(Cache.BitFlags.Box, Cache.BitFlags.Name),

		PlayerColor = Color(255, 0, 0, 255),
		FriendColor = Color(255, 255, 0, 255),
		EntityColor = Color(200, 0, 255, 255),
	},

	PlayerChams = true,
	PlayerChams_Visible = true,
	PlayerChams_Invisible = true,
	
	PlayerCham_Visible_Color = Color(0, 200, 255),
	PlayerCham_Invisible_Color = Color(200, 20, 10),
	
	PlayerCham_Visible_Material = "DebugWhite",
	PlayerCham_Invisible_Material = "DebugWhite",
			
	PropChams = true,
	PropChams_Overlay = true,
	
	PropCham_Material = "DebugWhite",
	PropCham_Overlay_Material = "DebugWhite",
	
	PropCham_Color = Color(0, 255, 255),
	PropCham_Overlay_Color = Color(220, 20, 20),
	
	Hitboxes = false,
	BoundingBox = false,

	Bhop = true,
	AutoStrafe = true,

	Tracers = true,
	KillSound = true,
	FOV = 116,
		
	Crosshair = true,
	Length = 2,
	Width = 1,
	Color = Color(255, 0, 0, 0),
	
	ThirdPerson = false,
	TPS_Distance = 120,
	TPS_Yaw = 0
}

-- metatable functions are swag

local _Registry = debug.getregistry()

local meta_en_g = _Registry.Entity
local meta_pl_g = _Registry.Player
local meta_wn_g = _Registry.Weapon

meta_pl_g.IsInBuildMode = function(self)
	for i = 1, #Cache.NetVars.BuildMode do
		if self:GetNWBool(Cache.NetVars.BuildMode[i], false) then
			return true
		end
	end

	return false
end

meta_pl_g.IsInGodMode = function(self)
	if self:HasGodMode() then return true end

	for i = 1, #Cache.NetVars.GodMode do
		if self:GetNWBool(Cache.NetVars.GodMode[i], false) then
			return true
		end
	end

	return false
end

meta_pl_g.IsProtected = function(self)
	for i = 1, #Cache.NetVars.Protected do
		if self:GetNWBool(Cache.NetVars.Protected[i], false) then
			return true
		end
	end
	
	return false
end

meta_pl_g.IsTargetable = function(self)
	return self ~= Cache.LocalPlayer and self:Alive() and self:Team() ~= TEAM_SPECTATOR and self:GetObserverMode() == 0
end

meta_en_g.GetHealthColor = function(self)
	local Max = self:GetMaxHealth()
	local Health = math.Clamp(self:Health(), 0, Max)
	local Percent = Health * (Health / Max)

	if self._LastHealth ~= Health or not self._LastHealthColor then
		self._LastHealth = Health
		self._LastHealthColor = Color(255 - (Percent * 2.55), Percent * 2.55, 0)
	end
		
	return self._LastHealthColor, Percent / Health
end

meta_en_g.GetScreenCorners = function(self)
	if not IsValid(self) then
		return 0, 0, 0, 0
	end

	local Mins, Maxs = self:OBBMins(), self:OBBMaxs()

	local Coords = {
		self:LocalToWorld(Mins):ToScreen(),
    	self:LocalToWorld(Vector(Mins.x, Maxs.y, Mins.z)):ToScreen(),
    	self:LocalToWorld(Vector(Maxs.x, Maxs.y, Mins.z)):ToScreen(),
    	self:LocalToWorld(Vector(Maxs.x, Mins.y, Mins.z)):ToScreen(),

    	self:LocalToWorld(Maxs):ToScreen(),
    	self:LocalToWorld(Vector(Mins.x, Maxs.y, Maxs.z)):ToScreen(),
    	self:LocalToWorld(Vector(Mins.x, Mins.y, Maxs.z)):ToScreen(),
    	self:LocalToWorld(Vector(Maxs.x, Mins.y, Maxs.z)):ToScreen()
	}

	local Left, Right, Top, Bottom = Coords[1].x, Coords[1].x, Coords[1].y, Coords[1].y

	for _, v in ipairs(Coords) do
		if Left > v.x then
			Left = v.x
		end

		if Top > v.y then
			Top = v.y
		end

		if Right < v.x then
			Right = v.x
		end

		if Bottom < v.y then
			Bottom = v.y
		end
	end

	return math.Round(Left), math.Round(Right), math.Round(Top), math.Round(Bottom)
end

meta_pl_g.HasValidMoveType = function(self)
	return self:GetMoveType() == MOVETYPE_WALK and not IsValid(self:GetVehicle()) and self:WaterLevel() < 2
end

meta_pl_g.IsFriend = function(self)
	if not IsValid(self) then return false end

	return self:GetFriendStatus() == "friend"
end

meta_wn_g.GetBase = function(self)
	if not self.Base then return nil end

	return self.Base:lower():Split("_")[1]
end

meta_wn_g.IsBasedOnShort = function(self, Base)
	return self:GetBase() == Base
end

meta_wn_g.GetWeaponName = function(self)
	local Name = self:GetClass()
	
	if self.GetPrintName then
		local PrintName = self:GetPrintName()

		if PrintName == "<MISSING SWEP PRINT NAME>" then
			return Name
		end

		return language.GetPhrase(PrintName)
	end

	return Name
end

--- normal functions

local function DrawLineToScreen(first, second)
	surface.DrawLine(first.x, first.y, second.x, second.y)
end

local function BitflagHasValue(pFlags, pBit)
	return bit.band(pFlags, pBit) ~= 0
end

local function BitflagAddValue(pFlags, pBit)
	return bit.bor(pFlags, pBit)
end

local function BitflagRemoveValue(pFlags, pBit)
	return bit.band(pFlags, bit.bnot(pBit))
end

local function ESPBoxShouldRotate(Entity)
	return not (Entity:IsPlayer() or Entity:IsNPC() or Entity:IsNextBot())
end

local function GetESPColor(Entity)
	if not Entity:IsPlayer() then
	return Cache.Colors.Pink
	end

	return Entity:IsFriend() and Cache.Colors.Blue or Cache.Colors.Red
end

local function ShouldRunESP(Entity)
	if not IsValid(Entity) then return false end

	if not Entity:IsPlayer() then
		return Cache.EntityClasses[Entity:GetClass()] or false
	end

	return Entity:Alive() and Entity:Team() ~= TEAM_SPECTATOR and Entity:GetObserverMode() == OBS_MODE_NONE and not Entity:IsDormant()
end

local angle_zero = angle_zero * 1
local vector_all = Vector(0.3, 0.3, 0.3)

local function DoESP(Entity, pFlags)
	if not ShouldRunESP(Entity) then return end
	if not BitflagHasValue(pFlags, Cache.BitFlags.Enabled) then return end

	if not Entity:WorldSpaceCenter():ToScreen().visible then return end

	surface.SetFont("DebugOverlay")

	local ESPColor = GetESPColor(Entity)

	local Left, Right, Top, Bottom = Entity:GetScreenCorners()
	local w, h = Right - Left, Bottom - Top

	if BitflagHasValue(pFlags, Cache.BitFlags.Box) then
		surface.SetDrawColor(ESPColor)
		surface.DrawOutlinedRect(Left, Top, w - 1, h - 1)

		surface.SetDrawColor(Cache.Colors.Black)
		surface.DrawOutlinedRect(Left - 1, Top - 1, w + 1, h + 1)
		surface.DrawOutlinedRect(Left + 1, Top + 1, w - 3, h - 3)
	end

	if BitflagHasValue(pFlags, Cache.BitFlags.BoxTD) then
		local EntityPos = Entity:GetPos()
		local Mins, Maxs = Entity:GetCollisionBounds()
		local EntityAngle = ESPBoxShouldRotate(Entity) and Entity:GetAngles() or angle_zero

		cam.Start3D()
			render.DrawWireframeBox(EntityPos, EntityAngle, Mins + vector_all, Maxs - vector_all, Cache.Colors.Black)
				render.DrawWireframeBox(EntityPos, EntityAngle, Mins, Maxs, ESPColor)
			render.DrawWireframeBox(EntityPos, EntityAngle, Mins - vector_all, Maxs + vector_all, Cache.Colors.Black)
		cam.End3D()
	end

	if BitflagHasValue(pFlags, Cache.BitFlags.Name) then
		local Name = Entity:IsPlayer() and Entity:GetName() or Entity:GetClass()
		local tw, th = surface.GetTextSize(Name)

		surface.SetTextColor(Cache.Colors.White)
		surface.SetTextPos(Left + (w / 2) - (tw / 2), Top - th)
		surface.DrawText(Name)
	end

	if BitflagHasValue(pFlags, Cache.BitFlags.Weapon) and Entity.GetActiveWeapon then
		local Weapon = Entity:GetActiveWeapon()

		if IsValid(Weapon) then
			local Name = Weapon:GetWeaponName()
			local tw, th = surface.GetTextSize(Name)
			
			surface.SetTextColor(Cache.Colors.White)
			surface.SetTextPos(Left + (w / 2) - (tw / 2), Bottom)
			surface.DrawText(Name)
		end
	end

	if BitflagHasValue(pFlags, Cache.BitFlags.Skeleton) then
		surface.SetDrawColor(ESPColor)

		for i = 0, Entity:GetBoneCount() - 1 do
			local parent = Entity:GetBoneParent(i)
			if not parent or parent == -1 then continue end

			local pbhb = Entity:BoneHasFlag(parent, BONE_USED_BY_HITBOX)
			local bhb = Entity:BoneHasFlag(i, BONE_USED_BY_HITBOX)
			if not pbhb or not bhb then continue end

			local pbm = Entity:GetBoneMatrix(parent)
			local bm = Entity:GetBoneMatrix(i)
			if not pbm or not bm then continue end

			local ppos = pbm:GetTranslation()
			local pos = bm:GetTranslation()
			if not ppos or not pos then continue end

			DrawLineToScreen(ppos:ToScreen(), pos:ToScreen())
		end
	end

	if BitflagHasValue(pFlags, Cache.BitFlags.HealthBar) then
		local hw, s = 4, 2

		local Health = Entity:Health()

		surface.SetDrawColor(Cache.Colors.Black)
		surface.DrawOutlinedRect(Left - s - hw, Top - 1, hw, h + 1)

		surface.SetDrawColor(Cache.Colors.Gray)
		surface.DrawRect((Left - s - hw) + 1, Top, hw - 2, h - 1)

		local HealthColor, HealthPercent = Entity:GetHealthColor()
		local HealthScreen = math.Round((h * HealthPercent) - 1)
		local HealthPos = (Bottom - HealthScreen) - 1

		surface.SetDrawColor(HealthColor)
		surface.DrawRect((Left - s - hw) + 1, HealthPos, hw - 2, HealthScreen)

		if Health ~= Entity:GetMaxHealth() then
			local tw, th = surface.GetTextSize(Health)

			surface.SetTextColor(Cache.Colors.White)
			surface.SetTextPos(Left - s - hw - tw, math.Clamp(HealthPos, HealthPos - (th / 3), Bottom - th))
			surface.DrawText(Health)
		end
	end

	if Entity:IsPlayer() then
		if BitflagHasValue(pFlags, Cache.BitFlags.Flags) then
	        surface.SetTextColor(Cache.Colors.Seafoam)
	
	        local pFlags = {}
	
	        if Entity:IsInGodMode() then
	            pFlags[#pFlags + 1] = "*Godmode*"
	        end
	
	        if Entity:IsInBuildMode() then
	            pFlags[#pFlags + 1] = "*Build Mode*"
	        end
	
	        if Entity:IsProtected() then
	            pFlags[#pFlags + 1] = "*Protected*"
	        end
			
			if Entity:IsDormant() then
	            pFlags[#pFlags + 1] = "*Dormant*"
	        end
			
	        if #pFlags > 0 then
	            local ypos = Top
	            local _, th = surface.GetTextSize(pFlags[1])
	
	            for _, v in ipairs(pFlags) do
	                surface.SetTextPos(Right, ypos)
	                surface.DrawText(v)
	
	                _, th = surface.GetTextSize(v)
	                ypos = ypos + th
	            end
	        end
	    end
	    
	    if BitflagHasValue(pFlags, Cache.BitFlags.Avatar) and IsValid(Cache.AvatarFrames[Entity:SteamID64() or "BOT"]) then
			local x = Left + (w / 2) - 8
			local y = Top - 24

			if BitflagHasValue(pFlags, Cache.BitFlags.Name) then
				local tw, th = surface.GetTextSize(Entity:GetName() or Entity:Name() or Entity:Nick())
				y = y - th
			end

			Cache.AvatarFrames[Entity:SteamID64() or "BOT"]:PaintAt(x, y)
		end
	end
end

timer.Create("sup", 0.3, 0, function()
	table.Empty(Cache.Players)
	table.Merge(Cache.Players, player.GetAll()) -- best way of getting a table of all players lol
		
	Cache.Entities = ents.GetAll()

	table.sort(Cache.Entities, function(a, b)
		return a:EntIndex() < b:EntIndex()
	end)

	for i = #Cache.Entities, 1, -1 do
		if Cache.Entities[i]:EntIndex() < 0 then
			table.remove(Cache.Entities, i)
		end
	end
	
	for i = 1, #Cache.Players do
		if BitflagHasValue(Vars.ESP.PlayerFlags, Cache.BitFlags.Avatar) then
			if not IsValid(Cache.AvatarFrames[Cache.Players[i]:SteamID64() or "BOT"]) then
				local pAvatar = vgui.Create("AvatarImage")

				pAvatar:SetSize(16, 16)
				pAvatar:SetVisible(false)
				pAvatar:SetPaintedManually(true)
				pAvatar:SetPlayer(Cache.Players[i], 16)

				Cache.AvatarFrames[Cache.Players[i]:SteamID64() or "BOT"] = pAvatar
			end
		end
	end
end)

local GroundTick = 0
local function Bhop(cmd)
	if not Vars.Bhop then return end
	if Cache.LocalPlayer:GetMoveType() ~= MOVETYPE_WALK or IsValid(Cache.LocalPlayer:GetVehicle()) or Cache.LocalPlayer:WaterLevel() > 2 then return end
	if not cmd:KeyDown(IN_JUMP) then return end
	
	if Cache.LocalPlayer:IsOnGround() then 
		GroundTick = GroundTick + 1
		
		if GroundTick > 3 then 
			cmd:RemoveKey(IN_JUMP)
			GroundTick = 0
		end
	else
		cmd:RemoveKey(IN_JUMP)
		GroundTick = 0
	end
end

local function AutoStrafe(cmd)
	if not Vars.AutoStrafe then return end
	if Cache.LocalPlayer:IsOnGround() then return end
	
	local MaxSideMove = Cache.ConVars.cl_sidespeed:GetFloat()
	
	if cmd:GetMouseX() > 0 then 
		cmd:SetSideMove(MaxSideMove)
	elseif cmd:GetMouseX() < 0 then
		cmd:SetSideMove(MaxSideMove * -1)
	end
end

hook.Add("CreateMove", "", function(cmd)
	Bhop(cmd)
	AutoStrafe(cmd)
end)
     
hook.Add("PreDrawViewModel", "", function()
	if IsDrawingGlow then
		render.SetColorModulation(1, 0, 0)
		render.MaterialOverride( mat )
		render.MaterialOverride(Glow)
	else
		render.SetColorModulation(0, 0, 0)
	end
	render.SetBlend(1)
end)	
     
hook.Add("PostDrawViewModel", "", function()
	render.SetColorModulation(1, 1, 1)
	render.MaterialOverride(None)
	render.SetBlend(1)
	render.SuppressEngineLighting(false)
     
	if IsDrawingGlow then return end
     
	IsDrawingGlow = true
	Cache.LocalPlayer:GetViewModel():DrawModel()
	IsDrawingGlow = false
end)

local function ShowHitboxes(Entity)
	if Vars.Hitboxes then
		Entity:SetupBones()

		if Entity:GetHitBoxGroupCount() == nil then return end
		
		for Group = 0, Entity:GetHitBoxGroupCount() - 1 do
		 	for Hitbox = 0, Entity:GetHitBoxCount(Group) - 1 do
		 		local Position, Angle = Entity:GetBonePosition(Entity:GetHitBoxBone(Hitbox, Group))
		 		local Mins, Maxs = Entity:GetHitBoxBounds(Hitbox, Group)

				render.DrawWireframeBox(Position, Angle, Mins, Maxs, Cache.Colors.Hitboxes.Hitbox, true)
			end
		end
	
		if Vars.BoundingBox then
			local Mins, Maxs = Entity:GetCollisionBounds()
			render.DrawWireframeBox(Entity:GetPos(), Entity:IsPlayer() and angle_zero or Entity:GetAngles(), Mins, Maxs, Cache.Colors.Hitboxes.BoundingBox, true)
		end
	end
end

local function Chams(Entity)
	if Entity:IsPlayer() then
		if not Vars.PlayerChams then return end
		
		local Weapon = Entity.GetActiveWeapon and Entity:GetActiveWeapon() or NULL

		if Vars.PlayerChams_Invisible then
			local Color = Vars.PlayerCham_Invisible_Color
			local Material = Vars.PlayerCham_Invisible_Material
			
			render.SetColorModulation(Color.r / 255, Color.g / 255, Color.b / 255)
			render.SetBlend(Color.a / 255)
			render.MaterialOverride(Cache.Materials.Invisible[Material])
			
			Entity:DrawModel()
			if Weapon:IsValid() then Weapon:DrawModel() end
		end

		if Vars.PlayerChams_Visible then
			local Color = Vars.PlayerCham_Visible_Color
			local Material = Vars.PlayerCham_Visible_Material
			
			render.SetColorModulation(Color.r / 255, Color.g / 255, Color.b / 255)
			render.SetBlend(Color.a / 255)
			render.MaterialOverride(Cache.Materials.Visible[Material])

			Entity:DrawModel()
			if Weapon:IsValid() then Weapon:DrawModel() end
		end
	else
		if not Vars.PropChams then return end
		
		local Dist = Entity:GetPos():Distance(Cache.LocalPlayer:GetPos()) / 500
			
		local Color = Vars.PropCham_Color
		local Material = Vars.PropCham_Material
		
		cam.Start3D()
			render.SuppressEngineLighting(true)
			render.MaterialOverride(Cache.Materials.Invisible[Material])
			Entity:SetRenderMode(RENDERMODE_TRANSALPHA)
			render.SetColorModulation(Color.r, Color.g, Color.b)
			render.SetBlend(0.08 + Dist)
			Entity:DrawModel()
			render.SuppressEngineLighting(false)
			render.MaterialOverride(nil)
			
			-- overlay
			if Vars.PropChams_Overlay then
				local OverLayColor = Vars.PropCham_Overlay_Color
				local OverlayMaterial = Vars.PropCham_Overlay_Material
			
				render.SuppressEngineLighting(true)
				render.MaterialOverride(Cache.Materials.Overlay[OverlayMaterial])
				Entity:SetRenderMode(RENDERMODE_TRANSALPHA)
				render.SetColorModulation(OverLayColor.r, OverLayColor.g, OverLayColor.b)
				render.SetBlend(100 / 255)
							
				Entity:DrawModel()
							
				render.SuppressEngineLighting(false)
				render.MaterialOverride(nil)
			end
		cam.End3D()
	end
end

hook.Add("PostDrawHUD", "@@@@@@@@@@@", function()
	local PlayerFlags = Vars.ESP.PlayerFlags
	local FriendFlags = Vars.ESP.FriendFlags
	local EntityFlags = Vars.ESP.EntityFlags

	local EntsThisFrame = {}
	
	if BitflagHasValue(PlayerFlags, Cache.BitFlags.Enabled) then
		for i = 1, #Cache.Players do
			if Cache.Players[i] == Cache.LocalPlayer or not IsValid(Cache.Players[i]) then continue end

			EntsThisFrame[#EntsThisFrame + 1] = {Cache.Players[i], PlayerFlags}
		end
	end

	if BitflagHasValue(Vars.ESP.EntityFlags, Cache.BitFlags.Enabled) then
		for i = 1, #Cache.Entities do
			if not IsValid(Cache.Entities[i]) or Cache.Entities[i]:IsPlayer() then continue end
			EntsThisFrame[#EntsThisFrame + 1] = {Cache.Entities[i], EntityFlags}
		end
	end

	local lpos = Cache.LocalPlayer:GetPos()

	table.sort(EntsThisFrame, function(a, b)
		return a[1]:GetPos():DistToSqr(lpos) > b[1]:GetPos():DistToSqr(lpos)
	end)
	
	cam.Start2D() -- fix for the avatar thing cause its a bit fucky without
		for i = 1, #EntsThisFrame do
			DoESP(EntsThisFrame[i][1], EntsThisFrame[i][2])
		end
	cam.End2D()
end)

hook.Add("PreDrawEffects", "", function()
	local Blend = render.GetBlend()
	
	local EntsThisFrame = {}
	
	if Vars.PlayerChams then
		for i = 1, #Cache.Players do	
			if not IsValid(Cache.Players[i]) or not Cache.Players[i]:IsTargetable() then continue end
	
			EntsThisFrame[#EntsThisFrame + 1] = Cache.Players[i]
		end
	end
	
	if Vars.PropChams then
		for _, v in ipairs(ents.FindByClass("prop_physics")) do
			if not IsValid(v) then continue end
			
			EntsThisFrame[#EntsThisFrame + 1] = v
		end
	end
	
	for i = 1, #EntsThisFrame do
		Chams(EntsThisFrame[i])
		ShowHitboxes(EntsThisFrame[i])
	end
	
	-- Reset everything
	render.SetBlend(Blend)
	render.SetColorModulation(1, 1, 1)
	render.MaterialOverride(nil)
end)

hook.Add("CalcView", "", function(Player, Position, Angle, FOV, ZNear, ZFar)
	if not IsValid(Player) then return end	

	local View = {
		origin = Vars.ThirdPerson and Position - ((Angle - Angle(0, Vars.TPS_Yaw, 0)):Forward() * Vars.TPS_Distance) or Position,
		angles = Angle,
		fov = Vars.FOV,
		znear = ZNear,
		zfar = ZFar,
		drawviewer = Vars.Thirdperson
	}

	return View
end)

concommand.Add("an_menu", function()
	if not IsValid(Cache.Menu) then return end

	Cache.Menu:SetVisible(true)
	Cache.Menu:MakePopup()

	if IsValid(Cache.MenuEntityList) then
		Cache.MenuEntityList:CacheUpdate()
	end
end)

concommand.Add("an_unload", function()
	hook.Remove("CreateMove", "")
	hook.Remove("PreDrawViewModel", "")
	hook.Remove("PostDrawViewModel", "")
	hook.Remove("PostDrawHUD", "@@@@@@@@@@@")
	hook.Remove("PreDrawEffects", "")
	hook.Remove("CalcView", "")
	timer.Remove("sup")
	
	concommand.Remove("an_menu")
	concommand.Remove("an_unload")
end)


-- Menu Creation

do
	
	local function MakeBitFlagCheckBox(parent, x, y, label, pFlags, pBit)
		local CheckBox = vgui.Create("DCheckBoxLabel", parent)
		CheckBox:SetPos(x, y)
		CheckBox:SetText(label)
		CheckBox:SetChecked(BitflagHasValue(Vars.ESP[pFlags], pBit))
		CheckBox:SetTextColor(Cache.Colors.Black)
	
		CheckBox._pFlags = pFlags
		CheckBox._pBit = pBit
		
		CheckBox.OnChange = function(self, new)
			local tFlags = Vars.ESP[self._pFlags]
	
			if new then
				Vars.ESP[self._pFlags] = BitflagAddValue(tFlags, self._pBit)
			else
				Vars.ESP[self._pFlags] = BitflagRemoveValue(tFlags, self._pBit)
			end
		end
	end
	
	local function MakeCheckBox(Parent, X, Y, Name, Val)
        local CheckBox = vgui.Create("DCheckBoxLabel", Parent)
        CheckBox:SetText(tostring(Name))
        CheckBox:SetPos(X, Y)
        CheckBox:SetChecked(Vars[Val])
        CheckBox:SetTextColor(Cache.Colors.Black)
        	
        CheckBox.OnChange = function(self, new)
        	Vars[Val] = new
        end
    end
    
    local function MakeSlider(Parent, X, Y, W, H, Name, Min, Max, Val)
        local NewSlider = vgui.Create("DNumSlider", Parent)
		NewSlider:SetMin(Min)
		NewSlider:SetMax(Max)
		NewSlider:SetText(Name)
		NewSlider:SetSize(W, H)
		NewSlider:SetPos(X, Y)
		NewSlider:SetValue(Vars[Val])
		NewSlider:SetDecimals(0)
		
        NewSlider.OnValueChanged = function(self, NewVal)
            Vars[Val] = NewVal
        end
    end
    
    local function AddColorbox(Parent, X, Y, Table, Key)
		local Colorbox = vgui.Create("DButton", Parent)
		Colorbox:SetSize(15, 15)
		Colorbox:SetText("")
		Colorbox:SetPos(X, Y)
		Colorbox.m_tTable = Table
		Colorbox.m_strKey = Key

		function Colorbox:Paint(Width, Height)
			surface.SetDrawColor(Cache.Colors.Black)
			surface.DrawRect(0, 0, Width, Height)
			
			surface.SetDrawColor(self.m_tTable[self.m_strKey])
			surface.DrawRect(1, 1, Width - 2, Height - 2)
		end

		function Colorbox:DoClick()
			local ScreenX, ScreenY = self:LocalToScreen(0, 0)

			local ColorPanel = vgui.Create("DPanel")
			ColorPanel:SetSize(190, 130)
			ColorPanel:DockPadding(4, 4, 4, 4)
			ColorPanel:SetPos(ScreenX, ScreenY + self:GetTall() + 5)
			ColorPanel:MakePopup()

			function ColorPanel:PerformLayout()
				function self:Think()
					if not self:HasFocus() then
						self:Remove()
					end
				end
			end

			function ColorPanel:Paint(Width, Height)
				surface.SetDrawColor(Cache.Colors.White)
				surface.DrawRect(1, 1, Width - 2, Height - 2)

				surface.SetDrawColor(Cache.Colors.Black)
				surface.DrawOutlinedRect(0, 0, Width, Height)
			end

			ColorPanel:InvalidateLayout()

			local Mixer = vgui.Create("DColorMixer", ColorPanel)
			Mixer:Dock(FILL)
			Mixer:SetPalette(false)
			Mixer:SetWangs(false)
			Mixer:SetColor(self.m_tTable[self.m_strKey])
			Mixer:SetSkin("Default")

			Mixer.m_tTable = self.m_tTable
			Mixer.m_strKey = self.m_strKey

			function Mixer:ValueChanged(NewColor)
				debug.setmetatable(NewColor, Cache._R.Color)
				self.m_tTable[self.m_strKey] = NewColor
			end
		end
	end
	
	local Main = vgui.Create("DFrame")
	Main:SetSize(400, 325)
	Main:Center()
	Main:SetTitle("ananus thing")
	Main:SetVisible(false)
	Main:SetDeleteOnClose(false)
	
	local MainTabs = vgui.Create("DPropertySheet", Main)
	MainTabs:Dock(FILL)
	local PlayerPanel = vgui.Create("DPanel", MainTabs)
	MainTabs:AddSheet("Players", PlayerPanel)

	-- Players

	MakeBitFlagCheckBox(PlayerPanel, 25, 25, "ESP Enabled", "PlayerFlags", Cache.BitFlags.Enabled)
	MakeBitFlagCheckBox(PlayerPanel, 50, 50, "Box", "PlayerFlags", Cache.BitFlags.Box)
	MakeBitFlagCheckBox(PlayerPanel, 50, 75, "3D Box", "PlayerFlags", Cache.BitFlags.BoxTD)
	MakeBitFlagCheckBox(PlayerPanel, 50, 100, "Name", "PlayerFlags", Cache.BitFlags.Name)
	MakeBitFlagCheckBox(PlayerPanel, 50, 125, "Weapon", "PlayerFlags", Cache.BitFlags.Weapon)
	MakeBitFlagCheckBox(PlayerPanel, 50, 150, "Skeleton", "PlayerFlags", Cache.BitFlags.Skeleton)
	MakeBitFlagCheckBox(PlayerPanel, 50, 175, "Healthbar", "PlayerFlags", Cache.BitFlags.HealthBar)
	MakeBitFlagCheckBox(PlayerPanel, 50, 200, "Flags", "PlayerFlags", Cache.BitFlags.Flags)
	MakeBitFlagCheckBox(PlayerPanel, 50, 225, "Avatar", "PlayerFlags", Cache.BitFlags.Avatar)
	
	-- player chams
	
	MakeCheckBox(PlayerPanel, 155, 25, "Chams Enabled", "PlayerChams")
	MakeCheckBox(PlayerPanel, 180, 50, "Visible Chams", "PlayerChams_Visible")
	MakeCheckBox(PlayerPanel, 180, 75, "Invisible Chams", "PlayerChams_Invisible")
	
	AddColorbox(PlayerPanel, 315, 50, Vars, "PlayerCham_Visible_Color")
	AddColorbox(PlayerPanel, 315, 75, Vars, "PlayerCham_Invisible_Color")
	
	local VisibleMaterial = vgui.Create("DComboBox", PlayerPanel)
	VisibleMaterial:SetPos(180, 100)
	VisibleMaterial:SetSize(100, 20)
	VisibleMaterial:SetValue("Visible Mat")
	VisibleMaterial:AddChoice("DebugWhite")
	VisibleMaterial:AddChoice("Cherry")
	VisibleMaterial:AddChoice("Waterish")
	VisibleMaterial:AddChoice("Woa")
	VisibleMaterial.OnSelect = function(self, index, value)
		Vars.PlayerCham_Visible_Material = value
	end
	
	local InvisibleMaterial = vgui.Create("DComboBox", PlayerPanel)
	InvisibleMaterial:SetPos(180, 125)
	InvisibleMaterial:SetSize(100, 20)
	InvisibleMaterial:SetValue("Invisible Mat")
	InvisibleMaterial:AddChoice("DebugWhite")
	InvisibleMaterial.OnSelect = function(self, index, value)
		Vars.PlayerCham_Invisible_Material = value
	end
	
	--- Hitboxes
	
	MakeCheckBox(PlayerPanel, 155, 150, "Hitboxes", "Hitboxes")
	MakeCheckBox(PlayerPanel, 180, 175, "Bounding Box", "BoundingBox")
	
	local EntityPanel = vgui.Create("DPanel", MainTabs)
	MainTabs:AddSheet("Entity ESP", EntityPanel)

	-- Entity ESP

	MakeBitFlagCheckBox(EntityPanel, 25, 25, "Enabled", "EntityFlags", Cache.BitFlags.Enabled)
	MakeBitFlagCheckBox(EntityPanel, 50, 50, "Box", "EntityFlags", Cache.BitFlags.Box)
	MakeBitFlagCheckBox(EntityPanel, 50, 75, "3D Box", "EntityFlags", Cache.BitFlags.BoxTD)
	MakeBitFlagCheckBox(EntityPanel, 50, 100, "Name", "EntityFlags", Cache.BitFlags.Name)
	MakeBitFlagCheckBox(EntityPanel, 50, 125, "Weapon", "EntityFlags", Cache.BitFlags.Weapon)
	MakeBitFlagCheckBox(EntityPanel, 50, 150, "Skeleton", "EntityFlags", Cache.BitFlags.Skeleton)
	MakeBitFlagCheckBox(EntityPanel, 50, 175, "Healthbar", "EntityFlags", Cache.BitFlags.HealthBar)
	
	--- Misc panel
	
	local MiscPanel = vgui.Create("DPanel", MainTabs)
	MainTabs:AddSheet("Misc", MiscPanel)
	
	MakeCheckBox(MiscPanel, 25, 25, "Bhop", "Bhop")
	MakeCheckBox(MiscPanel, 25, 50, "AutoStrafe", "AutoStrafe")
	
	MakeSlider(MiscPanel, 25, 75, 230, 20, "FOV", 0, 180, "FOV")
	
	---- Entity list

	local EntityListPanel = vgui.Create("DPanel", MainTabs)
	MainTabs:AddSheet("Entity List", EntityListPanel)

	local EntityList = vgui.Create("DListView", EntityListPanel)
	EntityList:Dock(FILL)
	EntityList:AddColumn("Class")
	EntityList:AddColumn("Show on ESP")

	EntityList.CacheUpdate = function(self)
		self:Clear()

		local Added = {}

		for i = 1, #Cache.Entities do
			if not IsValid(Cache.Entities[i]) then continue end

			local Class = Cache.Entities[i]:GetClass()

			if not Added[Class] then
				self:AddLine(Class, Cache.EntityClasses[Class] and "True" or "False")
				Added[Class] = true
			end
		end

		for k, _ in pairs(scripted_ents.GetList()) do
			if not Added[k] then
				self:AddLine(k, Cache.EntityClasses[k] and "True" or "False")
				Added[k] = true
			end
		end
	end

	EntityList.OnRowSelected = function(self, _, row)
		Cache.EntityClasses[row:GetValue(1)] = not Cache.EntityClasses[row:GetValue(1)]
		self:CacheUpdate()
	end

	Cache.Menu = Main
	Cache.MenuEntityList = EntityList
end
