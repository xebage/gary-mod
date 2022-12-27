/*
	ananus thing 
	TODO:
		make viewmodel chams customizable
		add 180 shot
		add tracers
*/

jit.flush() -- woot woot

local Cache = {
	ScrW = ScrW(),
	ScrH = ScrH(),
	
	Menu = nil,
	
	LocalPlayer = LocalPlayer(),
	
	_R = proxi and proxi._R or debug.getregistry(), -- B)
	
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
	},

	Materials = { -- if you wanna add your own cham materials, then add the option on line 1005 or somewhere around there
		Visible = { -- if you know literally the most basic lua then you can do it, you got this	
			DebugWhite = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "VertexLitGeneric", {
				["$basetexture"] = "models/debug/debugwhite",
				["$model"] = 1,
				["$ignorez"] = 0
			}),
		
			Cherry = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "VertexLitGeneric", {
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
			
			Waterish = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "VertexLitGeneric", {
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
		
			Woa = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "UnlitGeneric", { 
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
			DebugWhite = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "VertexLitGeneric", {
				["$basetexture"] = "models/debug/debugwhite",
				["$model"] = 1,
				["$ignorez"] = 1
			}),
		
			Woa = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "UnlitGeneric", { 
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
			Wireframe = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "", {
				["$basetexture"] = "models/wireframe",
				["$ignorez"] = 1
			}),
			
			Glow = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "VertexLitGeneric", { -- Wireframe Glow Federal HeMovin
				["$additive"] = "1", 
				["$basetexture"] = "vgui/white_additive",
				["$bumpmap"] = "vgui/white_additive",
				["$selfillum"] = "1",
				["$selfIllumFresnel"] = "1",
				["$selfIllumFresnelMinMaxExp"] = "[0 0.15 0.1]",
				["$selfillumtint"] = "[0 0 0]",
				["$ignorez"] = 1,
			}),
		
			Federal = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "UnlitGeneric", {
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
		
			HeMovin = CreateMaterial("hi" .. tostring(math.random(-10000, 10000)), "UnlitGeneric", {
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

    Chams = {
        Player = {
			Enabled = true,
            Visible = {
                Enabled = true,
                Color = Color(0, 255, 255),
                Material = "DebugWhite",
            },

            Invisible = {
                Enabled = true,
                Color = Color(255, 0, 0),
                Material = "DebugWhite",
            },
        },

        Prop = {
            Enabled = true,
            Color = Color(0, 200, 200),
            Material = "DebugWhite",

            Overlay = {
                Enabled = true,
                Color = Color(150, 10, 10),
                Material = "Wireframe"
            }
        }
    },
	
	Hitboxes = {
        Enabled = false,
        BoundingBox = false
    },

    Movement = {
        Bhop = true,    
        AutoStrafe = true,
    },

	Tracers = {
        Enabled = true,
        Color = Color(255, 0, 255)
    },

	KillSound = {
        Enabled = true,
        Sound = "buttons/button17.wav"
    },

	CustomFOV = {
        Enabled = true,
        FOV = 116
    },
		
	Crosshair = {
        Enabled = true,
	    Length = 2,
	    Width = 1,
	    Color = Color(255, 0, 0, 0),
    },

	Thirdperson = {
        Enabled = false,
        Distance = 120,
        Yaw = 0
    }
}

do -- metatable functions are swag
    local meta_en_g = Cache._R.Entity
    local meta_pl_g = Cache._R.Player
    local meta_wn_g = Cache._R.Weapon

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
            if Left > v.x then Left = v.x end
            if Top > v.y then Top = v.y end
            if Right < v.x then Right = v.x end
            if Bottom < v.y then Bottom = v.y end
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
end

--- normal functions

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

			local PPScreen, PScreen = ppos:ToScreen(), pos:ToScreen()

			surface.DrawLine(PPScreen.x, PPScreen.y, PScreen.x, PScreen.y)
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

			surface.SetTextColor(HealthColor)
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

local function ShowHitboxes(Entity)
	if Vars.Hitboxes.Enabled then
		Entity:SetupBones()

		if Entity:GetHitBoxGroupCount() == nil then return end
		
		for Group = 0, Entity:GetHitBoxGroupCount() - 1 do
		 	for Hitbox = 0, Entity:GetHitBoxCount(Group) - 1 do
		 		local Position, Angle = Entity:GetBonePosition(Entity:GetHitBoxBone(Hitbox, Group))
		 		local Mins, Maxs = Entity:GetHitBoxBounds(Hitbox, Group)

				render.DrawWireframeBox(Position, Angle, Mins, Maxs, Cache.Colors.Black, true)
			end
		end
	
		if Vars.Hitboxes.BoundingBox then
			local Mins, Maxs = Entity:GetCollisionBounds()
			render.DrawWireframeBox(Entity:GetPos(), Entity:IsPlayer() and angle_zero or Entity:GetAngles(), Mins, Maxs, Cache.Colors.Yellow, true)
		end
	end
end

local function Chams(Entity)
	if Entity:IsPlayer() then
		if not Vars.Chams.Player.Enabled then return end
		
		local Weapon = Entity.GetActiveWeapon and Entity:GetActiveWeapon() or NULL

		if Vars.Chams.Player.Invisible.Enabled then
			local Color = Vars.Chams.Player.Invisible.Color
			local Material = Vars.Chams.Player.Invisible.Material
			
			render.SetColorModulation(Color.r / 255, Color.g / 255, Color.b / 255)
			render.SetBlend(Color.a / 255)
			render.MaterialOverride(Cache.Materials.Invisible[Material])
			
			Entity:DrawModel()
			if Weapon:IsValid() then Weapon:DrawModel() end
		end

		if Vars.Chams.Player.Visible.Enabled then
			local Color = Vars.Chams.Player.Visible.Color
			local Material = Vars.Chams.Player.Visible.Material
			
			render.SetColorModulation(Color.r / 255, Color.g / 255, Color.b / 255)
			render.SetBlend(Color.a / 255)
			render.MaterialOverride(Cache.Materials.Visible[Material])

			Entity:DrawModel()
			if Weapon:IsValid() then Weapon:DrawModel() end
		end
	elseif Vars.Chams.Prop.Enabled and Entity:GetClass() == "prop_physics" then
		local Dist = Entity:GetPos():DistToSqr(Cache.LocalPlayer:GetPos()) / 500^2
		
		local Color = Vars.Chams.Prop.Color
		local Material = Vars.Chams.Prop.Material
		
		cam.Start3D()
			render.MaterialOverride(Cache.Materials.Invisible[Material])
			render.SetColorModulation(Color.r / 255, Color.g / 255, Color.b / 255)
			render.SetBlend(0.08 + Dist)
			Entity:DrawModel()
			
			-- overlay
			if Vars.Chams.Prop.Overlay.Enabled then
				local OverLayColor = Vars.Chams.Prop.Overlay.Color
				local OverlayMaterial = Vars.Chams.Prop.Overlay.Material
			
				render.MaterialOverride(Cache.Materials.Overlay[OverlayMaterial])
				render.SetColorModulation(OverLayColor.r / 255, OverLayColor.g / 255, OverLayColor.b / 255)
				render.SetBlend(OverLayColor.a / 255)
							
				Entity:DrawModel()
			end
		cam.End3D()
	end
end

local GroundTick = 0
local function Bhop(cmd)
	if not Vars.Movement.Bhop then return end
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
	if not Vars.Movement.AutoStrafe then return end
	if Cache.LocalPlayer:IsOnGround() then return end
	
	local MaxSideMove = Cache.ConVars.cl_sidespeed:GetFloat()
	
	if cmd:GetMouseX() > 0 then 
		cmd:SetSideMove(MaxSideMove)
	elseif cmd:GetMouseX() < 0 then
		cmd:SetSideMove(MaxSideMove * -1)
	end
end

gameevent.Listen("entity_killed")
hook.Add("entity_killed", "", function(data)
	attacker = ents.GetByIndex(data.entindex_attacker) or NULL
	victim = ents.GetByIndex(data.entindex_killed) or NULL

	if not IsValid(attacker) or not IsValid(victim) or not victim:IsPlayer() or victim == attacker then return end

	if attacker == ply and Vars.KillSound.Enabled then
		timer.Simple(0, function()
		print("owned")
			surface.PlaySound(Vars.KillSound.Sound)
		end)
	end
end)

local LastTick = 0
hook.Add("Tick", "", function()
	local Time = SysTime()

	if Time - LastTick >= 0.3 then
		table.Empty(Cache.Players)
		table.Merge(Cache.Players, player.GetAll()) -- best way of getting a table of all players apparently lol
			
		Cache.Entities = ents.GetAll()

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

		collectgarbage("step")

		LastTick = Time
	end
end)

hook.Add("CreateMove", "", function(cmd)
	Bhop(cmd)
	AutoStrafe(cmd)
end)
     
hook.Add("PreDrawViewModel", "", function()
	if IsDrawingGlow then
		render.SetColorModulation(1, 0, 0)
		render.MaterialOverride(Cache.Materials.Visible.Woa)
		render.MaterialOverride(Cache.Materials.Overlay.Federal)
	else
		render.SetColorModulation(0, 0, 0)
	end
	render.SetBlend(1)
end)	
     
hook.Add("PostDrawViewModel", "", function()
	render.SetColorModulation(1, 1, 1)
	render.MaterialOverride(nil)
	render.SetBlend(1)
     
	if IsDrawingGlow then return end
     
	IsDrawingGlow = true
	Cache.LocalPlayer:GetViewModel():DrawModel()
	IsDrawingGlow = false
end)

hook.Add("PostDrawHUD", "", function()
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
	
	if Vars.Chams.Player.Enabled then
		for i = 1, #Cache.Players do	
			if not IsValid(Cache.Players[i]) or not Cache.Players[i]:IsTargetable() then continue end
	
			EntsThisFrame[#EntsThisFrame + 1] = Cache.Players[i]
		end
	end
	
	if Vars.Chams.Prop.Enabled then
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
		origin = Vars.Thirdperson.Enabled and Position - ((Angle - Angle(0, Vars.Thirdperson.Yaw, 0)):Forward() * Vars.Thirdperson.Distance) or Position,
		angles = Angle,
		fov = Vars.CustomFOV.Enabled and Vars.CustomFOV.FOV or FOV,
		znear = ZNear,
		zfar = ZFar,
		drawviewer = Vars.Thirdperson.Enabled
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
	hook.Remove("entity_killed", "")
	hook.Remove("Tick", "")
	hook.Remove("CreateMove", "")
	hook.Remove("PreDrawViewModel", "")
	hook.Remove("PostDrawViewModel", "")
	hook.Remove("PostDrawHUD", "")
	hook.Remove("PreDrawEffects", "")
	hook.Remove("CalcView", "")
	
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

    local function MakeCheckbox(Parent, X, Y, Label, Table, Key)
		local Checkbox = vgui.Create("DCheckBoxLabel", Parent)

		Checkbox.m_tTable = Table
		Checkbox.m_strKey = Key
		Checkbox.m_flLastThink = 0

		Checkbox:SetTextColor(Cache.Colors.Black)
		Checkbox:SetText(Label)
        Checkbox:SetPos(X, Y)
		Checkbox:SetChecked(tobool(Table[Key]))
		Checkbox:SetSkin("Default")

		function Checkbox:Think()
			if CurTime() - self.m_flLastThink >= 0.3 then
				self:SetChecked(self.m_tTable[self.m_strKey])
				self.m_flLastThink = CurTime()
			end
		end

		function Checkbox:OnChange(NewValue)
			self.m_tTable[self.m_strKey] = NewValue
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
	
	MakeCheckbox(PlayerPanel, 155, 25, "Chams Enabled", Vars.Chams.Player, "Enabled")
	MakeCheckbox(PlayerPanel, 180, 50, "Visible Chams", Vars.Chams.Player.Visible, "Enabled")
	MakeCheckbox(PlayerPanel, 180, 75, "Invisible Chams", Vars.Chams.Player.Invisible, "Enabled")
	
	AddColorbox(PlayerPanel, 315, 50, Vars.Chams.Player.Visible, "Color")
	AddColorbox(PlayerPanel, 315, 75, Vars.Chams.Player.Invisible, "Color")
	
	local VisibleMaterial = vgui.Create("DComboBox", PlayerPanel)
	VisibleMaterial:SetPos(180, 100)
	VisibleMaterial:SetSize(100, 20)
	VisibleMaterial:SetValue("Visible Mat")
	VisibleMaterial:AddChoice("DebugWhite")
	VisibleMaterial:AddChoice("Cherry")
	VisibleMaterial:AddChoice("Waterish")
	VisibleMaterial:AddChoice("Woa")
	VisibleMaterial.OnSelect = function(self, index, value)
		Vars.Chams.Player.Visible.Material = value
	end
	
	local InvisibleMaterial = vgui.Create("DComboBox", PlayerPanel)
	InvisibleMaterial:SetPos(180, 125)
	InvisibleMaterial:SetSize(100, 20)
	InvisibleMaterial:SetValue("Invisible Mat")
	InvisibleMaterial:AddChoice("DebugWhite")
	InvisibleMaterial.OnSelect = function(self, index, value)
		Vars.Chams.Player.Invisible.Material = value
	end
	
	--- Hitboxes
	
	MakeCheckbox(PlayerPanel, 155, 150, "Hitboxes", Vars.Hitboxes, "Enabled")
	MakeCheckbox(PlayerPanel, 180, 175, "Bounding Box", Vars.Hitboxes, "BoundingBox")

	local PropChamPanel = vgui.Create("DPanel", MainTabs)
	MainTabs:AddSheet("Prop Chams", PropChamPanel)

	MakeCheckbox(PropChamPanel, 25, 25, "Chams Enabled", Vars.Chams.Prop, "Enabled")
	MakeCheckbox(PropChamPanel, 50, 50, "Overlay Enabled", Vars.Chams.Prop.Overlay, "Enabled")

	AddColorbox(PropChamPanel, 200, 25, Vars.Chams.Prop, "Color")
	AddColorbox(PropChamPanel, 200, 50, Vars.Chams.Prop.Overlay, "Color")

	local PropChamMaterial = vgui.Create("DComboBox", PropChamPanel)
	PropChamMaterial:SetPos(50, 75)
	PropChamMaterial:SetSize(100, 20)
	PropChamMaterial:SetValue("Cham Material")
	PropChamMaterial:AddChoice("DebugWhite")
	PropChamMaterial:AddChoice("Cherry")
	PropChamMaterial:AddChoice("Waterish")
	PropChamMaterial:AddChoice("Woa")
	PropChamMaterial.OnSelect = function(self, index, value)
		Vars.Chams.Prop.Material = value
	end
	
	local PropChamOverlayMaterial = vgui.Create("DComboBox", PropChamPanel)
	PropChamOverlayMaterial:SetPos(50, 100)
	PropChamOverlayMaterial:SetSize(100, 20)
	PropChamOverlayMaterial:SetValue("Overlay Mat")
	PropChamOverlayMaterial:AddChoice("Wireframe")
	PropChamOverlayMaterial:AddChoice("Glow")
	PropChamOverlayMaterial:AddChoice("Federal")
	PropChamOverlayMaterial:AddChoice("HeMovin")
	PropChamOverlayMaterial.OnSelect = function(self, index, value)
		Vars.Chams.Prop.Overlay.Material = value
	end
	
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
	
	MakeCheckbox(MiscPanel, 25, 25, "Bhop", Vars.Movement, "Bhop")
	MakeCheckbox(MiscPanel, 25, 50, "AutoStrafe", Vars.Movement, "AutoStrafe")
	
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

collectgarbage("step") -- :P
