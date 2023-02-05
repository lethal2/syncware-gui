local RunService = game:GetService"RunService"
local IsStudio = RunService:IsStudio()
emptyfunction = function() end

repeat wait() until game:IsLoaded()

local TweenService = game:GetService"TweenService"
local UserInputService = game:GetService"UserInputService"
local Players = game:GetService"Players"
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Mouse1Down = false
local Mouse2Down = false
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end
	Mouse1Down = true
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end
	Mouse1Down = false
end)
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
		return
	end
	Mouse2Down = true
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
		return
	end
	Mouse2Down = false
end)
local function getparent(v)
	local str = v.Name=="Game"and"game"or v.Name
	if v.Parent then
		str = getparent(v.Parent).."."..str
	end
	return str
end
ts = nil;
function unpacktbl(tbl, d)
	local rc = ""
	local d2 = d and d or 1
	if d and d-1>0 then
		for i=1,d-1,1 do
			rc = rc.."	"
		end
	end
	local str = "{"
	for i, v in pairs (tbl) do
		local K = [[

]]..rc.."	["..ts(i).."] = "..ts(v, d2+1)..","
		str = str..K
	end
	return str..[[

]]..rc.."}"
end
ts = function(v,d)
	if typeof(v) == "table" then
		return unpacktbl(v,d)
	elseif typeof(v) == "Instance" then
		return getparent(v)
	elseif typeof(v) == "function" then
		return "'"..tostring(v).."'"
	elseif typeof(v) == "string" then
		local Sym1 = "'"
		local Sym2 = "'"
		if v:find(Sym1) then
			Sym1 = '"'
			Sym2 = '"'
			if v:find(Sym1) then
				Sym1 = '[['
				Sym2 = ']]'
			end
		end
		return Sym1..v..Sym2
	end
	return tostring(v)
end
Tw=nil
Tween = function(...) Tw=TweenService:Create(...)Tw:Play() return Tw end
Smoothing = 10
UsingSlidas = false
drag_gui_1 = function(var1)
	var1.Draggable = false 
	do 
		local a = var1 
		local dragInput 
		local dragStart 
		local startPos 
		local function update(input) 
			if UsingSlidas then return end
			local delta = input.Position - dragStart 
			Tween(a, TweenInfo.new(0.01*Smoothing), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
		end 
		a.InputBegan:Connect(function(input) 
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
				return
			end
			var1.Draggable = true 
			dragStart = input.Position 
			startPos = a.Position 

			input.Changed:Connect(function() 
				if input.UserInputState == Enum.UserInputState.End then 
					var1.Draggable = false 
				end 
			end) 
		end) 
		a.InputChanged:Connect(function(input) 
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
				dragInput = input 
			end 
		end) 
		UserInputService.InputChanged:Connect(function(input) 
			if input == dragInput and var1.Draggable then 
				update(input) 
			end 
		end) 
	end 
end 
makefolder("SyncCFG")
Values={}
local Gui = nil
local NOTON = nil
local HideUi = nil
local FakeUI = nil
local MainUI = nil
local IsBusy = false
local FirstTab = true
local IsHidden = false
local UIClickDebounce = 0.15
local HitMessageDuration = 2
local DisableClickClose = false
local DisableTabSwitching = false
local TabSwitchCrossDissolveTable_Outro = nil
local TabSwitchCrossDissolveTable_Intro = nil
local GlobalDisableMouseClickConnections = false
Library={
    ['SetProperties'] = function(tbl)
        UIClickDebounce = tbl['UIClickDebounce'] or UIClickDebounce
        HitMessageDuration = tbl['HitMessageDuration'] or HitMessageDuration
    end,
	['HitMessageUIScale'] = nil,
	['CreateHitMessage'] = emptyfunction,
	['SaveConfig'] = function(name)
		UsingSlidas = true
		task.wait()
		local Directory = "SyncCFG/"..name..".txt"
		local Text = ""
		local s = tostring
		local function stbl(tbl)
			local S = ""
			for i, v in pairs (tbl) do
				S = S.."**"..v
			end
			return S
		end
		for TabName, Tab in pairs (Values) do
			for SectorName, Sector in pairs (Tab) do
				for ElementName, Element in pairs (Sector) do
					Text = Text..("||%s\\%s\\%s\\%s##%s##%s##%s##%s##%s##%s"):format(TabName,SectorName,ElementName,s(Element["Text"]),s(Element["Slider"]),s(Element["Toggle"]),s(Element["ActuationType"]),s(Element["ToggleKey"] and tostring(Element["ToggleKey"]):gsub("Enum.KeyCode.", "") or "nil"),s(Element["Dropdown"]),Element["Jumbobox"] and stbl(Element["Jumbobox"]) or "Nothing")
				end
			end
		end
		writefile(Directory, Text)
		task.wait()
		UsingSlidas = false
	end,
	['LoadConfig'] = function(name)
		UsingSlidas = true
		task.wait()
		local Directory = "SyncCFG/"..name..".txt"
		local Text = readfile(Directory)
		local Data = Text:split("||")
		Data[1] = nil
		for i, v in pairs (Data) do
			local s,e = pcall(function()
				local Data1 = v:split("\\")
				local Data2 = Data1[4]:split("##")
				local function totbl(Str)
					if not Str or Str == "Nothing" then return {} end
					local S = ""
					local Tbl = {}
					local Split = Str:split("**")
					Split[1] = nil
					for i, v in pairs (Split) do 
						Tbl[#Tbl+1] = v
					end
					return Tbl
				end
				Values[Data1[1]][Data1[2]][Data1[3]].SetValue({
					Text = Data2[1],
					Slider = tonumber(Data2[2]),
					Toggle = Data2[3]=="true",
					ActuationType = Data2[4],
					ToggleKey = Data2[5]=="nil" and "nil" or Enum.KeyCode[Data2[5]],
					Dropdown = Data2[6],
					Jumbobox = totbl(Data2[7])
				})
			end) if not s then warn(e) end
		end
		task.wait()
		UsingSlidas = false
	end,
	['Button Function'] = function(input, Callback)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or not Callback then 
			return
		end
		return Callback()
	end,
	['New'] = function()
		TabSwitchCrossDissolveTable_Outro = {
			["UIListLayout"] = {},
			["UIPadding"] = {},
			["UICorner"] = {},
			["UIStroke"] = {
				Transparency = 1,
			},
			["Frame"] = {
				BackgroundTransparency = 1,
			},
			["ScrollingFrame"] = {
				BackgroundTransparency = 1,
			},
			["TextLabel"] = {
				BackgroundTransparency = 1,
				TextTransparency = 1,
			},
			["TextBox"] = {
				BackgroundTransparency = 1,
				TextTransparency = 1,
			},
			["ImageLabel"] = {
				ImageTransparency = 1,
			},
		}
		Gui = Instance.new("ScreenGui", IsStudio and game.Players.LocalPlayer.PlayerGui or game.CoreGui)
		IsStudio = nil
		Gui.ResetOnSpawn = false
		Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		Gui.DisplayOrder = 72769420
		HideUi = Instance.new("Frame", Gui)
		drag_gui_1(HideUi)
		HideUi.BackgroundColor3 = Color3.new(0.205882, 0.205882, 0.205882)
		HideUi.Size = UDim2.new(0,30,0,30)
		HideUi.Visible = true
		HideUi.ZIndex = 999
		local CornersLUL = Instance.new("UICorner", HideUi)
		CornersLUL.CornerRadius = UDim.new(1,0)
		local StrokeL = Instance.new("UIStroke", HideUi)
		StrokeL.Color = Color3.new(0.125882, 0.125882, 0.125882)
		StrokeL.Thickness = 2

		local SyncWareHitLogsFrame = Instance.new("Frame", Gui)
		SyncWareHitLogsFrame.BackgroundTransparency = 1
		SyncWareHitLogsFrame.Size = UDim2.new(0.4,0,1,0)
		SyncWareHitLogsFrame.ZIndex = 999999
		local UIListLayout = Instance.new("UIListLayout", SyncWareHitLogsFrame)
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		Library.HitMessageUIScale = Instance.new("UIScale", SyncWareHitLogsFrame)
		Library.HitMessageUIScale.Scale = 1
		local SyncWareHit = Instance.new("Frame", Gui)
		SyncWareHit.Position = UDim2.new(-1,0,0,0)
		SyncWareHit.BackgroundColor3 = Color3.fromRGB(74,74,74)
		SyncWareHit.BorderSizePixel = 0
		SyncWareHit.Size = UDim2.new(0,0,0,20)
		SyncWareHit.ZIndex = 9999999
		SyncWareHit.AutomaticSize = Enum.AutomaticSize.X
		SyncWareHit.BackgroundTransparency = 1
		local UIGrad = Instance.new("UIGradient", SyncWareHit)
		UIGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
			ColorSequenceKeypoint.new(0.554,Color3.fromRGB(229,229,229)),
			ColorSequenceKeypoint.new(1,Color3.fromRGB(161,161,161)),
		})
		UIGrad.Rotation = 90
		local UIStroke = Instance.new("UIStroke", SyncWareHit)
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Color = Color3.fromRGB(62,62,62)
		UIStroke.LineJoinMode = Enum.LineJoinMode.Bevel
		UIStroke.Thickness = 1
		UIStroke.Transparency = 1
		local LeftLine = Instance.new("ImageLabel", SyncWareHit)
		LeftLine.BackgroundTransparency = 1
		LeftLine.BorderSizePixel = 0
		LeftLine.Size = UDim2.new(0,10,1,0)
		LeftLine.ZIndex = 99999999
		LeftLine.Image = "rbxassetid://595695917"
		LeftLine.ImageColor3 = Color3.fromRGB(49,49,49)
		LeftLine.ImageTransparency = 1
		UIGrad = Instance.new("UIGradient", LeftLine)
		UIGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
			ColorSequenceKeypoint.new(0.957,Color3.fromRGB(229,229,229)),
			ColorSequenceKeypoint.new(1,Color3.fromRGB(161,161,161)),
		})
		local TextLabel = Instance.new("TextLabel", SyncWareHit)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0,15,0,0)
		TextLabel.Size = UDim2.new(1,-15,1,-2)
		TextLabel.ZIndex = 72769420
		TextLabel.Font = Enum.Font.SourceSansLight
		TextLabel.RichText = true
		TextLabel.Text = "<font color='#9f9f9f'>Hit</font> <font color='#78B810'>player</font> <font color='#9f9f9f'>in the</font> <font color='#78B810'>hitbox</font>"
		TextLabel.TextColor3 = Color3.new(1,1,1)
		TextLabel.TextSize = 0
		TextLabel.TextTransparency = 1
		TextLabel.TextStrokeTransparency = 1
		TextLabel.TextStrokeColor3 = Color3.fromRGB(57,57,57)
		TextLabel.TextWrapped = false
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.AutomaticSize = Enum.AutomaticSize.X
		Library.CreateHitMessage = function(text)
			TextLabel.Text = text
			spawn(function()
				local HitGui = SyncWareHit:Clone()
				HitGui.Parent = SyncWareHitLogsFrame
				Tween(HitGui, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,200,0,20), BackgroundTransparency = 0})
				Tween(HitGui.ImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,10,1,0), ImageTransparency = 0})
				Tween(HitGui.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,-15,1,-2), TextTransparency = 0, TextStrokeTransparency = 0, TextSize = 14})
				Tween(HitGui.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
				task.wait(HitMessageDuration)
				Tween(HitGui, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,0,0,20), BackgroundTransparency = 1})
				Tween(HitGui.ImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,0,1,0), ImageTransparency = 1})
				Tween(HitGui.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,0,1,-2), TextTransparency = 1, TextStrokeTransparency = 1, TextSize = 0})
				Tween(HitGui.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
				task.wait(.4)
				HitGui:Destroy()
			end)
		end

		local KeybindActuationTypeBox = Instance.new("Frame", Gui)
		KeybindActuationTypeBox.Name = "KeybindActuationTypeBox"
		KeybindActuationTypeBox.BorderSizePixel = 0
		KeybindActuationTypeBox.Size = UDim2.new(0,10,0,10)
		KeybindActuationTypeBox.Position = UDim2.new(10,10,10,10)
		KeybindActuationTypeBox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		KeybindActuationTypeBox.ZIndex = 999999
		KeybindActuationTypeBox.BackgroundTransparency = 0
		KeybindActuationTypeBox.AutomaticSize = Enum.AutomaticSize.XY
		local UIListLayout = Instance.new("UIListLayout", KeybindActuationTypeBox)
		UIListLayout.Padding = UDim.new(0,2)
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		CornersLUL = Instance.new("UICorner", KeybindActuationTypeBox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local UIStroke = Instance.new("UIStroke", KeybindActuationTypeBox)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local KAToggle = Instance.new("TextLabel", KeybindActuationTypeBox)
		KAToggle.Name = "Toggle"
		KAToggle.BorderSizePixel = 0
		KAToggle.Size = UDim2.new(0,35,0,15)
		KAToggle.BackgroundTransparency = 1
		KAToggle.TextColor3 = Color3.new(1,1,1)
		KAToggle.Text = "Toggle"
		KAToggle.TextTransparency = 0
		KAToggle.Font = Enum.Font.SourceSansLight
		KAToggle.TextSize = 14
		KAToggle.ZIndex = 1000000
		local KAHold = Instance.new("TextLabel", KeybindActuationTypeBox)
		KAHold.Name = "Hold"
		KAHold.BorderSizePixel = 0
		KAHold.Size = UDim2.new(0,35,0,15)
		KAHold.BackgroundTransparency = 1
		KAHold.TextColor3 = Color3.new(1,1,1)
		KAHold.Text = "Hold"
		KAHold.TextTransparency = 0
		KAHold.Font = Enum.Font.SourceSansLight
		KAHold.TextSize = 14
		KAHold.ZIndex = 1000000

		FakeUI = Instance.new("Frame", Gui)
		FakeUI.BorderSizePixel = 0
		FakeUI.BackgroundColor3 = Color3.new(0.205882, 0.205882, 0.205882)
		FakeUI.Size = UDim2.new(0,20,0,1)
		FakeUI.ZIndex = 3
		CornersLUL = Instance.new("UICorner", FakeUI)
		CornersLUL.CornerRadius = UDim.new(1,5)
		Tween(CornersLUL, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CornerRadius=UDim.new(0,5)})
		Tween(FakeUI, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,20,0,20),Position = UDim2.new(0.5,-255,0.5,-305)})
		task.wait(0.3)
		Tween(FakeUI, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,510,0,20)})
		task.wait(0.5)
		Tween(FakeUI, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,510,0,610),Position = UDim2.new(0.5,-255,0.5,-305)})

		task.wait(0.5)
		FakeUI.Visible = false

		MainUI = Instance.new("Frame", Gui)
		drag_gui_1(MainUI)
		MainUI.BorderSizePixel = 0
		MainUI.BackgroundColor3 = Color3.new(0.205882, 0.205882, 0.205882)
		MainUI.Size = UDim2.new(0,510,0,610)
		MainUI.Position = UDim2.new(0.5,-255,0.5,-305)
		MainUI.ZIndex = 3
		CornersLUL = Instance.new("UICorner", MainUI)
		CornersLUL.CornerRadius = UDim.new(0,5)

		local FakeTitleBox = Instance.new("TextLabel", MainUI)
		FakeTitleBox.BorderSizePixel = 0
		FakeTitleBox.Size = UDim2.new(1,0,0,20)
		FakeTitleBox.BackgroundTransparency = 1
		FakeTitleBox.TextColor3 = Color3.new(1,1,1)
		FakeTitleBox.Text = "Made by <font color='#78B810'><b>wowot</b></font>"
		FakeTitleBox.TextTransparency = 1
		FakeTitleBox.Font = Enum.Font.SourceSansLight
		FakeTitleBox.TextSize = 18
		FakeTitleBox.ZIndex = 6
		FakeTitleBox.RichText = true

		local TitleBox = Instance.new("TextLabel", MainUI)
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(0,0,0,20)
		TitleBox.BackgroundColor3 = Color3.new(0.155882, 0.15882, 0.155882)
		TitleBox.TextColor3 = Color3.new(1,1,1)
		TitleBox.Text = ""
		TitleBox.TextTransparency = 1
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 18
		TitleBox.ZIndex = 5
		TitleBox.RichText = true
		CornersLUL = Instance.new("UICorner", TitleBox)
		CornersLUL.CornerRadius = UDim.new(0,5)

		Library.Hide = function()
			if IsBusy then return end
			IsBusy = true
			IsHidden = true
			FakeUI.Size = MainUI.Size
			FakeUI.Position = MainUI.Position
			MainUI.Visible = false
			FakeUI.Visible = true
			Tween(FakeUI, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,510,0,20), Position = UDim2.new(MainUI.Position.X.Scale,MainUI.Position.X.Offset,0,HideUi.Position.Y.Offset+15)})
			task.wait(0.4)
			Tween(FakeUI, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0,HideUi.Position.X.Offset+15,0,HideUi.Position.Y.Offset+15)})
			task.wait(0.2)
			IsBusy = false
		end

		Library.Expose = function()
			if IsBusy then return end
			IsBusy = true
			IsHidden = false
			FakeUI.Size = UDim2.new(0,0,0,0)
			FakeUI.Position = UDim2.new(0,HideUi.Position.X.Offset+15,0,HideUi.Position.Y.Offset+15)
			MainUI.Visible = false
			FakeUI.Visible = true
			Tween(FakeUI, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,510,0,20), Position = UDim2.new(MainUI.Position.X.Scale,MainUI.Position.X.Offset,0,HideUi.Position.Y.Offset+15)})
			task.wait(0.4)
			Tween(FakeUI, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = MainUI.Size, Position = MainUI.Position})
			task.wait(0.2)
			MainUI.Visible = true
			FakeUI.Visible = false
			IsBusy = false
		end

		TitleBox.InputBegan:Connect(function(input)
			if DisableClickClose or input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or IsHidden then 
				return
			end
			task.wait(UIClickDebounce)
			if Mouse1Down or GlobalDisableMouseClickConnections then return end
			Library:Hide()
		end)
		HideUi.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or not IsHidden then 
				return
			end
			task.wait(UIClickDebounce)
			if Mouse1Down or GlobalDisableMouseClickConnections then return end
			Library.Expose()
		end)
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Insert then
				if IsHidden then
					Library.Expose()
				else
					Library.Hide()
				end
			end
		end)

		local NOCLIPPING = Instance.new("Frame", MainUI)
		NOCLIPPING.BorderSizePixel = 0
		NOCLIPPING.Size = UDim2.new(1,0,0,35)
		NOCLIPPING.BackgroundColor3 = Color3.new(0.170882, 0.17082, 0.170882)
		NOCLIPPING.Position = UDim2.new(0,0,0,5)
		NOCLIPPING.ZIndex = 4

		local TabsFrame = Instance.new("Frame", MainUI)
		TabsFrame.Name = "TabsFrame"
		TabsFrame.BorderSizePixel = 0
		TabsFrame.Size = UDim2.new(1,0,0,20)
		TabsFrame.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		TabsFrame.Position = UDim2.new(0,0,0,20)
		TabsFrame.ZIndex = 5
		CornersLUL = Instance.new("UICorner", TabsFrame)
		CornersLUL.CornerRadius = UDim.new(0,5)
		UIListLayout = Instance.new("UIListLayout", TabsFrame)
		UIListLayout.Padding = UDim.new(0,5)
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local Left = Instance.new("ScrollingFrame", MainUI)
		Left.Name = "Left"
		Left.BorderSizePixel = 0
		Left.Size = UDim2.new(0.5,0,1,-45)
		Left.BackgroundColor3 = Color3.new(0.205882, 0.205882, 0.205882)
		Left.Position = UDim2.new(0,0,0,45)
		Left.ScrollBarThickness = 0
		Left.ScrollingDirection = Enum.ScrollingDirection.Y
		Left.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Left.CanvasSize = UDim2.new(0,0,10,0)
		Left.ZIndex = 5
		UIListLayout = Instance.new("UIListLayout", Left)
		UIListLayout.Padding = UDim.new(0,0)
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		local Padding = Instance.new("UIPadding", Left)
		Padding.PaddingTop = UDim.new(0,-5)
		Padding.PaddingLeft = UDim.new(0,4)

		local Right = Instance.new("ScrollingFrame", MainUI)
		Right.Name = "Right"
		Right.BorderSizePixel = 0
		Right.Size = UDim2.new(0.5,0,1,-45)
		Right.BackgroundColor3 = Color3.new(0.205882, 0.205882, 0.205882)
		Right.Position = UDim2.new(0.5,0,0,45)
		Right.ScrollBarThickness = 0
		Right.ScrollingDirection = Enum.ScrollingDirection.Y
		Right.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Right.CanvasSize = UDim2.new(0,0,10,0)
		Right.ZIndex = 5
		UIListLayout = Instance.new("UIListLayout", Right)
		UIListLayout.Padding = UDim.new(0,2)
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		Padding = Instance.new("UIPadding", Right)
		Padding.PaddingTop = UDim.new(0,-5)
		Padding.PaddingLeft = UDim.new(0,4)

		local TextsSettingAmoment = {
			"M",
			"Ma",
			"Mad",
			"Made",
			"Made ",
			"Made b",
			"Made by",
			"Made by ",
			"Made by <font color='#78B810'><b>w</b></font>",
			"Made by <font color='#78B810'><b>wo</b></font>",
			"Made by <font color='#78B810'><b>wow</b></font>",
			"Made by <font color='#78B810'><b>wowo</b></font>",
			"Made by <font color='#78B810'><b>wowot</b></font>",
		}

		Tween(TitleBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,20)})
		task.wait(0.5)
		spawn(function()
			for i, v in pairs (TextsSettingAmoment) do
				task.wait(1/40)
				TitleBox.Text = v
			end
			task.wait(1)
			FakeTitleBox.Text = "Made by <font color='#78B810'><b>wowot</b></font>"
			FakeTitleBox.TextTransparency = 0
			TitleBox.TextTransparency = 1
			TitleBox.Text = '<b>Sync<font color="#78B810">Ware</font></b>'
			task.wait(0.5)
			for i=0,1,0.05 do
				FakeTitleBox.TextTransparency = i
				TitleBox.TextTransparency = 1-i
				task.wait(1/60)
			end
			FakeTitleBox.TextTransparency = 1
			local ALREADYTWEENING = false
			local TweenQueued = false
			FakeTitleBox.MouseEnter:Connect(function() 
				if TweenQueued then return end
				if ALREADYTWEENING then TweenQueued = true repeat task.wait() until not ALREADYTWEENING end
				ALREADYTWEENING = true
				FakeTitleBox.Text = '<b>Sync<font color="#78B810">Ware</font></b>'
				FakeTitleBox.TextTransparency = 0
				TitleBox.TextTransparency = 1
				TitleBox.Text = "Made by <font color='#78B810'><b>wowot</b></font>"
				for i=0,1,0.05 do
					FakeTitleBox.TextTransparency = i
					TitleBox.TextTransparency = 1-i
					task.wait(1/60)
				end
				FakeTitleBox.TextTransparency = 1
				ALREADYTWEENING = false
				TweenQueued = false
			end)
			FakeTitleBox.MouseLeave:Connect(function()
				if TweenQueued then return end
				if ALREADYTWEENING then TweenQueued = true repeat task.wait() until not ALREADYTWEENING end
				ALREADYTWEENING = true
				FakeTitleBox.Text = "Made by <font color='#78B810'><b>wowot</b></font>"
				FakeTitleBox.TextTransparency = 0
				TitleBox.TextTransparency = 1
				TitleBox.Text = '<b>Sync<font color="#78B810">Ware</font></b>'
				for i=0,1,0.05 do
					FakeTitleBox.TextTransparency = i
					TitleBox.TextTransparency = 1-i
					task.wait(1/60)
				end
				FakeTitleBox.TextTransparency = 1
				ALREADYTWEENING = false
				TweenQueued = false
			end)
		end)
		Tween(TitleBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
		return {Tab = Library.Tab}
	end,
	['Tab'] = function(TabName)
		for i, v in pairs (MainUI.Left:GetChildren()) do
			if v.ClassName ~= "TextLabel" then continue end
			v.Parent = nil
		end
		for i, v in pairs (MainUI.Right:GetChildren()) do
			if v.ClassName ~= "TextLabel" then continue end
			v.Parent = nil
		end
		local TitleBox = Instance.new("TextLabel", MainUI.TabsFrame)
		TitleBox.Name = TabName
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(0,75,1,0)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(1,1,1)
		TitleBox.Text = TabName
		TitleBox.TextTransparency = 0
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 18
		TitleBox.ZIndex = 6
		local SectorUIs = {}	
		Values[TabName] = {}
		TitleBox.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or DisableTabSwitching then 
				return
			end
			task.wait(UIClickDebounce)
			if Mouse1Down or GlobalDisableMouseClickConnections then return end
			if SectorUIs[1].UI.Parent == MainUI.Left or SectorUIs[1].UI.Parent == MainUI.Right then
				return
			end
			DisableTabSwitching = true
			for i, v in pairs (MainUI.Left:GetChildren()) do
				if v.ClassName ~= "TextLabel" then continue end
				Tween(v, TweenInfo.new(0.15), {TextTransparency = 1})
				for i, v1 in pairs (v:GetDescendants()) do
					local Shit = {}
					for i2, v2 in pairs (TabSwitchCrossDissolveTable_Outro[v1.ClassName]) do
						Shit[i2] = v1[i2]
					end
					Tween(v1, TweenInfo.new(0.2), TabSwitchCrossDissolveTable_Outro[v1.ClassName])
					spawn(function()
						task.wait(0.5)
						Tween(v1, TweenInfo.new(0), Shit)
					end)
				end
				spawn(function()
					task.wait(0.5)
					v.Parent = nil
				end)
			end
			for i, v in pairs (MainUI.Right:GetChildren()) do
				if v.ClassName ~= "TextLabel" then continue end
				Tween(v, TweenInfo.new(0.15), {TextTransparency = 1})
				for i, v1 in pairs (v:GetDescendants()) do
					local Shit = {}
					for i2, v2 in pairs (TabSwitchCrossDissolveTable_Outro[v1.ClassName]) do
						Shit[i2] = v1[i2]
					end
					Tween(v1, TweenInfo.new(0.2), TabSwitchCrossDissolveTable_Outro[v1.ClassName])
					spawn(function()
						task.wait(0.5)
						Tween(v1, TweenInfo.new(0), Shit)
					end)
				end
				spawn(function()
					task.wait(0.5)
					v.Parent = nil
				end)
			end
			task.wait(0.5)
			for i, v in pairs (SectorUIs) do
				v.UI.Parent = MainUI[v.Side]
				v.UI.TextTransparency = 1
				Tween(v.UI, TweenInfo.new(0.25), {TextTransparency = 0})
				for i, v1 in pairs (v.UI:GetDescendants()) do
					local Shit = {}
					for i2,v2 in pairs (TabSwitchCrossDissolveTable_Outro[v1.ClassName]) do
						Shit[i2] = v1[i2]
						v1[i2] = v2
					end
					Tween(v1, TweenInfo.new(0.25), Shit)
				end
			end
			task.wait(0.25)
			DisableTabSwitching = false
		end)

		return {Sector=function(SectorName, Side) return Library.Sector(function(v)SectorUIs[#SectorUIs+1] = v end, TabName, SectorName, Side) end}
	end,
	['Sector'] = function(Add, TabName, SectorName, Side)
		Values[TabName][SectorName] = {} 
		local TitleBox = Instance.new("TextLabel", FirstTab and MainUI[Side] or nil)
		TitleBox.Name = SectorName
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(1,-8,0,5)
		TitleBox.Position = UDim2.new(0,4,0,-5)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(1,1,1)
		TitleBox.Text = " "..SectorName
		TitleBox.TextTransparency = 0
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 18
		TitleBox.ZIndex = 7
		TitleBox.TextXAlignment = Enum.TextXAlignment.Left
		TitleBox.TextYAlignment = Enum.TextYAlignment.Top
		TitleBox.AutomaticSize = Enum.AutomaticSize.Y
		local UIPadding = Instance.new("UIPadding", TitleBox)
		UIPadding.PaddingTop = UDim.new(0,5)
		local SectorBg = Instance.new("Frame", TitleBox)
		SectorBg.Name = SectorName
		SectorBg.BorderSizePixel = 0
		SectorBg.Size = UDim2.new(1,-10,0,15)
		SectorBg.Position = UDim2.new(0,0,0,20)
		SectorBg.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		SectorBg.ZIndex = 6
		SectorBg.AutomaticSize = Enum.AutomaticSize.Y
		local CornersLUL = Instance.new("UICorner", SectorBg)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local BottomSectorBg = Instance.new("Frame", SectorBg)
		BottomSectorBg.Name = SectorName
		BottomSectorBg.BorderSizePixel = 0
		BottomSectorBg.Size = UDim2.new(0,15,0,15)
		BottomSectorBg.Position = UDim2.new(0,0,1,-5)
		BottomSectorBg.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		BottomSectorBg.ZIndex = 6
		CornersLUL = Instance.new("UICorner", BottomSectorBg)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local Sector = Instance.new("Frame", SectorBg)
		Sector.Name = SectorName
		Sector.BorderSizePixel = 0
		Sector.Size = UDim2.new(1,-10,1,-10)
		Sector.Position = UDim2.new(0,5,0,5)
		Sector.BackgroundColor3 = Color3.new(0.265882, 0.26882, 0.265882)
		Sector.ZIndex = 7
		Sector.AutomaticSize = Enum.AutomaticSize.Y
		CornersLUL = Instance.new("UICorner", Sector)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local UIListLayout = Instance.new("UIListLayout", Sector)
		UIListLayout.Padding = UDim.new(0,5)
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		local Items = {}
		Add({UI = TitleBox, Side = Side, GetItems = function() return Items end})

		RunService.RenderStepped:Wait()

		return {SectorUI = TitleBox, Element=function(...) return Library.Element(function(v) Items[#Items+1] = v end, TabName, Sector, ...) end}
	end,
	['Element'] = function(AddItems, TabName, Sector, Type, ElementName, Default, Callback)
		local SectorName = Sector.Name
		Values[TabName][SectorName][ElementName] = {}

		AddItems(Library[Type]({TabName, SectorName, ElementName}, Sector, ElementName, Default, Callback))

		return
	end,
	['Button'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = {
			SetValue = emptyfunction,
			Callback = emptyfunction,
		}
		local TitleBox = Instance.new("TextLabel", Sector)
		TitleBox.Name = "Button"
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(1,0,0,11)
		TitleBox.Position = UDim2.new(0,4,0,0)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(0.8,0.8,0.8)
		TitleBox.Text = " "..ElementName
		TitleBox.TextTransparency = 1
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 16
		TitleBox.ZIndex = 7
		TitleBox.TextXAlignment = Enum.TextXAlignment.Left
		TitleBox.TextYAlignment = Enum.TextYAlignment.Top
		TitleBox.AutomaticSize = Enum.AutomaticSize.X
		local CornersLUL = Instance.new("UICorner", TitleBox)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local Button = Instance.new("TextLabel", TitleBox)
		Button.Name = "Button"
		Button.Text = ElementName
		Button.TextColor3 = Color3.new(0.8,0.8,0.8)
		Button.Font = Enum.Font.SourceSansLight
		Button.TextSize = 16
		Button.BorderSizePixel = 0
		Button.Size = UDim2.new(1,-10,0,11)
		Button.Position = UDim2.new(0,5,0,0)
		Button.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		Button.ZIndex = 8
		CornersLUL = Instance.new("UICorner", Button)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local UIStroke = Instance.new("UIStroke", Button)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Button.InputBegan:Connect(function(i)return Library['Button Function'](i, Callback)end)
	end,
	['TextBox'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = {
			Text = Defaults and Defaults.Text or "",
			Callback = Callback,
		}
		local TitleBox = Instance.new("TextLabel", Sector)
		TitleBox.Name = "TextBox"
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(1,-10,0,14)
		TitleBox.Position = UDim2.new(0,4,0,0)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(0.8,0.8,0.8)
		TitleBox.Text = " "..ElementName
		TitleBox.TextTransparency = 1
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 16
		TitleBox.ZIndex = 7
		TitleBox.TextXAlignment = Enum.TextXAlignment.Left
		TitleBox.TextYAlignment = Enum.TextYAlignment.Top
		TitleBox.AutomaticSize = Enum.AutomaticSize.None
		local ValueBox = Instance.new("TextBox", TitleBox)
		ValueBox.Name = "TextBoxFr"
		ValueBox.BorderSizePixel = 0
		ValueBox.Size = UDim2.new(1,0,0,11)
		ValueBox.Position = UDim2.new(0,5,0,3)
		ValueBox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		ValueBox.ZIndex = 8
		ValueBox.BackgroundTransparency = 0
		ValueBox.TextColor3 = Color3.new(1,1,1)
		ValueBox.Text = Defaults and Defaults.Text or ""
		ValueBox.TextTransparency = 0
		ValueBox.Font = Enum.Font.SourceSansLight
		ValueBox.TextSize = 16
		ValueBox.ZIndex = 7
		ValueBox.PlaceholderText = ""
		ValueBox.PlaceholderColor3 = Color3.new(0.784314, 0.784314, 0.784314)
		ValueBox.TextYAlignment = Enum.TextYAlignment.Center
		ValueBox.AutomaticSize = Enum.AutomaticSize.None
		local CornersLUL = Instance.new("UICorner", ValueBox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local KUIStroke = Instance.new("UIStroke", ValueBox)
		KUIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		KUIStroke.Thickness = 2
		KUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local ClonedSetValue
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue = function(Value)
			Value.Callback = Callback; Value.SetValue = ClonedSetValue
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = Value
			ValueBox.Text = Value.Text
			if not Callback then return end
			Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end
		ClonedSetValue = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue
		ValueBox.Focused:Connect(function()
			ValueBox.PlaceholderText = tostring(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Text)
		end)
		ValueBox.FocusLost:Connect(function()
			ValueBox.PlaceholderText = ""
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Text = tostring(ValueBox.Text)
			if not Callback then return end
			Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end)
	end,
	['Slider'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = {
			Slider = Defaults.Default,
			Callback = Callback or function() end,
		}
		local TitleBox = Instance.new("TextLabel", Sector)
		TitleBox.Name = "Slider"
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(1,-8,0,27)
		TitleBox.Position = UDim2.new(0,4,0,0)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(0.8,0.8,0.8)
		TitleBox.Text = " "..ElementName
		TitleBox.TextTransparency = 0
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 16
		TitleBox.ZIndex = 7
		TitleBox.TextXAlignment = Enum.TextXAlignment.Left
		TitleBox.TextYAlignment = Enum.TextYAlignment.Top
		local ValueBox = Instance.new("TextBox", TitleBox)
		ValueBox.Name = "ValueBox"
		ValueBox.BorderSizePixel = 0
		ValueBox.Size = UDim2.new(0,50,0,11)
		ValueBox.Position = UDim2.new(1,-54,0,3)
		ValueBox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		ValueBox.ZIndex = 8
		ValueBox.BackgroundTransparency = 0
		ValueBox.TextColor3 = Color3.new(1,1,1)
		ValueBox.Text = tostring(Defaults.Default)
		ValueBox.TextTransparency = 0
		ValueBox.Font = Enum.Font.SourceSansLight
		ValueBox.TextSize = 16
		ValueBox.ZIndex = 7
		ValueBox.PlaceholderText = ""
		ValueBox.PlaceholderColor3 = Color3.new(0.784314, 0.784314, 0.784314)
		ValueBox.TextYAlignment = Enum.TextYAlignment.Center
		ValueBox.AutomaticSize = Enum.AutomaticSize.X
		local CornersLUL = Instance.new("UICorner", ValueBox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local KUIStroke = Instance.new("UIStroke", ValueBox)
		KUIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		KUIStroke.Thickness = 2
		KUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		TitleBox.AutomaticSize = Enum.AutomaticSize.X
		CornersLUL = Instance.new("UICorner", TitleBox)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local SliderBox = Instance.new("Frame", TitleBox)
		SliderBox.Name = "SliderBox"
		SliderBox.BorderSizePixel = 0
		SliderBox.Size = UDim2.new(1,-10,0,4)
		SliderBox.Position = UDim2.new(0,5,0,20)
		SliderBox.BackgroundColor3 = Color3.new(0.47058823529411764, 0.7215686274509804, 0.06274509803921569)
		SliderBox.ZIndex = 9
		CornersLUL = Instance.new("UICorner", SliderBox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local UIStroke = Instance.new("UIStroke", SliderBox)
		UIStroke.Color = Color3.new(0.17058823529411764, 0.3215686274509804, 0)
		UIStroke.Thickness = 2
		local SliderBg = Instance.new("Frame", TitleBox)
		SliderBg.Name = "SliderBg"
		SliderBg.BorderSizePixel = 0
		SliderBg.Size = UDim2.new(1,-10,0,4)
		SliderBg.Position = UDim2.new(0,5,0,20)
		SliderBg.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		SliderBg.ZIndex = 8
		CornersLUL = Instance.new("UICorner", SliderBg)
		CornersLUL.CornerRadius = UDim.new(0,3)
		UIStroke = Instance.new("UIStroke", SliderBg)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		local AbsSizeXMax = 217
		local Value = AbsSizeXMax*(Defaults.Default/Defaults.Max)
		Tween(SliderBox, TweenInfo.new(0.01*Smoothing), {Size = UDim2.new(0, Value, 0, SliderBox.AbsoluteSize.Y)})
		local ClonedSetValue
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue = function(Value)
			Value.Callback = Callback or function() end; Value.SetValue = ClonedSetValue
			ValueBox.Text = tostring(Value.Slider)
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = Value
			local Value = AbsSizeXMax*(Value.Slider/Defaults.Max)
			Tween(SliderBox, TweenInfo.new(0.01*Smoothing), {Size = UDim2.new(0, Value, 0, SliderBox.AbsoluteSize.Y)})
			if not Callback then return end
			Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end
		ClonedSetValue = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue
		local dragInput 
		local function update(input) 
			local delta = math.clamp(input.Position.X - SliderBg.AbsolutePosition.X,0,SliderBg.AbsoluteSize.X)
			local Value = math.floor((Defaults.Max/(SliderBg.AbsoluteSize.X/SliderBox.AbsoluteSize.X))*10)/10
			ValueBox.Text = tostring(Value)
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Slider = Value
			Tween(SliderBox, TweenInfo.new(0.01*Smoothing), {Size = UDim2.new(0, delta, 0, SliderBg.AbsoluteSize.Y)})
			if not Callback then return end
			Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end 
		SliderBg.InputBegan:Connect(function(input) 
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
				return
			end
			UsingSlidas = true
			SliderBg.Draggable = true 

			input.Changed:Connect(function() 
				if input.UserInputState == Enum.UserInputState.End then 
					SliderBg.Draggable = false 
				end 
			end) 
		end) 
		SliderBg.InputChanged:Connect(function(input) 
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
				dragInput = input 
			end 
		end) 
		UserInputService.InputChanged:Connect(function(input) 
			spawn(function()
				task.wait(UIClickDebounce)
				if Mouse1Down or GlobalDisableMouseClickConnections then return end
				UsingSlidas = false
			end)
			if input ~= dragInput or not SliderBg.Draggable then 
				return
			end 
			update(input) 
		end) 
		ValueBox.Focused:Connect(function()
			ValueBox.PlaceholderText = tostring(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Slider)
		end)
		ValueBox.FocusLost:Connect(function()
			ValueBox.PlaceholderText = ""
			if not tonumber(ValueBox.Text) then 
				ValueBox.Text = tostring(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Slider)
				if not Callback then return end
				return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
			end
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Slider = math.clamp(tonumber(ValueBox.Text),Defaults.Min,Defaults.Max)
			ValueBox.Text = tostring(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Slider)
			local Value = SliderBg.AbsoluteSize.X*(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Slider/Defaults.Max)
			Tween(SliderBox, TweenInfo.new(0.01*Smoothing), {Size = UDim2.new(0, Value, 0, SliderBox.AbsoluteSize.Y)})
			if not Callback then return end
			return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end)


		return TitleBox
	end,
	['Toggle'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = {
			Toggle = false,
			Active = true,
			Callback = Callback,
			ToggleKey = nil,
			ActuationType = nil,
		}
		local TitleBox = Instance.new("TextLabel", Sector)
		TitleBox.Name = "Toggle"
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(1,-8,0,17)
		TitleBox.Position = UDim2.new(0,4,0,0)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(0.8,0.8,0.8)
		TitleBox.Text = " "..ElementName
		TitleBox.TextTransparency = 0
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextScaled = true
		TitleBox.ZIndex = 7
		TitleBox.TextXAlignment = Enum.TextXAlignment.Left
		TitleBox.TextYAlignment = Enum.TextYAlignment.Top
		TitleBox.AutomaticSize = Enum.AutomaticSize.X
		local CornersLUL = Instance.new("UICorner", TitleBox)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local ToggleBox = Instance.new("Frame", TitleBox)
		ToggleBox.Name = "ToggleBox"
		ToggleBox.BorderSizePixel = 0
		ToggleBox.Size = UDim2.new(0,11,0,11)
		ToggleBox.Position = UDim2.new(1,-14,0,3)
		ToggleBox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		ToggleBox.ZIndex = 8
		CornersLUL = Instance.new("UICorner", ToggleBox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local UIStroke = Instance.new("UIStroke", ToggleBox)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		local DisableToggling = false
		TitleBox.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch or DisableToggling then 
				return
			end
			task.wait(UIClickDebounce)
			if Mouse1Down or GlobalDisableMouseClickConnections or DisableToggling then return end
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Toggle = not Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Toggle
			ToggleBox.BackgroundColor3 = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Toggle and Color3.new(0.47058823529411764, 0.7215686274509804, 0.06274509803921569) or Color3.new(0.165882, 0.16882, 0.165882)
			UIStroke.Color = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Toggle and Color3.new(0.17058823529411764, 0.3215686274509804, 0) or Color3.new(0.135882, 0.13882, 0.135882)
			if not Callback then return end
			return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end)
		local KeybindBox = nil
		local Connection1, Connection2, Connection3
		local ClonedSetValue
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue = function(Value)
			Value.Callback = Callback; Value.SetValue = ClonedSetValue
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = Value
			ToggleBox.BackgroundColor3 = Value.Toggle and Color3.new(0.47058823529411764, 0.7215686274509804, 0.06274509803921569) or Color3.new(0.165882, 0.16882, 0.165882)
			UIStroke.Color = Value.Toggle and Color3.new(0.17058823529411764, 0.3215686274509804, 0) or Color3.new(0.135882, 0.13882, 0.135882)
			if KeybindBox then
				KeybindBox.Text = typeof(Value.ToggleKey) == "EnumItem" and tostring(Value.ToggleKey):gsub("Enum.KeyCode.", "") or "None"
			end
			if not Callback then return end
			return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end
		ClonedSetValue = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue
		if Defaults and Defaults["Keybind"] then
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Active = false
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ActuationType = "Toggle"
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ToggleKey = typeof(Defaults["Keybind"]) == "EnumItem" and Defaults["Keybind"] or Enum.KeyCode.World10
			KeybindBox = Instance.new("TextLabel", TitleBox)
			KeybindBox.Name = "KeybindBox"
			KeybindBox.BorderSizePixel = 0
			KeybindBox.Size = UDim2.new(0,50,0,11)
			KeybindBox.Position = UDim2.new(1,-70,0,3)
			KeybindBox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
			KeybindBox.ZIndex = 8
			KeybindBox.BackgroundTransparency = 0
			KeybindBox.TextColor3 = Color3.new(1,1,1)
			KeybindBox.Text = typeof(Defaults["Keybind"]) == "EnumItem" and tostring(Defaults["Keybind"]):gsub("Enum.KeyCode.", ""):gsub("World10", "None") or "None"
			KeybindBox.TextTransparency = 0
			KeybindBox.Font = Enum.Font.SourceSansLight
			KeybindBox.TextScaled = true
			KeybindBox.ZIndex = 7
			KeybindBox.TextYAlignment = Enum.TextYAlignment.Center
			KeybindBox.AutomaticSize = Enum.AutomaticSize.X
			CornersLUL = Instance.new("UICorner", KeybindBox)
			CornersLUL.CornerRadius = UDim.new(0,3)
			local KUIStroke = Instance.new("UIStroke", KeybindBox)
			KUIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
			KUIStroke.Thickness = 2
			KUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			local Connection
			Connection1, Connection2, Connection3 = nil,nil,nil
			Connection1 = UserInputService.InputBegan:Connect(function(i)
				if i.KeyCode ~= Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ToggleKey then
					return
				end
				local Not = not Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Active
				Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Active = Not
				if not Callback then return end
				return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
			end)
			Connection3 = UserInputService.InputEnded:Connect(function(i)
				if Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ActuationType ~= "Hold" or i.KeyCode ~= Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ToggleKey then
					return
				end
				Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Active = false
				if not Callback then return end
				return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
			end)
			KeybindBox.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
					if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
					DisableToggling = true
					task.wait(UIClickDebounce)
					DisableToggling = false
					if Mouse2Down then return end
					DisableToggling = true
					local KAGui = Gui.KeybindActuationTypeBox
					KAGui.Position = UDim2.new(0,Mouse.X-10,0,Mouse.Y)
					local ToggleConnection
					ToggleConnection = KAGui.Toggle.InputBegan:Connect(function(input)
						if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
							return
						end
						ToggleConnection:Disconnect()
						Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ActuationType = "Toggle"
						KAGui.Position = UDim2.new(10,0,10,0)
						DisableToggling = false
						return
					end)
					local HoldConnection
					HoldConnection = KAGui.Hold.InputBegan:Connect(function(input)
						if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
							return
						end
						HoldConnection:Disconnect()
						Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ActuationType = "Hold"
						KAGui.Position = UDim2.new(10,0,10,0)
						DisableToggling = false
						return
					end)
					DisableToggling = false
					return
				end
				if Mouse2Down then
					task.wait(UIClickDebounce)
					if Mouse2Down then return end
					local KAGui = Gui.KeybindActuationTypeBox
					KAGui.Position = UDim2.new(0,Mouse.X-10,0,Mouse.Y)
				end
				task.wait(UIClickDebounce)
				if Mouse1Down or GlobalDisableMouseClickConnections or Connection then return end
				Connection = UserInputService.InputBegan:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Unknown then
						return
					end
					Connection:Disconnect()
					Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].ToggleKey = input.KeyCode
					KeybindBox.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.","")
					DisableToggling = false
					return
				end)
			end)
		end

		return TitleBox
	end,
	['Graph'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)

	end,
	['Dropdown'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = {
			Dropdown = Defaults.Options[1],
			Callback = Callback,
		}
		local TitleBox = Instance.new("TextLabel", Sector)
		TitleBox.Name = "Dropdown"
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(1,-8,0,33)
		TitleBox.Position = UDim2.new(0,4,0,0)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(0.8,0.8,0.8)
		TitleBox.Text = " "..ElementName
		TitleBox.TextTransparency = 0
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 16
		TitleBox.ZIndex = 14
		TitleBox.TextXAlignment = Enum.TextXAlignment.Left
		TitleBox.TextYAlignment = Enum.TextYAlignment.Top
		TitleBox.AutomaticSize = Enum.AutomaticSize.XY
		local CornersLUL = Instance.new("UICorner", TitleBox)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local Dropdown = Instance.new("TextLabel", TitleBox)
		Dropdown.Name = "Dropdown"
		Dropdown.Text = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Dropdown
		Dropdown.TextColor3 = Color3.new(0.8,0.8,0.8)
		Dropdown.Font = Enum.Font.SourceSansLight
		Dropdown.TextSize = 16
		Dropdown.BorderSizePixel = 0
		Dropdown.Size = UDim2.new(1,-10,0,11)
		Dropdown.Position = UDim2.new(0,5,0,20)
		Dropdown.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		Dropdown.ZIndex = 13
		CornersLUL = Instance.new("UICorner", Dropdown)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local UIStroke = Instance.new("UIStroke", Dropdown)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local Triangle = Instance.new("ImageLabel", Dropdown)
		Triangle.Name = "Triangle"
		Triangle.Image = "rbxassetid://304846479"
		Triangle.Rotation = 180
		Triangle.BorderSizePixel = 0
		Triangle.BackgroundTransparency = 1
		Triangle.Size = UDim2.new(0,7,0,7)
		Triangle.Position = UDim2.new(1,-11,0,4)
		Triangle.ZIndex = 99999999

		local DropBox = Instance.new("ScrollingFrame", Dropdown)
		DropBox.Name = "KeybindActuationTypeBox"
		DropBox.Visible = false
		DropBox.BorderSizePixel = 0
		DropBox.Size = UDim2.new(1,0,0,60)
		DropBox.Position = UDim2.new(0,0,1,0)
		DropBox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		DropBox.ZIndex = 11
		DropBox.BackgroundTransparency = 0
		DropBox.ScrollingDirection = Enum.ScrollingDirection.Y
		DropBox.CanvasSize = UDim2.new(0,0,0,0)
		DropBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
		DropBox.ScrollBarThickness = 4
		local UIListLayout = Instance.new("UIListLayout", DropBox)
		UIListLayout.Padding = UDim.new(0,2)
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		CornersLUL = Instance.new("UICorner", DropBox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		UIStroke = Instance.new("UIStroke", DropBox)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local ClonedSetValue
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue = function(Value)
			Value.Callback = Callback; Value.SetValue = ClonedSetValue
			for i, v in pairs (DropBox:GetChildren()) do
				if v:IsA("TextLabel") then
					v.TextColor3 = Color3.new(0.8,0.8,0.8)
				end
			end
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = Value
			DropBox[Value.Dropdown].TextColor3 = Color3.new(0.4,0.85,0.4)
			Dropdown.Text = Value.Dropdown
			if not Callback then return end
			return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end
		ClonedSetValue = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue
		for i, v in pairs (Defaults.Options) do
			local Option = Instance.new("TextLabel", DropBox)
			Option.Name = v
			Option.Size = UDim2.new(1,0,0,20)
			Option.BackgroundTransparency = 1
			Option.TextColor3 = i == 1 and Color3.new(0.4,0.85,0.4) or Color3.new(0.8,0.8,0.8)
			Option.Text = v
			Option.TextTransparency = 0
			Option.Font = Enum.Font.SourceSansLight
			Option.TextSize = 16
			Option.ZIndex = 9999999
			Option.TextXAlignment = Enum.TextXAlignment.Left
			Option.TextYAlignment = Enum.TextYAlignment.Center
			Option.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
					return
				end
				task.wait(UIClickDebounce)
				if Mouse1Down then 
					return
				end
				for i1, v1 in pairs (DropBox:GetChildren()) do
					if v1:IsA("TextLabel") then
						v1.TextColor3 = Color3.new(0.8,0.8,0.8)
					end
				end
				Option.TextColor3 = Color3.new(0.4,0.85,0.4)
				Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Dropdown = v
				Dropdown.Text = v
				spawn(function()
					Tween(DropBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,0)})
					task.wait(0.4)
					DropBox.Visible = false
					GlobalDisableMouseClickConnections = false
				end)
				if not Callback then return end
				return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
			end)
		end
		local AbsoluteSize = DropBox.AbsoluteSize.Y
		DropBox.AutomaticSize = Enum.AutomaticSize.None

		Dropdown.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
				return
			end
			GlobalDisableMouseClickConnections = true
			task.wait(UIClickDebounce)
			GlobalDisableMouseClickConnections = false
			if Mouse1Down then 
				return
			end
			DropBox.Visible = not DropBox.Visible
			GlobalDisableMouseClickConnections = DropBox.Visible
			DropBox.Size = UDim2.new(1,0,0,0)
			Tween(DropBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,AbsoluteSize)})
			for i, v in pairs (DropBox:GetChildren()) do
				if v.ClassName ~= "TextLabel" then continue end
				v.Size = UDim2.new(1,0,0,0)v.TextTransparency = 1;v.TextSize = 0
				Tween(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, TextSize = 16, Size = UDim2.new(1,0,0,20)})
			end
		end)
		Dropdown.MouseEnter:Connect(function()
			if NOTON then
				NOTON:Disconnect()
			end
		end)
		Dropdown.MouseLeave:Connect(function()
			NOTON = UserInputService.InputBegan:Connect(function(i)
				if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then 
					return
				end
				if (Vector2.new(Mouse.X, Mouse.Y)-Vector2.new(Dropdown.AbsolutePosition.X,Dropdown.AbsolutePosition.Y)).Magnitude < Dropdown.AbsoluteSize.Magnitude*1.5 then return end
				Tween(DropBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,0)})
				task.wait(0.4)
				DropBox.Visible = false
				GlobalDisableMouseClickConnections = false
				NOTON:Disconnect()
			end)
		end)
	end,
	['Jumbobox'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = {
			Jumbobox = {},
			Callback = Callback,
		}
		local TitleBox = Instance.new("TextLabel", Sector)
		TitleBox.Name = "Jumbobox"
		TitleBox.BorderSizePixel = 0
		TitleBox.Size = UDim2.new(1,-8,0,33)
		TitleBox.Position = UDim2.new(0,4,0,0)
		TitleBox.BackgroundTransparency = 1
		TitleBox.TextColor3 = Color3.new(0.8,0.8,0.8)
		TitleBox.Text = " "..ElementName
		TitleBox.TextTransparency = 0
		TitleBox.Font = Enum.Font.SourceSansLight
		TitleBox.TextSize = 16
		TitleBox.ZIndex = 14
		TitleBox.TextXAlignment = Enum.TextXAlignment.Left
		TitleBox.TextYAlignment = Enum.TextYAlignment.Top
		TitleBox.AutomaticSize = Enum.AutomaticSize.XY
		local CornersLUL = Instance.new("UICorner", TitleBox)
		CornersLUL.CornerRadius = UDim.new(0,5)
		local Jumbobox = Instance.new("TextLabel", TitleBox)
		Jumbobox.Name = "Jumbobox"
		Jumbobox.Text = "None"
		Jumbobox.TextColor3 = Color3.new(0.8,0.8,0.8)
		Jumbobox.Font = Enum.Font.SourceSansLight
		Jumbobox.TextSize = 16
		Jumbobox.BorderSizePixel = 0
		Jumbobox.Size = UDim2.new(1,-10,0,11)
		Jumbobox.Position = UDim2.new(0,5,0,20)
		Jumbobox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		Jumbobox.ZIndex = 13
		CornersLUL = Instance.new("UICorner", Jumbobox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		local UIStroke = Instance.new("UIStroke", Jumbobox)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local Triangle = Instance.new("ImageLabel", Jumbobox)
		Triangle.Name = "Triangle"
		Triangle.Image = "rbxassetid://304846479"
		Triangle.Rotation = 180
		Triangle.BorderSizePixel = 0
		Triangle.BackgroundTransparency = 1
		Triangle.Size = UDim2.new(0,7,0,7)
		Triangle.Position = UDim2.new(1,-11,0,4)
		Triangle.ZIndex = 99999999

		local DropBox = Instance.new("ScrollingFrame", Jumbobox)
		DropBox.Name = "KeybindActuationTypeBox"
		DropBox.Visible = false
		DropBox.BorderSizePixel = 0
		DropBox.Size = UDim2.new(1,0,0,60)
		DropBox.Position = UDim2.new(0,0,1,0)
		DropBox.BackgroundColor3 = Color3.new(0.165882, 0.16882, 0.165882)
		DropBox.ZIndex = 11
		DropBox.BackgroundTransparency = 0
		DropBox.ScrollingDirection = Enum.ScrollingDirection.Y
		DropBox.CanvasSize = UDim2.new(0,0,0,0)
		DropBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
		DropBox.ScrollBarThickness = 4
		local UIListLayout = Instance.new("UIListLayout", DropBox)
		UIListLayout.Padding = UDim.new(0,2)
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		CornersLUL = Instance.new("UICorner", DropBox)
		CornersLUL.CornerRadius = UDim.new(0,3)
		UIStroke = Instance.new("UIStroke", DropBox)
		UIStroke.Color = Color3.new(0.135882, 0.13882, 0.135882)
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local ClonedSetValue
		Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue = function(Value)
			Value.Callback = Callback; Value.SetValue = ClonedSetValue
			for i, v in pairs (DropBox:GetChildren()) do
				if v:IsA("TextLabel") then
					v.TextColor3 = table.find(Value.Jumbobox, v.Name) and Color3.new(0.4,0.85,0.4) or Color3.new(0.8,0.8,0.8)
				end
			end
			Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]] = Value
			local Txt = ""
			for i, v in pairs (Value.Jumbobox) do
				Txt = Txt..v..(i~=#Value.Jumbobox and ", " or "")
			end
			Jumbobox.Text = Txt
			if not Callback then return end
			return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
		end
		ClonedSetValue = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].SetValue
		for i, v in pairs (Defaults.Options) do
			local Option = Instance.new("TextLabel", DropBox)
			Option.Name = v
			Option.Size = UDim2.new(1,0,0,20)
			Option.BackgroundTransparency = 1
			Option.TextColor3 = Color3.new(0.8,0.8,0.8)
			Option.Text = v
			Option.TextTransparency = 0
			Option.Font = Enum.Font.SourceSansLight
			Option.TextSize = 16
			Option.ZIndex = 9999999
			Option.TextXAlignment = Enum.TextXAlignment.Left
			Option.TextYAlignment = Enum.TextYAlignment.Center
			Option.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
					return
				end
				task.wait(UIClickDebounce)
				if Mouse1Down then 
					return
				end
				local Jn = Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]].Jumbobox
				if math.floor(Option.TextColor3.R*10) == 4 then
					for i1, v1 in pairs (Jn) do
						if v1 == v then
							table.remove(Jn, i1)
						end
					end
					Option.TextColor3 = Color3.new(0.8,0.8,0.8)
				else
					Jn[#Jn+1] = v
					Option.TextColor3 = Color3.new(0.4,0.85,0.4)
				end
				local Txt = ""
				for i, v in pairs (Jn) do
					Txt = Txt..v..(i~=#Jn and ", " or "")
				end
				Jumbobox.Text = Txt
				DropBox.Visible = false
				spawn(function()
					Tween(DropBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,0)})
					task.wait(0.4)
					DropBox.Visible = false
					GlobalDisableMouseClickConnections = false
				end)
				if not Callback then return end
				return Callback(Values[ValueTableF[1]][ValueTableF[2]][ValueTableF[3]])
			end)
		end
		local AbsoluteSize = DropBox.AbsoluteSize.Y
		DropBox.AutomaticSize = Enum.AutomaticSize.None

		Jumbobox.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then 
				return
			end
			GlobalDisableMouseClickConnections = true
			task.wait(UIClickDebounce)
			GlobalDisableMouseClickConnections = false
			if Mouse1Down then 
				return
			end
			DropBox.Visible = not DropBox.Visible
			GlobalDisableMouseClickConnections = DropBox.Visible
			DropBox.Size = UDim2.new(1,0,0,0)
			Tween(DropBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,AbsoluteSize)})
			for i, v in pairs (DropBox:GetChildren()) do
				if v.ClassName ~= "TextLabel" then continue end
				v.Size = UDim2.new(1,0,0,0)v.TextTransparency = 1;v.TextSize = 0
				Tween(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, TextSize = 16, Size = UDim2.new(1,0,0,20)})
			end
		end)
		Jumbobox.MouseEnter:Connect(function()
			if NOTON then
				NOTON:Disconnect()
			end
		end)
		Jumbobox.MouseLeave:Connect(function()
			NOTON = UserInputService.InputBegan:Connect(function(i)
				if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then 
					return
				end
				Tween(DropBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,0)})
				task.wait(0.4)
				DropBox.Visible = false
				GlobalDisableMouseClickConnections = false
				NOTON:Disconnect()
			end)
		end)
	end,
	['MultiSector'] = function(ValueTableF, Sector, ElementName, Defaults, Callback)

	end,
}

return Library
