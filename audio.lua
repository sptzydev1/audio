-- ======================================================
-- MINI 3-PAGE BUILD COPIER & PASTER (DARK WHITE)
-- COPYRIGHT (C) IkyyXD - ALL RIGHTS RESERVED
-- ======================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Mendapatkan Nama Game
local gameName = "Map Item"
pcall(function()
	local info = MarketplaceService:GetProductInfo(game.PlaceId)
	if info and info.Name then
		gameName = info.Name
	end
end)

-- Hapus GUI lama jika ada
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("IkyyCopyToolMini")
if oldGui then oldGui:Destroy() end

--------------------------------------------------
-- 1. UTAMA: SCREEN GUI & FLOATING ICON
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyCopyToolMini"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Icon Kecil
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 32, 0, 32)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -16)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "📦"
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

-- Main Frame UKURAN MINI (Lebar: 460px, Tinggi: 210px)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 210)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -105)
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

-- Gradient Sinar Putih Berjalan
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
BottomWatermark.Text = "@IkyyXD"
BottomWatermark.TextColor3 = Color3.fromRGB(150, 150, 150)
BottomWatermark.TextSize = 10
BottomWatermark.Font = Enum.Font.SourceSansBold
BottomWatermark.Parent = MainFrame

--------------------------------------------------
-- 3. PAGE KIRI: LIST FITUR MINI
--------------------------------------------------
local PageKiri = Instance.new("Frame")
PageKiri.Name = "PageKiri"
PageKiri.Size = UDim2.new(0, 142, 1, -22)
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
TitleKiri.Text = "LIST FITUR"
TitleKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKiri.TextSize = 10
TitleKiri.Font = Enum.Font.SourceSansBold
TitleKiri.Parent = PageKiri

local ListContainer = Instance.new("Frame")
ListContainer.Size = UDim2.new(1, -12, 1, -26)
ListContainer.Position = UDim2.new(0, 6, 0, 22)
ListContainer.BackgroundTransparency = 1
ListContainer.Parent = PageKiri

local UIListKiri = Instance.new("UIListLayout")
UIListKiri.SortOrder = Enum.SortOrder.LayoutOrder
UIListKiri.Padding = UDim.new(0, 3)
UIListKiri.Parent = ListContainer

local function createFeatureLabel(text, order)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 22)
	lbl.LayoutOrder = order
	lbl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
	lbl.TextSize = 9
	lbl.Font = Enum.Font.SourceSans
	lbl.Parent = ListContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = lbl
	return lbl
end

createFeatureLabel("• Multi-Select Object", 1)
createFeatureLabel("• Auto Save Storage", 2)
createFeatureLabel("• Quick Load & Paste", 3)
createFeatureLabel("• Precise Position", 4)
createFeatureLabel("• Anti-Lag System", 5)

--------------------------------------------------
-- 4. PAGE TENGAH: PROFILE MINI
--------------------------------------------------
local PageTengah = Instance.new("Frame")
PageTengah.Name = "PageTengah"
PageTengah.Size = UDim2.new(0, 142, 1, -22)
PageTengah.Position = UDim2.new(0, 154, 0, 6)
PageTengah.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageTengah.Parent = MainFrame

local UICornerTengah = Instance.new("UICorner")
UICornerTengah.CornerRadius = UDim.new(0, 6)
UICornerTengah.Parent = PageTengah

local TitleTengah = Instance.new("TextLabel")
TitleTengah.Size = UDim2.new(1, 0, 0, 18)
TitleTengah.Position = UDim2.new(0, 0, 0, 2)
TitleTengah.BackgroundTransparency = 1
TitleTengah.Text = "PROFILE AKUN"
TitleTengah.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleTengah.TextSize = 10
TitleTengah.Font = Enum.Font.SourceSansBold
TitleTengah.Parent = PageTengah

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 32, 0, 32)
AvatarImg.Position = UDim2.new(0, 6, 0, 22)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImg.Parent = PageTengah

local UICornerAvatar = Instance.new("UICorner")
UICornerAvatar.CornerRadius = UDim.new(1, 0)
UICornerAvatar.Parent = AvatarImg

local ProfileDetails = Instance.new("TextLabel")
ProfileDetails.Size = UDim2.new(1, -44, 0, 32)
ProfileDetails.Position = UDim2.new(0, 42, 0, 22)
ProfileDetails.BackgroundTransparency = 1
ProfileDetails.TextXAlignment = Enum.TextXAlignment.Left
ProfileDetails.TextYAlignment = Enum.TextYAlignment.Center
ProfileDetails.Text = "👤 " .. LocalPlayer.DisplayName .. "\n🗓️ " .. LocalPlayer.AccountAge .. " Hari"
ProfileDetails.TextColor3 = Color3.fromRGB(220, 220, 220)
ProfileDetails.TextSize = 9
ProfileDetails.Font = Enum.Font.SourceSans
ProfileDetails.Parent = PageTengah

local InfoList = Instance.new("TextLabel")
InfoList.Size = UDim2.new(1, -12, 0, 115)
InfoList.Position = UDim2.new(0, 6, 0, 60)
InfoList.BackgroundTransparency = 1
InfoList.TextXAlignment = Enum.TextXAlignment.Left
InfoList.TextYAlignment = Enum.TextYAlignment.Top
InfoList.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoList.TextSize = 9
InfoList.Font = Enum.Font.SourceSans
InfoList.Text = "👥 Friends: Loading...\n⭐ Followers: Loading...\n📌 Following: Loading..."
InfoList.Parent = PageTengah

task.spawn(function()
	local friendsCount, followersCount, followingCount = "0", "0", "0"
	pcall(function() friendsCount = tostring(#Players:GetFriendsAsync(LocalPlayer.UserId):GetCurrentPage()) end)
	pcall(function() followersCount = tostring(HttpService:JSONDecode(game:HttpGet("https://friends.roblox.com/v1/users/" .. LocalPlayer.UserId .. "/followers/count")).count) end)
	pcall(function() followingCount = tostring(HttpService:JSONDecode(game:HttpGet("https://friends.roblox.com/v1/users/" .. LocalPlayer.UserId .. "/followings/count")).count) end)
	InfoList.Text = "👥 Friends: " .. friendsCount .. "\n⭐ Followers: " .. followersCount .. "\n📌 Following: " .. followingCount
end)

--------------------------------------------------
-- 5. PAGE KANAN: KONTROL, LIST & DROPDOWN MENU
--------------------------------------------------
local PageKanan = Instance.new("Frame")
PageKanan.Name = "PageKanan"
PageKanan.Size = UDim2.new(0, 150, 1, -22)
PageKanan.Position = UDim2.new(0, 302, 0, 6)
PageKanan.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKanan.Parent = MainFrame

local UICornerKanan = Instance.new("UICorner")
UICornerKanan.CornerRadius = UDim.new(0, 6)
UICornerKanan.Parent = PageKanan

local TitleKanan = Instance.new("TextLabel")
TitleKanan.Size = UDim2.new(1, -24, 0, 18)
TitleKanan.Position = UDim2.new(0, 0, 0, 2)
TitleKanan.BackgroundTransparency = 1
TitleKanan.Text = "DATA SAVED"
TitleKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKanan.TextSize = 10
TitleKanan.Font = Enum.Font.SourceSansBold
TitleKanan.Parent = PageKanan

-- Tombol Titik 3 Header (Select All / Multi Delete)
local HeaderMenuBtn = Instance.new("TextButton")
HeaderMenuBtn.Size = UDim2.new(0, 16, 0, 16)
HeaderMenuBtn.Position = UDim2.new(1, -20, 0, 3)
HeaderMenuBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
HeaderMenuBtn.Text = "⋮"
HeaderMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderMenuBtn.TextSize = 10
HeaderMenuBtn.Font = Enum.Font.SourceSansBold
HeaderMenuBtn.Parent = PageKanan

local UICornerHeaderBtn = Instance.new("UICorner")
UICornerHeaderBtn.CornerRadius = UDim.new(0, 3)
UICornerHeaderBtn.Parent = HeaderMenuBtn

local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(1, -12, 0, 85)
BtnContainer.Position = UDim2.new(0, 6, 0, 20)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = PageKanan

local UIListKanan = Instance.new("UIListLayout")
UIListKanan.SortOrder = Enum.SortOrder.LayoutOrder
UIListKanan.Padding = UDim.new(0, 2)
UIListKanan.Parent = BtnContainer

local function createActionButton(name, text, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 15)
	btn.LayoutOrder = order
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(240, 240, 240)
	btn.TextSize = 9
	btn.Font = Enum.Font.SourceSansBold
	btn.Parent = BtnContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = btn
	return btn
end

local ToggleCopyBtn = createActionButton("ToggleCopyBtn", "Copy Mode: OFF", 1)
local SelectModeBtn = createActionButton("SelectModeBtn", "Mouse Click: OFF", 2)
local ClearBtn      = createActionButton("ClearBtn", "Reset Selection", 3)
local SaveBtn       = createActionButton("SaveBtn", "Save Data", 4)
local PasteBtn      = createActionButton("PasteBtn", "Paste Selected", 5)

-- Scroll Container
local ResultFrame = Instance.new("ScrollingFrame")
ResultFrame.Name = "ResultFrame"
ResultFrame.Size = UDim2.new(1, -12, 0, 75)
ResultFrame.Position = UDim2.new(0, 6, 0, 108)
ResultFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ResultFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ResultFrame.ScrollBarThickness = 2
ResultFrame.Parent = PageKanan

local UICornerResult = Instance.new("UICorner")
UICornerResult.CornerRadius = UDim.new(0, 4)
UICornerResult.Parent = ResultFrame

local ResultListLayout = Instance.new("UIListLayout")
ResultListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ResultListLayout.Padding = UDim.new(0, 2)
ResultListLayout.Parent = ResultFrame

-- Overlay Frame Global untuk Dropdown Menu
local DropdownOverlay = Instance.new("Frame")
DropdownOverlay.Name = "DropdownOverlay"
DropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
DropdownOverlay.BackgroundTransparency = 1
DropdownOverlay.Visible = false
DropdownOverlay.ZIndex = 10
DropdownOverlay.Parent = PageKanan

local function closeAllDropdowns()
	DropdownOverlay.Visible = false
	for _, child in ipairs(DropdownOverlay:GetChildren()) do
		child:Destroy()
	end
end

--------------------------------------------------
-- 6. LOGIKA SYSTEM (SELEKSI, DROPDOWN & HAPUS)
--------------------------------------------------
local isCopyEnabled = false
local isSelecting = false
local selectedParts = {}
local highlights = {}
local savedStorage = {}
local selectedListIndex = nil
local multiSelectedMap = {}
local listButtons = {}

local function saveStorageToFile()
	if writefile then
		pcall(function()
			writefile("saved_build_data.dat", HttpService:JSONEncode(savedStorage))
		end)
	end
end

ToggleCopyBtn.MouseButton1Click:Connect(function()
	isCopyEnabled = not isCopyEnabled
	if isCopyEnabled then
		ToggleCopyBtn.Text = "Copy Mode: ON"
		ToggleCopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	else
		isSelecting = false
		SelectModeBtn.Text = "Mouse Click: OFF"
		SelectModeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ToggleCopyBtn.Text = "Copy Mode: OFF"
		ToggleCopyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end
end)

SelectModeBtn.MouseButton1Click:Connect(function()
	if not isCopyEnabled then return end
	isSelecting = not isSelecting
	if isSelecting then
		SelectModeBtn.Text = "Mouse Click: ON"
		SelectModeBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
	else
		SelectModeBtn.Text = "Mouse Click: OFF"
		SelectModeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
		else
			selectedParts[target] = true
			local hl = Instance.new("Highlight")
			hl.Adornee = target
			hl.FillColor = Color3.fromRGB(255, 255, 255)
			hl.FillTransparency = 0.4
			hl.OutlineColor = Color3.fromRGB(0, 0, 0)
			hl.Parent = target
			highlights[target] = hl
		end
	end
end)

ClearBtn.MouseButton1Click:Connect(function()
	for part, hl in pairs(highlights) do
		if hl then hl:Destroy() end
	end
	selectedParts = {}
	highlights = {}
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
				Anchored = part.Anchored,
				CanCollide = part.CanCollide,
				CFrame = {part.CFrame:GetComponents()}
			})
		end
	end
	return data
end

-- Refresh UI List Hasil
local function refreshResultList()
	closeAllDropdowns()
	for _, btn in ipairs(listButtons) do
		btn:Destroy()
	end
	listButtons = {}

	for idx, itemData in ipairs(savedStorage) do
		local isMultiSelected = multiSelectedMap[idx]
		local isSingleSelected = (selectedListIndex == idx)

		local itemFrame = Instance.new("Frame")
		itemFrame.Size = UDim2.new(1, -4, 0, 16)
		itemFrame.LayoutOrder = idx
		itemFrame.BackgroundColor3 = isMultiSelected and Color3.fromRGB(80, 50, 50) 
			or (isSingleSelected and Color3.fromRGB(60, 90, 130) or Color3.fromRGB(25, 25, 25))
		itemFrame.Parent = ResultFrame

		local cornerFrame = Instance.new("UICorner")
		cornerFrame.CornerRadius = UDim.new(0, 3)
		cornerFrame.Parent = itemFrame

		-- Tombol Titik 3 di Sudut Kiri/Kanan Item
		local itemMenuBtn = Instance.new("TextButton")
		itemMenuBtn.Size = UDim2.new(0, 14, 1, 0)
		itemMenuBtn.Position = UDim2.new(0, 2, 0, 0)
		itemMenuBtn.BackgroundTransparency = 1
		itemMenuBtn.Text = "⋮"
		itemMenuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		itemMenuBtn.TextSize = 10
		itemMenuBtn.Font = Enum.Font.SourceSansBold
		itemMenuBtn.ZIndex = 2
		itemMenuBtn.Parent = itemFrame

		-- Tombol Utama Item
		local itemBtn = Instance.new("TextButton")
		itemBtn.Size = UDim2.new(1, -18, 1, 0)
		itemBtn.Position = UDim2.new(0, 18, 0, 0)
		itemBtn.BackgroundTransparency = 1
		itemBtn.Text = idx .. ". " .. itemData.Title .. " (" .. #itemData.Parts .. ")"
		itemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
		itemBtn.TextXAlignment = Enum.TextXAlignment.Left
		itemBtn.TextSize = 8
		itemBtn.Font = Enum.Font.SourceSans
		itemBtn.Parent = itemFrame

		-- Klik Item untuk Memilih
		itemBtn.MouseButton1Click:Connect(function()
			if next(multiSelectedMap) then
				multiSelectedMap[idx] = not multiSelectedMap[idx] or nil
			else
				selectedListIndex = idx
			end
			refreshResultList()
		end)

		-- Popup Dropdown Menu untuk 1 Item (Hapus)
		itemMenuBtn.MouseButton1Click:Connect(function()
			closeAllDropdowns()
			DropdownOverlay.Visible = true

			local popMenu = Instance.new("Frame")
			popMenu.Size = UDim2.new(0, 60, 0, 18)
			popMenu.Position = UDim2.new(0, 20, 0, math.clamp(itemFrame.AbsolutePosition.Y - ResultFrame.AbsolutePosition.Y + 110, 10, 180))
			popMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			popMenu.ZIndex = 11
			popMenu.Parent = DropdownOverlay

			local popCorner = Instance.new("UICorner")
			popCorner.CornerRadius = UDim.new(0, 3)
			popCorner.Parent = popMenu

			local delBtn = Instance.new("TextButton")
			delBtn.Size = UDim2.new(1, 0, 1, 0)
			delBtn.BackgroundTransparency = 1
			delBtn.Text = "🗑️ Hapus"
			delBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
			delBtn.TextSize = 8
			delBtn.Font = Enum.Font.SourceSansBold
			delBtn.ZIndex = 12
			delBtn.Parent = popMenu

			delBtn.MouseButton1Click:Connect(function()
				table.remove(savedStorage, idx)
				if selectedListIndex == idx then selectedListIndex = nil end
				multiSelectedMap[idx] = nil
				saveStorageToFile()
				refreshResultList()
			end)
		end)

		table.insert(listButtons, itemFrame)
	end

	ResultFrame.CanvasSize = UDim2.new(0, 0, 0, ResultListLayout.AbsoluteContentSize.Y)
end

-- Popup Header Dropdown Menu (Select All / Multi Delete)
HeaderMenuBtn.MouseButton1Click:Connect(function()
	if DropdownOverlay.Visible then
		closeAllDropdowns()
		return
	end
	closeAllDropdowns()
	DropdownOverlay.Visible = true

	local menuFrame = Instance.new("Frame")
	menuFrame.Size = UDim2.new(0, 85, 0, 38)
	menuFrame.Position = UDim2.new(1, -90, 0, 20)
	menuFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	menuFrame.ZIndex = 11
	menuFrame.Parent = DropdownOverlay

	local menuCorner = Instance.new("UICorner")
	menuCorner.CornerRadius = UDim.new(0, 4)
	menuCorner.Parent = menuFrame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 1)
	layout.Parent = menuFrame

	local selectAllBtn = Instance.new("TextButton")
	selectAllBtn.Size = UDim2.new(1, 0, 0, 18)
	selectAllBtn.BackgroundTransparency = 1
	selectAllBtn.Text = "☑️ Select All"
	selectAllBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	selectAllBtn.TextSize = 8
	selectAllBtn.Font = Enum.Font.SourceSans
	selectAllBtn.ZIndex = 12
	selectAllBtn.Parent = menuFrame

	local deleteSelectedBtn = Instance.new("TextButton")
	deleteSelectedBtn.Size = UDim2.new(1, 0, 0, 18)
	deleteSelectedBtn.BackgroundTransparency = 1
	deleteSelectedBtn.Text = "🗑️ Hapus Terpilih"
	deleteSelectedBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
	deleteSelectedBtn.TextSize = 8
	deleteSelectedBtn.Font = Enum.Font.SourceSansBold
	deleteSelectedBtn.ZIndex = 12
	deleteSelectedBtn.Parent = menuFrame

	selectAllBtn.MouseButton1Click:Connect(function()
		for i = 1, #savedStorage do
			multiSelectedMap[i] = true
		end
		refreshResultList()
	end)

	deleteSelectedBtn.MouseButton1Click:Connect(function()
		local newStorage = {}
		for i, data in ipairs(savedStorage) do
			if not multiSelectedMap[i] then
				table.insert(newStorage, data)
			end
		end
		savedStorage = newStorage
		multiSelectedMap = {}
		selectedListIndex = nil
		saveStorageToFile()
		refreshResultList()
	end)
end)

-- Menutupi Dropdown jika Area Lain Diklik
DropdownOverlay.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		closeAllDropdowns()
	end
end)

-- Save Data
SaveBtn.MouseButton1Click:Connect(function()
	if not isCopyEnabled then return end
	local partsData = serializeParts()
	if #partsData == 0 then return end

	local payload = {
		Title = gameName,
		Parts = partsData
	}

	table.insert(savedStorage, payload)
	selectedListIndex = #savedStorage
	saveStorageToFile()
	refreshResultList()
end)

-- Paste Data
local function executePaste(dataList)
	if not dataList or #dataList == 0 then return end

	local folder = Instance.new("Folder")
	folder.Name = "Pasted_" .. math.random(100, 999)
	folder.Parent = workspace

	for _, item in ipairs(dataList) do
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
	end
end

PasteBtn.MouseButton1Click:Connect(function()
	if selectedListIndex and savedStorage[selectedListIndex] then
		executePaste(savedStorage[selectedListIndex].Parts)
	end
end)

-- Auto Load File Data
if readfile and isfile and isfile("saved_build_data.dat") then
	pcall(function()
		local content = readfile("saved_build_data.dat")
		local decoded = HttpService:JSONDecode(content)
		if type(decoded) == "table" then
			savedStorage = decoded
			refreshResultList()
		end
	end)
end
