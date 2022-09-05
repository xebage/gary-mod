jit.flush()
 
local gdraw = draw
local simpletxt = gdraw.SimpleText
local simpletxtout = gdraw.SimpleTextOutlined
local gRoundedBoxEx = gdraw.RoundedBoxEx
local gRoundedBox = gdraw.RoundedBox
 
local gmath = math
local matan = gmath.atan
local mabs = gmath.abs
local mcos = gmath.cos
local macos = gmath.acos
local msin = gmath.sin
local mrad = gmath.rad
local mdeg = gmath.deg
local mRound = gmath.Round
local mRand = gmath.Rand
local mClamp = gmath.Clamp
local mfloor = gmath.floor
local mrandom = gmath.random
local mSqrt = gmath.sqrt
local mMin = gmath.Min
local mRandSeed = gmath.randomseed
local nAngle = gmath.NormalizeAngle
 
local gsurface = surface
local sPlaySound = gsurface.PlaySound
local sDrawRect = gsurface.DrawRect
local sDrawLine = gsurface.DrawLine
local sDrawText = gsurface.DrawText
local sCreateFont = gsurface.CreateFont
local sGetTextSize = gsurface.GetTextSize
local sSetTextColor = gsurface.SetTextColor
local sSetTextPos = gsurface.SetTextPos
local sSetDrawColor = gsurface.SetDrawColor
local sSetFont = gsurface.SetFont
local sDrawOutlinedRect = gsurface.DrawOutlinedRect
local sDrawCircle = gsurface.DrawCircle
 
local lply = LocalPlayer()
local cmdFont = 'BudgetLabel'
local guiFont = 'Trebuchet18'
local ui = ui
local frame = frame
 
local hk = hook
local hAdd = hk.Add
local hRem = hk.Remove
local hRun = hk.Run
local hTbl = hk.GetTable
 
local gtable = table
local tSort = gtable.sort
local tRandom = gtable.Random
local tIns = gtable.insert
local tEmpty = gtable.Empty
local tString = gtable.ToString
local tcopy = gtable.Copy
 
local gtimer = timer
local tCreate = gtimer.Create
local tRemove = gtimer.Remove
 
local teamGetColor = team.GetColor
local isValid = IsValid
local ccmd = concommand.Add
local gcvar = GetConVar
local rcmd = RunConsoleCommand
local realFrameTime = RealFrameTime
local frameTime = FrameTime
local nulVec = Vector()
 
local sv_gravity = gcvar('sv_gravity'):GetFloat()
local sv_friction = gcvar('sv_friction'):GetFloat()
local sv_stopspeed = gcvar('sv_stopspeed'):GetFloat()
local sv_accelerate = gcvar('sv_accelerate'):GetFloat()
 
local grender = render
local rDrawLine = render.DrawLine
local rGetRenderTarget = grender.GetRenderTarget
local rCopyRenderTargetToTexture = grender.CopyRenderTargetToTexture
 
local R_ = debug.getregistry()
local R = tcopy( R_ )
 
pcall(require, "frozen2")

local StartEnginePred = StartPrediction
local StopEnginePred = EndPrediction
local nbpkt = false
local getFLBool = GetSendPacket
local GetLatency = (lply:Ping()/1000)
 
 
sCreateFont( 'FONT', {
   font  = 'Roboto',
   size  = 18,
   weight   = 600,
})

sCreateFont( 'FONT2', {
   font  = 'BudgetLabel',
   size  = 18,
   weight   = 600,
})
 
local chamsmat_1 = CreateMaterial(' ' .. tostring(SysTime()), 'VertexLitGeneric',{
        ['$basetexture'] = 'color/white',
        ['$model'] = 1,
        ['$ignorez'] = 1,
})
 
local chamsmat_2 = CreateMaterial('2 ' .. tostring(SysTime()), 'VertexLitGeneric',{
    ['$basetexture'] = 'color/white',
    ['$model'] = 1,
    ['$ignorez'] = 1,
})
 
local colors = {
    white = Color(255, 255, 255),
    red = Color(255, 0, 0),
    crimson = Color(175,0,42),
    green = Color(0, 255, 0),
    greener = Color(132,222,2),
    blue = Color(0, 0, 255),
    grey = Color(155, 155, 155),
    orange = Color(255, 126, 0),
    purple = Color(160, 32, 240),
    violet = Color(178,132,190),
    seafoam = Color(201,255,229)
}
 
local vars = {
    hudpaint = true,
    xhair = true,
 
    bhop = true,
    bhop_as = false,
 
    tps = false,
    tps_h = 0,
    tps_y = 0,
    fov = 100,
 
    tesp = true,
    tesp_names = true,
    tesp_wep = false,
    tesp_dormant = false,
    tesp_group = false,
    tesp_props = false,
 
    esp = true,
    esp_boxes = false,
    esp_lines = false,
    esp_lplylines = true,
    esp_tracers = false,
    esp_chams = true,
    esp_hitboxes = false,
    esp_xray = true,
 
    act = false,
    act_type = 'robot',
    act_delay = 1,
 
    light = false,
    light_size = 100,
    light_bright = 5,
    light_ply = false,
    light_col_r = 255,
    light_col_g = 255,
    light_col_b = 255,
 
    firekey = 'f',
    predtype = 'velocity',
    predtype_autoswap = true,
    mpred_num = 200,
 
    preddot = true,
    predline = true,
    showinfo = true,
 
    aim_triggerbot = true,
    aim_silent = true,
    aim_noteam = false,
    aim_nofriends = false,
    aim_onlybots = false,
    aim_onlynpcs = false,
    aim_autofire = false,
    aim_rapidfire = true,
    aim_wallbang = false,
    aim_smarttb = false,
    aim_bias = 0,
    aim_baim = false,
    aim_cone = true,
    aim_conefov = 16,
    targmode = 'xhair',
 
    fl = false,
    fl_choke = 1,
    fl_send = 1,
    fl_triggerbot = false,
 
    aa = false,
    aa_mode = 'spinx2',
    aa_realy = 0,
    aa_realp = 0,
    aa_fakey = 180,
    aa_fakep = 90,
    fakeduck = false,
}

local friends = {}
local vdbg = {
    destroy = false,
    view = Angle(),
}
 
--------------
--   menu   --
--------------
 
local function DrawText(col,x,y,str,font)
    sSetTextColor(col.r,col.g,col.b,col.a)
    sSetTextPos(x,y)
    sSetFont(font)
    sDrawText(str)
end

local function GetTextSize(font,str)
    sSetFont(font)
    return sGetTextSize(str)
end

local function ThemeBox(name,x,y,x1,y1,col,col2)
    DrawText(col,x+30,y-7,name,guiFont)
    local w,h = GetTextSize(cmdFont,name)
    sSetDrawColor(col2)
    sDrawLine(x,y,x+25,y)
    sDrawLine(x+w+35,y,x+x1,y)
    sDrawLine(x,y+y1,x+x1,y+y1)
    sDrawLine(x,y+y1,x,y)
    sDrawLine(x+x1,y+y1,x+x1,y)
end

local function DrawCircle(X, Y, R, col )
    sDrawCircle(X,Y,R)
    sSetDrawColor(col.r,col.g,col.b,col.a)
end
 
local function checkbox( name, tooltip, val, x, y, parent )
    local checkbox = vgui.Create( "DCheckBoxLabel", parent )
    checkbox:SetText( name )
    checkbox:SetPos( x, y )
    checkbox:SetChecked( vars[val] )

    if isstring( tooltip ) then
        checkbox:SetTooltip( tooltip )
    end

    function checkbox:OnChange(bval)
        vars[val] = bval
    end
    function checkbox:PaintOver()
        draw.RoundedBox( 0, 0, 0, 15, 15, Color( 0, 0, 0 ) )
        if checkbox:GetChecked() then
            draw.RoundedBox( 0, 4, 4, 7.5, 7.5, Color( 100, 0, 0 ) )
        end
    end
end
 
local function slider( name, val, min, max, x, y, w, h, parent)
    local slider = vgui.Create( "DNumSlider", parent)
    slider:SetMin( min )
    slider:SetMax( max )
    slider:SetText( name )
    slider:SetSize(w, h)
    slider:SetPos(x, y)
    slider:SetValue( vars[val] )
    slider:SetDecimals(0)

    function slider:OnValueChanged( num )
        vars[val] = num
    end
end
 
local messages = {}
local blockedhooks = {}
local tabselect = 'Fart Console'
local msgtext
 
local function addText(...)
    local col = HSVToColor(  ( CurTime() * 100) % 360, 1, 1 )
    local args = {...}
    local txtinfo = {
        text = {'*'},
        color = {col},
    }
    for i = 1, #args do
        if isstring(args[i]) then
            txtinfo.text[#txtinfo.text + 1] = args[i]
        else
            txtinfo.color[#txtinfo.color + 1] = args[i]
        end
    end
    if msgtext then
        for i, text in pairs(txtinfo.text) do
            local color = txtinfo.color[i] or colors.white
            msgtext:InsertColorChange(color.r, color.g, color.b, 255)
            msgtext:AppendText(text)
        end
        msgtext:AppendText('\n')
    end
    tIns(messages, txtinfo)
end
 
local function makeHook(txt,fnc)
    local sys,txsz = tostring((util.CRC(mrandom(10^4)+SysTime())) )..'',#txt
    addText(colors.green,'Hook added! ['..txt..'] '..('.'):rep((#sys+2-txsz)+20)..sys)
    hAdd(txt,'Fart|'..util.CRC(mrandom(10^4)+SysTime()),fnc)
end
 
local cmds = {}
 
cmds = {
    help = {
        function()
            addText(colors.red, 'CMDS:')
            for k, v in pairs(cmds) do
                addText(colors.white, k)
            end
            addText(colors.red, 'VARS:')
            for k, v in pairs(vars)  do
                addText(colors.white, k,' ',colors.green,tostring(v))
            end
        end,
        function() end
    },
    s = {
        function(args)
            if vars[args[2]] == nil then addText(colors.white, 'invalid var (s <var> <val> )') return end
            if not args[3] then addText(colors.white, tostring(vars[args[2]])) return end
            if isnumber(vars[args[2]]) then vars[args[2]] = tonumber(args[3]) end
            if isbool(vars[args[2]]) then vars[args[2]] = tobool(args[3]) end
            if isstring(vars[args[2]]) then vars[args[2]] = tostring(args[3]) end
        end,
        function() end
        },
    unload = {
        function()
            for k,v in pairs(hTbl()) do
                for k1,v1 in pairs(v) do
                    if string.find(tostring(k1),'Fart|') then 
                        hRem(k,k1) 
                    end
                end
            end
            vdbg.destroy = true
            tRemove('tthink')
            addText('cya')
        end,
        function() end
    },
    time = {
        function()
            addText(colors.white,string.FormattedTime(SysTime(), '[%02i:%02i] '))
        end,
        function() end
    },
    clear = {
        function()
            tEmpty( messages )
        end,
        function() end
    },
    dbug = {
        function()
            print(tString( messages ))
        end,
        function() end
    },
    status = {
        function()
            addText('StartPrediction: '..tString( epStart ))
            addText('EndPrediction: '..tString(epEnd))
            addText('getFLBool: '..tString(getFLBool))
            addText('GetLatency: '..tString(GetLatency))
        end,
        function() end
    },
    silentmode = {
        function()
            addText(colors.blue, 'stealth mode enabled !')
            vars.esp_hitboxes = true
            vars.esp_boxes = false
            vars.aim_bias = 0
            vars.aim_silent = true
            vars.predtype_autoswap = true
            vars.aim_smarttb = true
            vars.aim_baim = false
            vars.aim_triggerbot = false
            vars.tps = false
            vars.act_tog = false
            vars.aim_autofire = true
            vars.esp_chams = false
            vars.showinfo = false
            vars.preddot = false
            vars.predline = true
            vars.esp_xray = false
        end,
        function() end
    },
    mediummode = {
        function()
            addText(colors.white, 'medium mode enabled .')
            vars.esp_hitboxes = true
            vars.esp_boxes = false
            vars.aim_bias = 0
            vars.aim_silent = true
            vars.predtype = 'velocity'
            vars.aim_smarttb = false
            vars.aim_triggerbot = true
            vars.predtype_autoswap = true
            vars.aim_baim = false
            vars.tps = false
            vars.act_tog = false
            vars.aim_autofire = false
            vars.preddot = true
            vars.predline = true
            vars.esp_xray = true
            vars.esp_boxes = false
            vars.showinfo = true
        end,
        function() end
    },
    loudmode = {
        function()
            addText(colors.green, 'nuclear mode enabled !')
            vars.esp_hitboxes = false
            vars.aim_bias = 0
            vars.aim_silent = true
            vars.predtype = 'velocity'
            vars.predtype_autoswap = true
            vars.aim_smarttb = false
            vars.aim_triggerbot = true
            vars.aim_autofire = true
            vars.preddot = true
            vars.predline = true
            vars.tps = true
            vars.tps_h = 200
            vars.aim_baim = false
            vars.act_tog = true
            vars.esp_boxes = true
            vars.esp_chams = true
            vars.esp_xray = true
            vars.showinfo = true
        end,
        function() end
    },
    xbowmode = {
        function()
            addText(colors.purple, 'crossbow mode enabled !')
            vars.aim_silent = true
            vars.predtype = 'xbow'
            vars.aim_smarttb = fase
            vars.aim_triggerbot = true
            vars.aim_autofire = false
            vars.preddot = true
            vars.predline = false
            vars.tps = true
            vars.tps_h = 30
            vars.tps_y = 70
            vars.aim_baim = true
            vars.act_tog = false
            vars.esp_boxes = true
            vars.esp_chams = true
            vars.esp_hitboxes = true
            vars.esp_xray = false
            vars.showinfo = false
        end,
        function() end
    },
    browser = {
        function()
            local browserframe = vgui.Create("DFrame")
            browserframe:SetSize(ScrW()*.8,ScrH()*.8)
            browserframe:Center()
            browserframe:SetDraggable(true)
            browserframe:MakePopup()
            browserframe:SetTitle("fartbrowser")
            
            local htmlpanel = vgui.Create("DHTML",browserframe)
            htmlpanel:SetSize(ScrW()*.8,ScrH()*.75)
            htmlpanel:AlignBottom()
            htmlpanel:OpenURL("www.google.com")
            
            local htmlcontrols = vgui.Create("DHTMLControls",browserframe)
            htmlcontrols:SetHTML(htmlpanel)
            htmlcontrols:SetSize(ScrW()*.8,ScrH()*.04)
            htmlcontrols:AlignTop((ScrH()*.04)/2)
        end,
        function() end
    }
}
 
local function paintListView(list)
    function list:Paint()
        sSetDrawColor(Color(50, 50, 50))
        sDrawRect(0, 0, self:GetWide(), self:GetTall())
    end
    function list.VBar:Paint()
        sSetDrawColor(Color(60, 60, 60))
        sDrawRect(0, 0, self:GetWide(), self:GetTall())
    end
    function list.VBar.btnGrip:Paint()
        sSetDrawColor(Color(100, 50, 50))
        sDrawRect(0, 0, self:GetWide(), self:GetTall())
        sSetDrawColor(Color(200, 0, 0))
        sDrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
    end
    function list.VBar.btnUp:Paint()
        sSetDrawColor(Color(100, 100, 100))
        sDrawRect(0, 0, self:GetWide(), self:GetTall())
    end
    function list.VBar.btnDown:Paint()
        sSetDrawColor(Color(100, 100, 100))
        sDrawRect(0, 0, self:GetWide(), self:GetTall())
    end
    for _, v in pairs(list.Columns) do
        function v.Header:Paint()
            sSetDrawColor(Color(155, 105, 105))
            sDrawRect(2.5, 0, self:GetWide() - 5, self:GetTall())
            self:SetTextColor(Color(255, 255, 255))
        end
    end
end
 
addText(colors.red, 'hey retard, type "help" to get started... ..\n')
 
local function ui()
    frame = vgui.Create('DFrame')
    frame:SetSize(700, 400)
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetTitle('')

    function frame:Paint()
        gRoundedBoxEx(5, 0, 0, self:GetWide(), 25, Color(100, 50, 50), true, true)
        gRoundedBox(0, 0, 25, self:GetWide(), self:GetTall() - 25, Color(65, 65, 65, 230))
    end

    local consolepanel = vgui.Create('DPanel', frame)
    consolepanel:Dock(FILL)
    consolepanel.Paint = function() end
    consolepanel:SetVisible(tabselect == 'Fart Console')

    local hookpanel = vgui.Create('DPanel', frame)
    hookpanel:Dock(FILL)
    hookpanel:InvalidateParent(true)
    hookpanel.Paint = function() end
    hookpanel:SetVisible(tabselect == 'Hooks')

    local guipanel = vgui.Create('DPanel', frame)
    guipanel:Dock(FILL)
    guipanel:InvalidateParent(true)
    guipanel.Paint = function() end
    guipanel:SetVisible(tabselect == 'GUI')

    local friendslistpanel = vgui.Create('DPanel', frame)
    friendslistpanel:Dock(FILL)
    friendslistpanel:InvalidateParent(true)
    friendslistpanel.Paint = function() end
    friendslistpanel:SetVisible(tabselect == 'Friends')
 
    local cbutton = vgui.Create('DButton', frame)
    cbutton:SetText('')
    cbutton:SetSize(16, 16)
    cbutton:SetPos(frame:GetWide() - cbutton:GetWide() - 4, 5)

    function cbutton:DoClick()
        frame:Close()
    end

    function cbutton:Paint()
        gRoundedBox(5, 0, 0, self:GetWide(), self:GetTall(), Color(255, 25, 25))
    end
    if vdbg.destroy then frame:Close() end
 
    local consoletab = vgui.Create('DButton', frame)
    consoletab:SetText('Console')
    consoletab:SetTextColor(colors.white)
    consoletab:SetSize(frame:GetWide() / 2 - 3, 19)
    consoletab:SetPos(3, 3)

    function consoletab:DoClick()
        tabselect = 'Console'
        consolepanel:SetVisible(true)
        hookpanel:SetVisible(false)
        guipanel:SetVisible(false)
        friendslistpanel:SetVisible(false)
    end

    function consoletab:Paint()
        gRoundedBox(5, 0, 0, self:GetWide(), self:GetTall(), tabselect == 'Console' and Color(155, 100, 100) or Color(100, 100, 100))
    end
 
    local hooktab = vgui.Create('DButton', frame)
    hooktab:SetText('HookDel')
    hooktab:SetTextColor(colors.white)
    hooktab:SetSize(frame:GetWide() / 5 - 60, 19)
    hooktab:SetPos(frame:GetWide() / 2 + 83, 3)

    function hooktab:DoClick()
        tabselect = 'Hooks'
        consolepanel:SetVisible(false)
        hookpanel:SetVisible(true)
        guipanel:SetVisible(false)
        friendslistpanel:SetVisible(false)
    end

    function hooktab:Paint()
        gRoundedBox(5, 0, 0, self:GetWide(), self:GetTall(), tabselect == 'Hooks' and Color(155, 100, 100) or Color(100, 100, 100))
    end
 
    local friendtab = vgui.Create('DButton', frame)
    friendtab:SetText('Friends')
    friendtab:SetTextColor(colors.white)
    friendtab:SetSize(frame:GetWide() / 5 - 60, 19)
    friendtab:SetPos(frame:GetWide() / 2 + 2, 3)

    function friendtab:DoClick()
        tabselect = 'Friends'
        consolepanel:SetVisible(false)
        hookpanel:SetVisible(false)
        guipanel:SetVisible(false)
        friendslistpanel:SetVisible(true)
    end

    function friendtab:Paint()
        gRoundedBox(5, 0, 0, self:GetWide(), self:GetTall(), tabselect == 'Friends' and Color(155, 100, 100) or Color(100, 100, 100))
    end
 
    local guitab = vgui.Create('DButton', frame)
    guitab:SetText('GUI')
    guitab:SetTextColor(colors.red)
    guitab:SetSize(frame:GetWide() / 4 - 15, 19)
    guitab:SetPos(frame:GetWide() / 2 + 165, 3)

    function guitab:DoClick()
        tabselect = 'GUI'
        consolepanel:SetVisible(false)
        hookpanel:SetVisible(false)
        guipanel:SetVisible(true)
        friendslistpanel:SetVisible(false)
    end

    function guitab:Paint()
        gRoundedBox(5, 0, 0, self:GetWide(), self:GetTall(), tabselect == 'GUI' and Color(200, 200, 200) or Color(100, 100, 100))
    end
 
    local coolhoob2 = vgui.Create('DModelPanel', guipanel)
    coolhoob2:SetSize(195, 180)
    coolhoob2:SetPos(480, 5)
    coolhoob2:SetModel('models/player/Kleiner.mdl')
    coolhoob2:SetAnimated(true)

    function coolhoob2:PaintOver(w, h)
        sSetDrawColor(HSVToColor((CurTime() * 100) % 360, 1, 1))
        sDrawOutlinedRect(0, 0, w, h)
    end

    local mdl = coolhoob2:GetEntity()
    function coolhoob2:LayoutEntity()
        coolhoob2:SetCamPos(Vector(50, 50, 50))
        if not mdl.SeqStart or CurTime() > (mdl.SeqStart +mdl.SeqDuration) then
            local idx = mdl:LookupSequence('taunt_robot')
            mdl.SeqDuration = mdl:SequenceDuration(idx)
            mdl.SeqStart = CurTime()
            mdl:ResetSequence(idx)
        end
        mdl:SetCycle((CurTime() -mdl.SeqStart) /mdl.SeqDuration)
    end

    function guipanel:Paint()
        local color = colors.white
        ThemeBox("FakeLag/AA", 5, 5, 150, 180, color, color)
        ThemeBox("ESP", 5, 190, 150, 170, color, color)
        ThemeBox("txtESP", 160, 190, 150, 170, color, color)
        ThemeBox("Aimbot", 160, 5, 315, 180, colors.red, color)
        ThemeBox("Whitelist", 160, 100, 125, 85, color, color)
        ThemeBox("Movement", 480, 190, 195, 170, color, color)
        ThemeBox("Light", 480, 285, 195, 75, color, color)
        ThemeBox("CamCtrl/HUD", 315, 190, 160, 170, color, color)
    end
 
    -- aa stuff
    slider("FL: Choke", "fl_choke", 1, 14, 10, 15, 150, 10, guipanel)
    checkbox("FL: Toggle","fakelag toggle", "fl", 9, 25, guipanel)
    checkbox("FL: Triggerbot","triggerbot on a lagged tick", "fl_triggerbot", 9, 40, guipanel) -- + 17
    checkbox("AA: Toggle","toggle antiaim", "aa", 9,  56, guipanel)
    checkbox("AA: Fake Duck","if it quacks like a duck .. . ", "fakeduck", 9, 72, guipanel)
    slider("AA: Real Y", "aa_realy", 0, 360, 10, 88, 150, 10, guipanel)
    slider("AA: Real P", "aa_realp", -90, 90, 10, 104, 150, 10, guipanel)
    slider("AA: Fake Y", "aa_fakey", 0, 360, 10, 120, 150, 10, guipanel)
    slider("AA: Fake P", "aa_fakep", -90, 90, 10, 130, 150, 10, guipanel)

    --aa mode combo box
    local cbox = vgui.Create( "DComboBox", guipanel )
    cbox:SetPos( 30, 157.5 )
    cbox:SetSize( 100, 13 )
    cbox:SetValue("AA Modes" )
    cbox:AddChoice("none")
    cbox:AddChoice("hblock")
    cbox:AddChoice("spin")
    cbox:AddChoice("spinx2")
    cbox:AddChoice("spin2")
    cbox:AddChoice("fakeangle")
    cbox:AddChoice("invert")
    cbox:AddChoice("side")

    function cbox:OnSelect( _, mode )
        vars.aa_mode = mode
    end

    checkbox("AIM: Triggerbot", "fire on keypress", "aim_triggerbot", 165, 14, guipanel)
    checkbox("AIM: Smart Triggerbot", "fire if you are aiming at your target", "aim_smarttb", 165, 30, guipanel)
 
    checkbox("AIM: Autofire", "constantly aim at whatever target is closest", "aim_autofire", 165, 46, guipanel)
    checkbox("AIM: Rapidfire", "rapid fire", "aim_rapidfire", 165, 62, guipanel)
    checkbox("AIM: Wallbang", "target player who are obscured", "aim_wallbang", 165, 78, guipanel)
 
    checkbox("WL: No Team", "ignore teammates", "aim_noteam", 165, 110, guipanel)
    checkbox("WL: No Friends", "ignore steam friends", "aim_nofriends", 165, 126, guipanel)
    checkbox("WL: Only Bots", "only target bots", "aim_onlybots", 165, 142, guipanel)
    checkbox("WL: Only NPCs", "only target NPCs", "aim_onlynpcs", 165, 158, guipanel)
 
    checkbox("AIM: Target Dot", "draws a dot on the predicted fire position", "preddot", 315, 14, guipanel)
    checkbox("AIM: Target Line", "draws a line to the predicted fire position", "predline", 315, 30, guipanel)
    checkbox("AIM: B-Aim", "always body aim", "aim_baim", 315, 62, guipanel)
    checkbox("AIM: Aimbot Cone", "should the aimbot target players within a cone", "aim_cone", 315, 78, guipanel)
    slider("AIM: Bias", "aim_bias", 0, 100, 315, 94, 150, 10, guipanel)
    slider("AIM: Cone", "aim_conefov", 0, 100, 315, 110, 150, 10, guipanel)
 
    local binder = vgui.Create( "DBinder", guipanel )
    binder:SetSize( 50, 20 )
    binder:SetPos( 290, 160 )

    function binder:OnChange( num )
        vars.firekey = input.GetKeyName( num )
    end

    local targbox = vgui.Create( "DComboBox", guipanel )
    targbox:SetPos( 345, 140 )
    targbox:SetSize( 115, 20 )
    targbox:SetValue( "Target Modes" )
    targbox:AddChoice( "xhair")
    targbox:AddChoice( "focus")
    targbox:AddChoice( "pos")

    function targbox:OnSelect( _, mode )
        vars.targmode = mode
    end

    local predbox = vgui.Create( "DComboBox", guipanel )
    predbox:SetPos( 345, 160 )
    predbox:SetSize( 115, 20 )
    predbox:SetSortItems(false)
    predbox:SetValue("Prediction Methods" )
    predbox:AddChoice("none")
    predbox:AddChoice("velocity")
    predbox:AddChoice("classic")
    predbox:AddChoice("ping")
    predbox:AddChoice("engine")
    predbox:AddChoice("gtick")
    predbox:AddChoice("xbow")

    function predbox:OnSelect( _, mode )
        vars.predtype = mode
    end
    checkbox("Auto-swap method", "auto swaps the prediction method based on current weapon", "predtype_autoswap", 345, 125, guipanel)
 
    -- esp stuff
    checkbox("ESP: Toggle", "esp elements", "esp", 9, 200, guipanel)
    checkbox("ESP: Boxes", "toggles boxes", "esp_boxes", 9, 216, guipanel)
    checkbox("ESP: Lines", "toggles player eye beams", "esp_lines", 9, 232, guipanel)
    checkbox("ESP: My lines", "toggles your eye beams", "esp_lplylines", 9, 248, guipanel)
    checkbox("ESP: Chams", "chams", "esp_chams", 9, 264, guipanel)
    checkbox("ESP: HitBoxes", "toggle hitboxes", "esp_hitboxes", 9, 280, guipanel)
    checkbox("ESP: XRay", "toggle xray", "esp_xray", 9, 296, guipanel)

    -- tesp stuff
    checkbox("TESP: Toggle","tesp elements", "tesp", 165, 200, guipanel)
    checkbox("TESP: Names", "toggle names", "tesp_names", 165, 217, guipanel)
    checkbox("TESP: Weapon", "toggle current weapon", "tesp_wep", 165, 234, guipanel)
    checkbox("TESP: Dormant", "dormancy indicator", "tesp_dormant", 165, 251, guipanel)
    checkbox("TESP: Group", "group indicator", "tesp_group", 165, 268, guipanel)
    checkbox("TESP: Props", "prop names", "tesp_props", 165, 285, guipanel)

    -- camstuff
    slider("FOV", "fov", 0, 180, 320, 200, 150, 10, guipanel)
    slider("CAM: Height", "tps_h", 0, 500, 320, 216, 150, 10, guipanel)
    slider("CAM: Yaw", "tps_y", -180, 180, 320, 232, 150, 10, guipanel)
    checkbox("TPS: Thirdperson", "thirdperson", "tps", 320, 248, guipanel)
    checkbox("TPS: Silent", "defucked view", "aim_silent", 320, 264, guipanel)

    --info
    checkbox("HUD: Crosshair", "toggle xhair", "xhair", 320, 280, guipanel)
    checkbox("HUD: showinfo", "predicted info: GREEN: their REAL POS, your latency, WHITE/RED: the predicted attackpos and their speed", "showinfo", 320, 296, guipanel)
 
    --movement
    checkbox("MV: Bunnyhop", "toggle bunnyhop", "bhop", 485, 200, guipanel)
    checkbox("MV: Autostrafe", "toggle autostrafe", "bhop_as", 485, 216, guipanel)
    checkbox("MV: Act", "toggle act", "act", 485, 232, guipanel)
    slider("Act Delay", "act_delay", 1, 5, 485, 248, 150, 10, guipanel)

    local wbreset = vgui.Create('DButton', guipanel)
    wbreset:SetText('WB: Purge')
    wbreset:SetSize(80, 15)
    wbreset:SetPos(585, 190)

    function wbreset:DoClick()
        if file.Find("wb".."*"..".dat", "DATA" ) then
            file.Delete( "wb".."*"..".dat")
        end
    end

    function wbreset:Paint()
        gRoundedBox(5, 0, 0, self:GetWide(), self:GetTall(), colors.seafoam)
    end
 
    checkbox("Light: Toggle", "toggles the lantern", "light", 485, 295, guipanel)
    checkbox("Light: Light", "toggles the player light", "light_ply", 485, 311, guipanel)
    slider("Brightness", "light_bright", 0.1, 10, 550, 330, 150, 10, guipanel)
    slider("Radius", "light_size", 1, 500, 550, 340, 150, 10, guipanel)
 
    local lightpalette = vgui.Create( "DColorPalette", guipanel )
    lightpalette:SetPos( 485, 330 )
    lightpalette:SetSize( 50, 15 )
    lightpalette:SetButtonSize( 5 )

    function lightpalette:OnValueChanged(val)
        vars.light_col_r = ( val.r )
        vars.light_col_g = ( val.g )
        vars.light_col_b = ( val.b )
    end
 
    local friendslist = vgui.Create( "DListView", friendslistpanel )
    friendslist:Dock( FILL )
    friendslist:AddColumn( "Player" )
    friendslist:AddColumn( "Steam ID" )
    friendslist:AddColumn( "Is friend" )
    paintListView( friendslist )
 
    local function updateFriends()
        friendslist:Clear()
        for k, v in pairs( player.GetAll() ) do
            if v == lply or v:IsBot() then continue end
            if friends[ v:SteamID() ] == true then
                friendslist:AddLine( v:Nick(), v:SteamID(), "true")
            else
                friendslist:AddLine( v:Nick(), v:SteamID(), "false")
            end
        end
        for _, line in pairs( friendslist.Lines ) do
            function line:Paint()
                if self:IsHovered() then
                    sSetDrawColor( Color( 100, 100, 100 ) )
                else
                    sSetDrawColor( Color( 50, 50, 50 ) )
                end
                sDrawRect( 0, 0, self:GetWide(), self:GetTall() )
            end
            for _, column in pairs( line.Columns ) do
                column:SetTextColor( Color( 255, 255, 255 ) )
            end
        end
    end
    updateFriends()

    function friendslist:OnRowSelected()
        local line = self:GetLine( self:GetSelectedLine() ):GetValue( 2 )
        friends[ line ] = not friends[ line ]
        updateFriends()
    end

    local outputbg = vgui.Create('DPanel', consolepanel)
    outputbg:DockMargin(0, 0, 0, 5)
    outputbg:Dock(FILL)
    outputbg:SetBackgroundColor(Color(50, 50, 50))
    msgtext = vgui.Create('RichText', consolepanel)
    msgtext:Dock(FILL)
    for k, txtdata in pairs(messages) do
        for i, text in pairs(txtdata.text) do
            local color = txtdata.color[i] or colors.white
            msgtext:InsertColorChange(color.r, color.g, color.b, 255)
            msgtext:AppendText(text)
        end
        msgtext:AppendText('\n')
    end

    function msgtext:PerformLayout()
        self:SetFontInternal('HudHintTextLarge')
    end
    
    local textbg = vgui.Create('DPanel', consolepanel)
    textbg:Dock(BOTTOM)
    textbg:SetBackgroundColor(Color(50, 50, 50))

    local textentry = vgui.Create('DTextEntry', textbg)
    textentry:Dock(FILL)
    textentry:SetFont('Trebuchet18')
    textentry:SetTextColor(Color(255, 255, 255))
    textentry:SetCursorColor(Color(255, 255, 255))
    textentry:SetPaintBackground(false)
    textentry:RequestFocus()
    
    function textentry:OnEnter()
        local plaintext = self:GetValue()
        local args = string.Explode(' ', plaintext)
        self:SetText('')
        self:RequestFocus()
        addText(colors.grey, '] ' .. plaintext)
        if cmds[args[1]] == nil then addText(colors.white, 'invalid cmd') return end
        cmds[args[1]][1](args)
    end

    local coolhoob = vgui.Create('DModelPanel', hookpanel)
    coolhoob:SetSize(hookpanel:GetWide() / 2 - 3, 150)
    coolhoob:SetPos(hookpanel:GetWide() - coolhoob:GetWide(), hookpanel:GetTall() - coolhoob:GetTall())
    coolhoob:SetModel('models/player/Kleiner.mdl') 
    coolhoob:SetAnimated(true)

    function coolhoob:PaintOver(w, h)
        sSetDrawColor(HSVToColor((CurTime() * 100) % 360, 1, 1))
        sDrawOutlinedRect(0, 0, w, h)
    end

    local mdl = coolhoob:GetEntity()
    function coolhoob:LayoutEntity()
        coolhoob:SetCamPos(Vector(110, mcos(CurTime() * 5) * 40, 100))
        if not mdl.SeqStart or CurTime() > (mdl.SeqStart +mdl.SeqDuration) then
            local idx = mdl:LookupSequence('taunt_dance')
            mdl.SeqDuration = mdl:SequenceDuration(idx)
            mdl.SeqStart = CurTime()
            mdl:ResetSequence(idx)
        end
        mdl:SetCycle((CurTime() -mdl.SeqStart) /mdl.SeqDuration)
    end

    local refreshBlocked
    local hooklist = vgui.Create('DListView', hookpanel)
    hooklist:SetSize(hookpanel:GetWide() / 2 - 3, 0)
    hooklist:Dock(LEFT)
    hooklist:AddColumn('Name')
    hooklist:AddColumn('Type')
    paintListView(hooklist)
    local function refreshHooks()
        hooklist:Clear()
        for htype, hooks in pairs(hTbl()) do
            if not istable(hooks) then continue end
            for hname, _ in pairs(hooks) do
                htype = tostring(htype)
                hname = tostring(hname)
 
                hooklist:AddLine(hname, htype)
            end
        end
            for _, line in pairs(hooklist.Lines) do
            function line:Paint()
                if line:IsHovered() then
                    sSetDrawColor(Color(100, 100, 100))
                else
                    sSetDrawColor(Color(50, 50, 50))
                end
                sDrawRect(0, 0, self:GetWide(), self:GetTall())
            end
            for _, column in pairs(line.Columns) do
                column:SetTextColor(Color(255, 255, 255))
            end
        end
    end
    function hooklist:OnRowSelected()
        for _, v in pairs(hooklist:GetSelected()) do
            local hname = tostring(v:GetValue(1))
            local htype = tostring(v:GetValue(2))
            if not istable(blockedhooks[htype]) then blockedhooks[htype] = {} end
            blockedhooks[htype][hname] = hTbl()[htype][hname]
            hRem(htype, hname)
        end
        refreshHooks()
        refreshBlocked()
    end
    refreshHooks()

    local blocklist = vgui.Create('DListView', hookpanel)
    blocklist:SetSize(hookpanel:GetWide() / 2 - 3, 210)
    blocklist:SetPos(hookpanel:GetWide() - blocklist:GetWide(), 0)
    blocklist:AddColumn('Name')
    blocklist:AddColumn('Type')
    paintListView(blocklist)
    
    function refreshBlocked()
        blocklist:Clear()
        for htype, hooks in pairs(blockedhooks) do
            if not istable(hooks) then continue end
            for hname, _ in pairs(hooks) do
                htype = tostring(htype)
                hname = tostring(hname)
                blocklist:AddLine(hname, htype)
            end
        end
        for _, line in pairs(blocklist.Lines) do
            function line:Paint()
                if line:IsHovered() then
                    sSetDrawColor(Color(100, 100, 100))
                else
                    sSetDrawColor(Color(50, 50, 50))
                end
 
                sDrawRect(0, 0, self:GetWide(), self:GetTall())
            end
            for _, column in pairs(line.Columns) do
                column:SetTextColor(Color(255, 255, 255))
            end
        end
    end

    function blocklist:OnRowSelected()
        for _, v in pairs(blocklist:GetSelected()) do
            local hname = tostring(v:GetValue(1))
            local htype = tostring(v:GetValue(2))

            hAdd(htype, hname, blockedhooks[htype][hname])
            blockedhooks[htype][hname] = nil
        end
        refreshBlocked()
        refreshHooks()
    end
    refreshBlocked()
end
 
local ddance = {}
 
ddance.setviewangles = FindMetaTable( 'CUserCmd' ).SetViewAngles
ddance.clearbuttons = FindMetaTable( 'CUserCmd' ).ClearButtons
ddance.clearmovement = FindMetaTable( 'CUserCmd' ).ClearMovement

FindMetaTable( 'CUserCmd' ).SetViewAngles = function( cmd, ang )
local src = string.lower( debug.getinfo(2).short_src )
    if string.find( src, 'taunt_camera' ) then 
        return
    else 
        return ddance.setviewangles( cmd, ang )
    end
end

FindMetaTable( 'CUserCmd' ).ClearButtons = function( cmd )
local src = string.lower( debug.getinfo(2).short_src )
    if string.find( src, 'taunt_camera' ) then 
        return
    else
        return ddance.clearbuttons( cmd )
    end
end

FindMetaTable( 'CUserCmd' ).ClearMovement = function( cmd )
local src = string.lower( debug.getinfo(2).short_src )
    if string.find( src, 'taunt_camera' ) then 
        return
    else
        return ddance.clearmovement( cmd )
    end
end

local Cache = {
	ScrW = ScrW(),
	ScrH = ScrH(),
	
	Order = {
		HITGROUP_HEAD,
		HITGROUP_CHEST,
		HITGROUP_STOMACH
	},

	CalcView = {
		EyePos = EyePos(),
		EyeAngles = EyeAngles(),
		FOV = lply:GetFOV(),
		ZNear = 2.6
	},

	ConVars = {
		cl_interp = GetConVar("cl_interp"),

		sv_gravity = GetConVar("sv_gravity"),

		m_pitch = GetConVar("m_pitch"),
		m_yaw = GetConVar("m_yaw")
	},
	
	WeaponCones = {},
	
	Players = {},
	
	GroundTick = 0,
	
	og = lply:EyeAngles(),

	ServerTime = CurTime(),
	TickInterval = engine.TickInterval()
}
 
-- global functions

function player.Getstuffd(ValidOnly)
	if ValidOnly then
		local players = {}

		for i = 1, #Cache.Players do
			if not isValid(Cache.Players[i]) then continue end

			players[#players + 1] = Cache.Players[i]
		end

		return players
	else
		return Cache.Players
	end
end

function player.GetSorted()
	local players = player.Getstuffd(true)
	local lpos = ply:GetPos()

	tSort(players, function(a, b)
		return a:GetPos():DistToSqr(lpos) > b:GetPos():DistToSqr(lpos)
	end)

	return players
end
 
-- local functions

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

local function FixAngle(ang)
	ang = ang or angle_zero
	
	return Angle(math.Clamp(math.NormalizeAngle(ang.pitch), -89, 89), math.NormalizeAngle(ang.yaw), math.NormalizeAngle(ang.roll))
end

local function UpdateCalcViewData(data)
	if not data then return end

	Cache.CalcView.EyePos = data.origin
	Cache.CalcView.EyeAngles = data.angles
	Cache.CalcView.FOV = data.fov
	Cache.CalcView.ZNear = data.znear
end

local function ValidEntity(entity)
	if not IsValid(entity) then
		return false
	end

	if not entity:IsPlayer() then
		return true
	end

	return entity ~= lply and entity:Alive() and entity:Team() ~= TEAM_SPECTATOR and entity:GetObserverMode() == 0 and not entity:IsDormant()
end

local function getWeapon( ent )
    local wep = ent:GetActiveWeapon()
    if isValid(wep) then
        return wep:GetClass()
    else
        return false
    end
end
 
local function normalizeAngle( ang )
    ang.x = nAngle( ang.x )
    ang.p = mClamp( ang.p, -89, 89 )

    return ang
end
 
local function onScreen(ent)
    local entang = ( (ent:GetPos() + Vector( 0, 0, 35 ) ) - lply:GetShootPos() ):Angle()
    local lplyang = Either(vars.aim_silent, Cache.og, lply:GetAngles())
    local fov = lply:GetFOV()

    if vars.tps then fov = 360 end

    local dx = mabs( nAngle( lplyang.p - entang.p ) )
    local dy = mabs( nAngle( lplyang.y - entang.y ) )

    if ( dx <= fov -30 and dy <= fov -30) then
        return true
    else
        return false
    end
end
 
local function txtesp(v)
    local col = teamGetColor(v:Team())
    local ppos = v:GetPos()
    local pos  = ppos:ToScreen()
    local tpos = ppos + Vector( 0, 0, 75 )
    local ttpos  = tpos:ToScreen()
    local str = string.Explode('/',v:GetModel())
    local nn = str[#str]
    local w,h = GetTextSize(cmdFont,nn)
    
    if 150000 < (ppos-lply:GetPos()):Length2DSqr()/5000 then return end
    if (vars.tesp_names) then
        simpletxtout(v:Nick() .. ' (' .. tostring( v:Health() ) .. ')', cmdFont, ttpos.x, ttpos.y-h/2+5, teamGetColor(v:Team()) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, colors.grey ) 
    end

    if (vars.tesp_dormant) and v:IsDormant() then
        DrawText(colors.red,ttpos.x-w/2,ttpos.y-h/2-10,'[Fart]',cmdFont) 
    end

    if (vars.tesp_wep) then
        DrawText(colors.white,pos.x-w/2,pos.y-h,tostring(getWeapon( v )),cmdFont) 
    end

    if (vars.tesp_group) then
        DrawText(col,pos.x-w/2,pos.y+h/2-10,v:GetUserGroup(), 'FONT') 
    end
end
 
local function txtprops(v)
    local text = ''
    local ppos = v:GetPos()
    local pos  = ppos:ToScreen()
    local str = string.Explode('/',v:GetModel())
    local nn = str[#str]

    if 1500 < (ppos-lply:GetPos()):Length2DSqr()/500 then return end
    local w,h = GetTextSize(cmdFont,nn)
    DrawText(colors.green,pos.x-w/2,pos.y-h/2,nn,cmdFont)
    if v:GetOwner() ~= NULL then
        DrawText(colors.green,pos.x-w/2,pos.y-h/2-15,tostring(v:GetOwner()),cmdFont)
    end
end
 
local function linez(v)
    local col = teamGetColor(v:Team())
    local b = v:LookupBone('ValveBiped.Bip01_R_Hand')

    if v == lply then col = Color(0,0,0) end
    if not vars.esp_lplylines and v == lply then return end

    if b then
        local ShootBone = v:GetBonePosition(b)
        cam.Start({type = '3D'})
        rDrawLine(ShootBone,v:GetEyeTrace().HitPos,col,false)
        cam.End3D()
    end

    if v ~= lply and vars.esp_tracers then
        cam.Start({type = '3D'})

        local vpos = v:GetPos():ToScreen()
        cam.End3D()
        if vpos.y > 2000 or vpos.y < -2000 then return end
        if vpos.x > 2000 or vpos.x < -2000 then return end
        if v:IsAdmin() or v:IsSuperAdmin() then
            sSetDrawColor(255, 0, 0)
        elseif v:IsBot() then
            sSetDrawColor(160, 32, 240)
        else
            sSetDrawColor(255, 255, 255)
        end
        sDrawLine(Cache.ScrW / 2, Cache.ScrH / 1, vpos.x , vpos.y)
    end
end
 
local function xhair()
    if (vars.xhair and not vars.tps) then
        for k,v in pairs(player.GetAll()) do
            sSetDrawColor(teamGetColor(v:Team()))
        end
        sDrawRect(Cache.ScrW/2-8,Cache.ScrH/2-1,16,2)
        sDrawRect(Cache.ScrW/2-1,Cache.ScrH/2-8,2,16)
    end
end
 
local function chamz(v)
    local wep = v:GetActiveWeapon()
    local col = teamGetColor(v:Team())

    cam.Start({type = '3D'})
    render.SuppressEngineLighting(true)

    if v ~= lply and isValid(wep) then
        render.SetColorModulation(55,15,15)
        render.MaterialOverride(chamsmat_1)
        wep:DrawModel()
    end

    if v ~= lply then
        render.SetColorModulation(col.r/255,col.g/255,col.b/255)
        render.MaterialOverride(chamsmat_2)
        v:DrawModel()
    end

    render.MaterialOverride()
    render.SetColorModulation(1, 1, 1)
    render.SuppressEngineLighting(false)
    cam.IgnoreZ(false)
    cam.End3D()
end
 
local function hitboxes(v)
    local col = teamGetColor(v:Team())
    for group = 0,v:GetHitBoxGroupCount()-1 do
        local count = v:GetHitBoxCount(group) - 1
        for hitbox = 0,count do
            local bone = v:GetHitBoxBone(hitbox,group)
            if not bone then continue end
            local min,max = v:GetHitBoxBounds(hitbox,group)
            local bonepos,boneang = v:GetBonePosition(bone)
            if lply:GetEyeTrace().Entity == v then col = colors.red end
            cam.Start({type = '3D'})
            render.DrawWireframeBox(bonepos,boneang,min,max,col,true)
            cam.End3D()
        end
    end
end
 
local function xray(v)
    cam.Start({type = '3D'})
    render.SuppressEngineLighting(true)
    v:DrawModel()
    render.SuppressEngineLighting(false)
    cam.IgnoreZ(false)
    cam.End3D()
end
 
local function boxcorners(v)
    local x,y,color
    local mon,nom
    local h,w
    local bot,top
    local sx,sy
    local size = 10
    local col = teamGetColor(v:Team())
    local trans = Color(0,0,0,col.a)
    local halfbox = 2

    nom = v:GetPos()
    mon = nom + Vector(0, 0, v:OBBMaxs().z)
    bot = nom:ToScreen()
    top = mon:ToScreen()
    
    h = (bot.y - top.y)
    w = h
    sx,sy = 0,0
    sx = (top.x - (w / halfbox))
    sy = top.y

    sSetDrawColor(trans)
    sDrawRect(sx - 1, sy - 1, size + 2, 3)
    sDrawRect(sx - 1, sy - 1, 3, size + 2)
    sSetDrawColor(col)
    sDrawLine(sx, sy, sx + size, sy)
    sDrawLine(sx, sy, sx, sy + size)
    
    sx = ( top.x + (w / halfbox))
    sy = top.y
    
    sSetDrawColor(trans)
    sDrawRect(sx - size, sy - 1, size + 2, 3)
    sDrawRect(sx - 1, sy - 1, 3, size + 2)
    sSetDrawColor(col)
    sDrawLine(sx, sy, sx - size, sy)
    sDrawLine(sx, sy, sx, sy + size)
    
    sx = (bot.x - (w / halfbox))
    sy = bot.y
    
    sSetDrawColor(trans)
    sDrawRect(sx - 1, sy - 1, size + 2, 3)
    sDrawRect(sx - 1, sy - size, 3, size + 2)
    sSetDrawColor(col)
    sDrawLine(sx, sy, sx + size, sy)
    sDrawLine(sx, sy, sx, sy - size)
    
    sx = ( bot.x + ( w / halfbox ) )
    sy = bot.y
    
    sSetDrawColor(trans)
    sDrawRect( sx - size, sy - 1, size + 2, 3)
    sDrawRect( sx - 1, sy - size, 3, size + 2)
    sSetDrawColor(col)
    sDrawLine( sx, sy, sx - size, sy )
    sDrawLine( sx, sy, sx, sy - size )
end
 
local function shouldFire(b)
    local wep = getWeapon(lply)
    local wepactive = lply:GetActiveWeapon()
    local weps = {
        'weapon_physgun',
        'hands',
        'none',
        'pocket',
        'inventory',
        'weapon_physcannon',
        'weapon_vape*',
    }
    if lply:Alive() and wep then
        for k, v in pairs( weps ) do
            if wep == v then return false end
        end
    end
    return true
end

local function rapidfire( cmd )
    local wep = getWeapon( lply )
    if lply:KeyDown( IN_ATTACK ) and lply:Alive() and vars.aim_rapidfire then
        if shouldFire(wep) then
            cmd:RemoveKey( IN_ATTACK )
        end
    end
end
 
local choke = 0
 
local function fakelag(cmd)
    if cmd:CommandNumber( cmd ) ~= 0 then
        if vars.fl then
            choke = choke + 1
            if choke > vars.fl_choke then choke = 1 end
            nbpkt = choke >= vars.fl_choke and true or false
        else
            nbpkt = true
        end
    end
end
 
-- aimbot
 
local function xpwn(pos, target)
    local lpos = lply:GetPos()
    local v0 = 3500
    if ValidEntity(target) then
        local G = GetConVar("sv_gravity"):GetFloat()
        local lerp = GetConVar("cl_interp"):GetFloat()
        local tvel = target:GetAbsVelocity()
        local onGround = target:IsOnGround()
        local gravperTick = G * engine.TickInterval()
        tvel.z = not onGround and tvel.z - (gravperTick) or tvel.z
        local dist = pos:Distance( lpos )
        local comptime = (dist/v0) + lerp
        local final = pos + (tvel * comptime)
        return final
    end
    return pos
end
 
local function predictTarget(pos,trg)
    if not pos then return nulVec end
    local lvel,tvel,frm,eng = lply:GetAbsVelocity(), trg:GetAbsVelocity(), realFrameTime(), engine.TickInterval()
    if vars.predtype == 'none' then return pos end
    if vars.predtype == 'velocity' then return pos+((lvel-tvel)*(frm/(1/eng))) end
    if vars.predtype == 'classic' then return pos-(lvel*eng) end
    if vars.predtype == 'ping'  then return pos+(lvel*eng)*(GetLatency) end
    if vars.predtype == 'engine'  then return tvel == nulVec and pos or pos+tvel*eng*frm-lvel*eng end
    if vars.predtype == 'gtick' then return pos+(((tvel*frm/25)-(tvel*frm/66))-((lvel*frm/25)+(lvel*frm/66))) end
    if vars.predtype == 'm' then return pos-((lvel - (tvel* vars.mpred_num )) * (frm/(1/eng))) end
    if vars.predtype == 'xbow' then return (xpwn(pos, trg)) end
end
 
local function FixView(cmd) 
	Cache.og = Cache.og or cmd:GetViewAngles()

	Cache.og = Cache.og + Angle( cmd:GetMouseY() * .023, cmd:GetMouseX() * -.023, 0 )
    Cache.og = FixAngle(Cache.og)
	
	if cmd:CommandNumber() == 0 then
		if cmd:KeyDown(IN_USE) then
			Cache.og = FixAngle(cmd:GetViewAngles())
		end
	
		cmd:SetViewAngles(Cache.og)
		return
	end
end

local function FixMovement(cmd)
	if not vars.aim_silent then return end
	if not cmd then return end
	
    local MovementVector = Vector(cmd:GetForwardMove(),cmd:GetSideMove(),0)
    
    local CMDAngle = cmd:GetViewAngles()
    local mang = MovementVector:Angle()
    local Yaw = CMDAngle.y - Cache.og.y + mang.y
    
    if ((CMDAngle.p+90)%360) > 180 then
        Yaw = 180 - Yaw
    end
    
    local Speed = mSqrt( MovementVector.x*MovementVector.x + MovementVector.y*MovementVector.y )
    Yaw = ((Yaw + 180)%360)-180
    
    cmd:SetForwardMove(mcos(mrad(Yaw)) * Speed)
    cmd:SetSideMove(msin(mrad(Yaw)) * Speed)
end

local function IsVisible(pos,ply)
    local trace = util.TraceLine({
        start = lply:GetShootPos(),
        endpos = pos,
        filter = {ply, lply},
        mask = MASK_SHOT
    })
    if vars.aim_wallbang then
        if vars.aim_cone and mabs(mdeg(macos(lply:GetEyeTrace().Normal:Dot(trace.Normal)))) >= vars.aim_conefov then
            return false
        else
            return true
        end
    end
    if vars.aim_cone and mabs(mdeg(macos(lply:GetEyeTrace().Normal:Dot(trace.Normal)))) >= vars.aim_conefov then return false end
    return trace.Fraction == 1
end


---- Nospread

local EngineSpread = {
    [0] = {-0.492036, 0.286111},
    [1] = {-0.492036, 0.286111},
    [2] = {-0.255320, 0.128480},
    [3] = {0.456165, 0.356030},
    [4] = {-0.361731, 0.406344},
    [5] = {-0.146730, 0.834589},
    [6] = {-0.253288, -0.421936},
    [7] = {-0.448694, 0.111650},
    [8] = {-0.880700, 0.904610},
    [9] = {-0.379932, 0.138833},
    [10] = {0.502579, -0.494285},
    [11] = {-0.263847, -0.594805},
    [12] = {0.818612, 0.090368},
    [13] = {-0.063552, 0.044356},
    [14] = {0.490455, 0.304820},
    [15] = {-0.192024, 0.195162},
    [16] = {-0.139421, 0.857106},
    [17] = {0.715745, 0.336956},
    [18] = {-0.150103, -0.044842},
    [19] = {-0.176531, 0.275787},
    [20] = {0.155707, -0.152178},
    [21] = {-0.136486, -0.591896},
    [22] = {-0.021022, -0.761979},
    [23] = {-0.166004, -0.733964},
    [24] = {-0.102439, -0.132059},
    [25] = {-0.607531, -0.249979},
    [26] = {-0.500855, -0.185902},
    [27] = {-0.080884, 0.516556},
    [28] = {-0.003334, 0.138612},
    [29] = {-0.546388, -0.000115},
    [30] = {-0.228092, -0.018492},
    [31] = {0.542539, 0.543196},
    [32] = {-0.355162, 0.197473},
    [33] = {-0.041726, -0.015735},
    [34] = {-0.713230, -0.551701},
    [35] = {-0.045056, 0.090208},
    [36] = {0.061028, 0.417744},
    [37] = {-0.171149, -0.048811},
    [38] = {0.241499, 0.164562},
    [39] = {-0.129817, -0.111200},
    [40] = {0.007366, 0.091429},
    [41] = {-0.079268, -0.008285},
    [42] = {0.010982, -0.074707},
    [43] = {-0.517782, -0.682470},
    [44] = {-0.663822, -0.024972},
    [45] = {0.058213, -0.078307},
    [46] = {-0.302041, -0.132280},
    [47] = {0.217689, -0.209309},
    [48] = {-0.143615, 0.830349},
    [49] = {0.270912, 0.071245},
    [50] = {-0.258170, -0.598358},
    [51] = {0.099164, -0.257525},
    [52] = {-0.214676, -0.595918},
    [53] = {-0.427053, -0.523764},
    [54] = {-0.585472, 0.088522},
    [55] = {0.564305, -0.533822},
    [56] = {-0.387545, -0.422206},
    [57] = {0.690505, -0.299197},
    [58] = {0.475553, 0.169785},
    [59] = {0.347436, 0.575364},
    [60] = {-0.069555, -0.103340},
    [61] = {0.286197, -0.618916},
    [62] = {-0.505259, 0.106581},
    [63] = {-0.420214, -0.714843},
    [64] = {0.032596, -0.401891},
    [65] = {-0.238702, -0.087387},
    [66] = {0.714358, 0.197811},
    [67] = {0.208960, 0.319015},
    [68] = {-0.361140, 0.222130},
    [69] = {-0.133284, -0.492274},
    [70] = {0.022824, -0.133955},
    [71] = {-0.100850, 0.271962},
    [72] = {-0.050582, -0.319538},
    [73] = {0.577980, 0.095507},
    [74] = {0.224871, 0.242213},
    [75] = {-0.628274, 0.097248},
    [76] = {0.184266, 0.091959},
    [77] = {-0.036716, 0.474259},
    [78] = {-0.502566, -0.279520},
    [79] = {-0.073201, -0.036658},
    [80] = {0.339952, -0.293667},
    [81] = {0.042811, 0.130387},
    [82] = {0.125881, 0.007040},
    [83] = {0.138374, -0.418355},
    [84] = {0.261396, -0.392697},
    [85] = {-0.453318, -0.039618},
    [86] = {0.890159, -0.335165},
    [87] = {0.466437, -0.207762},
    [88] = {0.593253, 0.418018},
    [89] = {0.566934, -0.643837},
    [90] = {0.150918, 0.639588},
    [91] = {0.150112, 0.215963},
    [92] = {-0.130520, 0.324801},
    [93] = {-0.369819, -0.019127},
    [94] = {-0.038889, -0.650789},
    [95] = {0.490519, -0.065375},
    [96] = {-0.305940, 0.454759},
    [97] = {-0.521967, -0.550004},
    [98] = {-0.040366, 0.683259},
    [99] = {0.137676, -0.376445},
    [100] = {0.839301, 0.085979},
    [101] = {-0.319140, 0.481838},
    [102] = {0.201437, -0.033135},
    [103] = {0.384637, -0.036685},
    [104] = {0.598419, 0.144371},
    [105] = {-0.061424, -0.608645},
    [106] = {-0.065337, 0.308992},
    [107] = {-0.029356, -0.634337},
    [108] = {0.326532, 0.047639},
    [109] = {0.505681, -0.067187},
    [110] = {0.691612, 0.629364},
    [111] = {-0.038588, -0.635947},
    [112] = {0.637837, -0.011815},
    [113] = {0.765338, 0.563945},
    [114] = {0.213416, 0.068664},
    [115] = {-0.576581, 0.554824},
    [116] = {0.246580, 0.132726},
    [117] = {0.385548, -0.070054},
    [118] = {0.538735, -0.291010},
    [119] = {0.609944, 0.590973},
    [120] = {-0.463240, 0.010302},
    [121] = {-0.047718, 0.741086},
    [122] = {0.308590, -0.322179},
    [123] = {-0.291173, 0.256367},
    [124] = {0.287413, -0.510402},
    [125] = {0.864716, 0.158126},
    [126] = {0.572344, 0.561319},
    [127] = {-0.090544, 0.332633},
    [128] = {0.644714, 0.196736},
    [129] = {-0.204198, 0.603049},
    [130] = {-0.504277, -0.641931},
    [131] = {0.218554, 0.343778},
    [132] = {0.466971, 0.217517},
    [133] = {-0.400880, -0.299746},
    [134] = {-0.582451, 0.591832},
    [135] = {0.421843, 0.118453},
    [136] = {-0.215617, -0.037630},
    [137] = {0.341048, -0.283902},
    [138] = {-0.246495, -0.138214},
    [139] = {0.214287, -0.196102},
    [140] = {0.809797, -0.498168},
    [141] = {-0.115958, -0.260677},
    [142] = {-0.025448, 0.043173},
    [143] = {-0.416803, -0.180813},
    [144] = {-0.782066, 0.335273},
    [145] = {0.192178, -0.151171},
    [146] = {0.109733, 0.165085},
    [147] = {-0.617935, -0.274392},
    [148] = {0.283301, 0.171837},
    [149] = {-0.150202, 0.048709},
    [150] = {-0.179954, -0.288559},
    [151] = {-0.288267, -0.134894},
    [152] = {-0.049203, 0.231717},
    [153] = {-0.065761, 0.495457},
    [154] = {0.082018, -0.457869},
    [155] = {-0.159553, 0.032173},
    [156] = {0.508305, -0.090690},
    [157] = {0.232269, -0.338245},
    [158] = {-0.374490, -0.480945},
    [159] = {-0.541244, 0.194144},
    [160] = {-0.040063, -0.073532},
    [161] = {0.136516, -0.167617},
    [162] = {-0.237350, 0.456912},
    [163] = {-0.446604, -0.494381},
    [164] = {0.078626, -0.020068},
    [165] = {0.163208, 0.600330},
    [166] = {-0.886186, -0.345326},
    [167] = {-0.732948, -0.689349},
    [168] = {0.460564, -0.719006},
    [169] = {-0.033688, -0.333340},
    [170] = {-0.325414, -0.111704},
    [171] = {0.010928, 0.723791},
    [172] = {0.713581, -0.077733},
    [173] = {-0.050912, -0.444684},
    [174] = {-0.268509, 0.381144},
    [175] = {-0.175387, 0.147070},
    [176] = {-0.429779, 0.144737},
    [177] = {-0.054564, 0.821354},
    [178] = {0.003205, 0.178130},
    [179] = {-0.552814, 0.199046},
    [180] = {0.225919, -0.195013},
    [181] = {0.056040, -0.393974},
    [182] = {-0.505988, 0.075184},
    [183] = {-0.510223, 0.156271},
    [184] = {-0.209616, 0.111174},
    [185] = {-0.605132, -0.117104},
    [186] = {0.412433, -0.035510},
    [187] = {-0.573947, -0.691295},
    [188] = {-0.712686, 0.021719},
    [189] = {-0.643297, 0.145307},
    [190] = {0.245038, 0.343062},
    [191] = {-0.235623, -0.159307},
    [192] = {-0.834004, 0.088725},
    [193] = {0.121377, 0.671713},
    [194] = {0.528614, 0.607035},
    [195] = {-0.285699, -0.111312},
    [196] = {0.603385, 0.401094},
    [197] = {0.632098, -0.439659},
    [198] = {0.681016, -0.242436},
    [199] = {-0.261709, 0.304265},
    [200] = {-0.653737, -0.199245},
    [201] = {-0.435512, -0.762978},
    [202] = {0.701105, 0.389527},
    [203] = {0.093495, -0.148484},
    [204] = {0.715218, 0.638291},
    [205] = {-0.055431, -0.085173},
    [206] = {-0.727438, 0.889783},
    [207] = {-0.007230, -0.519183},
    [208] = {-0.359615, 0.058657},
    [209] = {0.294681, 0.601155},
    [210] = {0.226879, -0.255430},
    [211] = {-0.307847, -0.617373},
    [212] = {0.340916, -0.780086},
    [213] = {-0.028277, 0.610455},
    [214] = {-0.365067, 0.323311},
    [215] = {0.001059, -0.270451},
    [216] = {0.304025, 0.047478},
    [217] = {0.297389, 0.383859},
    [218] = {0.288059, 0.262816},
    [219] = {-0.889315, 0.533731},
    [220] = {0.215887, 0.678889},
    [221] = {0.287135, 0.343899},
    [222] = {0.423951, 0.672285},
    [223] = {0.411912, -0.812886},
    [224] = {0.081615, -0.497358},
    [225] = {-0.051963, -0.117891},
    [226] = {-0.062387, 0.331698},
    [227] = {0.020458, -0.734125},
    [228] = {-0.160176, 0.196321},
    [229] = {0.044898, -0.024032},
    [230] = {-0.153162, 0.930951},
    [231] = {-0.015084, 0.233476},
    [232] = {0.395043, 0.645227},
    [233] = {-0.232095, 0.283834},
    [234] = {-0.507699, 0.317122},
    [235] = {-0.606604, -0.227259},
    [236] = {0.526430, -0.408765},
    [237] = {0.304079, 0.135680},
    [238] = {-0.134042, 0.508741},
    [239] = {-0.276770, 0.383958},
    [240] = {-0.298963, -0.233668},
    [241] = {0.171889, 0.697367},
    [242] = {-0.292571, -0.317604},
    [243] = {0.587806, 0.115584},
    [244] = {-0.346690, -0.098320},
    [245] = {0.956701, -0.040982},
    [246] = {0.040838, 0.595304},
    [247] = {0.365201, -0.519547},
    [248] = {-0.397271, -0.090567},
    [249] = {-0.124873, -0.356800},
    [250] = {-0.122144, 0.617725},
    [251] = {0.191266, -0.197764},
    [252] = {-0.178092, 0.503667},
    [253] = {0.103221, 0.547538},
    [254] = {0.019524, 0.621226},
    [255] = {0.663918, -0.573476}
}

local Const = {
	0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
	0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
	0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
	0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
	0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
	0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
	0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
	0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
	0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
	0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
	0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
	0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
	0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
	0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
	0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
	0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
	0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
}

local f = function(x, y, z)
	return bit.bor(bit.band(x, y), bit.band(-x - 1, z))
end

local g = function(x, y, z)
	return bit.bor(bit.band(x, z), bit.band(y, -z - 1))
end

local h = function(x, y, z)
	return bit.bxor(x, bit.bxor(y, z))
end

local i = function(x, y, z)
	return bit.bxor(y, bit.bor(x, -z - 1))
end

local z = function(f, a, b, c, d, x, s, ac)
	a = bit.band(a + f(b, c, d) + x + ac, 0xffffffff)
	return bit.bor(bit.lshift(bit.band(a, bit.rshift(0xffffffff, s)), s), bit.rshift(a, 32 - s)) + b
end

local MAX = 2 ^ 31
local SUB = 2 ^ 32

local function Fix(a)
	if a > MAX then
		return a - SUB
	end

	return a
end

local function Transform(A, B, C, D, X)
	local a, b, c, d = A, B, C, D

	a=z(f,a,b,c,d,X[ 0], 7,Const[ 1])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[ 1],12,Const[ 2])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[ 2],17,Const[ 3])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[ 3],22,Const[ 4])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(f,a,b,c,d,X[ 4], 7,Const[ 5])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[ 5],12,Const[ 6])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[ 6],17,Const[ 7])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[ 7],22,Const[ 8])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(f,a,b,c,d,X[ 8], 7,Const[ 9])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[ 9],12,Const[10])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[10],17,Const[11])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[11],22,Const[12])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(f,a,b,c,d,X[12], 7,Const[13])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[13],12,Const[14])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[14],17,Const[15])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[15],22,Const[16])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	a=z(g,a,b,c,d,X[ 1], 5,Const[17])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[ 6], 9,Const[18])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[11],14,Const[19])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[ 0],20,Const[20])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(g,a,b,c,d,X[ 5], 5,Const[21])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[10], 9,Const[22])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[15],14,Const[23])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[ 4],20,Const[24])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(g,a,b,c,d,X[ 9], 5,Const[25])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[14], 9,Const[26])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[ 3],14,Const[27])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[ 8],20,Const[28])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(g,a,b,c,d,X[13], 5,Const[29])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[ 2], 9,Const[30])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[ 7],14,Const[31])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[12],20,Const[32])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	a=z(h,a,b,c,d,X[ 5], 4,Const[33])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[ 8],11,Const[34])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[11],16,Const[35])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[14],23,Const[36])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(h,a,b,c,d,X[ 1], 4,Const[37])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[ 4],11,Const[38])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[ 7],16,Const[39])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[10],23,Const[40])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(h,a,b,c,d,X[13], 4,Const[41])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[ 0],11,Const[42])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[ 3],16,Const[43])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[ 6],23,Const[44])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(h,a,b,c,d,X[ 9], 4,Const[45])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[12],11,Const[46])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[15],16,Const[47])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[ 2],23,Const[48])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	a=z(i,a,b,c,d,X[ 0], 6,Const[49])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[ 7],10,Const[50])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[14],15,Const[51])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[ 5],21,Const[52])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(i,a,b,c,d,X[12], 6,Const[53])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[ 3],10,Const[54])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[10],15,Const[55])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[ 1],21,Const[56])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(i,a,b,c,d,X[ 8], 6,Const[57])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[15],10,Const[58])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[ 6],15,Const[59])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[13],21,Const[60])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(i,a,b,c,d,X[ 4], 6,Const[61])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[11],10,Const[62])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[ 2],15,Const[63])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[ 9],21,Const[64])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	return A + a, B + b, C + c, D + d
end

local function PseudoRandom(number)
    local a, b, c, d = Fix(Const[65]), Fix(Const[66]), Fix(Const[67]), Fix(Const[68])

    local m = {}

    for i= 0, 15 do
		m[i] = 0
	end

    m[0] = number
    m[1] = 128
    m[14] = 32

    local a,b,c,d = Transform(a,b,c,d,m)

    return bit.rshift(Fix(b) , 16) % 256
end

local function GetHitBoxPositions(entity)
	if not isValid(entity) then
		return nil
	end

	local null = true
	
	
	if not vars.aim_baim then -- this is absolutely retarded and theres a much better way but im too tired to care
		hitboxdata = {
			[HITGROUP_HEAD] = {},
			[HITGROUP_CHEST] = {},
			[HITGROUP_STOMACH] = {}
		}
	else
		hitboxdata = {
			[HITGROUP_CHEST] = {},
			[HITGROUP_STOMACH] = {}
		}
	end

	for hitset = 0, entity:GetHitboxSetCount() - 1 do
		for hitbox = 0, entity:GetHitBoxCount(hitset) - 1 do
			local hitgroup = entity:GetHitBoxHitGroup(hitbox, hitset)

			if not hitgroup or not hitboxdata[hitgroup] then continue end

			local bone = entity:GetHitBoxBone(hitbox, hitset)
			local mins, maxs = entity:GetHitBoxBounds(hitbox, hitset)

			if not bone or not mins or not maxs then continue end

			local bmatrix = entity:GetBoneMatrix(bone)

			if not bmatrix then continue end

			local pos, ang = bmatrix:GetTranslation(), bmatrix:GetAngles()

			if not pos or not ang then continue end

			mins:Rotate(ang)
			maxs:Rotate(ang)

			table.insert(hitboxdata[hitgroup], pos + ((mins + maxs) * 0.5))

			null = false
		end
	end

	if null then
		return nil
	end

	return hitboxdata
end

local function GetBoneDataPosition(bonename)
	if not bonename then
		return nil
	end

	bonename = bonename:lower()
	
	if bonename:find("head") then
		return HITGROUP_HEAD
	end

	if bonename:find("spine") then
		return HITGROUP_CHEST
	end

	if bonename:find("pelvis") then
		return HITGROUP_STOMACH
	end

	return nil
end

local function GetBonePositions(entity)
	if not isValid(entity) then
		return nil
	end

	entity:InvalidateBoneCache()
	entity:SetupBones()

	local null = true

	local data = {
		[HITGROUP_HEAD] = {},
		[HITGROUP_CHEST] = {},
		[HITGROUP_STOMACH] = {}
	}

	for bone = 0, entity:GetBoneCount() - 1 do
		local name = entity:GetBoneName(bone)

		if not name or name == "__INVALIDBONE__" then continue end

		name = name:lower()

		local boneloc = GetBoneDataPosition(name)

		if not boneloc then continue end

		local bonematrix = entity:GetBoneMatrix(bone)

		if not bonematrix then continue end

		local pos = bonematrix:GetTranslation()

		if not pos then continue end

		table.insert(data[boneloc], pos)

		null = false
	end

	if null then
		return nil
	end

	return data
end

local function GetAimPositions(entity)
	if not isValid(entity) then
		return nil
	end

	local data = GetHitBoxPositions(entity) or GetBonePositions(entity) or {
		[HITGROUP_HEAD] = {
			entity:LocalToWorld(entity:OBBCenter())
		}
	}

	return data
end

local function GetAimbotPosition(entity)
	if not isValid(entity) then
		return nil
	end

	local data = GetAimPositions(entity)

	for _, set in ipairs(Cache.Order) do
		if not data[set] then continue end

		for _, v in ipairs(data[set]) do
			if IsVisible(v, entity) then
				return v
			end
		end
	end

	return nil
end

local function GetTarget(quick)
	local x, y = ScrW() * 0.5, ScrH() * 0.5

	local best = math.huge
	local entity = nil

	for _, v in ipairs(Cache.Players) do
		if not ValidEntity(v) then continue end
		if vars.aim_noteam and (lply:Team() == v:Team()) then continue end
        if vars.aim_nofriends and v:GetFriendStatus() == 'friend' then continue end
        if vars.aim_onlybots and not v:IsBot() then continue end
        if vars.aim_onlynpcs and not v:IsNPC() then continue end
        if friends[ v:SteamID() ] == true then continue end

		local obbpos = v:LocalToWorld(v:OBBCenter())
		local pos = obbpos:ToScreen() 
		
		local cur = math.Dist(pos.x, pos.y, x, y)
	
		if IsVisible(obbpos, v) and cur < best  then
			best = cur
			entity = v
		end

		if quick then continue end

		local data = GetAimPositions(v)

		for _, set in ipairs(Cache.Order) do
			if not data[set] then continue end
	
			for _, d in ipairs(data[set]) do
				if not IsVisible(d, v) then continue end

				pos = d:ToScreen()
				cur = math.Dist(pos.x, pos.y, x, y)

				if cur < best then
					best = cur
					entity = v
				end
			end
		end
	end

	return entity
end

local function CalculateNoSpread(weapon, cmdnbr, ang)
	ang = ang or Cache.og
	local weaponcone = Cache.WeaponCones[weapon:GetClass()]

	if not weaponcone then
		return ang
	end

	local seed = PseudoRandom(cmdnbr)

	local x = EngineSpread[seed][1]
	local y = EngineSpread[seed][2]

	local forward = ang:Forward()
	local right = ang:Right()
	local up = ang:Up()

	local spreadvector = forward + (x * weaponcone.x * right * -1) + (y * weaponcone.y * up * -1)
	local spreadangle = spreadvector:Angle()
	spreadangle:Normalize()

	return spreadangle
end

local function CalculateViewPunch(weapon)
	if not weapon:IsScripted() then return lply:GetViewPunchAngles() end
	return angle_zero
end

local function triggerBot(cmd,ang)
    if vars.aim_triggerbot or (vars.aim_smarttb and lply:GetEyeTrace().Entity == targ) then
        cmd:SetViewAngles(ang)
        cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_ATTACK))
    elseif vars.fl_triggerbot then
        if nbpkt then
            cmd:SetViewAngles(ang)
            cmd:SetButtons(IN_ATTACK)
        end
    else
        cmd:SetViewAngles(ang)
    end
end
 
local function Aimbot(cmd)
	local Target = GetTarget()
	local Weapon = lply:GetActiveWeapon()
	local key = input.GetKeyCode(vars.firekey)
	
	if lply:Alive() and shouldFire(Weapon) then
		if input.IsKeyDown(key) or vars.aim_autofire then
	
			local pos = GetAimbotPosition(Target)
			if pos then
				local AimAngle = FixAngle((pos - lply:EyePos()):Angle())
				local spreadang = CalculateNoSpread(Weapon, cmd:CommandNumber(), AimAngle)
				
				if vars.aim_bias > 0 then 
	    			spreadang = LerpAngle(1 - vars.aim_bias/100, cmd:GetViewAngles(), spreadang) 
	            end
				triggerBot(cmd, FixAngle(spreadang - CalculateViewPunch(Weapon)))
			end
			if isValid(a) and a:Clip1() <= 0 then cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_RELOAD)) end
		else
			if cmd:KeyDown(IN_ATTACK) then
				local spreadang = CalculateNoSpread(Weapon, cmd:CommandNumber(), Cache.og)
				
				cmd:SetViewAngles(FixAngle(spreadang - CalculateViewPunch(Weapon)))
			end
		end
		if vars.aim_triggerbot then 
			if lply:GetEyeTrace().Entity == Target then
				cmd:AddKey(IN_ATTACK)
			end
		end
	end
	if vars.predtype_autoswap then
        if getWeapon(lply) == 'weapon_ar2' then vars.predtype = 'ping' end
        if getWeapon(lply) == 'weapon_crossbow' then vars.predtype = 'xbow' end
        if getWeapon(lply) == 'weapon_357' then vars.predtype = 'gtick' end
        if getWeapon(lply) == 'weapon_smg1' then vars.predtype = 'velocity' end
        if getWeapon(lply) == 'weapon_pistol' then vars.predtype = 'engine' end
    end
end

local function bunnyhop(cmd)
    if vars.bhop then
        if lply:GetMoveType() == MOVETYPE_NOCLIP or lply:InVehicle() or lply:GetMoveType() == 8 then return end
        if cmd:CommandNumber() ~= 0 then
            if lply:IsOnGround() and cmd:KeyDown(IN_JUMP) then 
            	cmd:RemoveKey(IN_JUMP) 
            end
            if vars.bhop_as then
                if lply:IsOnGround() then return end
                
                cmd:SetForwardMove(5850 / lply:GetVelocity():Length2D())
                cmd:SetSideMove((cmd:CommandNumber() % 2 == 0) and 700 or -700)
            end
        end
    end
end
 
local function fakeduck(cmd)
    if not vars.fakeduck then return end
    if not lply:IsOnGround() or lply:GetMoveType() == MOVETYPE_NOCLIP or lply:InVehicle() then return end
    
    if not vars.fl then
    	vars.fl = true
    end
    
    if vars.fl_choke <= 0 then
		vars.fl_choke = 1
	end
    
    if nbpkt then 
    	cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_DUCK))
	else
		cmd:RemoveKey(IN_DUCK)
	end
	
end
 
local fakeAngles = {p=0,y=0}
local realAngles = {p=0,y=0}
 
local function aaEnemyPos()
    local targ = GetTarget()
    
    if not ValidEntity(targ) then return Cache.og end
    return (predictTarget(targ:GetPos(), targ)-lply:EyePos()):Angle()
end
 
local function antiaim(cmd)
    if not vars.aa then return end
    if lply:GetMoveType() == MOVETYPE_LADDER then return end
    
    local ex = aaEnemyPos().x
    local ey = aaEnemyPos().y
    local p, y
    
    if vars.aa_mode == 'none' then return end
    if vars.aa_mode == 'hblock' then
        p = -30
        y = ey+4
    end
    if vars.aa_mode == 'spin' then
        if nbpkt then
            p = 90
            y = ey-180
        else
            p = -70
            y = (RealTime()*360%360)
        end
    end
    if vars.aa_mode == 'spinx2' then
        local change = RealTime()*5%360
        if nbpkt then
            p = 90
            y = RealTime()*360%360
        else
            p = 90
            y = (change > 90 and change < 250) and 0 or 180
        end
    end
    if vars.aa_mode == 'spin2' then
        p = 90
        y = (RealTime()*360%360)
    end
    if vars.aa_mode == 'fakeangle' then
        p = nbpkt and vars.aa_realp or vars.aa_fakep
        y = nbpkt and vars.aa_realy or vars.aa_fakey
    end
    if vars.aa_mode == 'invert' then
        if nbpkt then
            p = 89
            y = ey + 89
        else
            p = 89
            y = ey+189
        end
    end
    if vars.aa_mode == 'side' then
        if nbpkt then
            p = 90
            y = ey-90
        else
            p = 90
            y = ey+90
        end
    end
 
    local ang = Angle(p,y,0)
 
    cmd:SetViewAngles(normalizeAngle(ang))
 
    if nbpkt then
        fakeAngles.p = p
        fakeAngles.y = y
    else
        realAngles.p = p
        realAngles.y = y
    end
end

local function boltTrails()
    local bolts
    for k, v in pairs(ents.GetAll()) do
        if v:GetClass() ~= "crossbow_bolt" then continue end
        bolts = v
    end
    
    if not isValid(bolts) then return end

    local mins, maxs = bolts:GetRenderBounds()
    local mod = Vector(300, 0, 0)
    
    cam.Start({type = '3D'})
    	render.DrawWireframeBox(bolts:GetPos(), bolts:GetAngles(), mins - mod, maxs, Color(0,255,0), true)
    cam.End3D()
end
 
local function funnylights()
    if vars.light then
        for k, v in pairs( player.GetAll() ) do
        local dlight = DynamicLight( v:EntIndex() )
            if v ~= lply then
                if dlight and vars.light_ply then
                    local col = teamGetColor(v:Team())
                    dlight.Pos = v:EyePos()
                    dlight.r = col.r
                    dlight.g = col.g
                    dlight.b = col.b
                    dlight.nomodel = true
                    dlight.Brightness = vars.light_bright
                    dlight.Decay = vars.light_size
                    dlight.Size = vars.light_size
                    dlight.DieTime = CurTime() + 1
                end
            end
        end
    end
end
 
local function predInfo()
    if lply:Alive() then
        if lply:KeyDown(IN_ATTACK) then hmark = colors.red else hmark = colors.white end
        local targ = GetTarget()
        local gg = GetAimbotPosition(targ)
        
        if ValidEntity(targ) and gg then 
	        local fart = gg:ToScreen()
	        local dist = mRound(targ:GetPos():Distance(lply:GetPos()))
	        local lspeed = mfloor(lply:GetAbsVelocity():Length())
	        local tspeed = mfloor(targ:GetAbsVelocity():Length())
	        	
	        if vars.aim_nofriends and targ:GetFriendStatus() == 'friend' then return end
	
	        sSetDrawColor(hmark)
	        if vars.showinfo then
	            DrawText(teamGetColor(targ:Team()),Cache.ScrW/2+10, Cache.ScrH/2 + 5 ,targ:Nick().. " / " .. tostring(vars.predtype),cmdFont)
	            DrawText(teamGetColor(targ:Team()),Cache.ScrW/2+0, Cache.ScrH/2 + 15 ,tostring(targ:GetPos()),cmdFont)
	            DrawText(teamGetColor(targ:Team()), Cache.ScrW/2+260, Cache.ScrH/2 + 15, 'p: ' .. tostring(GetLatency), cmdFont)
	        end
	        if fart.x > Cache.ScrW or fart.x < -Cache.ScrH then return end
	        if vars.preddot then sDrawRect(fart.x,fart.y,9,9)end
	        if vars.predline then sDrawLine(Cache.ScrW/2, Cache.ScrH/2, fart.x, fart.y) end
        end
    end
end
 
tCreate("act", vars.act_delay, 0, function()
    if vars.act then
        rcmd('act', vars.act_type)
    end
end)

tCreate("pa_Update", 0.3, 0, function()
	Cache.Players = player.GetAll()
end)

-- hooks

makeHook("EntityFireBullets", function(entity, data)
	if entity ~= lply then return end

	local weapon = entity:GetActiveWeapon()
	if not IsValid(weapon) then return end

	Cache.WeaponCones[weapon:GetClass()] = data.Spread
end)
 
makeHook("CalcView", function(ply, pos, ang, fov, zn, zf)
	if not IsValid(ply) then return end

	local CalcAng = Cache.og * 1
	
	local sideoff = vars.tps_y
    offsetangle = Angle(0, sideoff, 0)
    
	local view = {
		origin = vars.tps and pos - ((Cache.og - offsetangle):Forward() * vars.tps_h ) or pos - ((ang - offsetangle):Forward() * vars.tps_h),
		angles = Either(vars.aim_silent, Cache.og, angles),
		fov = vars.fov,
		znear = zn,
		zfar = zf,
		drawviewer = vars.tps
	}

	local vehicle = lply:GetVehicle()

	if IsValid(vehicle) then
		UpdateCalcViewData(view)

		return hook.Run("CalcVehicleView", vehicle, ply, view)
	end

	local weapon = lply:GetActiveWeapon()

	if IsValid(weapon) then
		local wCalcView = weapon.CalcView

		if wCalcView then
			local WeaponAngle = angle_zero

			view.origin, WeaponAngle, view.fov = wCalcView(weapon, ply, view.origin * 1, CalcAng * 1, view.fov)

			if GetBase(weapon) ~= "arccw" then
				view.angles = WeaponAngle
			end
		end
	end

	UpdateCalcViewData(view)

	return view
end)
 
makeHook("CreateMove", function(cmd)
    bunnyhop(cmd)
    fakeduck(cmd)
    antiaim(cmd)
    
    StartEnginePred(cmd)
    Aimbot(cmd)
    StopEnginePred()
    
    fakelag(cmd)
    getFLBool(nbpkt)
    rapidfire(cmd)
    
    if vars.aim_silent then
    	FixView(cmd)
        FixMovement(cmd)
    end
end)
 
makeHook("RenderScreenspaceEffects", function()
    if vars.esp then
        for k, v in pairs(ents.FindByClass( 'prop_physics' )) do
            if isValid(v) and onScreen(v) then
                if vars.esp_xray then xray(v) end
                if vars.tesp_props then txtprops(v) end
            end
        end
        for k,v in pairs(player.Getstuffd(true)) do
            if ValidEntity(v) then
                if vars.esp_chams then chamz(v) end
                if vars.esp_hitboxes then hitboxes(v) end
            end
        end
    end
end)

makeHook("HUDPaint", function()
    if vars.hudpaint then
    	if vars.aim_cone then 
    		surface.DrawCircle(Cache.ScrW/2, Cache.ScrH/2, vars.aim_conefov * 11.25, colors.white ) 
    	end
        for k,v in pairs(player.Getstuffd(true)) do
            if ValidEntity(v) and lply:Alive() then
                if vars.esp_boxes then boxcorners(v) end
                if vars.tesp then txtesp(v) end
            end
            if ValidEntity(v) and lply:Alive() then
                if vars.esp_lines then 
                    linez(v) 
                end
            end
        end
        predInfo()
        xhair()
        boltTrails()
    end
end)

makeHook("PrePlayerDraw", function(Player)
	if Player ~= lply then return end
	
	Player:AnimResetGestureSlot(GESTURE_SLOT_VCD)
end)

makeHook("OnScreenSizeChanged", function()
	Cache.ScrW = ScrW()
	Cache.ScrH = ScrH()
end)

makeHook("Think", function()
	funnylights()
end)
 
ccmd('fartmenu', ui)