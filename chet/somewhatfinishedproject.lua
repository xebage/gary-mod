--[[
	Edit of https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Features:
		Ragebot:
			Aimbot
			Silent Aim
			NoSpread
			Aim Triangle
			Auto Shoot
			Anti Recoil
			Auto Wall

		HvH:
			Customizable Anti Aim
			LBY breaker (But only sometimes for some reason)
			Fakelag (Air + ground)

		Visuals:
			Box ESP
			Name ESP
			Weapon ESP
			Skeleton ESP
			Flags (Build, god, etc)
			Outline
			Health (Bar + amount)
			(Chams never got done)

		Miscellaneous:
			Killsound (Always on, bonk sound that you probably don't have)
			BHop
			Autostrafe
			Deathsay

		Playerlist that doesn't do much of anything

	Requires
		Frozen2
		https://github.com/anaamne/gary-mod/tree/main/chet/cheat_modules
]]

local function LoadModules(Directory)
	if not file.Exists(Directory, "MOD") and not file.IsDir(Directory, "MOD") then return end

	local files = file.Find(string.format("%s/*", Directory), "MOD")
	
	for _, v in next, files do
		local code = file.Read(string.format("%s/%s", Directory, v), "MOD")	
		RunString(code)
		
		print("Loaded " .. v)
	end
end

LoadModules("lua/cheat_modules")

local fgui = fgui.Hide()

require("frozen2")

local AUTOSTRAFE_MODE_LEGIT = 0
local AUTOSTRAFE_MODE_RAGE = 1

local DEATHSAY_MODE_HACKUSATE = 0

local Cache = {
	LocalPlayer = LocalPlayer(),
	FacingAngle = LocalPlayer():EyeAngles(),
	AntiAimAngle = LocalPlayer():EyeAngles(),

	MovementFix = {
		x = 0,
		y = 0
	},

	TickInterval = engine.TickInterval(),
	SecondInterval = 1 / engine.TickInterval(),
	ServerTime = CurTime(),

	FakeLagTick = 0,
	BhopStickTick = 0,

    HookName = tostring({}),

    Hooks = {
        Local = {}
    },

	TraceOutput = {},

	LastUpdate = 0,

	DeathSays = {
		[DEATHSAY_MODE_HACKUSATE] = {
			"Nice hacks, kid",
			"Cheating lol. reported.",
			"enjoy your ban bud",
			"!calladmin",
			"This server has an anticheat you know",
			"stupid cheater",
			"There's no way you knew I was there, you're clearly cheating",
			"your hacks are so obvious LMAO",
			"i can literally see your aimlock",
			"admins can you please ban him? he's literally cheating",
			"Cheaters are the DEVIL",
			"how do I report someone?"
		}
	},
	
	Entities = {},
	Players = {},

	Skyboxes = {},
	SkyTextures = {},

	FOVTri = {
		{x = 0, y = 0},
		{x = 0, y = 0},
		{x = 0, y = 0},
	},

	CalcView = {
		EyePos = LocalPlayer():EyePos(),
		EyeAngles = LocalPlayer():EyeAngles(),
		FOV = LocalPlayer():GetFOV()
	},
	
	Colors = {
		Red = Color(255, 0, 0, 255),
		Green = Color(0, 255, 0, 255),
		Blue = Color(0, 0, 255, 255),
		Yellow = Color(255, 200, 0, 255),
		White = Color(255, 255, 255, 255),
		Black = Color(0, 0, 0, 255),
		Aqua = Color(0, 255, 255, 255),
		Purple = Color(125, 0, 255),
		Pink = Color(200, 0, 255, 255)
	},

	Panels = {
		EnvPlayerList = nil
	},

	NotGuns = {
		"bomb",
		"c4",
		"climb",
		"fist",
		"gravity gun",
		"grenade",
		"hand",
		"ied",
		"knife",
		"physics gun",
		"slam",
		"sword",
		"tool gun"
	},

	ActuallyGuns = {
		"handgun"
	},

	ConVars = {
		m_pitch = GetConVar("m_pitch"),
		m_yaw = GetConVar("m_yaw"),
		
		cl_interpolate = GetConVar("cl_interpolate"),

		cl_sidespeed = GetConVar("cl_sidespeed"),
		cl_forwardspeed = GetConVar("cl_forwardspeed"),
		
		sv_tfa_recoil_legacy = GetConVar("sv_tfa_recoil_legacy"),

		Penetration = {
			ArcCW = GetConVar("arccw_enable_penetration"),
			M9K = GetConVar("M9KDisablePenetration"),
			TFA = GetConVar("sv_tfa_bullet_penetration"),
			TFA_Multiplier = GetConVar("sv_tfa_bullet_penetration_power_mul")
		}
	},

	ExtraWeaponChecks = {
		bobs = function(weapon) -- M9K
			if not IsValid(weapon) then return false end

			if not weapon.Owner:IsPlayer() then return false end
			if weapon.Owner:KeyDown(IN_SPEED) or weapon.Owner:KeyDown(IN_RELOAD) then return false end
			if weapon:GetNWBool("Reloading", false) then return false end
			if weapon:Clip1() < 1 then return false end

			return true
		end,

		cw = function(weapon)
			if not IsValid(weapon) then return false end

			if not weapon:canFireWeapon(1) or not weapon:canFireWeapon(2) or not weapon:canFireWeapon(3) then return false end
			if weapon.Owner:KeyDown(IN_USE) and CustomizableWeaponry.quickGrenade.canThrow(weapon) then return false end
			if weapon.dt.State == CW_AIMING and weapon.dt.M203Active and weapon.M203Chamber then return false end
			if weapon.dt.Safe then return false end
			if weapon:Clip1() == 0 then return false end
			if weapon.BurstAmount and weapon.BurstAmount > 0 then return false end

			return true
		end,

		fas2 = function(weapon)
			if not IsValid(weapon) then return false end

			if weapon.FireMode == "safe" then return false end
			if weapon.BurstAmount > 0 and weapon.dt.Shots >= weapon.BurstAmount then return false end
			if weapon.ReloadState ~= 0 then return false end
			if weapon.dt.Status == FAS_STAT_CUSTOMIZE then return false end
			if weapon.Cooking or weapon.FuseTime then return false end
			if weapon.Owner:KeyDown(IN_USE) and weapon:CanThrowGrenade() then return false end
			if weapon.dt.Status == FAS_STAT_SPRINT or weapon.dt.Status == FAS_STAT_QUICKGRENADE then return false end
			if weapon:Clip1() <= 0 or weapon.Owner:WaterLevel() >= 3 then return false end
			if weapon.CockAfterShot and not weapon.Cocked then return false end

			return true
		end,

		tfa = function(weapon)
			if not IsValid(weapon) then return false end

			local weapon2 = weapon:GetTable()

			local v = hook.Run("TFA_PreCanPrimaryAttack", weapon)
			if v ~= nil then return v end

			local stat = weapon:GetStatus()
			if stat == TFA.Enum.STATUS_RELOADING_WAIT or stat == TFA.Enum.STATUS_RELOADING then return false end

			if weapon:IsSafety() then return false end
			if weapon:GetSprintProgress() >= 0.1 and not weapon:GetStatL("AllowSprintAttack", false) then return false end
			if weapon:GetStatL("Primary.ClipSize") <= 0 and weapon:Ammo1() < weapon:GetStatL("Primary.AmmoConsumption") then return false end
			if weapon:GetPrimaryClipSize(true) > 0 and weapon:Clip1() < weapon:GetStatL("Primary.AmmoConsumption") then return false end
			if weapon2.GetStatL(weapon, "Primary.FiresUnderwater") == false and weapon:GetOwner():WaterLevel() >= 3 then return false end

			v = hook.Run("TFA_CanPrimaryAttack", self)
			if v ~= nil then return v end

			if weapon:CheckJammed() then return false end

			return true
		end,

		arccw = function(weapon)
			if not IsValid(weapon) then return false end

			if IsValid(weapon:GetHolster_Entity()) then return false end
			if weapon:GetHolster_Time() > 0 then return false end
			if weapon:GetReloading() then return false end
			if weapon:GetWeaponOpDelay() > CurTime() then return false end
			if weapon:GetHeatLocked() then return false end
			if weapon:GetState() == ArcCW.STATE_CUSTOMIZE then return false end
			if weapon:BarrelHitWall() > 0 then return false end
			if weapon:GetNWState() == ArcCW.STATE_SPRINT and not weapon:GetBuff_Override("Override_ShootWhileSprint", weapon.ShootWhileSprint) then return false end
			if (weapon:GetBurstCount() or 0) >= weapon:GetBurstLength() then return false end
			if weapon:GetNeedCycle() then return false end
			if weapon:GetCurrentFiremode().Mode == 0 then return false end
			if weapon:GetBuff_Override("Override_TriggerDelay", weapon.TriggerDelay) and weapon:GetTriggerDelta() < 1 then return false end
			if weapon:GetBuff_Hook("Hook_ShouldNotFire") then return false end
			if weapon:GetBuff_Hook("Hook_ShouldNotFireFirst") then return false end

			return true
		end
	},

	WeaponCones = {},

	AmmoPenetration = {
		M9K = {
			["357"] = 144,
			AR2 = 256,
			Buckshot = 25,
			Pistol = 81,
			SMG1 = 196,
			SniperPenetratedRound = 400
		}
	},

	NetVars = {
		BuildMode = {
			"BuildMode", -- Libby's
			"buildmode", -- Fun Server
			"_Kyle_Buildmode" -- Workshop addon
		},

		GodMode = {
			"has_god" -- Fun Server + LBG
		},

		Protected = {
			"LibbyProtectedSpawn" -- Libby's
		}
	},

	FreeCam = {
		Speeds = {
			Normal = 150,
			Sprint = 250,
			Walk = 75
		},
	
		Position = LocalPlayer():EyePos(),
		Angle = angle_zero * 1,
		PreAngle = angle_zero * 1
	}
}

Cache.WeaponConeFunctions = {
	tfa = function(Weapon, _, WeaponCone, ForwardAngle)
		local Cone, Recoil = Weapon:CalculateConeRecoil()
	
		local Yaw, Pitch = Weapon:ComputeBulletDeviation(1, 1, Cone)
	
		local WeaponAngle = Angle(ForwardAngle)
		local BulletAngle = Angle(WeaponAngle)
	
		if Cache.ConVars.sv_tfa_recoil_legacy:GetBool() then
			WeaponAngle:Add(Cache.LocalPlayer:GetViewPunchAngles())
		elseif Weapon:HasRecoilLUT() then
			WeaponAngle:Add(Weapon:GetRecoilLUTAngle())
		else
			local PitchPunch = Weapon:GetViewPunchP()
			local YawPunch = Weapon:GetViewPunchY()
	
			PitchPunch = PitchPunch - PitchPunch * Cache.TickInterval
			YawPunch = YawPunch - YawPunch * Cache.TickInterval
	
			WeaponAngle.pitch = WeaponAngle.pitch + PitchPunch
			WeaponAngle.yaw = WeaponAngle.yaw + YawPunch
		end
	
		WeaponAngle:Normalize()
	
		local Up = BulletAngle:Up()
		local Right = BulletAngle:Right()
	
		BulletAngle:RotateAroundAxis(Up, Yaw)
		BulletAngle:RotateAroundAxis(Right, Pitch)
	
		local Difference = WeaponAngle - BulletAngle
	
		ForwardAngle:Sub(Difference)
	
		return true
	end,
		
	cw = function(Weapon, Command, _, ForwardAngle)
		local Cone = Weapon.CurCone
	
		math.randomseed(Command:CommandNumber())
		ForwardAngle:Add(Angle(-math.Rand(-Cone, Cone), -math.Rand(-Cone, Cone), 0) * 25)
	
		return true
	end
}

local Vars = {
	Aimbot = {
		Enabled = true,
		
		Key = KEY_F,
		Silent = false,
		AutoShoot = true,
		NoSpread = true,
		AntiRecoil = true,
		AutoWall = false,
		IgnoreFriends = false,
		QuickScan = false,

		AimCone = {
			Enabled = false,
			FOV = 16
		},
		
		Classes = {},
		Friends = {},

		HitboxOrder = {
			HITGROUP_HEAD,
			HITGROUP_CHEST,
			HITGROUP_STOMACH
		}
	},

	HvH = {
		bSendPacket = true,

		AntiAim = {
			Enabled = false,
			ForceOff = true,

			Pitch = 89,

			Yaw = {
				Fake = 90,
				Real = -90
			},

			Breaker = {
				Enabled = false,
				Active = false,

				Delta = 45,
				LastBreak = 0
			}
		},

		FakeLag = {
			Enabled = false,

			CurTick = 0,

			MaxTick = {
				Ground = 2,
				Air = 2
			}
		}
	},
	
	Visuals = {
		ESP = {
			Enabled = true,
		
			Box = true,
			Name = true,
			Weapon = false,
			Skeleton = false,
			Flags = true,
			Outline = false,
			
			Health = {
				Enabled = true,

				Bar = false,
				Amount = true
			},

			Chams = {
				Player = {
					Enabled = false,

					Visible = false,
					Invisible = false,

					Local = {
						Enabled = false,

						Self = false,
						FakeAngle = false,

						ViewModel = {
							Weapon = false,
							Hands = false
						}
					}
				},

				Entity = {
					Enabled = false,

					Visible = false,
					Invisible = false
				}
			},

			Colors = {
				Normal = Cache.Colors.Red,
				Friend = Cache.Colors.Red,

				Box = Cache.Colors.Red,
				Name = Cache.Colors.White,
				Weapon = Cache.Colors.Yellow,
				Skeleton = Cache.Colors.Red,
				Flags = Cache.Colors.Aqua,
				Outline = Cache.Colors.Black,

				Chams = {
					Player = {
						Visible = Cache.Colors.Aqua,
						Invisible = Cache.Colors.Blue,

						Local = {
							Self = Cache.Colors.Green,
							FakeAngle = Cache.Colors.White
						}
					},

					Entity = {
						Visible = Cache.Colors.Pink,
						Invisible = Cache.Colors.Purple
					}
				}
			}
		}
	},

	Miscellaneous = {
		FreeCam = {
			Enabled = false,
			Speed = 15
		},
		
		
		KillSound = {
			Enabled = false,
			Path = "pSounds/bonk.mp3"
		},

		Movement = {
			Bhop = false,

			AutoStrafe = {
				Enabled = false,
				Mode = AUTOSTRAFE_MODE_LEGIT
			}
		},

		DeathSay = {
			Enabled = false,
			Mode = DEATHSAY_MODE_HACKUSATE
		}
	}
}

local _Registry = debug.getregistry()

local meta_an_g = _Registry.Angle
local meta_cv_g = _Registry.ConVar
local meta_en_g = _Registry.Entity
local meta_pl_g = _Registry.Player
local meta_wn_g = _Registry.Weapon

do
	local CurrSky = GetConVar("sv_skyname"):GetString()

	if not CurrSky then
		return error("Failed to get sky name") -- Black magic
	end

	local SkyboxTypes = {"lf", "ft", "rt", "bk", "dn", "up"} -- Retarded

	for i = 1, #SkyboxTypes do
		Cache.SkyTextures[i] = Material("skybox/".. CurrSky.. SkyboxTypes[i]) -- Get the current sky materials
	end

	local files, _ = file.Find("materials/skybox/*", "GAME") -- Get list of skyboxes

	if #files < 1 then
		return error("No skybox files found") -- Sad times
	end

	local parsed = {}

	for _, v in next, files do
		local name = v:sub(1, #v - 6) -- Remove file extension and stupid 2 letters at the end
		
		if parsed[name] then continue end
		
		local temp = {}
		local breakouter = false
		
		for i = 1, #SkyboxTypes do
			local mat = Material("skybox/" .. name .. SkyboxTypes[i]) -- This is very laggy the first time the script is loaded
			
			if not mat or mat:IsError() then -- No bueno
				breakouter = true
				break
			end
			
			local texture = mat:GetTexture("$basetexture")
			
			if not texture or texture:IsError() or texture:IsErrorTexture() then -- No bueno
				breakouter = true
				break
			end
			
			temp[#temp + 1] = texture -- Bueno!!
		end
		
		parsed[name] = true
		
		if breakouter then continue end
		
		Cache.Skyboxes[name] = table.Copy(temp)
	end

	if table.Count(Cache.Skyboxes) < 1 then
		return error("No skyboxes found") -- Sadder times
	end
end

--[[
	Panel setup
]]

local MainFrame = fgui.Create("FHFrame")
MainFrame:SetVisible(false)
MainFrame:SetTitle("Best cheat you've ever seen")
MainFrame:SetSize(600, 700)
MainFrame:SetDeleteOnClose(false)
MainFrame:SetX((ScrW() / 2) - MainFrame:GetWide() - 10)
MainFrame:CenterVertical()

MainFrame._OldPerformLayout = MainFrame.PerformLayout

MainFrame.PerformLayout = function(self, w, h)
	MainFrame._OldPerformLayout(self, w, h)

	local MainFrameTabs = fgui.Create("FHTabbedMenu", self)
	MainFrameTabs:Dock(FILL)
	MainFrameTabs:SetTabBackground(true)
	local MainTabs = MainFrameTabs:AddTabs("Aimbot", "HvH", "Visuals", "Miscellaneous")

	local AimbotPanel = MainTabs[1]

	local AimbotEnabled = fgui.Create("FHCheckBox", AimbotPanel)
	AimbotEnabled:SetPos(25, 25)
	AimbotEnabled:SetText("Enabled")
	AimbotEnabled:SetVarTable(Vars.Aimbot, "Enabled")

	local AimbotKey = fgui.Create("FHBinder", AimbotPanel)
	AimbotKey:SetSize(100, 25)
	AimbotKey:SetPos(150, 40)
	AimbotKey:SetLabel("Aim Key")
	AimbotKey:SetVarTable(Vars.Aimbot, "Key")

	local AimbotSilent = fgui.Create("FHCheckBox", AimbotPanel)
	AimbotSilent:SetPos(50, 75)
	AimbotSilent:SetText("Silent Aim")
	AimbotSilent:SetVarTable(Vars.Aimbot, "Silent")

	local AimbotAutoShoot = fgui.Create("FHCheckBox", AimbotPanel)
	AimbotAutoShoot:SetPos(50, 100)
	AimbotAutoShoot:SetText("Auto Shoot")
	AimbotAutoShoot:SetVarTable(Vars.Aimbot, "AutoShoot")

	local AimbotAntiRecoil = fgui.Create("FHCheckBox", AimbotPanel)
	AimbotAntiRecoil:SetPos(50, 125)
	AimbotAntiRecoil:SetText("Anti Recoil")
	AimbotAntiRecoil:SetVarTable(Vars.Aimbot, "AntiRecoil")

	local AimbotAutoWall = fgui.Create("FHCheckBox", AimbotPanel)
	AimbotAutoWall:SetPos(50, 150)
	AimbotAutoWall:SetText("Auto Wall")
	AimbotAutoWall:SetVarTable(Vars.Aimbot, "AutoWall")

	local AimbotIgnoreFriends = fgui.Create("FHCheckBox", AimbotPanel)
	AimbotIgnoreFriends:SetPos(50, 175)
	AimbotIgnoreFriends:SetText("Ignore Friends")
	AimbotIgnoreFriends:SetVarTable(Vars.Aimbot, "IgnoreFriends")

	local AimbotQuickScan = fgui.Create("FHCheckBox", AimbotPanel)
	AimbotQuickScan:SetPos(50, 200)
	AimbotQuickScan:SetText("Quick Scan")
	AimbotQuickScan:SetVarTable(Vars.Aimbot, "QuickScan")

	local AimbotAdjustAimConeFov = fgui.Create("FHSlider", AimbotPanel)
	AimbotAdjustAimConeFov:SetText("Cone Fov")
	AimbotAdjustAimConeFov:SetPos(50, 225)
	AimbotAdjustAimConeFov:SetWide(400)
	AimbotAdjustAimConeFov:SetMinMax(0, 60)
	AimbotAdjustAimConeFov:SetDecimals(0)
	AimbotAdjustAimConeFov:SetVarTable(Vars.Aimbot.AimCone, "FOV")

	local HvHPanel = MainTabs[2]

	local HvHAntiAimSection = fgui.Create("FHSection", HvHPanel)
	HvHAntiAimSection:SetSize(560, 175)
	HvHAntiAimSection:SetPos(5, 5)
	HvHAntiAimSection:SetTitle("Anti Aim")

	local HvHAntiAimEnabled = fgui.Create("FHCheckBox", HvHAntiAimSection)
	HvHAntiAimEnabled:SetPos(10, 25)
	HvHAntiAimEnabled:SetText("Enabled")
	HvHAntiAimEnabled:SetVarTable(Vars.HvH.AntiAim, "Enabled")

	local HvHAntiAimPitch = fgui.Create("FHSlider", HvHAntiAimSection)
	HvHAntiAimPitch:SetText("Pitch")
	HvHAntiAimPitch:SetPos(30, 40)
	HvHAntiAimPitch:SetWide(400)
	HvHAntiAimPitch:SetMinMax(-89, 89)
	HvHAntiAimPitch:SetDecimals(0)
	HvHAntiAimPitch:SetVarTable(Vars.HvH.AntiAim, "Pitch")

	local HvHAntiAimYawReal = fgui.Create("FHSlider", HvHAntiAimSection)
	HvHAntiAimYawReal:SetText("Real Yaw")
	HvHAntiAimYawReal:SetPos(30, 65)
	HvHAntiAimYawReal:SetWide(400)
	HvHAntiAimYawReal:SetMinMax(-180, 180)
	HvHAntiAimYawReal:SetDecimals(0)
	HvHAntiAimYawReal:SetVarTable(Vars.HvH.AntiAim.Yaw, "Real")

	local HvHAntiAimYawFake = fgui.Create("FHSlider", HvHAntiAimSection)
	HvHAntiAimYawFake:SetText("Fake Yaw")
	HvHAntiAimYawFake:SetPos(30, 90)
	HvHAntiAimYawFake:SetWide(400)
	HvHAntiAimYawFake:SetMinMax(-180, 180)
	HvHAntiAimYawFake:SetDecimals(0)
	HvHAntiAimYawFake:SetVarTable(Vars.HvH.AntiAim.Yaw, "Fake")

	local HvHAntiAimBreakerEnabled = fgui.Create("FHCheckBox", HvHAntiAimSection)
	HvHAntiAimBreakerEnabled:SetPos(30, 125)
	HvHAntiAimBreakerEnabled:SetText("Enable Breaker")
	HvHAntiAimBreakerEnabled:SetVarTable(Vars.HvH.AntiAim.Breaker, "Enabled")

	local HvHAntiAimBreakerDelta = fgui.Create("FHSlider", HvHAntiAimSection)
	HvHAntiAimBreakerDelta:SetText("Breaker Delta")
	HvHAntiAimBreakerDelta:SetPos(30, 140)
	HvHAntiAimBreakerDelta:SetWide(400)
	HvHAntiAimBreakerDelta:SetMinMax(-90, 90)
	HvHAntiAimBreakerDelta:SetDecimals(0)
	HvHAntiAimBreakerDelta:SetVarTable(Vars.HvH.AntiAim.Breaker, "Delta")

	local HvHFakeLagSection = fgui.Create("FHSection", HvHPanel)
	HvHFakeLagSection:SetSize(560, 125)
	HvHFakeLagSection:SetPos(5, 185)
	HvHFakeLagSection:SetTitle("Fake Lag")

	local HvHFakeLagEnabled = fgui.Create("FHCheckBox", HvHFakeLagSection)
	HvHFakeLagEnabled:SetPos(10, 25)
	HvHFakeLagEnabled:SetText("Enabled")
	HvHFakeLagEnabled:SetVarTable(Vars.HvH.FakeLag, "Enabled")

	local HvHFakeLagMaxTickGround = fgui.Create("FHSlider", HvHFakeLagSection)
	HvHFakeLagMaxTickGround:SetText("Max Ground")
	HvHFakeLagMaxTickGround:SetPos(30, 40)
	HvHFakeLagMaxTickGround:SetWide(400)
	HvHFakeLagMaxTickGround:SetMinMax(0, 14)
	HvHFakeLagMaxTickGround:SetDecimals(0)
	HvHFakeLagMaxTickGround:SetVarTable(Vars.HvH.FakeLag.MaxTick, "Ground")

	local HvHFakeLagMaxTickAir = fgui.Create("FHSlider", HvHFakeLagSection)
	HvHFakeLagMaxTickAir:SetText("Max Air")
	HvHFakeLagMaxTickAir:SetPos(30, 65)
	HvHFakeLagMaxTickAir:SetWide(400)
	HvHFakeLagMaxTickAir:SetMinMax(0, 14)
	HvHFakeLagMaxTickAir:SetDecimals(0)
	HvHFakeLagMaxTickAir:SetVarTable(Vars.HvH.FakeLag.MaxTick, "Air")

	local VisualPanel = MainTabs[3]

	local VisualESPSection = fgui.Create("FHSection", VisualPanel)
	VisualESPSection:SetSize(560, 260)
	VisualESPSection:SetPos(5, 5)
	VisualESPSection:SetTitle("ESP")

	local VisualsESPEnabled = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPEnabled:SetPos(5, 15)
	VisualsESPEnabled:SetText("Enabled")
	VisualsESPEnabled:SetVarTable(Vars.Visuals.ESP, "Enabled")

	local VisualsESPName = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPName:SetPos(30, 40)
	VisualsESPName:SetText("Name ESP")
	VisualsESPName:SetVarTable(Vars.Visuals.ESP, "Name")

	local VisualsESPWeapon = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPWeapon:SetPos(30, 65)
	VisualsESPWeapon:SetText("Weapon ESP")
	VisualsESPWeapon:SetVarTable(Vars.Visuals.ESP, "Weapon")

	local VisualsESPHealthEnabled = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPHealthEnabled:SetPos(30, 90)
	VisualsESPHealthEnabled:SetText("Health Information")
	VisualsESPHealthEnabled:SetVarTable(Vars.Visuals.ESP.Health, "Enabled")

	local VisualsESPHealthBar = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPHealthBar:SetPos(55, 115)
	VisualsESPHealthBar:SetText("Health Bar")
	VisualsESPHealthBar:SetVarTable(Vars.Visuals.ESP.Health, "Bar")

	local VisualsESPHealthAmount = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPHealthAmount:SetPos(55, 140)
	VisualsESPHealthAmount:SetText("Health Amount")
	VisualsESPHealthAmount:SetVarTable(Vars.Visuals.ESP.Health, "Amount")

	local VisualsESPBox = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPBox:SetPos(30, 165)
	VisualsESPBox:SetText("Box ESP")
	VisualsESPBox:SetVarTable(Vars.Visuals.ESP, "Box")

	local VisualsESPSkeleton = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPSkeleton:SetPos(30, 190)
	VisualsESPSkeleton:SetText("Skeleton ESP")
	VisualsESPSkeleton:SetVarTable(Vars.Visuals.ESP, "Skeleton")

	local VisualsESPFlags = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPFlags:SetPos(30, 215)
	VisualsESPFlags:SetText("Player Flags")
	VisualsESPFlags:SetVarTable(Vars.Visuals.ESP, "Flags")

	local VisualsESPOutline = fgui.Create("FHCheckBox", VisualESPSection)
	VisualsESPOutline:SetPos(30, 240)
	VisualsESPOutline:SetText("Outline")
	VisualsESPOutline:SetVarTable(Vars.Visuals.ESP, "Outline")

	local MiscellaneousPanel = MainTabs[4]

	local MiscellaneousMovementSection = fgui.Create("FHSection", MiscellaneousPanel)
	MiscellaneousMovementSection:SetSize(560, 130)
	MiscellaneousMovementSection:SetPos(5, 5)
	MiscellaneousMovementSection:SetTitle("Movement")

	local MiscellaneousMovementBhop = fgui.Create("FHCheckBox", MiscellaneousMovementSection)
	MiscellaneousMovementBhop:SetPos(5, 15)
	MiscellaneousMovementBhop:SetText("Bunny Hop")
	MiscellaneousMovementBhop:SetVarTable(Vars.Miscellaneous.Movement, "Bhop")

	local MiscellaneousMovementAutoStrafeEnabled = fgui.Create("FHCheckBox", MiscellaneousMovementSection)
	MiscellaneousMovementAutoStrafeEnabled:SetPos(30, 40)
	MiscellaneousMovementAutoStrafeEnabled:SetText("Auto Strafe")
	MiscellaneousMovementAutoStrafeEnabled:SetVarTable(Vars.Miscellaneous.Movement.AutoStrafe, "Enabled")

	local MiscellaneousMovementAutoStrafeMode = fgui.Create("FHDropDown", MiscellaneousMovementSection)
	MiscellaneousMovementAutoStrafeMode:SetSize(100, 20)
	MiscellaneousMovementAutoStrafeMode:SetPos(55, 65)
	MiscellaneousMovementAutoStrafeMode:AddChoice("Legit", AUTOSTRAFE_MODE_LEGIT)
	MiscellaneousMovementAutoStrafeMode:AddChoice("Rage", AUTOSTRAFE_MODE_RAGE)
	MiscellaneousMovementAutoStrafeMode:ChooseOption("Legit", 0)

	MiscellaneousMovementAutoStrafeMode.FHOnSelect = function(self, index, value, data)
		Vars.Miscellaneous.Movement.AutoStrafe.Mode = data
	end

	local MiscellaneousDeathSayEnabled = fgui.Create("FHCheckBox", MiscellaneousPanel)
	MiscellaneousDeathSayEnabled:SetPos(25, 140)
	MiscellaneousDeathSayEnabled:SetText("Death Say")
	MiscellaneousDeathSayEnabled:SetVarTable(Vars.Miscellaneous.DeathSay, "Enabled")

	local MiscellaneousDeathSayMode = fgui.Create("FHDropDown", MiscellaneousPanel)
	MiscellaneousDeathSayMode:SetSize(100, 20)
	MiscellaneousDeathSayMode:SetPos(50, 165)
	MiscellaneousDeathSayMode:AddChoice("Hackusate", DEATHSAY_MODE_HACKUSATE)
	MiscellaneousDeathSayMode:ChooseOption("Hackusate", 0)

	MiscellaneousDeathSayMode.FHOnSelect = function(self, index, value, data)
		Vars.Miscellaneous.DeathSay.Mode = data
	end

	local MiscellaneousSkyboxChanger = fgui.Create("FHDropDown", MiscellaneousPanel)
	MiscellaneousSkyboxChanger:SetSize(100, 20)
	MiscellaneousSkyboxChanger:SetPos(50, 195)
	MiscellaneousSkyboxChanger:SetText("Skybox Changer")

	for k, _ in pairs(Cache.Skyboxes) do
		MiscellaneousSkyboxChanger:AddChoice(k)
	end

	MiscellaneousSkyboxChanger.FHOnSelect = function(self, index, value) 
		if not Cache.Skyboxes[value] then return end

		SelectedSky = value
			
		for i = 1, #Cache.SkyTextures do
			Cache.SkyTextures[i]:SetTexture("$basetexture", Cache.Skyboxes[SelectedSky][i])
		end 
	end

	local MiscellaneousFreeCam = fgui.Create("FHCheckBox", MiscellaneousPanel)
	MiscellaneousFreeCam:SetPos(25, 225)
	MiscellaneousFreeCam:SetText("Free Cam")
	MiscellaneousFreeCam:SetVarTable(Vars.Miscellaneous.FreeCam, "Enabled")
	
	local MiscellaneousFreeCamSpeed = fgui.Create("FHSlider", MiscellaneousPanel)
	MiscellaneousFreeCamSpeed:SetText("Cam Speed")
	MiscellaneousFreeCamSpeed:SetPos(25, 250)
	MiscellaneousFreeCamSpeed:SetWide(400)
	MiscellaneousFreeCamSpeed:SetMinMax(1, 120)
	MiscellaneousFreeCamSpeed:SetDecimals(0)
	MiscellaneousFreeCamSpeed:SetVarTable(Vars.Miscellaneous.FreeCam, "Speed")
end

-- Env list

local EnvFrame = fgui.Create("FHFrame")
EnvFrame:SetVisible(false)
EnvFrame:SetTitle("Environment List")
EnvFrame:SetSize(700, 600)
EnvFrame:ShowCloseButton(false)
EnvFrame:SetDeleteOnClose(false)
EnvFrame:SetX((ScrW() / 2) + 10)
EnvFrame:CenterVertical()

EnvFrame._OldPerformLayout = EnvFrame.PerformLayout

EnvFrame.PerformLayout = function(self, w, h)
	EnvFrame._OldPerformLayout(self, w, h)

	local EnvFrameTabs = fgui.Create("FHTabbedMenu", self)
	EnvFrameTabs:Dock(FILL)
	EnvFrameTabs:SetTabBackground(true)
	local EnvTabs = EnvFrameTabs:AddTabs("Players", "Entities")

	local PlayerPanel = EnvTabs[1]

	local EnvPlayerList = fgui.Create("FHList", PlayerPanel)
	EnvPlayerList:SetSize(670, 264)
	EnvPlayerList:SetMultiSelect(false)
	EnvPlayerList:SetSortable(false)

	Cache.Panels.EnvPlayerList = EnvPlayerList

	local EnvPlayerListIndex = EnvPlayerList:AddColumn("Index")
	EnvPlayerListIndex:SetFixedWidth(50)

	EnvPlayerList:AddColumn("Username")

	local EnvPlayerListPriority = EnvPlayerList:AddColumn("Priority")
	EnvPlayerListPriority:SetFixedWidth(75)

	local EnvPlayerSettings = fgui.Create("FHSection", PlayerPanel)
	EnvPlayerSettings:SetSize(670, 264)
	EnvPlayerSettings:SetPos(0, EnvPlayerList:GetTall() + 10)
	EnvPlayerSettings:SetTitle("Player Settings")

	local EnvPlayerSettingsPanel = EnvPlayerSettings:GetContentFrame()

	local EnvPlayerSettingsInfo = fgui.Create("FHSection", EnvPlayerSettingsPanel)
	EnvPlayerSettingsInfo:SetPos(0, 5)
	EnvPlayerSettingsInfo:SetSize(330, 244)
	EnvPlayerSettingsInfo:SetTitle("Info")

	local EnvPlayerSettingsInfoAvatar = vgui.Create("AvatarImage", EnvPlayerSettingsInfo)
	EnvPlayerSettingsInfoAvatar:SetSize(64, 64)
	EnvPlayerSettingsInfoAvatar:SetPos(EnvPlayerSettingsInfo:GetWide() - EnvPlayerSettingsInfoAvatar:GetWide() - 23, 35)
	EnvPlayerSettingsInfoAvatar:SetPlayer(NULL, 64)

	local EnvPlayerSettingsInfoLabel = fgui.Create("FHLabel", EnvPlayerSettingsInfo)
	EnvPlayerSettingsInfoLabel:SetWide(200)
	EnvPlayerSettingsInfoLabel:SetAutoStretchVertical(true)
	EnvPlayerSettingsInfoLabel:SetPos(10, 25)

	EnvPlayerSettingsInfoAvatar.Paint = function(self, w, h)
		surface.SetDrawColor(fgui.Colors.outline)
		surface.DrawLine(0, 0, w, h)
		surface.DrawLine(w, 0, 0, h)
	end

	EnvPlayerSettingsInfoAvatar.PaintOver = function(self, w, h)
		surface.SetDrawColor(fgui.Colors.outline)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	EnvPlayerSettingsInfoLabel._FHPlayer = NULL
	EnvPlayerSettingsInfoLabel._ThinkTick = 0
	EnvPlayerSettingsInfoLabel._ThinkLimit = Cache.TickInterval * (Cache.SecondInterval / 3)

	EnvPlayerSettingsInfoLabel.UpdateInfo = function(self)
		local ply = self._FHPlayer or NULL

		local valid = IsValid(ply)

		EnvPlayerSettingsInfoAvatar:SetPlayer(ply, 64)

		local name = valid and ply:GetName() or ""
		local id64 = valid and (ply:SteamID64() or "BOT") or ""
		local origin = valid and ply:GetPos() or vector_origin
		local angles = (valid and ply:EyeAngles() or angle_zero)
		local velocity = valid and ply:GetVelocity():Length() or 0

		origin = table.concat({
			util.NiceFloat(math.Round(origin.x)),
			util.NiceFloat(math.Round(origin.y)),
			util.NiceFloat(math.Round(origin.z))
		}, ", ")

		angles = table.concat({
			util.NiceFloat(math.Round(angles.pitch)),
			util.NiceFloat(math.Round(angles.yaw)),
			util.NiceFloat(math.Round(angles.roll))
		}, ", ")

		velocity = util.NiceFloat(math.Round(velocity))

		self:SetText(string.format([=[Name: %s

			Steam64: %s

			Origin: (%s)

			Angles: (%s)

			Velocity: %s]=],
			
			name, id64, origin, angles, velocity
		))
	end

	EnvPlayerSettingsInfoLabel._OldThink = EnvPlayerSettingsInfoLabel.Think

	EnvPlayerSettingsInfoLabel.Think = function(self)
		self._OldThink(self)

		self._ThinkTick = self._ThinkTick + Cache.TickInterval

		if self._ThinkTick >= self._ThinkLimit then
			self:UpdateInfo()
			self._ThinkTick = 0
		end
	end

	local EnvPlayerSettingsInfoProfile = fgui.Create("FHButton", EnvPlayerSettingsInfo)
	EnvPlayerSettingsInfoProfile:SetSize(100, 22)
	EnvPlayerSettingsInfoProfile:SetPos(EnvPlayerSettingsInfo:GetWide() - EnvPlayerSettingsInfoProfile:GetWide() - 5, 10)
	EnvPlayerSettingsInfoProfile:SetText("Open Profile")

	EnvPlayerSettingsInfoProfile.DoClick = function()
		if not IsValid(EnvPlayerSettingsInfoLabel._FHPlayer) or not EnvPlayerSettingsInfoLabel._FHPlayer:SteamID64() then return end

		gui.OpenURL("https://steamcommunity.com/profiles/" .. EnvPlayerSettingsInfoLabel._FHPlayer:SteamID64())
	end
	
	local EnvPlayerSettingsControls = fgui.Create("FHSection", EnvPlayerSettingsPanel)
	EnvPlayerSettingsControls:SetSize(325, 244)
	EnvPlayerSettingsControls:SetPos(EnvPlayerSettingsInfo:GetWide() + 5, 5)
	EnvPlayerSettingsControls:SetTitle("Controls")

	EnvPlayerList.FHOnRowSelected = function(self, index, row)
		EnvPlayerSettingsInfoLabel._FHPlayer = row._FHPlayer or NULL
		EnvPlayerSettingsInfoLabel:UpdateInfo()
	end

	local EntitiesPanel = EnvTabs[2]

	local EnvEntityList = fgui.Create("FHList", EntitiesPanel)
	EnvEntityList:SetSize(670, 264)
	EnvEntityList:SetMultiSelect(false)
	EnvEntityList:SetSortable(false)

	local EnvEntityListIndex = EnvEntityList:AddColumn("Index")
	EnvEntityListIndex:SetFixedWidth(50)

	EnvEntityList:AddColumn("Class")

	local EnvEntityListPriority = EnvEntityList:AddColumn("Priority")
	EnvEntityListPriority:SetFixedWidth(75)

	local EnvEntitySettings = fgui.Create("FHSection", EntitiesPanel)
	EnvEntitySettings:SetSize(670, 264)
	EnvEntitySettings:SetPos(0, EnvEntityList:GetTall() + 10)
	EnvEntitySettings:SetTitle("Entity Settings")
end

MainFrame.OnRemove = function()
	EnvFrame:Remove()
end

MainFrame.OnClose = function()
	EnvFrame:Close()
end

timer.Simple(0, function()
	MainFrame:InvalidateLayout(true)
	EnvFrame:InvalidateLayout(true)
end)

--[[
	Functurios
]]

-- Metatable functions

meta_pl_g.IsProtected = function(self)
	for i = 1, #Cache.NetVars.Protected do
		if self:GetNWBool(Cache.NetVars.Protected[i], false) then
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

meta_pl_g.IsInBuildMode = function(self)
	for i = 1, #Cache.NetVars.BuildMode do
		if self:GetNWBool(Cache.NetVars.BuildMode[i], false) then
			return true
		end
	end

	return false
end

meta_pl_g.IsFriend = function(self)
	return table.HasValue(Vars.Aimbot.Friends, self)
end

meta_pl_g.IsTargettable = function(self)
	return self ~= Cache.LocalPlayer and self:Alive() and self:Team() ~= TEAM_SPECTATOR and self:GetObserverMode() == 0 and not self:IsDormant()
end

meta_en_g.IsTargettable = function(self)
	return IsValid(self) and table.HasValue(Vars.Aimbot.Classes, self)
end

meta_en_g.GetHealthColor = function(self)
	local max = self:GetMaxHealth()
	local health = math.Clamp(self:Health(), 0, max)
	local percent = health * (health / max)

	if self._LastHealth ~= health or not self._LastHealthColor then
		self._LastHealth = health
		self._LastHealthColor = Color(255 - (percent * 2.55), percent * 2.55, 0)
	end
		
	return self._LastHealthColor, percent / health
end

meta_en_g.GetScreenCorners = function(self)
	if not IsValid(self) then
		return 0, 0, 0, 0
	end

	local mins, maxs = self:OBBMins(), self:OBBMaxs()

	local coords = {
		self:LocalToWorld(mins):ToScreen(),
    	self:LocalToWorld(Vector(mins.x, maxs.y, mins.z)):ToScreen(),
    	self:LocalToWorld(Vector(maxs.x, maxs.y, mins.z)):ToScreen(),
    	self:LocalToWorld(Vector(maxs.x, mins.y, mins.z)):ToScreen(),

    	self:LocalToWorld(maxs):ToScreen(),
    	self:LocalToWorld(Vector(mins.x, maxs.y, maxs.z)):ToScreen(),
    	self:LocalToWorld(Vector(mins.x, mins.y, maxs.z)):ToScreen(),
    	self:LocalToWorld(Vector(maxs.x, mins.y, maxs.z)):ToScreen()
	}

	local left, right, top, bottom = coords[1].x, coords[1].x, coords[1].y, coords[1].y

	for _, v in next, coords do
		if left > v.x then
			left = v.x
		end

		if top > v.y then
			top = v.y
		end

		if right < v.x then
			right = v.x
		end

		if bottom < v.y then
			bottom = v.y
		end
	end

	return math.Round(left), math.Round(right), math.Round(top), math.Round(bottom)
end

meta_pl_g.Say = function(self, stuff)
	if self ~= Cache.LocalPlayer then return end

	self:ConCommand("say " .. stuff)
end

meta_pl_g.GetForward = function(self) -- Fix for context menu
	if self ~= Cache.LocalPlayer then return meta_en_g.GetForward(self) end

	if Cache.LocalPlayer:IsWorldClicking() then
		return gui.ScreenToVector(gui.MouseX(), gui.MouseY())
	end

	return meta_en_g.GetForward(self)
end

meta_pl_g.GetRealEyeTrace = function(self) -- Fix for antiaim
	if self ~= Cache.LocalPlayer then return self:GetEyeTrace() end

	return util.TraceLine({
		start = Cache.CalcView.EyePos,
		endpos = Cache.CalcView.EyePos + (Cache.CalcView.EyeAngles:Forward() * 32767),
		filter = Cache.LocalPlayer
	})
end

meta_pl_g.HasValidMoveType = function(self)
	return self:GetMoveType() == MOVETYPE_WALK and not IsValid(self:GetVehicle()) and self:WaterLevel() < 2
end

meta_cv_g.GetBoolSafe = function(self)
	if not self then return false end

	return self:GetBool()
end

meta_cv_g.GetFloatSafe = function(self)
	if not self then return 1 end -- Should technically be 0 but for my use, it's 1

	return self:GetFloat()
end

meta_wn_g.GetBase = function(self)
	if not self.Base then return nil end

	return self.Base:lower():Split("_")[1]
end

meta_wn_g.IsBasedOnShort = function(self, base)
	return self:GetBase() == base
end

meta_wn_g.GetNiceName = function(self)
	local name = self:GetClass()
	
	if self.GetPrintName then
		local printname = self:GetPrintName()

		if printname == "<MISSING SWEP PRINT NAME>" then
			return name
		end

		return language.GetPhrase(printname)
	end

	return name
end

-- Global additions

function player.GetCached(ValidOnly)
	if ValidOnly then
		local players = {}

		for i = 1, #Cache.Players do
			if not IsValid(Cache.Players[i]) then continue end

			players[#players + 1] = Cache.Players[i]
		end

		return players
	else
		return Cache.Players
	end
end

function player.GetSorted()
	local players = player.GetCached(true)
	local lpos = Cache.LocalPlayer:GetPos()

	table.sort(players, function(a, b)
		return a:GetPos():DistToSqr(lpos) > b:GetPos():DistToSqr(lpos)
	end)

	return players
end

-- Normal lame functions

local function GetEyePos()
	return Cache.CalcView.EyePos
end

local function GetEyeAngles()
	return Cache.CalcView.EyeAngles
end

local function GetFOV()
	return Cache.CalcView.FOV
end

local function GetZNear()
	return Cache.CalcView.ZNear
end

local function UpdateCalcViewData(data)
	if not data then return end

	Cache.CalcView.EyePos = data.origin
	Cache.CalcView.EyeAngles = data.angles
	Cache.CalcView.FOV = data.fov
	Cache.CalcView.ZNear = data.znear
end

local function AddHook(Type, Function)
	local Name = Cache.HookName

	Cache.Hooks.Local[#Cache.Hooks.Local + 1] = {Type, Name}
	
	print(string.format("Hook Added! %s %s", Type, Name))
	
	hook.Add(Type, Name, Function)
end

local function FixAngle(Angle)
    Angle.pitch = math.Clamp(math.NormalizeAngle(Angle.pitch), -89, 89)
    Angle.yaw = math.NormalizeAngle(Angle.yaw)
    Angle.roll = math.NormalizeAngle(Angle.roll)
end

local function TickToTime(Tick)
	return Cache.TickInterval * Tick
end

-- Gets the CurTime of the server
local function GetServerTime()
	return TickToTime(Cache.LocalPlayer:GetInternalVariable("m_nTickBase"))
end

local function CanShoot()
	local Weapon = Cache.LocalPlayer:GetActiveWeapon()
	if not IsValid(Weapon) then return false end

	local WeaponName = string.lower(Weapon.PrintName or Weapon:GetPrintName())
	
	for i = 1, #Cache.NotGuns do
		if string.find(WeaponName, Cache.NotGuns[i]) then
			local BreakOuter = false
	
			for i = 1, #Cache.ActuallyGuns do
				if string.find(WeaponName, Cache.ActuallyGuns[i]) then
					BreakOuter = true
					break
				end
			end
	
			if BreakOuter then continue end
	
			return false
		end
	end
	
	local Base = Weapon:GetBase()
	local BaseCheck = Cache.ExtraWeaponChecks[Base] and Cache.ExtraWeaponChecks[Base](Weapon) or true
	
	return GetServerTime() >= Weapon:GetNextPrimaryFire() and BaseCheck	
end

local function GetLerpTime()
	if not Cache.ConVars.cl_interpolate:GetBoolSafe() then
		return 0
	end
	
	if Cache.ConVars.sv_minupdaterate and Cache.ConVars.sv_maxupdaterate then
		Cache.ConVars.cl_updaterate = Cache.ConVars.sv_maxupdaterate:GetInt()
	end

	local ratio = Cache.ConVars.cl_interp_ratio:GetFloatSafe()
	if ratio == 0 then
		ratio = 1
	end

	local lerp = Cache.ConVars.cl_interp:GetFloatSafe()
	if Cache.ConVars.sv_client_max_interp_ratio and Cache.ConVars.sv_client_max_interp_ratio and Cache.ConVars.sv_client_min_interp_ratio:GetFloatSafe() ~= 1 then
		ratio = math.Clamp(ratio, Cache.ConVars.sv_client_min_interp_ratio:GetFloatSafe(), Cache.ConVars.sv_client_max_interp_ratio:GetFloatSafe())
	end

	return math.max(lerp, ratio / Cache.ConVars.cl_updaterate)
end

local function ToggleMenu()
	local stat = not MainFrame:IsVisible()
	
	EnvFrame:SetVisible(stat)
	MainFrame:SetVisible(stat)
	
	if stat then
		EnvFrame:MakePopup()
		MainFrame:MakePopup()
	else
		MainFrame:Close()
	end
	
	gui.EnableScreenClicker(not stat)
end

local function UpdateEntityCache()
	Cache.Entities = ents.GetAll()

	table.sort(Cache.Entities, function(a, b)
		return a:EntIndex() < b:EntIndex()
	end)

	for i = #Cache.Entities, 1, -1 do
		if Cache.Entities[i]:EntIndex() < 0 then -- Stupid ass entities
			table.remove(Cache.Entities, i)
		end
	end
end

local function UpdateCachedPlayers()
    table.Empty(Cache.Players)
	table.Merge(Cache.Players, player.GetAll())
end

local function UpdatePlayerList()
	if not IsValid(Cache.Panels.EnvPlayerList) then return end

	Cache.Panels.EnvPlayerList:Clear()

	local players = player.GetCached(true)

	for i = 1, #players do
		local v = players[i]

		local line = Cache.Panels.EnvPlayerList:AddLine(i, v:GetName(), table.HasValue(Vars.Aimbot.Friends, v) and "Friend" or "Normal")
		line._FHPlayer = v
	end
end

local function GetWeaponAmmoPenetration(weapon, tracedata)
	if not IsValid(weapon) then return nil end

	local AmmoType = weapon:GetPrimaryAmmoType()
	if not AmmoType then return nil end
	
	local AmmoName = game.GetAmmoName(AmmoType)
	if not AmmoName then return nil end
	
	tracedata = tracedata or Cache.LocalPlayer:GetRealEyeTrace()

	if not tracedata.Fraction then -- tracedata isn't already a traceresult
		tracedata = tracedata.mins and util.TraceHull(tracedata) or util.TraceLine(tracedata)
	end
	
	if weapon:IsBasedOnShort("bobs") then -- M9K is Bob's base
		if Cache.ConVars.Penetration.M9K:GetBoolSafe() then
			return nil
		end
	
		return Cache.AmmoPenetration.M9K[AmmoName] or nil
	end
	
	if weapon:IsBasedOnShort("tfa") then
		if not Cache.ConVars.Penetration.TFA:GetBoolSafe() then
			return nil
		end
	
		local AmmoForceMultiplier = weapon.GetAmmoForceMultiplier
		local PenetrationMultiplier = weapon.GetPenetrationMultiplier
		if not AmmoForceMultiplier or not PenetrationMultiplier then return nil end
		
		local Multiplier = Cache.ConVars.Penetration.TFA_Multiplier:GetFloatSafe()
		
		return ((AmmoForceMultiplier(weapon) / PenetrationMultiplier(weapon, tracedata.MatType)) * Multiplier) * 0.875
	end
	
	if weapon:IsBasedOnShort("arccw") then
		if not Cache.ConVars.Penetration.ArcCW:GetBoolSafe() then
			return nil
		end

		return math.pow(weapon.Penetration or math.huge, 2)
	end
	
	if weapon:IsBasedOnShort("fas2") then
		if not weapon.PenetrationEnabled or not weapon.PenStr then
			return nil
		end
		
		return math.pow(weapon.PenStr, 2) + (weapon.PenStr * 0.25)
	end
	
	if weapon:IsBasedOnShort("cw") then
		if not weapon.CanPenetrate or not weapon.PenStr then
			return nil
		end
		
		return math.pow(weapon.PenStr, 2) + (weapon.PenStr * 0.25)
	end
	
	return nil
end

local function WeaponCanPenetrate(weapon, tracedata)
	if not IsValid(weapon) then return false end

	tracedata = tracedata or Cache.LocalPlayer:GetRealEyeTrace()

	if not tracedata.Fraction then
		tracedata = tracedata.mins and util.TraceHull(tracedata) or util.TraceLine(tracedata)
	end
	
	if weapon:IsBasedOnShort("fas2") or weapon:IsBasedOnShort("cw") then
		local Entity = tracedata.Entity
		
		if tracedata.MatType == MAT_SLOSH or (IsValid(Entity) and (entity:IsPlayer() or entity:IsNPC())) then
			return false
		end
	end
	
	local AmmoPen = GetWeaponAmmoPenetration(weapon)
	if not AmmoPen then return false end
	
	local HitPos = tracedata.HitPos
	local Forward = tracedata.Normal
	local EndPos
	
	local pTraceData = {}
	
	for i = 1, 75 do
		local cur = HitPos + (Forward * i)
		
		pTraceData.start = cur
		pTraceData.endpos = cur
		
		local tr = util.TraceLine(pTraceData)
		
		if not tr.Hit then
			EndPos = cur
		
			break
		end
	end
	
	if EndPos then
		local decimals = tostring(AmmoPen):Split(".")
		decimals = decimals[2] and #decimals[2] or 0
		
		if weapon:IsBasedOnShort("tfa") then
			return math.Round(HitPos:Distance(EndPos) / 100, decmials) <= AmmoPen / 2, EndPos
		end
		
		return math.Round(HitPos:DistToSqr(EndPos), decimals) < AmmoPen, EndPos
	end

	return false
end

local function IsVisible(Position, Entity)
	local Trace = {
		output = Cache.TraceOutput,

		start = Cache.LocalPlayer:EyePos(),
		endpos = Position,
		filter = Cache.LocalPlayer,
		mask = MASK_SHOT
	}

	util.TraceLine(Trace)

	if Cache.TraceOutput.Entity == Entity then
		return true, 0, Cache.TraceOutput.Fraction
	elseif Vars.Aimbot.AutoWall then
		local Weapon = Cache.LocalPlayer:GetActiveWeapon()
		if not IsValid(Weapon) then
			return false, 0, Cache.TraceOutput.Fraction
		end

		local Hit, Penetrations = WeaponCanPenetrate(Weapon, Cache.TraceOutput, Entity, Position)
		Hit = Hit or false
		Penetrations = Penetrations or 0

		return Hit, Penetrations, Cache.TraceOutput.Fraction
	else
		return false, 0, Cache.TraceOutput.Fraction
	end
end

---- new aim functions

local function Sign(p1, p2, p3)
	if not p1 or not p2 or not p3 then return 0 end

	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

local function IsPointInTriangle(pt, tri)
	if not pt or not tri then return false end

	local v1, v2, v3 = tri[1], tri[2], tri[3]
	local n, p

	local test1 = Sign(pt, v1, v2)
	local test2 = Sign(pt, v2, v3)
	local test3 = Sign(pt, v3, v1)

	n = test1 < 0 or test2 < 0 or test3 < 0
	p = test1 > 0 or test2 > 0 or test3 > 0

	return not (n and p)
end

local function CalculateAntiRecoil(Weapon)
	if Weapon:GetClass() == "weapon_pistol" then
		return angle_zero
	end

	if Weapon:IsScripted() then
		if Weapon:GetBase() ~= "cw" and Weapon:GetBase() ~= "fas2" then
			return angle_zero
		end
	end

	return Cache.LocalPlayer:GetViewPunchAngles()
end

local function CalculateNoSpread(Weapon, cmd, ForwardAngle)
	if not Vars.Aimbot.NoSpread then return end

	if Weapon:GetClass() == "weapon_pistol" then
		cmd:SetRandomSeed(33)
		return
	end

	local WeaponCone = Cache.WeaponCones[Weapon:GetClass()]
	if not WeaponCone then return end

	if type(WeaponCone) == "function" then
		WeaponCone = WeaponCone(Weapon, cmd)
	end
	
	if Cache.WeaponConeFunctions[Weapon:GetBase()] then
		Cache.WeaponConeFunctions[Weapon:GetBase()](Weapon, cmd, WeaponCone, ForwardAngle)
		return
	end

	local Seed = md5.PseudoRandom(cmd:CommandNumber())

	local X = md5.EngineSpread[Seed].X
	local Y = md5.EngineSpread[Seed].Y

	local Forward = ForwardAngle:Forward()
	local Right = ForwardAngle:Right()
	local Up = ForwardAngle:Up()

	local SpreadVector = Forward + (X * WeaponCone.x * Right * -1) + (Y * WeaponCone.y * Up * -1)
	ForwardAngle:Set(SpreadVector:Angle())
end

local function PredictTargetPosition(Position, Entity)
	if not Cache.ConVars.cl_interpolate:GetBool() then return end

	local Velocity = Entity:GetAbsVelocity()
	if Velocity:IsZero() then return end

	local FrameTime = RealFrameTime()
	local InterpolationTime = GetLerpTime()
	local Difference = math.max(FrameTime, InterpolationTime) - math.min(FrameTime, InterpolationTime)

	Velocity:Mul(FrameTime + Difference)
	Position:Add(Velocity)
end

local function GetHitBoxPositions(entity) -- Scans hitboxes for aim points
	if not IsValid(entity) then
		return nil
	end

	local null = true

	local data = {
		[HITGROUP_HEAD] = {},
		[HITGROUP_CHEST] = {},
		[HITGROUP_STOMACH] = {}
	}

	for hitset = 0, entity:GetHitboxSetCount() - 1 do
		for hitbox = 0, entity:GetHitBoxCount(hitset) - 1 do
			local hitgroup = entity:GetHitBoxHitGroup(hitbox, hitset)

			if not hitgroup or not data[hitgroup] then continue end -- Should be impossible but just in case

			local bone = entity:GetHitBoxBone(hitbox, hitset)
			local mins, maxs = entity:GetHitBoxBounds(hitbox, hitset)

			if not bone or not mins or not maxs then continue end

			local bmatrix = entity:GetBoneMatrix(bone)

			if not bmatrix then continue end

			local pos, ang = bmatrix:GetTranslation(), bmatrix:GetAngles()

			if not pos or not ang then continue end

			mins:Rotate(ang)
			maxs:Rotate(ang)

			table.insert(data[hitgroup], pos + ((mins + maxs) * 0.5))

			null = false
		end
	end

	if null then
		return nil -- No hitboxes found
	end

	return data
end

local function GetBoneDataPosition(bonename) -- Turns bone names into hitgroups so I don't have to do some dumb if-else shit
	if not bonename then
		return nil
	end

	bonename = bonename:lower()

	if bonename:find("head") then
		return HITGROUP_HEAD
	end

	if bonename:find("spine") then -- Due to the nature of this, bone scanning will have more points than hitbox scanning, but bones aren't centered to the hitbox
		return HITGROUP_CHEST
	end

	if bonename:find("pelvis") then
		return HITGROUP_STOMACH
	end

	return nil
end

local function GetBonePositions(entity) -- Scans bones
	if not IsValid(entity) then
		return nil
	end

	entity:InvalidateBoneCache() -- Prevent some matrix issues
	entity:SetupBones()

	local null = true

	local data = {
		[HITGROUP_HEAD] = {},
		[HITGROUP_CHEST] = {},
		[HITGROUP_STOMACH] = {}
	}

	for bone = 0, entity:GetBoneCount() - 1 do
		local name = entity:GetBoneName(bone)

		if not name or name == "__INVALIDBONE__" then continue end -- Fuck you and your retarded models

		name = name:lower()

		local boneloc = GetBoneDataPosition(name)
		if not boneloc then continue end

		local bonematrix = entity:GetBoneMatrix(bone)
		if not bonematrix then continue end

		local pos = bonematrix:GetTranslation()
		if not pos then continue end

		--data[boneloc][#data[boneloc] + 1] = pos
		table.insert(data[boneloc], pos)

		null = false
	end

	if null then return nil end

	return data
end

local function GetAimPositions(entity)
	if not IsValid(entity) then
		return nil
	end

	local data = GetHitBoxPositions(entity) or GetBonePositions(entity) or { -- OBBCenter fallback (For error models and whatnot)
		[HITGROUP_HEAD] = {
			entity:LocalToWorld(entity:OBBCenter())
		}
	}

	return data
end

local function GetAimPosition(entity)
	if not IsValid(entity) then
		return nil
	end

	local data = GetAimPositions(entity)

	for _, set in ipairs(Vars.Aimbot.HitboxOrder) do -- Scans through the positions to find visible ones
		if not data[set] then continue end

		for _, v in ipairs(data[set]) do
			if IsVisible(v, entity) then
				return v
			end
		end
	end

	return nil
end

local function GetTarget(quick) -- Gets the player whose aimbot points are closest to the center of the screen
	local x, y = ScrW() * 0.5, ScrH() * 0.5

	local best = math.huge
	local entity = nil

	for _, v in ipairs(player.GetSorted()) do
		if v:IsInGodMode() or v:IsInBuildMode() or v:IsProtected() or (Vars.Aimbot.IgnoreFriends and v:IsFriend()) or IsValid(v:GetVehicle()) then continue end

		local obbpos = v:LocalToWorld(v:OBBCenter())
		local pos = obbpos:ToScreen() -- Quick checks OBB only
	
		local cur = math.Dist(pos.x, pos.y, x, y)
	
		if IsVisible(obbpos, v) and cur < best and IsPointInTriangle(pos, Cache.FOVTri) then -- Closest player inside the FOV triangle
			best = cur
			entity = v
		end

		if quick then continue end

		local data = GetAimPositions(v)

		for _, set in ipairs(Vars.Aimbot.HitboxOrder) do
			if not data[set] then continue end
	
			for _, d in ipairs(data[set]) do
				if not IsVisible(d, v) then continue end

				pos = d:ToScreen()
				cur = math.Dist(pos.x, pos.y, x, y)

				if cur < best and IsPointInTriangle(pos, Cache.FOVTri) then
					best = cur
					entity = v
				end
			end
		end
	end

	return entity
end

local function Aimbot(cmd)
	local Weapon = Cache.LocalPlayer:GetActiveWeapon()
	
	local KeyDown = input.IsButtonDown(Vars.Aimbot.Key)

	if Vars.Aimbot.Enabled and (KeyDown or cmd:KeyDown(IN_ATTACK)) and (IsValid(Weapon) and CanShoot()) then
		if not KeyDown then
			local NewForward = Angle(Cache.FacingAngle)

			if Vars.Aimbot.NoSpread then CalculateNoSpread(Weapon, cmd, NewForward) end
			if Vars.Aimbot.AntiRecoil then NewForward:Sub(CalculateAntiRecoil(Weapon)) end
			FixAngle(NewForward)

			cmd:SetViewAngles(NewForward)

			return 
		end

		local Target = GetTarget()
		if not IsValid(Target) then return end

		local Position = GetAimPosition(Target)
		if not Position then return end
		
		PredictTargetPosition(Position, Target)
		
		local Direction = (Position - Cache.LocalPlayer:EyePos()):Angle()

		if Vars.Aimbot.Enabled then cmd:AddKey(IN_ATTACK) end

		if not Vars.Aimbot.Silent then Cache.FacingAngle = Angle(Direction) end
		if Vars.Aimbot.NoSpread then CalculateNoSpread(Weapon, cmd, Direction) end
		if Vars.Aimbot.AntiRecoil then Direction:Sub(CalculateAntiRecoil(Weapon)) end
		FixAngle(Direction)

		cmd:SetViewAngles(Direction)
	end
end

local function FixMovement(cmd)
	local MovementVector = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), 0)

	local CMDAngle = cmd:GetViewAngles()
	local Yaw = CMDAngle.yaw - Cache.FacingAngle.yaw + MovementVector:Angle().yaw
	
	if (CMDAngle.pitch + 90) % 360 > 180 then
		Yaw = 180 - Yaw
	end
	
	Yaw = ((Yaw + 180) % 360) - 180
	
	local Speed = math.sqrt((MovementVector.x * MovementVector.x) + (MovementVector.y * MovementVector.y))
	Yaw = math.rad(Yaw)

	Cache.MovementFix.x = math.cos(Yaw) * Speed
	Cache.MovementFix.y = math.sin(Yaw) * Speed
	
	cmd:SetForwardMove(Cache.MovementFix.x )
	cmd:SetSideMove(Cache.MovementFix.y)
end

local function GenerateReport(ply)
	local id = "3"

	for i = 1, 18 do
		id = id .. math.random(0, 9)
	end

	return "Report " .. (IsValid(ply) and "for " .. ply:GetName() .. " " or "") .. "submitted, report id " .. id
end

local function CoinFlip(odds)
	odds = odds or 50

	return math.random(0, 100) < odds
end

local function GetDeathSay(attacker)
	if CoinFlip(10) then
		return GenerateReport(attacker)
	else
		return Cache.DeathSays[Vars.Miscellaneous.DeathSay.Mode][math.random(#Cache.DeathSays[Vars.Miscellaneous.DeathSay.Mode])]
	end
end

local function ShouldAntiAim(cmd)
	local Weapon = Cache.LocalPlayer:GetActiveWeapon()

	return Cache.LocalPlayer:Alive() and Cache.LocalPlayer:GetObserverMode() == OBS_MODE_NONE and Cache.LocalPlayer:Team() ~= TEAM_SPECTATOR and not ((cmd and cmd:KeyDown(IN_ATTACK) or Cache.LocalPlayer:KeyDown(IN_ATTACK)) and CanShoot()) and not (cmd and cmd:KeyDown(IN_USE) or Cache.LocalPlayer:KeyDown(IN_USE)) and Cache.LocalPlayer:GetMoveType() == MOVETYPE_WALK and not IsValid(Cache.LocalPlayer:GetVehicle()) and Cache.LocalPlayer:WaterLevel() < 2
end

local function RenderReal(ply)
	if not Vars.HvH.AntiAim.Enabled or Vars.HvH.AntiAim.ForceOff then return end

	local rAngle = Angle(0, Cache.FacingAngle.yaw + Vars.HvH.AntiAim.Yaw.Real + (Vars.HvH.AntiAim.Breaker.Active and Vars.HvH.AntiAim.Breaker.Delta or 0), 0)
    FixAngle(rAngle)

	ply:SetRenderAngles(rAngle)

	rAngle.pitch = Cache.AntiAimAngle.pitch

	local head_pitch_min, head_pitch_max = ply:GetPoseParameterRange(ply:LookupPoseParameter("head_pitch"))
	local aim_pitch_min, aim_pitch_max = ply:GetPoseParameterRange(ply:LookupPoseParameter("aim_pitch"))
	local move_x_min, move_x_max = ply:GetPoseParameterRange(ply:LookupPoseParameter("move_x"))
	local move_y_min, move_y_max = ply:GetPoseParameterRange(ply:LookupPoseParameter("move_y"))

	ply:SetPoseParameter("head_pitch", math.Clamp(rAngle.pitch, head_pitch_min, head_pitch_max))
	ply:SetPoseParameter("aim_pitch", math.Clamp(rAngle.pitch, aim_pitch_min, aim_pitch_max))
	ply:SetPoseParameter("move_x", math.Clamp(Cache.MovementFix.x, move_x_min, move_x_max))
	ply:SetPoseParameter("move_y", math.Clamp(Cache.MovementFix.y, move_y_min, move_y_max))

	ply:InvalidateBoneCache()
end

local function FreeCam(cmd)
	if not Vars.Miscellaneous.FreeCam.Enabled then return end

	-- Movement
	
	local CamAng = Cache.FreeCam.Angle
	local CamPos = Cache.FreeCam.Position

	local Forward = Cache.FreeCam.Angle:Forward()
	local Right = Cache.FreeCam.Angle:Right()
	local Up = Cache.FreeCam.Angle:Up()

	local Speed = 0

	if cmd:KeyDown(IN_WALK) then
		Speed = Cache.FreeCam.Speeds.Walk
	elseif cmd:KeyDown(IN_SPEED) then
		Speed = Cache.FreeCam.Speeds.Sprint
	else
		Speed = Cache.FreeCam.Speeds.Normal
	end

	Speed = Speed * (RealFrameTime() * Vars.Miscellaneous.FreeCam.Speed)
	
	if cmd:KeyDown(IN_JUMP) then
		Cache.FreeCam.Position:Add(Up * Speed)
	end
	
	if cmd:KeyDown(IN_DUCK) then
		Cache.FreeCam.Position:Sub(Up * Speed)
	end

	if cmd:KeyDown(IN_FORWARD) then
		Cache.FreeCam.Position:Add(Forward * Speed)
	end

	if cmd:KeyDown(IN_BACK) then
		Cache.FreeCam.Position:Sub(Forward * Speed)
	end

	if cmd:KeyDown(IN_MOVERIGHT) then
		Cache.FreeCam.Position:Add(Right * Speed)
	end

	if cmd:KeyDown(IN_MOVELEFT) then
		Cache.FreeCam.Position:Sub(Right * Speed)
	end

	-- Camera

	local MouseX = cmd:GetMouseX()
	local MouseY = cmd:GetMouseY()

	if MouseX ~= 0 or MouseY ~= 0 then
		Cache.FreeCam.Angle = Cache.FacingAngle

		cmd:SetMouseX(0)
		cmd:SetMouseY(0)
	end

	cmd:ClearButtons()
	cmd:ClearMovement()

	cmd:SetViewAngles(Cache.FreeCam.PreAngle)	
end

--[[
	Setup Nospread Seeds
]]

do
	local RandomStream = CUniformRandomStream.New()

	local ShotBiasMin = GetConVar("ai_shot_bias_min"):GetFloat()
	local ShotBiasMax = GetConVar("ai_shot_bias_max"):GetFloat()
	local ShotBiasDif = (ShotBiasMax - ShotBiasMin) + ShotBiasMin
	local Flatness = math.abs(ShotBiasDif) / 2
	local iFlatness = 1 - Flatness
	
	for Seed = 0, 255 do
		RandomStream:SetSeed(Seed)
	
		local FirstRan = false
		local X, Y, Z = 0, 0, 0
	
		while true do
			if Z <= 1 and FirstRan then break end
	
			X = (RandomStream:RandomFloat(-1, 1) * Flatness) + (RandomStream:RandomFloat(-1, 1) * iFlatness)
			Y = (RandomStream:RandomFloat(-1, 1) * Flatness) + (RandomStream:RandomFloat(-1, 1) * iFlatness)
	
			if ShotBiasDif < 0 then
				X = X >= 0 and 1 - X or -1 - X
				Y = Y >= 0 and 1 - Y or -1 - Y
			end
	
			Z = (X * X) + (Y * Y)
			FirstRan = true
		end
	
		md5.EngineSpread[Seed] = {
			X = X,
			Y = Y,
			Z = Z
		 }
	end	
end

--[[
	Hooks
]]

gameevent.Listen("player_connect_client")
AddHook("player_connect_client", function()
	UpdateEntityCache()
	UpdateCachedPlayers()

	UpdatePlayerList()
end)

gameevent.Listen("player_disconnect")
AddHook("player_disconnect", function()
	UpdateEntityCache()
	UpdateCachedPlayers()

	UpdatePlayerList()
end)

gameevent.Listen("entity_killed")
AddHook("entity_killed", function(data)
	attacker = ents.GetByIndex(data.entindex_attacker) or NULL
	victim = ents.GetByIndex(data.entindex_killed) or NULL

	if not IsValid(attacker) or not IsValid(victim) or not victim:IsPlayer() or victim == attacker then return end


	if attacker == Cache.LocalPlayer and Vars.Miscellaneous.KillSound.Enabled then
		timer.Simple(0, function()
			sound.PlayFile(Vars.Miscellaneous.KillSound.Path, "mono", function() end)
		end)
	end
end)

AddHook("EntityFireBullets", function(Player, Data)
	if Player ~= Cache.LocalPlayer then return end
	if not IsFirstTimePredicted() then return end 
	
	local Weapon = Player:GetActiveWeapon()
	if not IsValid(Weapon) then return end

	if isvector(Data.Spread) and not Data.Spread:IsZero() then
		Cache.WeaponCones[Weapon:GetClass()] = Data.Spread
	end
end)

AddHook("Tick", function()
	Cache.LocalPlayer = LocalPlayer()

	local CurTime = SysTime()

	if CurTime - Cache.LastUpdate >= 0.3 then
		UpdateEntityCache()

		local doUpdatePlayerList = false

		if IsValid(Cache.Panels.EnvPlayerList) then
			if #Cache.Players ~= #Cache.Panels.EnvPlayerList:GetLines() then
				doUpdatePlayerList = true
			end
		end

		for i = 1, #Cache.Players do
			if not IsValid(Cache.Players[i]) then -- Update Player List menu if a connect/disconnect was missed
				doUpdatePlayerList = true

				break
			end
		end

		UpdateCachedPlayers()

		if doUpdatePlayerList then
			UpdatePlayerList()
		end

		Cache.LastUpdate = CurTime
	end
end)

AddHook("InputMouseApply", function(cmd, MouseX, MouseY)
	Cache.FacingAngle.p = Cache.FacingAngle.p + (MouseY * Cache.ConVars.m_pitch:GetFloat())
	Cache.FacingAngle.y = Cache.FacingAngle.y - (MouseX * Cache.ConVars.m_yaw:GetFloat())

	FixAngle(Cache.FacingAngle)
end)

AddHook("CreateMove", function(cmd)
	if cmd:CommandNumber() == 0 then
		if cmd:KeyDown(IN_USE) then
			Cache.FacingAngle = cmd:GetViewAngles()
		end

		cmd:SetViewAngles(Cache.FacingAngle)

		return
	end
	
	FreeCam(cmd)

	local Velocity = Cache.LocalPlayer:GetVelocity()
	local Velocity2D = Velocity:Length2D()
	local ValidMoveType = Cache.LocalPlayer:HasValidMoveType()
	local Grounded = Cache.LocalPlayer:IsOnGround()
	local SideMove = cmd:GetSideMove()
	local ForwardMove = cmd:GetForwardMove()
	local MaxSideMove = Cache.ConVars.cl_sidespeed:GetFloatSafe()
	local MaxForwardMove = Cache.ConVars.cl_forwardspeed:GetFloatSafe()
	
	local MouseX = cmd:GetMouseX()
	local MouseY = cmd:GetMouseY()

	if Vars.Miscellaneous.Movement.Bhop then
		if cmd:KeyDown(IN_JUMP) then
			if not Grounded then
				cmd:RemoveKey(IN_JUMP)
				Cache.BhopStickTick = 0
			else
				Cache.BhopStickTick = Cache.BhopStickTick + 1

				if Cache.BhopStickTick > 4 then -- Fix for sv_sticktoground
					cmd:RemoveKey(IN_JUMP)
					Cache.BhopStickTick = 0
				end
			end
		end
	end

	if Vars.Miscellaneous.Movement.AutoStrafe.Enabled and ValidMoveType then
		if not Grounded then
			if MouseX > 0 then
				cmd:SetSideMove(MaxSideMove)
			elseif MouseX < 0 then
				cmd:SetSideMove(MaxSideMove * -1)
			end
		end
		
		if Vars.Miscellaneous.Movement.AutoStrafe.Mode == AUTOSTRAFE_MODE_RAGE and cmd:KeyDown(IN_JUMP) then
			if Grounded then
				cmd:SetForwardMove(MaxForwardMove)
			else
				cmd:SetForwardMove((MaxForwardMove * 0.5) / Velocity2D)
				cmd:SetSideMove(cmd:CommandNumber() % 2 == 0 and (MaxSideMove * -1) or MaxSideMove)
			end
		end
	end

	Vars.HvH.AntiAim.ForceOff = true
	Vars.HvH.AntiAim.Breaker.Active = false

	if Vars.HvH.AntiAim.Enabled or Vars.HvH.FakeLag.Enabled then
		if ShouldAntiAim(cmd) then
			Vars.HvH.AntiAim.ForceOff = false

			if Vars.HvH.AntiAim.Enabled then
				local fYaw = Cache.FacingAngle.yaw

				if Vars.HvH.AntiAim.Breaker.Enabled and Vars.HvH.bSendPacket then
					if CurTime() - Vars.HvH.AntiAim.Breaker.LastBreak >= 1.1 then
						fYaw = fYaw + Vars.HvH.AntiAim.Breaker.Delta

						Vars.HvH.AntiAim.Breaker.LastBreak = CurTime()
						Vars.HvH.AntiAim.Breaker.Active = true
					end
				end

				Cache.AntiAimAngle.pitch = Vars.HvH.AntiAim.Pitch
				Cache.AntiAimAngle.yaw = fYaw + (Vars.HvH.bSendPacket and Vars.HvH.AntiAim.Yaw.Fake or Vars.HvH.AntiAim.Yaw.Real)

				FixAngle(Cache.AntiAimAngle)

				cmd:SetViewAngles(Cache.AntiAimAngle)
			end

			if Vars.HvH.FakeLag.Enabled then
				local MaxTick = Grounded and Vars.HvH.FakeLag.MaxTick.Ground or Vars.HvH.FakeLag.MaxTick.Air

				if Vars.HvH.FakeLag.CurTick >= MaxTick then
					Vars.HvH.bSendPacket = true
					Vars.HvH.FakeLag.CurTick = 0
				else
					Vars.HvH.bSendPacket = false
					Vars.HvH.FakeLag.CurTick = Vars.HvH.FakeLag.CurTick + 1
				end
			else
				Vars.HvH.bSendPacket = true
			end
		else
			Vars.HvH.bSendPacket = true
		end
	else
		Vars.HvH.bSendPacket = true
	end

	GetSendPacket(Vars.HvH.bSendPacket)

	local LocalWeapon = Cache.LocalPlayer:GetActiveWeapon()

	StartPrediction(cmd)
		Aimbot(cmd)
	EndPrediction()

	FixMovement(cmd)

	cmd:SetSideMove(math.Clamp(cmd:GetSideMove(), MaxSideMove * -1, MaxSideMove))
	cmd:SetForwardMove(math.Clamp(cmd:GetForwardMove(), MaxForwardMove * -1, MaxForwardMove))
end)

AddHook("HUDPaint", function()
	if Vars.Visuals.ESP.Enabled then
		surface.SetFont(fgui.FontName)

		for _, v in next, player.GetCached(true) do
			if not v:IsTargettable() then continue end

			local OBBPos = v:LocalToWorld(v:OBBCenter()):ToScreen()

			if not OBBPos.visible then continue end

			if Vars.Visuals.ESP.Skeleton then
				v:SetupBones()

				surface.SetDrawColor(Vars.Visuals.ESP.Colors.Skeleton)

				for i = 0, v:GetBoneCount() - 1 do
					local parent = v:GetBoneParent(i)
					if not parent or parent == -1 then continue end
		
					local pbhb = v:BoneHasFlag(parent, BONE_USED_BY_HITBOX)
					local bhb = v:BoneHasFlag(i, BONE_USED_BY_HITBOX)
					if not pbhb or not bhb then continue end
		
					local pbm = v:GetBoneMatrix(parent)
					local bm = v:GetBoneMatrix(i)
					if not pbm or not bm then continue end
		
					local ppos = pbm:GetTranslation()
					local pos = bm:GetTranslation()
					if not ppos or not pos then continue end
		
					ppos = ppos:ToScreen()
					pos = pos:ToScreen()
		
					surface.DrawLine(ppos.x, ppos.y, pos.x, pos.y)
				end
			end

			local left, right, top, bottom = v:GetScreenCorners()
			local w, h = right - left, bottom - top

			if Vars.Visuals.ESP.Box then
				surface.SetDrawColor(Vars.Visuals.ESP.Colors.Box)
				surface.DrawOutlinedRect(left, top, w - 1, h - 1)

				surface.SetDrawColor(Cache.Colors.Black)
				surface.DrawOutlinedRect(left - 1, top - 1, w + 1, h + 1)
				surface.DrawOutlinedRect(left + 1, top + 1, w - 3, h - 3)
			end

			if Vars.Visuals.ESP.Name then
				surface.SetTextColor(Vars.Visuals.ESP.Colors.Name)

				local name = v:GetName()
				tw, th = surface.GetTextSize(name)

				surface.SetTextPos(left + (w / 2) - (tw / 2), top - th)
				surface.DrawText(name)
			end

			if Vars.Visuals.ESP.Weapon then
				surface.SetTextColor(Vars.Visuals.ESP.Colors.Weapon)

				local vWeapon = v:GetActiveWeapon()

				name = IsValid(vWeapon) and vWeapon:GetNiceName() or ""
				tw, th = surface.GetTextSize(name)

				surface.SetTextPos(left + (w / 2) - (tw / 2), bottom)
				surface.DrawText(name)
			end

			if Vars.Visuals.ESP.Flags then
				surface.SetTextColor(Vars.Visuals.ESP.Colors.Flags)

				local pFlags = {}

				if v:IsInGodMode() then
					pFlags[#pFlags + 1] = "*Godmode*"
				end

				if v:IsInBuildMode() then
					pFlags[#pFlags + 1] = "*Build Mode*"
				end

				if v:IsProtected() then
					pFlags[#pFlags + 1] = "*Protected*"
				end

				if #pFlags > 0 then
					local ypos = top
					local _, th = surface.GetTextSize(pFlags[1])

					for _, v in next, pFlags do
						surface.SetTextPos(right, ypos)
						surface.DrawText(v)

						_, th = surface.GetTextSize(v)

						ypos = ypos + th
					end
				end
			end

			if Vars.Visuals.ESP.Health.Enabled then
				local hw, s = 4, 2

				local health = v:Health()
				
				local healthColor, percent = v:GetHealthColor()
				local healthScreen = math.Round((h * percent) - 1)
				local healthPos = (bottom - healthScreen) - 1

				if Vars.Visuals.ESP.Health.Bar then
					surface.SetDrawColor(Cache.Colors.Black)
					surface.DrawOutlinedRect(left - s - hw, top - 1, hw, h + 1)

					surface.SetDrawColor(44, 44, 44, 255)
					surface.DrawRect((left - s - hw) + 1, top, hw - 2, h - 1)

					surface.SetDrawColor(healthColor)
					surface.DrawRect((left - s - hw) + 1, healthPos, hw - 2, healthScreen)
				end

				if Vars.Visuals.ESP.Health.Amount then
					if health ~= v:GetMaxHealth() then
						local tw, th = surface.GetTextSize(health)

						local ypos = top

						if Vars.Visuals.ESP.Health.Bar then
							ypos = math.Clamp(healthPos, healthPos - (th / 3), bottom - th)
							surface.SetTextColor(Cache.Colors.White)
						else
							surface.SetTextColor(healthColor)
						end

						surface.SetTextPos(left - s - hw - tw, ypos)
						surface.DrawText(health)
					end
				end
			end
		end
	end

	local w = ScrW()
	local x, y = w * 0.5, ScrH() * 0.5
	local fovrad = (math.tan(math.rad(Vars.Aimbot.AimCone.FOV)) / math.tan(math.rad(GetFOV() * 0.5)) * w) / GetZNear()

	local t = fovrad * 2.3333333333333
	local s = x - (t / 2)
	local m = fovrad
	local offset_y = 0 - (fovrad / 3)

	Cache.FOVTri = {
		{x = s, y = (y + m) + offset_y},
		{x = s + t, y = (y + m) + offset_y},
		{x = x, y = (y - m) + offset_y}
	}

	local v1, v2, v3 = Cache.FOVTri[1], Cache.FOVTri[2], Cache.FOVTri[3]

	surface.SetDrawColor(color_white)
	surface.DrawLine(v1.x, v1.y, v2.x, v2.y)
	surface.DrawLine(v2.x, v2.y, v3.x, v3.y)
	surface.DrawLine(v3.x, v3.y, v1.x, v1.y)
end)

AddHook("PreDrawHalos", function() -- Hah just kidding, these aren't actually halos
	if Vars.Visuals.ESP.Enabled and Vars.Visuals.ESP.Outline then
		local Outlined = {}

		for _, v in ipairs(player.GetCached(true)) do
			if not v:IsTargettable() then continue end

			Outlined[#Outlined + 1] = v
		end

		outline.Add(Outlined, Vars.Visuals.ESP.Colors.Outline, OUTLINE_MODE_BOTH)
	end
end)

AddHook("CalcView", function(ply, pos, ang, fov, zn, zf)
	if ply ~= Cache.LocalPlayer then return end

	ang:Set(Cache.FacingAngle * 1)

	if not Vars.Aimbot.AntiRecoil then
		ang:Add(ply:GetViewPunchAngles())
	end
	
	local FreeCamEnabled = Vars.Miscellaneous.FreeCam.Enabled

	local view = {
		origin = FreeCamEnabled and Cache.FreeCam.Position or pos,
		angles = FreeCamEnabled and Cache.FreeCam.Angle or ang, 
		fov = fov,
		znear = zn,
		zfar = zf,
		drawviewer = FreeCamEnabled
	}
	
	local Vehicle = ply:GetVehicle()
	
	if IsValid(Vehicle) then
		UpdateCalcViewData(view)

		return hook.Run("CalcVehicleView", Vehicle, ply, view)
	end
	
	local Weapon = ply:GetActiveWeapon()
	
	if IsValid(Weapon) then
		local WeaponCalcView = Weapon.CalcView
		
		if WeaponCalcView then
			local DummyAngle = angle_zero
			
			view.origin, DummyAngle, view.fov = WeaponCalcView(Weapon, ply, view.origin * 1, view.angles * 1, view.fov)
			
			if not Vars.Aimbot.AntiRecoil then
				view.angles = DummyAngle
			end
		end
	end

	UpdateCalcViewData(view)

	return view
end)

AddHook("PrePlayerDraw", function(ply)
	if ply ~= Cache.LocalPlayer or not ShouldAntiAim() then return end

	RenderReal(ply)
end)

AddHook("PostPlayerDraw", function(ply)
	if ply ~= Cache.LocalPlayer or not ShouldAntiAim() then return end

	RenderReal(ply)
end)

--[[
	ConCommands
]]

concommand.Add("pMenu_toggle", function()
	ToggleMenu()
end)

concommand.Add("unload", function()
	for i = 1, #Cache.Hooks.Local do
		local CurrHook = Cache.Hooks.Local[i]
		local Type, Name = CurrHook[1], CurrHook[2]
		
		print(string.format("Removed Hook! %s %s", Type, Name))

		hook.Remove(Type, Name)
	end

	MainFrame:SetVisible(false)
	EnvFrame:SetVisible(false)

	concommand.Remove("pMenu_toggle")
	concommand.Remove("unload")
end)

-- Kabo

UpdateEntityCache()
UpdateCachedPlayers()
UpdatePlayerList()

ToggleMenu()
