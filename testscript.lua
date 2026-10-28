-- ==========================================
-- SHENRU | DODGE OR DIE (ULTRA SAFE)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

local Settings = {
	AutoDodge = false,
	DodgeRange = 20,
	DodgeCooldown = 0.16,
	BallESP = false,
	ESPColor = Color3.fromRGB(255, 50, 50),
	TripleJump = false,
	UIAccent = Color3.fromRGB(0, 140, 255)
}

local MovementGrace = nil
local lastDodge = 0
local BallHighlights = {}
local jumpCount = 0
local canExtraJump = false

-- Clean old UI
pcall(function()
	local old = CoreGui:FindFirstChild("ShenruDodgeUI")
	if old then old:Destroy() end
end)

-- ==========================================
-- CREATE UI FIRST (so you always see something)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShenruDodgeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999
ScreenGui.Parent = CoreGui

-- Icon
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenUI"
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0.5, -27.5, 0, 50)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "SX"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 20
OpenBtn.AutoButtonColor = false
OpenBtn.TextStrokeTransparency = 1

Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2.8
stroke.Parent = OpenBtn

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 340)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 50)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local UIScale = Instance.new("UIScale")
UIScale.Scale = 1
UIScale.Parent = MainFrame

-- Title
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 55)
TitleBar.BackgroundTransparency = 1

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -60, 0, 24)
TitleText.Position = UDim2.new(0, 16, 0, 8)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.RichText = true
TitleText.Text = '<font color="rgb(0, 160, 255)">SHENRU</font> <font color="rgb(255, 255, 255)">| DODGE OR DIE</font>'

local DescText = Instance.new("TextLabel")
DescText.Parent = TitleBar
DescText.Size = UDim2.new(1, -60, 0, 14)
DescText.Position = UDim2.new(0, 16, 0, 30)
DescText.BackgroundTransparency = 1
DescText.Font = Enum.Font.GothamMedium
DescText.TextSize = 11
DescText.TextColor3 = Color3.fromRGB(140, 140, 150)
DescText.TextXAlignment = Enum.TextXAlignment.Left
DescText.Text = "DEVELOPED By Shenru"

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 88, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local function CreateTabButton(name, y)
	local btn = Instance.new("TextButton")
	btn.Parent = Sidebar
	btn.Size = UDim2.new(1, -16, 0, 34)
	btn.Position = UDim2.new(0, 8, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(150, 150, 160)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	return btn
end

local MainBtn = CreateTabButton("MAIN", 12)
local VisualBtn = CreateTabButton("VISUAL", 54)
local SettingsBtn = CreateTabButton("SETTINGS", 96)

local Content = Instance.new("Frame")
Content.Parent = MainFrame
Content.Size = UDim2.new(1, -98, 1, -65)
Content.Position = UDim2.new(0, 94, 0, 60)
Content.BackgroundTransparency = 1

local function makePage()
	local page = Instance.new("ScrollingFrame")
	page.Parent = Content
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 2
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
	return page
end

local MainPage = makePage()
MainPage.Visible = true
local VisualPage = makePage()
local SettingsPage = makePage()

local function SwitchTab(btn, page)
	for _, b in ipairs({MainBtn, VisualBtn, SettingsBtn}) do
		if b == btn then
			TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Settings.UIAccent, TextColor3 = Color3.new(1,1,1)}):Play()
		else
			TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28,28,34), TextColor3 = Color3.fromRGB(150,150,160)}):Play()
		end
	end
	MainPage.Visible = page == MainPage
	VisualPage.Visible = page == VisualPage
	SettingsPage.Visible = page == SettingsPage
end

MainBtn.MouseButton1Click:Connect(function() SwitchTab(MainBtn, MainPage) end)
VisualBtn.MouseButton1Click:Connect(function() SwitchTab(VisualBtn, VisualPage) end)
SettingsBtn.MouseButton1Click:Connect(function() SwitchTab(SettingsBtn, SettingsPage) end)

MainBtn.BackgroundColor3 = Settings.UIAccent
MainBtn.TextColor3 = Color3.new(1,1,1)

-- Toggle helper
local function CreateToggle(parent, text, default, cb)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -8, 0, 36)
	frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	frame.Parent = parent
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 42, 0, 22)
	btn.Position = UDim2.new(1, -52, 0.5, -11)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 18, 0, 18)
	circle.Position = UDim2.new(0, 2, 0.5, -9)
	circle.BackgroundColor3 = Color3.fromRGB(200,200,210)
	circle.Parent = btn
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local on = default
	if on then
		btn.BackgroundColor3 = Color3.fromRGB(0,200,100)
		circle.Position = UDim2.new(1, -20, 0.5, -9)
	end

	btn.MouseButton1Click:Connect(function()
		on = not on
		if on then
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0,200,100)}):Play()
			TweenService:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
		else
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45,45,55)}):Play()
			TweenService:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
		end
		cb(on)
	end)
end

-- Slider helper
local function CreateSlider(parent, text, min, max, default, cb)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -8, 0, 50)
	frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	frame.Parent = parent
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 18)
	label.Position = UDim2.new(0, 12, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = text .. ": " .. default
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -24, 0, 5)
	bar.Position = UDim2.new(0, 12, 0, 32)
	bar.BackgroundColor3 = Color3.fromRGB(40,40,50)
	bar.Parent = frame
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
	fill.BackgroundColor3 = Settings.UIAccent
	fill.Parent = bar
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.Parent = bar
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local drag = false
	local function upd(inp)
		local x = math.clamp(inp.Position.X - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
		local a = x / bar.AbsoluteSize.X
		local v = math.floor(min + (max-min)*a)
		fill.Size = UDim2.new(a, 0, 1, 0)
		knob.Position = UDim2.new(a, -7, 0.5, -7)
		label.Text = text .. ": " .. v
		cb(v)
	end

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			upd(i)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			upd(i)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = false
		end
	end)
end

-- Features
CreateToggle(MainPage, "Auto-Dodge", false, function(v) Settings.AutoDodge = v end)
CreateToggle(MainPage, "Triple Jump", false, function(v) Settings.TripleJump = v end)
CreateSlider(MainPage, "Dodge Range", 8, 45, 20, function(v) Settings.DodgeRange = v end)
CreateSlider(MainPage, "Dodge Cooldown", 0.08, 1.2, 0.16, function(v) Settings.DodgeCooldown = v end)

CreateToggle(VisualPage, "Ball ESP", false, function(v) Settings.BallESP = v end)

CreateSlider(SettingsPage, "UI Size", 50, 140, 100, function(v) UIScale.Scale = v/100 end)
CreateSlider(SettingsPage, "Icon Size", 40, 80, 55, function(v)
	OpenBtn.Size = UDim2.new(0, v, 0, v)
	OpenBtn.Position = UDim2.new(OpenBtn.Position.X.Scale, -v/2, OpenBtn.Position.Y.Scale, OpenBtn.Position.Y.Offset)
end)

-- Open / Close
local open = false
local function Toggle()
	open = not open
	if open then
		MainFrame.Visible = true
		OpenBtn.Visible = false
		TweenService:Create(UIScale, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Scale = 1}):Play()
	else
		local t = TweenService:Create(UIScale, TweenInfo.new(0.2), {Scale = 0})
		t:Play()
		t.Completed:Connect(function()
			MainFrame.Visible = false
			OpenBtn.Visible = true
		end)
	end
end
OpenBtn.MouseButton1Click:Connect(Toggle)
CloseBtn.MouseButton1Click:Connect(Toggle)

-- Drag
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = MainFrame.Position
	end
end)
TitleBar.InputChanged:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
		dragInput = i
	end
end)

local bDragging, bDragInput, bDragStart, bStartPos
OpenBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		bDragging = true
		bDragStart = i.Position
		bStartPos = OpenBtn.Position
	end
end)
OpenBtn.InputChanged:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
		bDragInput = i
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if i == dragInput and dragging then
		local d = i.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
	if i == bDragInput and bDragging then
		local d = i.Position - bDragStart
		OpenBtn.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + d.X, bStartPos.Y.Scale, bStartPos.Y.Offset + d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		bDragging = false
	end
end)

print("[SHENRU] UI Loaded")

-- ==========================================
-- LOAD REMOTE LATER (safe)
-- ==========================================
task.spawn(function()
	local ok, net = pcall(function()
		return require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("safe-net", 8))
	end)
	if ok and net then
		local ok2, rem = pcall(function()
			return net.get("MovementGrace")
		end)
		if ok2 then
			MovementGrace = rem
			print("[SHENRU] MovementGrace connected")
		end
	end
end)

-- ==========================================
-- DASH
-- ==========================================
local function doDash(dir)
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if MovementGrace then
		pcall(function()
			MovementGrace:FireServer("Dash" .. dir)
		end)
	end

	local power = 130
	local upg = LocalPlayer:FindFirstChild("Upgrades")
	if upg and upg:FindFirstChild("Dashes") then
		power = power + (tonumber(upg.Dashes.Value) or 0)
	end

	local vec = dir == "Left" and -hrp.CFrame.RightVector or hrp.CFrame.RightVector
	local vel = hrp.AssemblyLinearVelocity
	hrp.AssemblyLinearVelocity = Vector3.new(vec.X * power, vel.Y, vec.Z * power)
end

-- ==========================================
-- AUTO DODGE
-- ==========================================
local function getBalls()
	local t = {}
	local f = workspace:FindFirstChild("Balls")
	if f then
		for _, v in ipairs(f:GetDescendants()) do
			if v:IsA("BasePart") and v.AssemblyLinearVelocity.Magnitude > 12 then
				table.insert(t, v)
			end
		end
	end
	local lobby = workspace:FindFirstChild("Lobby")
	if lobby and lobby:FindFirstChild("PracticeArea") and lobby.PracticeArea:FindFirstChild("PracticeBalls") then
		for _, v in ipairs(lobby.PracticeArea.PracticeBalls:GetDescendants()) do
			if v:IsA("BasePart") and v.AssemblyLinearVelocity.Magnitude > 12 then
				table.insert(t, v)
			end
		end
	end
	return t
end

RunService.Heartbeat:Connect(function()
	if not Settings.AutoDodge then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum or hum.Health <= 0 then return end
	if CollectionService:HasTag(char, "Downed") then return end

	local now = os.clock()
	if now - lastDodge < Settings.DodgeCooldown then return end

	local balls = getBalls()
	if #balls == 0 then return end

	local pos = hrp.Position
	local vel = hrp.AssemblyLinearVelocity
	local right = hrp.CFrame.RightVector

	local best = -math.huge
	local bestDir = nil

	for _, ball in ipairs(balls) do
		local bpos = ball.Position
		local bvel = ball.AssemblyLinearVelocity
		if bvel.Magnitude < 15 then continue end

		local to = pos - bpos
		local dist = to.Magnitude
		if dist > Settings.DodgeRange then continue end

		local rel = bvel - vel
		local rs = rel:Dot(rel)
		if rs < 1 then continue end

		local t = to:Dot(rel) / rs
		if t < 0.03 or t > 0.42 then continue end

		local fball = bpos + bvel * t
		local fplay = pos + vel * t
		local impact = (fplay - fball).Magnitude
		if impact > 8 then continue end

		local score = (1/(impact+0.15)) * (bvel.Magnitude*0.12) * (1/(t+0.04))
		if score > best then
			best = score
			local localX = hrp.CFrame:PointToObjectSpace(fball).X
			if localX > 0.7 then
				bestDir = "Left"
			elseif localX < -0.7 then
				bestDir = "Right"
			else
				bestDir = right:Dot((fball - pos).Unit) > 0 and "Left" or "Right"
			end
		end
	end

	if bestDir then
		doDash(bestDir)
		lastDodge = now
	end
end)

-- ==========================================
-- TRIPLE JUMP
-- ==========================================
local function setupJump(char)
	jumpCount = 0
	canExtraJump = false
	local hum = char:WaitForChild("Humanoid", 5)
	if not hum then return end

	hum.StateChanged:Connect(function(_, new)
		if new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall then
			task.delay(0.15, function() canExtraJump = true end)
		elseif new == Enum.HumanoidStateType.Landed then
			jumpCount = 0
			canExtraJump = false
		end
	end)
end

if LocalPlayer.Character then setupJump(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupJump)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or not Settings.TripleJump then return end
	if input.KeyCode \~= Enum.KeyCode.Space and input.KeyCode \~= Enum.KeyCode.ButtonA then return end

	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	if CollectionService:HasTag(char, "Downed") then return end

	if hum:GetState() == Enum.HumanoidStateType.Freefall and canExtraJump and jumpCount < 2 then
		jumpCount = jumpCount + 1
		canExtraJump = false

		if MovementGrace then
			pcall(function() MovementGrace:FireServer("DoubleJump") end)
		end

		local power = 58
		local upg = LocalPlayer:FindFirstChild("Upgrades")
		if upg and upg:FindFirstChild("Jump") then
			power = power + (tonumber(upg.Jump.Value) or 0) / 3
		end

		local vel = hrp.AssemblyLinearVelocity
		hrp.AssemblyLinearVelocity = Vector3.new(vel.X, power, vel.Z)
	end
end)

-- ESP
task.spawn(function()
	while task.wait(0.12) do
		if Settings.BallESP then
			for _, ball in ipairs(getBalls()) do
				local h = BallHighlights[ball]
				if not h or not h.Parent then
					h = Instance.new("Highlight")
					h.FillColor = Settings.ESPColor
					h.OutlineColor = Color3.new(1,1,1)
					h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					h.Adornee = ball
					h.Parent = ball
					BallHighlights[ball] = h
				end
				h.FillColor = Settings.ESPColor
				h.Enabled = true
			end
		else
			for b, h in pairs(BallHighlights) do
				if h then h:Destroy() end
				BallHighlights[b] = nil
			end
		end
	end
end)

print("[SHENRU] Fully Loaded")
