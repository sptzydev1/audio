-- ======================================================
-- MINI DANCE SCANNER & LOGGER
-- COPYRIGHT (C) IkyyXD - ALL RIGHTS RESERVED
-- ======================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Hapus GUI lama jika ada
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("IkyyDanceToolMini")
if oldGui then oldGui:Destroy() end

--------------------------------------------------
-- STATE & MEMORY
--------------------------------------------------
local isLoggerEnabled = true
local isAutoSaveEnabled = true
local savedDances = {} -- Menampung {Name = ..., Id = ...}

--------------------------------------------------
-- 1. UTAMA: SCREEN GUI & FLOATING ICON
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyDanceToolMini"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Icon Kecil (💃)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 32, 0, 32)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -16)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "💃"
ToggleButton.TextSize = 14
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local UICornerIcon = Instance.new("UICorner")
UICornerIcon.CornerRadius = UDim.new(0, 6)
UICornerIcon.Parent = ToggleButton

local UIStrokeIcon = Instance.new("UIStroke")
UIStrokeIcon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeIcon.Thickness = 1.5
UIStrokeIcon.Parent = ToggleButton

-- Main Frame Mini (Lebar: 320px, Tinggi: 220px)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeMain.Thickness = 1.5
UIStrokeMain.Parent = MainFrame

-- Gradient Animated Sinar Putih
local UIGradientIcon = Instance.new("UIGradient")
UIGradientIcon.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
})
UIGradientIcon.Parent = UIStrokeIcon

local UIGradientMain = Instance.new("UIGradient")
UIGradientMain.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
})
UIGradientMain.Parent = UIStrokeMain

local rotationAngle = 0
RunService.RenderStepped:Connect(function(dt)
	rotationAngle = (rotationAngle + (dt * 120)) % 360
	UIGradientIcon.Rotation = rotationAngle
	UIGradientMain.Rotation = rotationAngle
end)

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------
-- 2. WATERMARK PALING BAWAH (@IkyyXD)
--------------------------------------------------
local BottomWatermark = Instance.new("TextLabel")
BottomWatermark.Size = UDim2.new(1, 0, 0, 16)
BottomWatermark.Position = UDim2.new(0, 0, 1, -16)
BottomWatermark.BackgroundTransparency = 1
BottomWatermark.Text = "@IkyyXD - Dance Logger"
BottomWatermark.TextColor3 = Color3.fromRGB(150, 150, 150)
BottomWatermark.TextSize = 10
BottomWatermark.Font = Enum.Font.SourceSansBold
BottomWatermark.Parent = MainFrame

--------------------------------------------------
-- 3. PAGE KIRI: TOGGLES FITUR
--------------------------------------------------
local PageKiri = Instance.new("Frame")
PageKiri.Name = "PageKiri"
PageKiri.Size = UDim2.new(0, 120, 1, -22)
PageKiri.Position = UDim2.new(0, 6, 0, 6)
PageKiri.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKiri.Parent = MainFrame

local UICornerKiri = Instance.new("UICorner")
UICornerKiri.CornerRadius = UDim.new(0, 6)
UICornerKiri.Parent = PageKiri

local TitleKiri = Instance.new("TextLabel")
TitleKiri.Size = UDim2.new(1, 0, 0, 18)
TitleKiri.Position = UDim2.new(0, 0, 0, 2)
TitleKiri.BackgroundTransparency = 1
TitleKiri.Text = "SETTINGS"
TitleKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKiri.TextSize = 10
TitleKiri.Font = Enum.Font.SourceSansBold
TitleKiri.Parent = PageKiri

local LoggerToggle = Instance.new("TextButton")
LoggerToggle.Size = UDim2.new(1, -12, 0, 24)
LoggerToggle.Position = UDim2.new(0, 6, 0, 24)
LoggerToggle.BackgroundColor3 = Color3.fromRGB(35, 55, 35)
LoggerToggle.Text = "Logger [ON]"
LoggerToggle.TextColor3 = Color3.fromRGB(150, 255, 150)
LoggerToggle.TextSize = 9
LoggerToggle.Font = Enum.Font.SourceSansBold
LoggerToggle.Parent = PageKiri

local UICornerT1 = Instance.new("UICorner")
UICornerT1.CornerRadius = UDim.new(0, 4)
UICornerT1.Parent = LoggerToggle

local AutoSaveToggle = Instance.new("TextButton")
AutoSaveToggle.Size = UDim2.new(1, -12, 0, 24)
AutoSaveToggle.Position = UDim2.new(0, 6, 0, 52)
AutoSaveToggle.BackgroundColor3 = Color3.fromRGB(35, 55, 35)
AutoSaveToggle.Text = "Auto Save [ON]"
AutoSaveToggle.TextColor3 = Color3.fromRGB(150, 255, 150)
AutoSaveToggle.TextSize = 9
AutoSaveToggle.Font = Enum.Font.SourceSansBold
AutoSaveToggle.Parent = PageKiri

local UICornerT2 = Instance.new("UICorner")
UICornerT2.CornerRadius = UDim.new(0, 4)
UICornerT2.Parent = AutoSaveToggle

--------------------------------------------------
-- 4. PAGE KANAN: DANCE LIST & CONSOLE LOG
--------------------------------------------------
local PageKanan = Instance.new("Frame")
PageKanan.Name = "PageKanan"
PageKanan.Size = UDim2.new(0, 182, 1, -22)
PageKanan.Position = UDim2.new(0, 132, 0, 6)
PageKanan.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKanan.Parent = MainFrame

local UICornerKanan = Instance.new("UICorner")
UICornerKanan.CornerRadius = UDim.new(0, 6)
UICornerKanan.Parent = PageKanan

local TitleKanan = Instance.new("TextLabel")
TitleKanan.Size = UDim2.new(1, 0, 0, 18)
TitleKanan.Position = UDim2.new(0, 0, 0, 2)
TitleKanan.BackgroundTransparency = 1
TitleKanan.Text = "DANCE LIST"
TitleKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKanan.TextSize = 10
TitleKanan.Font = Enum.Font.SourceSansBold
TitleKanan.Parent = PageKanan

local DanceFrame = Instance.new("ScrollingFrame")
DanceFrame.Name = "DanceFrame"
DanceFrame.Size = UDim2.new(1, -12, 0, 126)
DanceFrame.Position = UDim2.new(0, 6, 0, 22)
DanceFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
DanceFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DanceFrame.ScrollBarThickness = 2
DanceFrame.Parent = PageKanan

local UICornerDance = Instance.new("UICorner")
UICornerDance.CornerRadius = UDim.new(0, 4)
UICornerDance.Parent = DanceFrame

local DanceListLayout = Instance.new("UIListLayout")
DanceListLayout.SortOrder = Enum.SortOrder.LayoutOrder
DanceListLayout.Padding = UDim.new(0, 2)
DanceListLayout.Parent = DanceFrame

local ConsoleLog = Instance.new("TextLabel")
ConsoleLog.Name = "ConsoleLog"
ConsoleLog.Size = UDim2.new(1, -12, 0, 32)
ConsoleLog.Position = UDim2.new(0, 6, 0, 154)
ConsoleLog.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
ConsoleLog.Text = "> System Ready..."
ConsoleLog.TextColor3 = Color3.fromRGB(150, 255, 150)
ConsoleLog.TextSize = 8
ConsoleLog.Font = Enum.Font.Code
ConsoleLog.TextXAlignment = Enum.TextXAlignment.Left
ConsoleLog.TextYAlignment = Enum.TextYAlignment.Top
ConsoleLog.TextWrapped = true
ConsoleLog.Parent = PageKanan

local UICornerConsole = Instance.new("UICorner")
UICornerConsole.CornerRadius = UDim.new(0, 4)
UICornerConsole.Parent = ConsoleLog

--------------------------------------------------
-- 5. LOGIKA DANCE SCANNER (MARKETPLACE)
--------------------------------------------------
local function setConsoleMessage(text, color)
	ConsoleLog.Text = "> " .. text
	ConsoleLog.TextColor3 = color or Color3.fromRGB(150, 255, 150)
end

LoggerToggle.MouseButton1Click:Connect(function()
	isLoggerEnabled = not isLoggerEnabled
	LoggerToggle.BackgroundColor3 = isLoggerEnabled and Color3.fromRGB(35, 55, 35) or Color3.fromRGB(55, 35, 35)
	LoggerToggle.Text = "Logger [" .. (isLoggerEnabled and "ON" or "OFF") .. "]"
	LoggerToggle.TextColor3 = isLoggerEnabled and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
	setConsoleMessage("Logger: " .. (isLoggerEnabled and "ACTIVE" or "STANDBY"))
end)

AutoSaveToggle.MouseButton1Click:Connect(function()
	isAutoSaveEnabled = not isAutoSaveEnabled
	AutoSaveToggle.BackgroundColor3 = isAutoSaveEnabled and Color3.fromRGB(35, 55, 35) or Color3.fromRGB(55, 35, 35)
	AutoSaveToggle.Text = "Auto Save [" .. (isAutoSaveEnabled and "ON" or "OFF") .. "]"
	AutoSaveToggle.TextColor3 = isAutoSaveEnabled and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
	setConsoleMessage("Auto Save: " .. (isAutoSaveEnabled and "ACTIVE" or "STANDBY"))
end)

local function refreshDanceList()
	for _, child in ipairs(DanceFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	for idx, danceData in ipairs(savedDances) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Size = UDim2.new(1, -4, 0, 18)
		itemFrame.LayoutOrder = idx
		itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		itemFrame.Parent = DanceFrame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 3)
		corner.Parent = itemFrame

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -20, 1, 0)
		btn.Position = UDim2.new(0, 4, 0, 0)
		btn.BackgroundTransparency = 1
		btn.Text = idx .. ". " .. danceData.Name
		btn.TextColor3 = Color3.fromRGB(220, 220, 220)
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.TextSize = 8
		btn.Font = Enum.Font.SourceSans
		btn.Parent = itemFrame

		btn.MouseButton1Click:Connect(function()
			if setclipboard then
				setclipboard(danceData.Id)
				setConsoleMessage("Copied ID: " .. danceData.Name)
			else
				setConsoleMessage("ID: " .. danceData.Id)
			end
		end)

		local delBtn = Instance.new("TextButton")
		delBtn.Size = UDim2.new(0, 14, 1, 0)
		delBtn.Position = UDim2.new(1, -16, 0, 0)
		delBtn.BackgroundTransparency = 1
		delBtn.Text = "❌"
		delBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
		delBtn.TextSize = 7
		delBtn.Parent = itemFrame

		delBtn.MouseButton1Click:Connect(function()
			table.remove(savedDances, idx)
			refreshDanceList()
		end)
	end

	DanceFrame.CanvasSize = UDim2.new(0, 0, 0, DanceListLayout.AbsoluteContentSize.Y)
end

-- Listener Animation + Cek Marketplace Auto
local function hookAnimator(animator)
	if not animator then return end
	animator.AnimationPlayed:Connect(function(track)
		if not isLoggerEnabled then return end
		if track and track.Animation and track.Animation.AnimationId ~= "" then
			local rawId = track.Animation.AnimationId
			local cleanId = string.match(rawId, "%d+")
			if not cleanId then return end
			
			local fullAssetId = "rbxassetid://" .. cleanId

			-- Biar gak ada ID dobel
			for _, d in ipairs(savedDances) do
				if d.Id == fullAssetId then return end
			end

			-- Ambil Nama Asli dari Marketplace secara Asynchronous
			task.spawn(function()
				local danceName = "Dance_" .. cleanId
				
				local success, info = pcall(function()
					return MarketplaceService:GetProductInfo(tonumber(cleanId), Enum.InfoType.Asset)
				end)

				if success and info and info.Name then
					danceName = info.Name
				elseif track.Name ~= "Animation" and track.Name ~= "AnimationTrack" then
					danceName = track.Name
				end

				table.insert(savedDances, {Name = danceName, Id = fullAssetId})
				refreshDanceList()

				setConsoleMessage("[RECORDED]\n" .. danceName, Color3.fromRGB(255, 220, 100))

				-- Auto Save File TXT Format 'name dance :' & 'id dance :'
				if writefile and isAutoSaveEnabled then
					pcall(function()
						local logEntry = string.format("name dance : %s\nid dance : %s\n----------------------------------------\n", danceName, fullAssetId)
						if appendfile then
							appendfile("saved_dances.txt", logEntry)
						else
							local existing = isfile("saved_dances.txt") and readfile("saved_dances.txt") or ""
							writefile("saved_dances.txt", existing .. logEntry)
						end
					end)
				end
			end)
		end
	end)
end

task.spawn(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
	hookAnimator(animator)

	LocalPlayer.CharacterAdded:Connect(function(newChar)
		local h = newChar:WaitForChild("Humanoid")
		local a = h:FindFirstChildOfClass("Animator") or h
		hookAnimator(a)
	end)
end)
