-- ======================================================
-- 3-PAGE LAYOUT BUILD COPIER & PASTER (DARK WHITE)
-- COPYRIGHT (C) IkyyXD - ALL RIGHTS RESERVED
-- ======================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Hapus GUI lama jika ada
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("IkyyCopyTool3Page")
if oldGui then oldGui:Destroy() end

--------------------------------------------------
-- 1. UTAMA: SCREEN GUI & FLOATING ICON
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyCopyTool3Page"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Icon (Draggable)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0, 15, 0.5, -21)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "📦"
ToggleButton.TextSize = 18
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local UICornerIcon = Instance.new("UICorner")
UICornerIcon.CornerRadius = UDim.new(0, 8)
UICornerIcon.Parent = ToggleButton

local UIStrokeIcon = Instance.new("UIStroke")
UIStrokeIcon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeIcon.Thickness = 2
UIStrokeIcon.Parent = ToggleButton

-- Main Frame Container (3 Kolom Sejajar)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 320) -- Ukuran pas untuk 3 Page
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeMain.Thickness = 2
UIStrokeMain.Parent = MainFrame

-- Gradient Sinar Putih Berjalan pada Border MainFrame & Icon
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
BottomWatermark.Size = UDim2.new(1, 0, 0, 20)
BottomWatermark.Position = UDim2.new(0, 0, 1, -22)
BottomWatermark.BackgroundTransparency = 1
BottomWatermark.Text = "@IkyyXD"
BottomWatermark.TextColor3 = Color3.fromRGB(150, 150, 150)
BottomWatermark.TextSize = 12
BottomWatermark.Font = Enum.Font.SourceSansBold
BottomWatermark.Parent = MainFrame

--------------------------------------------------
-- 3. PAGE KIRI: PROFILE AKUN LENGKAP
--------------------------------------------------
local PageKiri = Instance.new("Frame")
PageKiri.Name = "PageKiri"
PageKiri.Size = UDim2.new(0, 210, 1, -32)
PageKiri.Position = UDim2.new(0, 10, 0, 10)
PageKiri.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKiri.Parent = MainFrame

local UICornerKiri = Instance.new("UICorner")
UICornerKiri.CornerRadius = UDim.new(0, 8)
UICornerKiri.Parent = PageKiri

local TitleKiri = Instance.new("TextLabel")
TitleKiri.Size = UDim2.new(1, 0, 0, 22)
TitleKiri.Position = UDim2.new(0, 0, 0, 6)
TitleKiri.BackgroundTransparency = 1
TitleKiri.Text = "PROFILE AKUN"
TitleKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKiri.TextSize = 12
TitleKiri.Font = Enum.Font.SourceSansBold
TitleKiri.Parent = PageKiri

-- Icon Avatar Image
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 50, 0, 50)
AvatarImg.Position = UDim2.new(0, 10, 0, 32)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImg.Parent = PageKiri

local UICornerAvatar = Instance.new("UICorner")
UICornerAvatar.CornerRadius = UDim.new(1, 0) -- Round Circle
UICornerAvatar.Parent = AvatarImg

-- Text Details Avatar (Name, Age, Friends, Followers)
local ProfileDetails = Instance.new("TextLabel")
ProfileDetails.Size = UDim2.new(1, -70, 0, 50)
ProfileDetails.Position = UDim2.new(0, 66, 0, 32)
ProfileDetails.BackgroundTransparency = 1
ProfileDetails.TextXAlignment = Enum.TextXAlignment.Left
ProfileDetails.TextYAlignment = Enum.TextYAlignment.Top
ProfileDetails.Text = "👤 " .. LocalPlayer.DisplayName .. "\n🗓️ Umur: " .. LocalPlayer.AccountAge .. " Hari"
ProfileDetails.TextColor3 = Color3.fromRGB(220, 220, 220)
ProfileDetails.TextSize = 10
ProfileDetails.Font = Enum.Font.SourceSans
ProfileDetails.Parent = PageKiri

local InfoList = Instance.new("TextLabel")
InfoList.Size = UDim2.new(1, -20, 0, 160)
InfoList.Position = UDim2.new(0, 10, 0, 90)
InfoList.BackgroundTransparency = 1
InfoList.TextXAlignment = Enum.TextXAlignment.Left
InfoList.TextYAlignment = Enum.TextYAlignment.Top
InfoList.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoList.TextSize = 11
InfoList.Font = Enum.Font.SourceSans
InfoList.Text = "👥 Friends: Loading...\n⭐ Followers: Loading...\n📌 Following: Loading..."
InfoList.Parent = PageKiri

-- Async Fetch Data Friends & Followers
task.spawn(function()
	local friendsCount, followersCount, followingCount = "0", "0", "0"
	pcall(function()
		friendsCount = tostring(#Players:GetFriendsAsync(LocalPlayer.UserId):GetCurrentPage())
	end)
	pcall(function()
		followersCount = tostring(HttpService:JSONDecode(game:HttpGet("https://friends.roblox.com/v1/users/" .. LocalPlayer.UserId .. "/followers/count")).count)
	end)
	pcall(function()
		followingCount = tostring(HttpService:JSONDecode(game:HttpGet("https://friends.roblox.com/v1/users/" .. LocalPlayer.UserId .. "/followings/count")).count)
	end)

	InfoList.Text = "👥 Friends: " .. friendsCount .. "\n⭐ Followers: " .. followersCount .. "\n📌 Following: " .. followingCount
end)

--------------------------------------------------
-- 4. PAGE TENGAH: PILIHAN LIST FITUR
--------------------------------------------------
local PageTengah = Instance.new("Frame")
PageTengah.Name = "PageTengah"
PageTengah.Size = UDim2.new(0, 210, 1, -32)
PageTengah.Position = UDim2.new(0, 235, 0, 10)
PageTengah.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageTengah.Parent = MainFrame

local UICornerTengah = Instance.new("UICorner")
UICornerTengah.CornerRadius = UDim.new(0, 8)
UICornerTengah.Parent = PageTengah

local TitleTengah = Instance.new("TextLabel")
TitleTengah.Size = UDim2.new(1, 0, 0, 22)
TitleTengah.Position = UDim2.new(0, 0, 0, 6)
TitleTengah.BackgroundTransparency = 1
TitleTengah.Text = "LIST FITUR UTAMA"
TitleTengah.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleTengah.TextSize = 12
TitleTengah.Font = Enum.Font.SourceSansBold
TitleTengah.Parent = PageTengah

local ListContainer = Instance.new("Frame")
ListContainer.Size = UDim2.new(1, -16, 1, -40)
ListContainer.Position = UDim2.new(0, 8, 0, 32)
ListContainer.BackgroundTransparency = 1
ListContainer.Parent = PageTengah

local UIListTengah = Instance.new("UIListLayout")
UIListTengah.SortOrder = Enum.SortOrder.LayoutOrder
UIListTengah.Padding = UDim.new(0, 5)
UIListTengah.Parent = ListContainer

local function createFeatureLabel(text, order)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 28)
	lbl.LayoutOrder = order
	lbl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
	lbl.TextSize = 11
	lbl.Font = Enum.Font.SourceSans
	lbl.Parent = ListContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = lbl
	
	return lbl
end

createFeatureLabel("• Multi-Select Click Part", 1)
createFeatureLabel("• Copy Data Serialized (JSON)", 2)
createFeatureLabel("• Save to File / Clipboard", 3)
createFeatureLabel("• Realtime Paste Object System", 4)
createFeatureLabel("• Anti-Lag Lightweight GUI", 5)

--------------------------------------------------
-- 5. PAGE KANAN: BUTTON & REALTIME CONSOLE
--------------------------------------------------
local PageKanan = Instance.new("Frame")
PageKanan.Name = "PageKanan"
PageKanan.Size = UDim2.new(0, 215, 1, -32)
PageKanan.Position = UDim2.new(0, 455, 0, 10)
PageKanan.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKanan.Parent = MainFrame

local UICornerKanan = Instance.new("UICorner")
UICornerKanan.CornerRadius = UDim.new(0, 8)
UICornerKanan.Parent = PageKanan

local TitleKanan = Instance.new("TextLabel")
TitleKanan.Size = UDim2.new(1, 0, 0, 22)
TitleKanan.Position = UDim2.new(0, 0, 0, 6)
TitleKanan.BackgroundTransparency = 1
TitleKanan.Text = "KONTROL & CONSOLE"
TitleKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKanan.TextSize = 12
TitleKanan.Font = Enum.Font.SourceSansBold
TitleKanan.Parent = PageKanan

-- Container Tombol Akses
local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(1, -16, 0, 115)
BtnContainer.Position = UDim2.new(0, 8, 0, 30)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = PageKanan

local UIListKanan = Instance.new("UIListLayout")
UIListKanan.SortOrder = Enum.SortOrder.LayoutOrder
UIListKanan.Padding = UDim.new(0, 4)
UIListKanan.Parent = BtnContainer

local function createActionButton(name, text, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 24)
	btn.LayoutOrder = order
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(240, 240, 240)
	btn.TextSize = 11
	btn.Font = Enum.Font.SourceSansBold
	btn.Parent = BtnContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = btn
	
	return btn
end

local ToggleCopyBtn    = createActionButton("ToggleCopyBtn", "Fitur Copy: OFF", 1)
local SelectModeBtn    = createActionButton("SelectModeBtn", "Mode Pilih Mouse: OFF", 2)
local ClearBtn         = createActionButton("ClearBtn", "Reset Pilihan", 3)
local SaveClipboardBtn = createActionButton("SaveClipboardBtn", "Copy ke Clipboard", 4)
local PasteBtn         = createActionButton("PasteBtn", "Tempel (Paste) Part", 5)

-- Console Ukuran Kecil Realtime Loading/Logs
local ConsoleFrame = Instance.new("ScrollingFrame")
ConsoleFrame.Name = "ConsoleFrame"
ConsoleFrame.Size = UDim2.new(1, -16, 0, 115)
ConsoleFrame.Position = UDim2.new(0, 8, 0, 150)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ConsoleFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ConsoleFrame.ScrollBarThickness = 3
ConsoleFrame.Parent = PageKanan

local UICornerConsole = Instance.new("UICorner")
UICornerConsole.CornerRadius = UDim.new(0, 6)
UICornerConsole.Parent = ConsoleFrame

local ConsoleList = Instance.new("UIListLayout")
ConsoleList.SortOrder = Enum.SortOrder.LayoutOrder
ConsoleList.Padding = UDim.new(0, 2)
ConsoleList.Parent = ConsoleFrame

-- Log System Realtime
local logOrder = 0
local function writeConsole(msg, isError)
	logOrder = logOrder + 1
	local logLabel = Instance.new("TextLabel")
	logLabel.Size = UDim2.new(1, -6, 0, 14)
	logLabel.LayoutOrder = logOrder
	logLabel.BackgroundTransparency = 1
	logLabel.TextXAlignment = Enum.TextXAlignment.Left
	logLabel.Text = "> " .. tostring(msg)
	logLabel.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(180, 255, 180)
	logLabel.TextSize = 10
	logLabel.Font = Enum.Font.Code
	logLabel.Parent = ConsoleFrame
	
	ConsoleFrame.CanvasSize = UDim2.new(0, 0, 0, ConsoleList.AbsoluteContentSize.Y)
	ConsoleFrame.CanvasPosition = Vector2.new(0, ConsoleFrame.CanvasSize.Y.Offset)
	
	-- Print juga ke Output Bawaan Roblox Console
	if isError then
		warn("[IkyyXD Log] " .. msg)
	else
		print("[IkyyXD Log] " .. msg)
	end
end

writeConsole("Console initialized.", false)

--------------------------------------------------
-- 6. LOGIKA MULTI SELECT & PASTE SYSTEM
--------------------------------------------------
local isCopyEnabled = false
local isSelecting = false
local selectedParts = {}
local highlights = {}

ToggleCopyBtn.MouseButton1Click:Connect(function()
	isCopyEnabled = not isCopyEnabled
	if isCopyEnabled then
		ToggleCopyBtn.Text = "Fitur Copy: AKTIF [ON]"
		ToggleCopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		writeConsole("Fitur Copy diaktifkan.")
	else
		isSelecting = false
		SelectModeBtn.Text = "Mode Pilih Mouse: OFF"
		SelectModeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ToggleCopyBtn.Text = "Fitur Copy: NONAKTIF [OFF]"
		ToggleCopyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		writeConsole("Fitur Copy dimatikan.")
	end
end)

SelectModeBtn.MouseButton1Click:Connect(function()
	if not isCopyEnabled then
		writeConsole("Aktifkan Fitur Copy Dulu!", true)
		return
	end
	
	isSelecting = not isSelecting
	if isSelecting then
		SelectModeBtn.Text = "Mode Pilih Mouse: ON"
		SelectModeBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
		writeConsole("Mode Pilih Mouse ON.")
	else
		SelectModeBtn.Text = "Mode Pilih Mouse: OFF"
		SelectModeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		writeConsole("Mode Pilih Mouse OFF.")
	end
end)

Mouse.Button1Down:Connect(function()
	if not isCopyEnabled or not isSelecting then return end
	local target = Mouse.Target
	
	if target and target:IsA("BasePart") then
		if selectedParts[target] then
			selectedParts[target] = nil
			if highlights[target] then
				highlights[target]:Destroy()
				highlights[target] = nil
			end
			writeConsole("Batal: " .. target.Name)
		else
			selectedParts[target] = true
			
			local hl = Instance.new("Highlight")
			hl.Adornee = target
			hl.FillColor = Color3.fromRGB(255, 255, 255)
			hl.FillTransparency = 0.4
			hl.OutlineColor = Color3.fromRGB(0, 0, 0)
			hl.Parent = target
			highlights[target] = hl
			
			writeConsole("Dipilih: " .. target.Name)
		end
	end
end)

ClearBtn.MouseButton1Click:Connect(function()
	for part, hl in pairs(highlights) do
		if hl then hl:Destroy() end
	end
	selectedParts = {}
	highlights = {}
	writeConsole("Reset semua pilihan.")
end)

local function serializeParts()
	local data = {}
	for part in pairs(selectedParts) do
		if part then
			table.insert(data, {
				Name = part.Name,
				ClassName = part.ClassName,
				Size = {part.Size.X, part.Size.Y, part.Size.Z},
				Color = {part.Color.R, part.Color.G, part.Color.B},
				Material = part.Material.Name,
				Transparency = part.Transparency,
				Anchored = true,
				CanCollide = part.CanCollide,
				CFrame = {part.CFrame:GetComponents()}
			})
		end
	end
	return data
end

SaveClipboardBtn.MouseButton1Click:Connect(function()
	if not isCopyEnabled then return end
	local data = serializeParts()
	if #data == 0 then
		writeConsole("Gagal: Belum ada part!", true)
		return
	end
	
	local jsonStr = HttpService:JSONEncode(data)
	if setclipboard then
		setclipboard(jsonStr)
		writeConsole("Berhasil copy " .. #data .. " part!")
	else
		writeConsole("No setclipboard support", true)
	end
end)

PasteBtn.MouseButton1Click:Connect(function()
	local jsonStr = nil
	
	if readfile and pcall(function() jsonStr = readfile("copied_parts.json") end) then
		writeConsole("Membaca file JSON...")
	elseif getclipboard then
		jsonStr = getclipboard()
		writeConsole("Membaca Clipboard...")
	end
	
	if not jsonStr or jsonStr == "" then
		writeConsole("Data JSON Kosong!", true)
		return
	end
	
	local success, data = pcall(function()
		return HttpService:JSONDecode(jsonStr)
	end)
	
	if not success or type(data) ~= "table" then
		writeConsole("Format JSON Salah!", true)
		return
	end
	
	local folder = Instance.new("Folder")
	folder.Name = "PastedParts_" .. math.random(100, 999)
	folder.Parent = workspace
	
	local count = 0
	for _, item in ipairs(data) do
		local newPart = Instance.new(item.ClassName or "Part")
		newPart.Name = item.Name or "PastedPart"
		newPart.Size = Vector3.new(unpack(item.Size))
		newPart.Color = Color3.new(unpack(item.Color))
		newPart.Material = Enum.Material[item.Material] or Enum.Material.Plastic
		newPart.Transparency = item.Transparency or 0
		newPart.Anchored = item.Anchored
		newPart.CanCollide = item.CanCollide
		newPart.CFrame = CFrame.new(unpack(item.CFrame))
		newPart.Parent = folder
		count = count + 1
	end
	
	writeConsole("Sukses Tempel " .. count .. " Part!")
end)

writeConsole("Ready! Created by IkyyXD")
