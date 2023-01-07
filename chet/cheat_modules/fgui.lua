--[[
	leme's FlowHooks vgui base

	Valid Objects (These support the functions of their default Derma counterparts as well. If no functions are listed under it then it simply doesn't have any custom functions)
		FHFrame (DFrame that comes with a content frame)
			Functions:
				- SetAccentColor(newColor)			=>			Sets the frame's accent color (Added fgui elements will use the same color)
				- GetAccentColor()					=>			Returns the frame's accent color
				- SetTitle(newTitle)				=>			Modified version of DFrame:SetTitle (Works the exact same)
				- GetTitle()						=>			Modified version of DFrame:GetTitle (Works the exact same)
				- SetTitleColor(newColor)			=>			Sets the frame's title color
				- GetTitleColor()					=>			Returns the frame's title color
				- SetFont(newFont)					=>			Set the frame's font to be used for all added fgui elements
				- GetFont()							=>			Modified version of Panel:GetFont - Returns the frame's fgui child font
				- GetContentFrame()					=>			Returns the frame's DPanel content frame (Gray box in the middle)
				- ShowCloseButton(newState)			=>			Modified version of DFrame:ShowCloseButton (Works the exact same)

		FHContentFrame (DPanel)
			Functions:
				- SetDrawOutline(newState)			=>			Sets rendering out the content frame's outline
				- GetDrawOutline()					=>			Returns current rendering state of the content frame's outline

		FHSection (DPanel with an FHContentFrame inside)
			Functions:
				- SetTitle(newTitle)				=>			Sets the title of the section
				- GetTitle()						=>			Returns the title of the section
				- GetContentFrame()					=>			Return's the section's content frame

		FHCheckBox (DCheckBoxLabel; DO *NOT* OVERRIDE OnChange FOR THIS OBJECT! USE FHOnChange INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the checkbox's table key to update on click (Returns the checkbox state (True / False))
				- GetVarTable()						=>			Returns the checkbox's VarTable and key name

		FHSlider (DNumSlider; DO *NOT* OVERRIDE OnValueChanged FOR THIS OBJECT! USE FHOnValueChanged INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the slider's table key to update on value change (Returns the value of the slider)
				- GetVarTable()						=>			Returns the slider's VarTable and key name

		FHDropDown (DComboBox; DO *NOT* OVERRIDE OnSelect FOR THIS OBJECT! USE FHOnSelect INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the dropdown's table key to update on value change (Returns the text of the option)
				- GetVarTable()						=>			Returns the dropdown's VarTable and key name
				- AddChoice()						=>			A modified version of DComboBox:AddChoice (Works the exact same)
				- AddChoices(choices)				=>			Creates options passed as seperate arguments OR a table of choices (Ex: dropdown:AddChoices("option1", "option2", "option3")) (Returns a table of created indexes)

		FHTabbedMenu (DPropertySheet)
			Functions:
				- SetVarTable(table, key)			=>			Sets the tabbed menu's table key to update on value change (Returns the name of the tab)
				- GetVarTable()						=>			Returns the tabbed menu's VarTable and key name
				- AddTab(name, icon, sX, sY, tt)	=>			Creates a tab and returns the content frame of the tab (Works like DPropertySheet:AddSheet)
				- AddTabs(tabs)						=>			Creates tabs passed as seperate arguments OR a table of arguments (No icon, etc) (Ex: menu:AddTabs("tab1", "tab2", "tab3")) (Returns a table of the content frames)
				- SetTabBackground(newState)		=>			Sets rendering of the background behind tabs
				- GetTabBackground()				=>			Returns current rendering state of the background behind tabs
				- SetValue(value)					=>			Used internally to update the tabbed menu to the specified tab
				- SizeTabsToWidth()					=>			Evenly sizes the tabbed menu's tabs to fill the width of the tabbed menu

		FHList (DListView; DO *NOT* OVERRIDE OnRowSelected FOR THIS OBJECT! USE FHOnRowSelected INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the list's table key to update on value change (Returns DListView_Line objects instead of the index)
				- GetVarTable()						=>			Returns the list's VarTable and key name
				- AddColumn(newColumn, position)	=>			Modified version of DListView:AddColumn (Works the exact same)
				- AddLine(...)						=>			Modified version of DListView:AddLine (Works the exact same)
				- SetValue(value)					=>			Used internally to update the list to the specified line (Works the same as DListView:SelectItem)

		FHTextBox (DTextEntry; DO *NOT* OVERRIDE OnValueChanged FOR THIS OBJECT! USE FHOnValueChanged INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the text box's table key to update on value change (Returns the text inside the text box)
				- GetVarTable()						=>			Returns the text box's VarTable and key name

		FHButton (DButton)
			Functions:
				- SetCallback(function)				=>			Sets the callback function for the button (Same as overriding DoClick, you can do either to accomplish the same task)

		FHColorButton (DButton; DO *NOT* OVERRIDE DoClick NOR DoRightClick FOR THIS OBJECT! Use FHDoClick OR FHDoRightClick INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the color button's table key to update on value change (Returns the color)
				- GetVarTable()						=>			Returns the color button's VarTable and key name
				- SetColor(newColor)				=>			Sets the color button's color (Also updates the VarTable if provided)
				- GetColor()						=>			Returns the color button's color
				- SetValue(value)					=>			Used internally to update the button's color to the specified color (Works the same as FHColorButton:SetColor)

		FHColorPicker (DFrame; Used internally for FHFrames and FHColorButtons, may cause jank if used manually) (Not parented to anything)
			Functions:
				- Invoke(table, key)				=>			Used internally to show the color picker and sets its VarTable and key to update when OK is clicked
				- GetFont()							=>			Used internally to get the color picker's parent frame's font
				- GetContentFrame()					=>			Used internally to parent the color picker's components

		FHBinder (DBinder; DO *NOT* OVERRIDE OnChange FOR THIS OBJECT! USE FhOnChange INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the binder's table key to update on value change (Returns the key code instead of key name)
				- GetVarTable()						=>			Returns the binder's VarTable and key name
				- SetLabel(newLabel)				=>			Sets the binder's overhead label
				- GetLabel()						=>			Returns the binder's overhead label

		FHMiniMenu (DFrame) (Not parented to anything)
			Functions:
				- SetFont(newFont)					=>			Set the mini menu's font to be used
				- GetFont()							=>			Modified version of Panel:GetFont - Returns the mini menu's fgui font
				- SetTextColor(newColor)			=>			Sets the mini menu's text color
				- GetTextColor()					=>			Returns the mini menu's text color
				- AddColumn(columnName, index)		=>			Creates a column at optional index (Places at end if no index is given)
				- AddRow(...)						=>			Creates a row with given data (Format as a table with 1 key for each column, ex: {"Column 1", "Column 2", "Column 3"})
				- SetBackgroundAlpha(newAlpha)		=>			Sets backround alpha for the rows of the mini menu
				- GetBackgroundAlpha()				=>			Returns the background alpha for the rows of the mini menu

		FHLabel (DLabel)

		FHRadar (DFrame) (Not parented to anything)
			Functions:
				- SetEntities(entites)				=>			Takes a table of entity classes that the radar will display as well as what color they will use (Ex: {player = Color(255, 0, 0)})
				- GetEntities()						=>			Returns the table of entity classes the radar is using
				- SetBackgroundAlpha(newAlpha)		=>			Changes the radar's background color
				- GetBackgroundAlpha()				=>			Returns the radar's background color
				- SetRange(newRange)				=>			Sets how far the radar will show entities
				- GetRange()						=>			Returns the current range the radar is using
				- SetParentEntity(newParent)		=>			Sets the entity the radar will base its calculations around (Defaults to LocalPlayer so you don't need to call this usually)
				- GetParentEntity()					=>			Returns the entity the radar is currently based around (If it's valid)
				- SetDrawParentEntity(newState)		=>			Controls if the radar will render the parent entity on the radar or not
				- GetDrawParentEntity()				=>			Returns if the radar is rendering its parent entity or not
]]

fgui = fgui or {}

local fguitable = fgui

fguitable.FontName = string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456))

surface.CreateFont(fguitable.FontName, {
	font = "Verdana",
	size = 12,
	antialias = false,
	outline = true
})

fguitable.TimerName = "fgui_SlowTick"
fguitable.VarTableHolders = {} -- VarTable holders
fguitable.Clipboard = nil -- For color copy / pasting

fguitable.Colors = {
	black = Color(0, 0, 0, 255),
	white = Color(255, 255, 255, 255),

	accent = Color(255, 150, 0, 255), -- Default orange accent

	back = Color(45, 45, 45, 255), -- Menu backing
	back_min = Color(55, 55, 55, 255),
	back_obj = Color(24, 24, 24, 255), -- Object backing
	outline = Color(0, 0, 0, 255), -- Regular outlines
	outline_b = Color(12, 12, 12, 255), -- Special outlines (I didn't know what to call this)
	gray = Color(150, 150, 150, 255) -- For text boxes
}

fguitable.Colors.grey = fguitable.Colors.gray -- We are anonymous

fguitable.Functions = {}

fguitable.Functions = {
	GetFurthestParent = function(base) -- Used to get FHFrame's accent color from any child object
		if not base then
			return error("Invalid Panel Provided")
		end

		local cparent = base:GetParent()

		if not IsValid(cparent) then -- Base is the world panel
			return base
		end

		if cparent:GetParent() == vgui.GetWorldPanel() then
			return cparent
		end

		return fguitable.Functions.GetFurthestParent(cparent)
	end,

	CopyColor = function(color) -- Used for modification of the accent's alpha without affecting the original
		if not color then
			return error("No Color Provided")
		end

		return Color(color.r, color.g, color.b, color.a)
	end,

	RegisterVarTable = function(obj, varloc, var) -- Used to attach a variable in a table to an object
		if not obj then
			return
		end

		if not varloc then
			return error("Invalid Variable Table Provided")
		end

		if not var then
			return error("No Variable Provided")
		end

		obj.FH.VarTable = varloc
		obj.FH.Var = var

		fguitable.VarTableHolders[#fguitable.VarTableHolders + 1] = obj
	end,

	GenerateRandomString = function() -- Use for timer names
		return string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456))
	end,

	DrawFilledCircle = function(x, y, radius, segment) -- Used for radar
		local cir = {
			{
				x = x,
				y = y,
				u = 0.5,
				v = 0.5
			}
		}

		for i = 0, segment do
			local rad = math.rad((i / segment) * -360)

			cir[#cir + 1] = {
				x = x + (math.sin(rad) * radius),
				y = y + (math.cos(rad) * radius),
				u = (math.sin(rad) / 2) + 0.5,
				v = (math.cos(rad) / 2) + 0.5
			}
		end

		local Orad = math.rad(0)

		cir[#cir + 1] = {
			x = x + (math.sin(Orad) * radius),
			y = y + (math.cos(Orad) * radius),
			u = (math.sin(Orad) / 2) + 0.5,
			v = (math.cos(Orad) / 2) + 0.5
		}

		surface.DrawPoly(cir)

		return cir
	end,

	GetMPData = function(panel) -- Used to attempt to return data about a given parent panel (Allows for fallbacks and parenting to non FGUI objects)
		if not IsValid(panel) then
			return nil
		end
	
		local data = { -- Default information
			MP = panel,
			Font = fguitable.FontName,
			AccentColor = fguitable.Colors.accent,
			TitleColor = fguitable.Colors.white
		}
	
		local MP = fguitable.Functions.GetFurthestParent(panel)
	
		if MP and MP.FH and MP.FH.Type == "FHFrame" then
			data.MP = MP
			data.Font = MP:GetFont()
			data.AccentColor = MP:GetAccentColor()
			data.TitleColor = MP:GetTitleColor()
		end
	
		return data
	end
}

fguitable.Objects = {
	FHFrame = {
		Base = "DFrame",

		NotParented = true,
		HasContentFrame = true,

		Registry = {
			SetAccentColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.AccentColor = color
			end,

			GetAccentColor = function(self)
				return self.FH.AccentColor
			end,

			SetTitle = function(self, title)
				if not title then
					return error("No Text Provided")
				end

				self.FH.Title = title
			end,

			GetTitle = function(self)
				return self.FH.Title
			end,

			SetTitleColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.TitleColor = color
			end,

			GetTitleColor = function(self)
				return self.FH.TitleColor
			end,

			SetFont = function(self, font)
				if not font then
					return error("No Font Provided")
				end

				self.FH.Font = font
			end,

			GetFont = function(self)
				return self.FH.Font
			end,

			GetContentFrame = function(self)
				return self.FH.ContentFrame
			end,

			ShowCloseButton = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.CloseButton:SetVisible(active)
				self.FH.CloseButton:SetEnabled(active)
			end,

			Init = function(self)
				self.FH = {
					AccentColor = fguitable.Functions.CopyColor(fguitable.Colors.accent),
					Title = "Frame " .. math.random(0, 12345),
					TitleColor = fguitable.Functions.CopyColor(fguitable.Colors.white),
					Font = fguitable.FontName,

					ColorPicker = fguitable.Create("FHColorPicker")
				}

				self:SetCursor("arrow") -- Prevent cursor change when dragging
				self.SetCursor = function() end

				self.FH.ColorPicker.FH.MP = self

				self:SetTitle("") -- Hide default window title
				self:GetChildren()[4]:SetVisible(false)

				local closeButton = vgui.Create("DButton", self) -- Custom close button
				closeButton:SetSize(24, 24)
				closeButton:SetFont(self.FH.Font)
				closeButton:SetTextColor(fguitable.Colors.white)
				closeButton:SetText("X")
				closeButton:SetCursor("arrow")
	
				closeButton.DoClick = function()
					self:Close()
				end
	
				closeButton.Paint = function(self, w, h)
					surface.SetDrawColor(fguitable.Colors.back_obj)
					surface.DrawRect(0, 0, w, h)
	
					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
					
				self.FH.CloseButton = closeButton
	
				local children = self:GetChildren() -- Hide default close button
		
				for i = 1, 3 do
					children[i]:SetVisible(false)
					children[i]:SetEnabled(false)
				end
			end,

			Paint = function(self, w, h)
				self.FH.CloseButton:SetPos(w - self.FH.CloseButton:GetWide(), 0)
	
				surface.SetDrawColor(fguitable.Colors.black)
				surface.DrawRect(0, 0, w, h)
	
				local grad = 55
	
				for i = 1, grad do
					local c = grad - i
	
					surface.SetDrawColor(c, c, c, 255)
					surface.DrawLine(0, i, w, i)
				end
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
	
				surface.SetFont(self:GetFont())
				surface.SetTextColor(self:GetTitleColor())

				local title = self:GetTitle()
	
				local tw, th = surface.GetTextSize(title)
	
				surface.SetTextPos((w / 2) - (tw / 2), 13 - (th / 2)) -- Not perfectly proportional to the real FlowHook's menu because of the Close Button
				surface.DrawText(title)
			end
		}
	},

	FHContentFrame = {
		Base = "DPanel",

		Registry = {
			SetDrawOutline = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.DrawOutline = active
			end,

			GetDrawOutline = function(self)
				return self.FH.DrawOutline
			end,

			Init = function(self)
				self.FH = {
					DrawOutlined = true
				}

				self:DockMargin(5, -5, 5, 5)
				self:Dock(FILL)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back)
				surface.DrawRect(0, 0, w, h)
	
				if self:GetDrawOutline() then
					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
			end
		}
	},

	FHSection = {
		Base = "DPanel",

		HasContentFrame = true,

		Registry = {
			SetTitle = function(self, title)
				if not title then
					return error("No Text Provided")
				end

				self.FH.Title = title
			end,

			GetTitle = function(self)
				return self.FH.Title
			end,

			GetContentFrame = function(self)
				return self.FH.ContentFrame
			end,

			Init = function(self)
				self.FH = {
					Title = "Section " .. math.random(0, 12345)
				}

				timer.Simple(0, function()
					local ContentFrame = self:GetContentFrame()
	
					if IsValid(ContentFrame) then
						ContentFrame:DockMargin(5, 10, 5, 5)
						ContentFrame:SetDrawOutline(false)
					end
				end)
			end,

			Paint = function(self, w, h)
				surface.SetFont(fguitable.Functions.GetMPData(self).Font)
				surface.SetTextColor(fguitable.Colors.white)

				local title = self:GetTitle()
	
				local tw, th = surface.GetTextSize(title)
				local tx, ty = 8, 5 - (th / 2)
	
				surface.SetTextPos(tx, ty)
				surface.DrawText(title)
	
				w = w - 1
				h = h - 1
				ty = ty + (th / 2)
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawLine(0, ty, tx, ty)
				surface.DrawLine(tx + tw, ty, w, ty)
				surface.DrawLine(w, ty, w, h)
				surface.DrawLine(w, h, 0, h)
				surface.DrawLine(0, h, 0, ty)
			end
		}
	},

	FHCheckBox = {
		Base = "DCheckBoxLabel",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			Init = function(self)
				local checkbox = self:GetChildren()[1]
	
				checkbox:SetCursor("arrow")
	
				checkbox.Paint = function(self, w, h)
					surface.SetDrawColor(fguitable.Colors.back_obj)
					surface.DrawRect(0, 0, w, h)
		
					if self:GetChecked() then
						surface.SetDrawColor(fguitable.Functions.GetMPData(self).AccentColor)
						surface.DrawRect(2, 2, w - 4, h - 4)
					end
		
					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
	
				self:SetTextColor(fguitable.Colors.white)
				self:SetFont(fguitable.Functions.GetMPData(self).Font)
			end,

			OnChange = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnChange then
					self.FHOnChange(self, new)
				end
			end
		}
	},

	FHSlider = {
		Base = "DNumSlider",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			Init = function(self)
				local MPData = fguitable.Functions.GetMPData(self)

				self:GetTextArea().Paint = function(self, w, h) -- Paint number area
					local y = (h / 2) - 7.5
					h = 15
	
					surface.SetDrawColor(fguitable.Colors.back_obj)
					surface.DrawRect(0, y, w, h)
	
					surface.SetFont(MPData.Font)
					surface.SetTextColor(fguitable.Colors.white)
	
					local val = self:GetValue()
					local tw, th = surface.GetTextSize(val)
	
					surface.SetTextPos((w / 2) - (tw / 2), y + (h / 2) - (th / 2))
					surface.DrawText(val)
	
					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawOutlinedRect(0, y, w, h)
				end
	
				local children = self:GetChildren()

				self.Label:SetFont(MPData.Font)
				self.Label:SetTextColor(fguitable.Colors.white)
	
				local bar = children[2]
	
				bar:SetCursor("arrow")
	
				bar.Paint = function(self, w, h) -- Paint custom horizontal bar
					local y = h / 2
	
					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawLine(5, y, w - 5, y)
				end
	
				local handle = bar:GetChildren()[1]
	
				handle:SetCursor("arrow")
	
				handle.Paint = function(self, w, h) -- Paint bar handle
					local x = (w / 2) - 5
					w = 10
	
					surface.SetDrawColor(fguitable.Colors.back)
					surface.DrawRect(x, 0, w, h)
	
					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawOutlinedRect(x, 0, w, h)
				end
			end,

			OnValueChanged = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnValueChanged then
					self.FHOnValueChanged(self, new)
				end
			end
		}
	},

	FHDropDown = {
		Base = "DComboBox",
		HasDMenu = true,

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			AddChoices = function(self, ...)
				local data = {...}

				if type(data[1]) == "table" then
					data = data[1]
				end

				local created = {}

				for _, v in pairs(data) do
					local i = self:AddChoice(v)
					created[#created + 1] = i
				end

				return created
			end,

			Init = function(self)
				self.FH = {
					AddChoice = self.AddChoice
				}

				self.AddChoice = function(self, value, data, select, icon) -- Override default AddChoice
					if not value then
						return error("Invalid Value Provided")
					end

					local i = self.FH.AddChoice(self, value, data, select, icon)
	
					self.DMenu:AddOption(value, function()
						self:ChooseOptionID(i)
					end)

					return i
				end

				self:SetCursor("arrow")
	
				self:SetTextColor(fguitable.Colors.white)
				self:SetFont(fguitable.Functions.GetMPData(self).Font)
	
				self:GetChildren()[1].Paint = function() end -- Hide the dropdown's arrow
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				surface.SetDrawColor(fguitable.Colors.back)
				surface.DrawRect(w - h, 0, w - h, h)
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
				surface.DrawLine(w - h, 0, w - h, h)
	
				if self:IsMenuOpen() then
					surface.DrawLine((w - h) + 3, h / 2, w - 3, h / 2)
				else
					surface.DrawLine(w - (h / 2), 3, w - (h / 2), h - 3)
					surface.DrawLine((w - h) + 3, h / 2, w - 3, h / 2)
				end
			end,

			OnSelect = function(self, index, value, data)
				if index == nil then -- Prevent fucky business
					return
				end
	
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = value
				end
	
				if self.FHOnSelect then
					self.FHOnSelect(self, index, value, data)
				end
			end
		}
	},

	FHTabbedMenu = {
		Base = "DPropertySheet",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			AddTab = function(self, name, icon, noStretchX, noStretchY, tooltip)
				local ContentFrame = fguitable.Create("FHContentFrame", self)
				ContentFrame:SetDrawOutline(false)

				local data = self:AddSheet(name, ContentFrame, icon, noStretchX, noStretchY, tooltip)

				data.Tab:SetCursor("arrow")

				data.Tab:SetTextColor(fguitable.Colors.white)
				data.Tab:SetFont(fguitable.Functions.GetMPData(self).Font)

				local ogclick = data.Tab.DoClick

				data.Tab.FH = {}

				data.Tab.DoClick = function(selfP) -- selfP because I'm lazy
					if self.FH.VarTable then
						self.FH.VarTable[self.FH.Var] = self:GetText()
					end

					ogclick(selfP)
				end

				data.Tab.Paint = function(self, w, h)
					h = 21

					if self:IsActive() then
						surface.SetDrawColor(fguitable.Colors.back)
						surface.DrawRect(0, 0, w, h)

						surface.SetDrawColor(fguitable.Colors.outline)
						surface.DrawLine(0, 0, 0, h)
						surface.DrawLine(w - 1, 0, w - 1, h)

						surface.SetDrawColor(fguitable.Functions.GetMPData(self).AccentColor)
						surface.DrawLine(0, 0, w, 0)
						surface.DrawLine(0, 1, w, 1)
					else
						surface.SetDrawColor(fguitable.Colors.back_obj)
						surface.DrawRect(0, 0, w, h)
					end
				end

				return ContentFrame
			end,

			AddTabs = function(self, ...)
				local data = {...}

				if type(data[1]) == "table" then
					data = data[1]
				end

				local created = {}

				for _, v in pairs(data) do
					local i = self:AddTab(v)
					created[#created + 1] = i
				end

				return created
			end,

			SetTabBackground = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.TabBackground = active
			end,

			GetTabBackground = function(self)
				return self.FH.TabBackground
			end,

			SetValue = function(self, value)
				if value == nil then
					return error("No Value Provided")
				end

				for _, v in ipairs(self:GetItems()) do
					if v.Name == value then
						v:SetActiveTab(v.Tab)

						if self.FH.VarTable then
							self.FH.VarTable[self.FH.Var] = v.Name
						end

						break
					end
				end
			end,

			SizeTabsToWidth = function(self)
				self:InvalidateParent(true)
			
				local tabs = self:GetItems()
				local awidth = math.ceil((self:GetWide() / #tabs) - 20)
				local width = math.floor(awidth)
			
				surface.SetFont(fguitable.Functions.GetMPData(self).Font)

				local subamount = 0
			
				for k, v in ipairs(tabs) do
					local tab = v.Tab
			
					tab.FH = tab.FH or {}
			
					local text = tab.FH.Text or tab:GetText()
					tab.FH.Text = tab.FH.Text or text
			
					local tw, _ = surface.GetTextSize(text)
					local step = false
			
					local max = (k == #tabs and awidth or width) - subamount

					if subamount ~= 0 then
						max = max - subamount
						subamount = 0
					end

					if tw > max then
						subamount = (tw - max) / 2
					end
			
					while tw < max do
						text = step and text .. " " or " " .. text
						tw, _ = surface.GetTextSize(text)
			
						step = not step
					end
			
					tab:SetText(text)
					tab:InvalidateLayout()
				end
			end,

			Init = function(self)
				self.FH = {
					TabBackground = false
				}

				self:SetFadeTime(0)
	
				if self.tabScroller then
					self.tabScroller:DockMargin(0, 0, 0, 0)
					self.tabScroller:SetOverlap(0)
				end
	
				self.tabScroller.Paint = function(self, w, h)
					if not self:GetParent():GetTabBackground() then
						return
					end
	
					h = 20
	
					surface.SetDrawColor(fguitable.Colors.back_min)
					surface.DrawRect(0, 0, w, h)
	
					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawLine(0, 0, w, 0)
					surface.DrawLine(0, 0, 0, h)
					surface.DrawLine(w - 1, 0, w - 1, h)
				end
			end,
	
			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back)
				surface.DrawRect(0, 0, w, h)
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 20, w, h - 20)
				surface.DrawLine(0, 20, w, 20)
			end
		}
	},

	FHList = {
		Base = "DListView",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			SetValue = function(self, value)
				self:SelectItem(value)

				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = value
				end
			end,

			Init = function(self)
				self.FH = {
					AddColumn = self.AddColumn,
					AddLine = self.AddLine
				}

				self.AddColumn = function(self, name, pos) -- Override default AddColumn
					if not name then
						return error("No Column Name Provided")
					end
	
					if pos and (pos <= 0 or self.Columns[pos]) then
						return error("Tried to Override Existing Column")
					end

					local Column = self.FH.AddColumn(self, name, pos)
	
					local ColumnButton = Column:GetChildren()[1]
	
					ColumnButton:SetCursor("arrow")
					ColumnButton:SetTextColor(fguitable.Colors.white)
					ColumnButton:SetFont(fguitable.Functions.GetMPData(self).Font)
	
					ColumnButton.Paint = function(self, w, h)
						surface.SetDrawColor(fguitable.Colors.back_min)
						surface.DrawRect(0, 0, w, h)
	
						surface.SetDrawColor(fguitable.Colors.outline)
						surface.DrawOutlinedRect(0, 0, w, h)
					end
	
					return Column
				end

				self.AddLine = function(self, ...) -- Override default AddLine
					local vararg = {...}
	
					if #vararg < 1 then
						return error ("No Content Provided")
					end
	
					local MPData = fguitable.Functions.GetMPData(self)
	
					local Line = self.FH.AddLine(self, ...)
	
					for _, v in ipairs(Line:GetChildren()) do
						v:SetTextColor(fguitable.Colors.white)
						v:SetFont(MPData.Font)
					end
	
					Line.Paint = function(self, w, h)
						if not self:IsLineSelected() and not self:IsHovered() then
							return 
						end
	
						local accent = fguitable.Functions.CopyColor(fguitable.Functions.GetMPData(self).AccentColor)
	
						if self:IsHovered() and not self:IsLineSelected() then
							accent.a = accent.a / 4
						end
	
						surface.SetDrawColor(accent)
						surface.DrawRect(0, 0, w, h)
					end
	
					return Line
				end

				local scrollbar = self:GetChildren()[2]
	
				scrollbar.Paint = function(self, w, h)
					surface.SetDrawColor(fguitable.Colors.outline_b)
					surface.DrawRect(0, 0, w, h)
				end
	
				for _, v in ipairs(scrollbar:GetChildren()) do
					v:SetCursor("arrow")
	
					v.Paint = function(self, w, h)
						surface.SetDrawColor(fguitable.Colors.back)
						surface.DrawRect(0, 0, w, h)
		
						surface.SetDrawColor(fguitable.Colors.outline)
						surface.DrawOutlinedRect(0, 0, w, h)
					end
				end
			end,		
	
			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end,

			OnRowSelected = function(self, index, panel)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = panel
				end
	
				if self.FHOnRowSelected then
					self.FHOnRowSelected(self, index, panel)
				end
			end
		}
	},

	FHTextBox = {
		Base = "DTextEntry",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			Init = function(self)
				local MPData = fguitable.Functions.GetMPData(self)
	
				self:SetTextColor(fguitable.Colors.white)
				self:SetFont(MPData.Font)
	
				self:SetPaintBackground(false)
	
				-- Setup highlight colors
	
				self.m_colHighlight = MPData.AccentColor
				self.colTextEntryTextHighlight = MPData.AccentColor
	
				-- Setup content frame
	
				-- This creates a content frame at the exact same position and with the same size as the text box
				-- This is needed because overriding Paint on a DTextEntry causes the text to disappear as well
				-- and to avoid rendering the text manually, this workaround will suffice
	
				timer.Simple(0, function()
					local ContentFrame = fguitable.Create("FHContentFrame", self:GetParent())
					ContentFrame:Dock(NODOCK)
					ContentFrame:SetSize(self:GetSize())
					ContentFrame:SetPos(self:GetPos())
		
					ContentFrame.Paint = function(self, w, h)
						surface.SetDrawColor(fguitable.Colors.gray)
						surface.DrawRect(0, 0, w, h)
					end
		
					self:SetParent(ContentFrame)
					self:DockMargin(0, 0, 0, 0)
					self:Dock(FILL)
				end)
			end,

			OnValueChanged = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnValueChanged then
					self.FHOnValueChanged(self, new)
				end
			end
		}
	},

	FHButton = {
		Base = "DButton",

		Registry = {
			SetCallback = function(self, callback)
				if not callback then
					return error("No Callback Provided")
				end

				if not type(callback) == "function" then
					return error("Invalid Callback Provided")
				end

				self.DoClick = function(self)
					callback(self)
				end
			end,

			Init = function(self)
				self:SetTextColor(fguitable.Colors.white)
				self:SetFont(fguitable.Functions.GetMPData(self).Font)
	
				self:SetCursor("arrow")
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				if not self:IsDown() then
					local grad = 55
					local step = 55 / (h * 1.5)
					grad = math.floor(grad / step) - 1
		
					local c = 55
		
					for i = 1, grad do
						c = c - step
		
						surface.SetDrawColor(c, c, c, 255)
						surface.DrawLine(0, i, w, i)
					end
				end
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end
		}
	},

	FHColorButton = {
		Base = "DButton",
		HasDMenu = true,

		Registry = {
			SetVarTable = function(self, varloc, var)
				self.FH.Color = varloc[var]

				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			SetColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				local varloc = self.FH.VarTable and self.FH.VarTable or self.FH
				local var = self.FH.Var and self.FH.Var or "Color"

				varloc[var] = color
			end,

			GetColor = function(self)
				local varloc = self.FH.VarTable and self.FH.VarTable or self.FH
				local var = self.FH.Var and self.FH.Var or "Color"

				return varloc[var]
			end,

			Init = function(self)
				self.FH = {
					Color = fguitable.Functions.CopyColor(fguitable.Colors.white)
				}

				self.SetValue = self.SetColor

				self:SetTextColor(fguitable.Colors.white)
				self:SetFont(fguitable.Functions.GetMPData(self).Font)
	
				self:SetCursor("arrow")

				timer.Simple(0, function()
					self.DMenu:AddOption("Copy Color", function()
						fguitable.Clipboard = fguitable.Functions.CopyColor(self:GetColor())
						fguitable.clipboard = fguitable.Clipboard -- Compatibility 

						SetClipboardText(table.concat(fguitable.Clipboard:ToTable(), ", "))
					end)

					self.DMenu:AddOption("Paste Color", function()
						if fguitable.Clipboard and IsColor(fguitable.Clipboard) then
							self:SetColor(fguitable.Clipboard)
						end
					end)
				end)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back_obj)
				surface.DrawRect(0, 0, w, h)
				
				if not self:IsDown() then
					local grad = 55
					local step = 55 / (h * 1.5)
					grad = math.floor(grad / step) - 1
		
					local c = 55
		
					for i = 1, grad do
						c = c - step
		
						surface.SetDrawColor(c, c, c, 255)
						surface.DrawLine(0, i, w, i)
					end
				end
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
	
				local _, th = surface.GetTextSize(self:GetText())
				local ty = ((h / 2) - (th / 2)) + th
	
				surface.SetDrawColor(self:GetColor())
				surface.DrawRect(5, ty - 1, w - 10, 3)
			end,

			DoClick = function(self)
				local MP = fguitable.Functions.GetFurthestParent(self)

				if not MP.FH or not IsValid(MP.FH.ColorPicker) then return end -- Not parented to an FGUI object (Or it was removed)

				local MPPicker = MP.FH.ColorPicker
	
				if IsValid(MPPicker) then
					local varloc = self.FH.VarTable and self.FH.VarTable or self.FH
					local var = self.FH.Var and self.FH.Var or "Color"
	
					MPPicker:Invoke(varloc, var)
				end

				if self.FHDoClick then
					self.FHDoClick(self)
				end
			end,

			DoRightClick = function(self)
				self:OpenMenu()

				if self.FHDoRightClick then
					self.FHDoRightClick(self)
				end
			end
		}
	},

	FHColorPicker = {
		Base = "DFrame",
		NotParented = true,
		HasContentFrame = true,

		Registry = {
			Invoke = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				self:SetVisible(true)
				self:Center()

				self:MakePopup()

				self.FH.ColorMixer:SetColor(varloc[var])
			end,

			GetFont = function(self)
				return fguitable.Functions.GetMPData(self).Font
			end,

			GetContentFrame = function(self)
				return self.FH.ContentFrame
			end,

			Init = function(self, oparent)
				self.FH = {
					Title = "Color Picker"
				}

				self:SetTitle("")
				self:GetChildren()[4]:SetVisible(false)
	
				self:SetSize(210, 186)
				self:ShowCloseButton(false)
				self:SetDeleteOnClose(false)
	
				self:SetVisible(false)
				self:Close()
	
				timer.Simple(0, function() -- Do setup on next tick to avoid fucky business
					local ContentFrame = self:GetContentFrame()
					local cfw, cfh = self:GetWide() - 20, self:GetTall() - 10 -- Uses self instead of content frame because jank
		
					local OK = fguitable.Create("FHButton", ContentFrame)
					OK:SetSize(100, 22)
					OK:SetPos((cfw / 2) - 50, cfh - 50)
					OK:SetText("OK")
			
					OK.DoClick = function()
						self.FH.VarTable[self.FH.Var] = self.FH.ColorMixer:GetColor()
	
						self:Close()
					end
	
					local ColorMixer = vgui.Create("DColorMixer", ContentFrame)
					ColorMixer:SetPalette(false)
					ColorMixer:SetWangs(false)
					ColorMixer:SetSize(180, 116)
					ColorMixer:SetPos((cfw / 2) - 90, 6)
	
					self.FH.ColorMixer = ColorMixer
	
					local ColorMixerChildren = ColorMixer:GetChildren()
	
					local ColorMixerHandle = ColorMixerChildren[4]:GetChildren()[1]
					ColorMixerHandle:SetSize(15, 15)
					ColorMixerHandle:SetCursor("arrow")
	
					ColorMixerHandle.Paint = function(self, w, h)
						surface.DrawCircle((w / 2), (h / 2), 5, fguitable.Colors.white)
						surface.DrawCircle((w / 2), (h / 2), 4, fguitable.Colors.black)
						surface.DrawCircle((w / 2), (h / 2), 6, fguitable.Colors.black)
					end
				end)
			end,

			Paint = function(self, w, h) -- Same(ish) as FHFrame
				local MP = fguitable.Functions.GetFurthestParent(self)

				if not IsValid(MP) then -- Not parented to an FGUI object (Or it was removed)
					self:Remove()
					return
				end

				local MPData = fguitable.Functions.GetMPData(self)
	
				surface.SetDrawColor(fguitable.Colors.black)
				surface.DrawRect(0, 0, w, h)
	
				local grad = 55
	
				for i = 1, grad do
					local c = grad - i
	
					surface.SetDrawColor(c, c, c, 255)
					surface.DrawLine(0, i, w, i)
				end
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
	
				surface.SetFont(MPData.Font)
				surface.SetTextColor(MPData.TitleColor)
	
				local tw, th = surface.GetTextSize(self.FH.Title)
	
				surface.SetTextPos((w / 2) - (tw / 2), 13 - (th / 2))
				surface.DrawText(self.FH.Title)
			end
		}
	},

	FHBinder = {
		Base = "DBinder",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.Functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			SetLabel = function(self, label)
				if not label then
					return error("No Label Provided")
				end

				self.FH.LabelText = label

				if self.FH.Label then
					self.FH.Label:SetText(label)
				end
			end,

			GetLabel = function(self)
				return self.FH.LabelText
			end,

			Init = function(self)
				local MPData = fguitable.Functions.GetMPData(self)
	
				self:SetTextColor(fguitable.Colors.white)
				self:SetFont(MPData.Font)
	
				self:SetCursor("arrow")
	
				timer.Simple(0, function()
					surface.SetFont(MPData.Font)

					local label = self:GetLabel()
	
					local tw, th = surface.GetTextSize(label)
	
					local Label = vgui.Create("DLabel", self:GetParent())
					Label:SetTextColor(fguitable.Colors.white)
					Label:SetFont(MPData.Font)
					Label:SetText(label)
					Label:SetPos(self:GetX() + ((self:GetWide() / 2) - (tw / 2)), self:GetY() - th - 3)
		
					self.FH.Label = Label
				end)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				if not self:IsDown() then
					local grad = 55
					local step = 55 / (h * 1.5)
					grad = math.floor(grad / step) - 1
		
					local c = 55
		
					for i = 1, grad do
						c = c - step
		
						surface.SetDrawColor(c, c, c, 255)
						surface.DrawLine(0, i, w, i)
					end
				end
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end,

			OnChange = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnChange then
					self.FHOnChange(self, new)
				end
			end
		}
	},

	FHMiniMenu = {
		Base = "DFrame",
		NotParented = true,

		Registry = {
			SetFont = function(self, font)
				if not font then
					return error("No Font Provided")
				end

				self.FH.Font = font
			end,

			GetFont = function(self)
				return self.FH.Font
			end,

			SetTextColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.TextColor = color
			end,

			GetTextColor = function(self)
				return self.FH.TextColor
			end,

			AddColumn = function(self, name, index)
				if not name then
					return error("No Column Name Provided")
				end

				index = index or (#self.FH.Columns + 1)

				for _, v in ipairs(self.FH.Rows) do
					table.insert(v, index, "")
				end

				table.insert(self.FH.Columns, index, name)
			end,

			AddRow = function(self, ...)
				self.FH.Rows[#self.FH.Rows + 1] = ...

				self:SetTall(20 + (20 * #self.FH.Rows))
			end,

			SetBackgroundAlpha = function(self, alpha)
				if not alpha then
					return error("No Alpha Provided")
				end

				self.FH.BackgroundAlpha = alpha
			end,

			GetBackgroundAlpha = function(self)
				return self.FH.BackgroundAlpha
			end,

			Init = function(self)
				self.FH = {
					Columns = {},
					Rows = {},
					BackgroundAlpha = 255,
					Font = fguitable.FontName,
					TextColor = fguitable.Functions.CopyColor(fguitable.Colors.white)
				}

				self:SetKeyboardInputEnabled(false) -- Disable focusing

				-- Similarities to FHFrame

				self:SetCursor("arrow")
				self.SetCursor = function() end

				self:SetTitle("")
				self:GetChildren()[4]:SetVisible(false)
	
				self:ShowCloseButton(false)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back_min)
				surface.DrawRect(0, 0, w, 20)
	
				local bgcol = fguitable.Functions.CopyColor(fguitable.Colors.back_obj)
				bgcol.a = self.FH.BackgroundAlpha
	
				local rows = #self.FH.Rows
				local cols = #self.FH.Columns
	
				surface.SetDrawColor(bgcol)
				surface.DrawRect(0, 20, w, 20 * rows)
	
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
	
				surface.SetFont(self.FH.Font)
				surface.SetTextColor(self.FH.TextColor)
	
				local step = w / cols
	
				for i = 1, cols do
					surface.DrawLine((i - 1) * step, 0, (i - 1) * step, h)
	
					local cur = self.FH.Columns[i]
	
					local tw, th = surface.GetTextSize(cur)
	
					surface.SetTextPos(((step / 2) - (tw / 2)) + ((i - 1) * step), 10 - (th / 2))
					surface.DrawText(cur)
				end
	
				for i = 1, rows do
					surface.DrawLine(0, i * 20, w, i * 20)
	
					for k, v in ipairs(self.FH.Rows[i]) do
						local tw, th = surface.GetTextSize(v)
			
						surface.SetTextPos(((step / 2) - (tw / 2)) + ((k - 1) * step), (10 - (th / 2)) + 20)
						surface.DrawText(v)
					end
				end
			end
		}
	},

	FHLabel = {
		Base = "DLabel",

		Registry = {
			Init = function(self)
				self:SetTextColor(fguitable.Colors.white)
				self:SetFont(fguitable.Functions.GetMPData(self).Font)
			end
		}
	},

	FHRadar = {
		Base = "DFrame",

		NotParented = true,

		Registry = {
			SetEntities = function(self, entities)
				if not entities then
					return error("No entities provided")
				end

				self.FH.Entities = table.Copy(entities)
			end,

			GetEntities = function(self)
				return self.FH.Entities
			end,

			SetBackgroundAlpha = function(self, alpha)
				if not alpha then
					return error("No alpha provided")
				end

				self.FH.BackgroundAlpha = alpha
			end,

			GetBackgroundAlpha = function(self)
				return self.FH.BackgroundAlpha
			end,

			SetRange = function(self, range)
				if not range then
					return error("No range provided")
				end

				self.FH.Range = range
			end,

			GetRange = function(self)
				return self.FH.Range
			end,

			SetParentEntity = function(self, parent)
				if not parent or not IsValid(parent) then
					return error("Invalid parent entity provided")
				end

				self.FH.Parent = parent
			end,

			GetParentEntity = function(self)
				return self.FH.Parent
			end,

			SetDrawParentEntity = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.DrawParent = active
			end,

			GetDrawParentEntity = function(self)
				return self.FH.DrawParent
			end,

			OnMousePressed = function(self) -- Custom drag region
				local mouseX, mouseY = gui.MouseX(), gui.MouseY()
				local width, height = self:GetSize()
				local screenX, screenY = self:LocalToScreen(0, 0)

				if self.m_bSizable and (mouseX > screenX + (width - 32) and mouseY > screenY + (height - 32)) then
					self.Sizing = {
						mouseX - width,
						mouseY - height
					}

					self:MouseCapture(true)

					return
				end
			
				if self:GetDraggable() and mouseY < screenY + height then
					self.Dragging = {
						mouseX - self.x,
						mouseY - self.y
					}

					self:MouseCapture(true)

					return
				end
			
			end,

			Init = function(self)
				self.FH = {
					BackgroundAlpha = 255,
					Entities = {},
					Range = 1000,
					Parent = LocalPlayer(),
					DrawParent = true
				}

				self:SetKeyboardInputEnabled(false) -- Disable focusing

				-- Same as FHFrame

				self:SetCursor("arrow")
				self.SetCursor = function() end

				self:SetTitle("")
				self:GetChildren()[4]:SetVisible(false)

				local children = self:GetChildren()
		
				for i = 1, 3 do
					children[i]:SetVisible(false)
					children[i]:SetEnabled(false)
				end
			end,

			Paint = function(self, w, h)
				local x, y = w / 2, h / 2

				local backcolor = fguitable.Functions.CopyColor(fguitable.Colors.back)
				backcolor.a = self.FH.BackgroundAlpha

				draw.NoTexture()

				surface.SetDrawColor(backcolor)
				local poly = fguitable.Functions.DrawFilledCircle(x, y, x, 64)

				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawLine(0, y, w, y)
				surface.DrawLine(x, 0, x, h)

				surface.DrawCircle(x, y, x, fguitable.Colors.outline)

				local parent = self.FH.Parent

				if not IsValid(parent) then return end

				local origin = parent:GetPos()

				if not origin then return end -- Should be impossible, but some entities are weird sometimes

				local range = self.FH.Range
				local validents = self.FH.Entities
				local nearbyents = ents.FindInSphere(origin, range)

				for i = #nearbyents, 1, -1 do
					local cur = nearbyents[i]

					if not IsValid(cur) or not validents[cur:GetClass()] then -- Remove entities not in our selection
						table.remove(nearbyents, i)
					end
				end

				surface.SetFont(fguitable.FontName) -- This will not be changable
				surface.SetTextColor(fguitable.Colors.white)

				render.SetStencilWriteMask(0xFF)
				render.SetStencilTestMask(0xFF)
				render.SetStencilReferenceValue(0)
				render.SetStencilPassOperation(STENCIL_KEEP)
				render.SetStencilZFailOperation(STENCIL_KEEP)
				render.ClearStencil()
			
				render.SetStencilEnable(true)
				render.SetStencilReferenceValue(1)
				render.SetStencilCompareFunction(STENCIL_NEVER)
				render.SetStencilFailOperation(STENCIL_REPLACE)
			
				surface.SetDrawColor(fguitable.Colors.white)
				surface.DrawPoly(poly)

				render.SetStencilCompareFunction(STENCIL_EQUAL)
				render.SetStencilFailOperation(STENCIL_KEEP)

				for _, v in ipairs(nearbyents) do
					if v == parent and not self.FH.DrawParent then
						continue
					end

					if (v:IsPlayer() and not v:Alive()) or ((v:IsNPC() or v:IsNextBot()) and v:Health() < 1) then -- Entity is supposedly dead, don't render
						continue
					end

					local difference = v:GetPos() - origin

					local rx = difference.x / range
					local ry = difference.y / range

					local forward = parent:GetForward()

					local z = math.sqrt((rx * rx) + (ry * ry))
                    local phi = math.deg(math.rad(math.atan2(rx, ry)) - math.rad(math.atan2(forward.x, forward.y)) + 90)
                    rx = math.cos(phi) * z
                    ry = math.sin(phi) * z

                    if math.Dist(x, y, rx, ry) > w then continue end

                    local cx = x + (rx * x)
                    local cy = y + (ry * y)

					surface.SetDrawColor(validents[v:GetClass()])
					surface.DrawRect(cx - 4, cy - 4, 8, 8)

					surface.SetDrawColor(fguitable.Colors.outline)
					surface.DrawOutlinedRect(cx - 4, cy - 4, 8, 8)

					if v:IsDormant() then
						local tw, th = surface.GetTextSize("?")

						surface.SetTextPos(cx - (tw / 2), cy - (th / 2))
						surface.DrawText("?")
					end
				end

				render.SetStencilEnable(false)
			end
		}
	}
}

for k, v in pairs(fguitable.Objects) do -- Register objects
	vgui.Register(k, v.Registry, v.Base)
end

fguitable.Create = function(type, parent, name)
	if not type or not fguitable.Objects[type] then
		return error("Invalid FlowHooks Object (" .. type .. ")")
	end

	local current = fguitable.Objects[type]

	if not parent and not current.NotParented then
		return error("Invalid Parent Panel Specified")
	elseif parent and type ~= "FHContentFrame" then
		if parent.FH and parent.FH.Type == "FHFrame" and parent.GetContentFrame then
			parent = parent:GetContentFrame()
		end
	end

	local FHObject = vgui.Create(type, parent, name)

	FHObject.FH = FHObject.FH or {}
	FHObject.FH.Type = type

	if current.HasContentFrame then
		local frame = fguitable.Create("FHContentFrame", FHObject)
		frame:Dock(FILL)
		frame:SetDrawOutline(true)

		FHObject.FH.ContentFrame = frame
	end

	if current.HasDMenu then
		local MP = fguitable.Functions.GetFurthestParent(FHObject)

		FHObject.DMenuOpen = false
		FHObject.DMenu = vgui.Create("DMenu")

		local DMenu = FHObject.DMenu
		local ogAddOption = DMenu.AddOption

		DMenu.AddOption = function(...)
			local NewOption = ogAddOption(...)

			NewOption:SetCursor("arrow")
	
			NewOption:SetTextColor(fguitable.Colors.white)
			NewOption:SetFont(MP:GetFont())
	
			NewOption.Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.Colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				if self:IsHovered() then
					local accent = fguitable.Functions.CopyColor(MP:GetAccentColor())
					accent.a = accent.a / 4
	
					surface.SetDrawColor(accent)
					surface.DrawRect(0, 0, w, h)
				end
		
				surface.SetDrawColor(fguitable.Colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			return NewOption
		end
	
		DMenu:SetDeleteSelf(false)
		DMenu:Hide()
	
		FHObject.IsMenuOpen = function(self)
			return self.DMenuOpen
		end
		
		FHObject.OpenMenu = function(self)
			self.DMenu:Open(self:LocalToScreen(0, self:GetTall()))
			self.DMenu:SetVisible(true)
		end
		
		FHObject.CloseMenu = function(self)
			self.DMenu:Hide()
			self.DMenu:SetVisible(false)
		end

		local ogPaint = FHObject.Paint

		FHObject.Paint = function(self, w, h)
			ogPaint(self, w, h)

			if self.DMenu then
				self.DMenuOpen = self.DMenu:IsVisible()
				self.DMenu:SetMinimumWidth(self:GetWide())
			end
		end
	end
	
	return FHObject
end

fguitable.CreateVarTableTimer = function()
	timer.Create(fguitable.TimerName, 0.2, 0, function()
		for _, v in ipairs(fguitable.VarTableHolders) do
			if not IsValid(v) or not v:IsVisible() or not v.FH or not v.FH.VarTable or not v.FH.Var then -- Just in case something goes wrong
				continue
			end
	
			if v.FH.Type == "FHCheckBox" then -- Funny SetValue calls OnChange and I'm not gonna override SetValue
				v:SetChecked(v.FH.VarTable[v.FH.Var])
			elseif v.FH.Type == "FHBinder" and v.Trapping then
				continue
			else
				v:SetValue(v.FH.VarTable[v.FH.Var])
			end
		end
	end)
end

fguitable.Hide = function() -- Destroys the fgui globals and returns the new fgui table (Except the elements)
	local backup = table.Copy(fguitable)
	fgui = nil

	timer.Remove(backup.TimerName)

	backup.TimerName = backup.Functions.GenerateRandomString()
	backup.timer = backup.TimerName -- Compatibility

	backup.CreateVarTableTimer()

	fguitable = backup

	return backup
end

fguitable.CreateVarTableTimer() -- Create the timer when the script is loaded

-- Compatibility with old names

fguitable.timer = fguitable.TimerName
fguitable.clipboard = fguitable.Clipboard

fguitable.vth = fguitable.VarTableHolders
fguitable.colors = fguitable.Colors
fguitable.functions = fguitable.Functions
fguitable.objects = fguitable.Objects
