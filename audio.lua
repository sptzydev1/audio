-- ======================================================
-- PAGE KANAN AUTO-SCAN TERRAIN & PRECISE PASTE + MATERIAL GENERATOR
-- SUPPORT MOBILE & TOUCHSCREEN
-- COPYRIGHT (C) IkyyXD - ALL RIGHTS RESERVED
-- ======================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Terrain = workspace.Terrain

-- Mendapatkan Nama Game
local gameName = "Terrain Map"
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

-- Floating Icon Kecil (Dioptimalkan untuk Mobile UI)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 38, 0, 38)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "⚡"
ToggleButton.TextSize = 16
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local UICornerIcon = Instance.new("UICorner")
UICornerIcon.CornerRadius = UDim.new(0, 8)
UICornerIcon.Parent = ToggleButton

local UIStrokeIcon = Instance.new("UIStroke")
UIStrokeIcon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeIcon.Thickness = 1.5
UIStrokeIcon.Parent = ToggleButton

-- Main Frame Disesuaikan Khusus Page Kanan
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 175, 0, 235)
MainFrame.Position = UDim2.new(0.5, -87, 0.5, -117)
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
-- 3. PAGE KANAN (AUTO-SCAN & PRECISE PASTE)
--------------------------------------------------
local savedStorage = {}
local multiSelectedMap = {}
local listButtons = {}
local scannedVoxelsBuffer = {}
local refreshResultList

local PageKanan = Instance.new("Frame")
PageKanan.Name = "PageKanan"
PageKanan.Size = UDim2.new(0, 163, 1, -22)
PageKanan.Position = UDim2.new(0, 6, 0, 6)
PageKanan.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKanan.Parent = MainFrame

local UICornerKanan = Instance.new("UICorner")
UICornerKanan.CornerRadius = UDim.new(0, 6)
UICornerKanan.Parent = PageKanan

local TitleKanan = Instance.new("TextLabel")
TitleKanan.Size = UDim2.new(1, -48, 0, 18)
TitleKanan.Position = UDim2.new(0, 2, 0, 2)
TitleKanan.BackgroundTransparency = 1
TitleKanan.Text = "AUTO COPIER"
TitleKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKanan.TextSize = 10
TitleKanan.Font = Enum.Font.SourceSansBold
TitleKanan.Parent = PageKanan

-- Tombol Copy Script Material di Pojok Kanan Atas Frame (Mobile Touch Optimized)
local CopyScriptBtn = Instance.new("TextButton")
CopyScriptBtn.Name = "CopyScriptBtn"
CopyScriptBtn.Size = UDim2.new(0, 20, 0, 18)
CopyScriptBtn.Position = UDim2.new(1, -44, 0, 2)
CopyScriptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CopyScriptBtn.Text = "📋"
CopyScriptBtn.TextSize = 11
CopyScriptBtn.Font = Enum.Font.SourceSansBold
CopyScriptBtn.Parent = PageKanan

local UICornerCopyBtn = Instance.new("UICorner")
UICornerCopyBtn.CornerRadius = UDim.new(0, 4)
UICornerCopyBtn.Parent = CopyScriptBtn

local HeaderMenuBtn = Instance.new("TextButton")
HeaderMenuBtn.Size = UDim2.new(0, 20, 0, 18)
HeaderMenuBtn.Position = UDim2.new(1, -22, 0, 2)
HeaderMenuBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
HeaderMenuBtn.Text = "⋮"
HeaderMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderMenuBtn.TextSize = 11
HeaderMenuBtn.Font = Enum.Font.SourceSansBold
HeaderMenuBtn.Parent = PageKanan

local UICornerHeaderBtn = Instance.new("UICorner")
UICornerHeaderBtn.CornerRadius = UDim.new(0, 4)
UICornerHeaderBtn.Parent = HeaderMenuBtn

local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(1, -12, 0, 74)
BtnContainer.Position = UDim2.new(0, 6, 0, 22)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = PageKanan

local UIListKanan = Instance.new("UIListLayout")
UIListKanan.SortOrder = Enum.SortOrder.LayoutOrder
UIListKanan.Padding = UDim.new(0, 3)
UIListKanan.Parent = BtnContainer

local function createActionButton(name, text, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 16)
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

local AutoScanBtn = createActionButton("AutoScanBtn", "🔍 Auto Scan Nearby", 1)
local QuickCopyBtn = createActionButton("QuickCopyBtn", "⚡ Scan & Save Now", 2)
local ClearBtn     = createActionButton("ClearBtn", "Reset Storage", 3)
local SaveBtn      = createActionButton("SaveBtn", "Save to File", 4)

local ResultFrame = Instance.new("ScrollingFrame")
ResultFrame.Name = "ResultFrame"
ResultFrame.Size = UDim2.new(1, -12, 0, 62)
ResultFrame.Position = UDim2.new(0, 6, 0, 100)
ResultFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ResultFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ResultFrame.ScrollBarThickness = 3
ResultFrame.Parent = PageKanan

local UICornerResult = Instance.new("UICorner")
UICornerResult.CornerRadius = UDim.new(0, 4)
UICornerResult.Parent = ResultFrame

local ResultListLayout = Instance.new("UIListLayout")
ResultListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ResultListLayout.Padding = UDim.new(0, 2)
ResultListLayout.Parent = ResultFrame

local ConsoleLog = Instance.new("TextLabel")
ConsoleLog.Name = "ConsoleLog"
ConsoleLog.Size = UDim2.new(1, -12, 0, 32)
ConsoleLog.Position = UDim2.new(0, 6, 0, 166)
ConsoleLog.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
ConsoleLog.Text = "> Auto Copier Ready (Mobile Enabled)"
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

local function saveStorageToFile()
	if writefile then
		pcall(function()
			writefile("saved_build_data.dat", HttpService:JSONEncode(savedStorage))
		end)
	end
end

local function setConsoleMessage(text, color)
	ConsoleLog.Text = "> " .. text
	ConsoleLog.TextColor3 = color or Color3.fromRGB(150, 255, 150)
end

--------------------------------------------------
-- FUNGSI GENERATOR CODE MATERIAL SCRIPT SERVER
--------------------------------------------------
local function generateServerScriptCode(voxelList)
	if not voxelList or #voxelList == 0 then return nil end

	local char = LocalPlayer.Character
	local spawnPointStr = "Vector3.new(0, 50, 0)"
	if char and char:FindFirstChild("HumanoidRootPart") then
		local pos = char.HumanoidRootPart.Position
		spawnPointStr = string.format("Vector3.new(%d, %d, %d)", math.round(pos.X), math.round(pos.Y), math.round(pos.Z))
	end

	local lines = {}
	table.insert(lines, "-- ======================================================")
	table.insert(lines, "-- TERRAIN MATERIAL SCRIPT (PASTE KE SERVERSCRIPTSERVICE)")
	table.insert(lines, "-- GENERATED BY @IkyyXD (MOBILE SUPPORT)")
	table.insert(lines, "-- ======================================================")
	table.insert(lines, "local Terrain = workspace.Terrain")
	table.insert(lines, "local TargetBasePos = " .. spawnPointStr)
	table.insert(lines, "")
	table.insert(lines, "local VoxelData = {")

	for _, item in ipairs(voxelList) do
		local relX, relY, relZ = unpack(item.RelPos)
		table.insert(lines, string.format("\t{ RelPos = Vector3.new(%d, %d, %d), Mat = Enum.Material.%s },", relX, relY, relZ, item.Material))
	end

	table.insert(lines, "}")
	table.insert(lines, "")
	table.insert(lines, "print('[SERVER] Spawning ' .. #VoxelData .. ' Terrain Voxels...')")
	table.insert(lines, "task.spawn(function()")
	table.insert(lines, "\tfor i, v in ipairs(VoxelData) do")
	table.insert(lines, "\t\tlocal spawnPos = TargetBasePos + v.RelPos")
	table.insert(lines, "\t\tTerrain:FillBlock(CFrame.new(spawnPos), Vector3.new(4, 4, 4), v.Mat)")
	table.insert(lines, "\t\tif i % 50 == 0 then task.wait() end")
	table.insert(lines, "\tend")
	table.insert(lines, "\tprint('[SERVER] Terrain Generation Complete!')")
	table.insert(lines, "end)")

	return table.concat(lines, "\n")
end

--------------------------------------------------
-- FUNGSI SCAN AUTOMATIS TERRAIN & PRECISE OFFSET
--------------------------------------------------
local function autoScanTerrain()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then
		setConsoleMessage("Character not found!", Color3.fromRGB(255, 100, 100))
		return {}
	end

	local centerPos = char.HumanoidRootPart.Position
	local scanRadius = Vector3.new(24, 16, 24)
	local minPoint = centerPos - (scanRadius / 2)
	local maxPoint = centerPos + (scanRadius / 2)

	local region = Region3.new(minPoint, maxPoint):ExpandToGrid(4)
	local materials, occupancy = Terrain:ReadVoxels(region, 4)
	local size = materials.Size

	local voxels = {}
	local validMaterials = {
		[Enum.Material.Grass] = true,
		[Enum.Material.Rock]  = true,
		[Enum.Material.Sand]  = true
	}

	local count = 0
	for x = 1, size.X do
		for y = 1, size.Y do
			for z = 1, size.Z do
				local mat = materials[x][y][z]
				local occ = occupancy[x][y][z]
				if occ > 0 and validMaterials[mat] then
					local voxelWorldPos = region.CFrame.Position - (region.Size/2) + Vector3.new(x*4 - 2, y*4 - 2, z*4 - 2)
					local relPos = voxelWorldPos - centerPos

					table.insert(voxels, {
						RelPos = {math.round(relPos.X), math.round(relPos.Y), math.round(relPos.Z)},
						Material = mat.Name
					})
					count = count + 1
				end
			end
		end
	end

	setConsoleMessage("Auto Scanned " .. count .. " Voxels!", Color3.fromRGB(100, 255, 200))
	return voxels
end

-- Eksekusi Paste yang Mendukung Mobile (Touch Screen Fallback)
local function executePrecisePaste(voxelList)
	if not voxelList or #voxelList == 0 then return end
	
	local targetPos
	local char = LocalPlayer.Character
	
	-- Pengecekan posisi target (Mendukung Mouse PC dan Tap Mobile/Karakter Pos)
	if Mouse and Mouse.Target then
		targetPos = Mouse.Hit.Position
	elseif char and char:FindFirstChild("HumanoidRootPart") then
		targetPos = char.HumanoidRootPart.Position + (char.HumanoidRootPart.CFrame.LookVector * 10)
	else
		setConsoleMessage("No target position found!", Color3.fromRGB(255, 100, 100))
		return
	end

	local gridTargetPos = Vector3.new(
		math.floor(targetPos.X / 4 + 0.5) * 4,
		math.floor(targetPos.Y / 4 + 0.5) * 4,
		math.floor(targetPos.Z / 4 + 0.5) * 4
	)

	local total = #voxelList

	task.spawn(function()
		for i, item in ipairs(voxelList) do
			local relVec = Vector3.new(unpack(item.RelPos))
			local spawnPos = gridTargetPos + relVec
			local matEnum = Enum.Material[item.Material] or Enum.Material.Grass

			Terrain:FillBlock(CFrame.new(spawnPos), Vector3.new(4, 4, 4), matEnum)

			if i % 25 == 0 then
				local percent = math.floor((i / total) * 100)
				setConsoleMessage(string.format("[PASTING %d/%d] (%d%%)", i, total, percent), Color3.fromRGB(100, 200, 255))
				task.wait()
			end
		end
		setConsoleMessage("Pasted " .. total .. " Voxels Perfectly!", Color3.fromRGB(150, 255, 150))
	end)
end

--------------------------------------------------
-- TOMBOL AKSI & HANDLER
--------------------------------------------------
CopyScriptBtn.MouseButton1Click:Connect(function()
	local activeList = scannedVoxelsBuffer
	if #activeList == 0 and #savedStorage > 0 then
		activeList = savedStorage[#savedStorage].Voxels
	end

	if not activeList or #activeList == 0 then
		setConsoleMessage("No terrain scanned to copy!", Color3.fromRGB(255, 100, 100))
		return
	end

	local scriptCode = generateServerScriptCode(activeList)
	if scriptCode then
		print("\n" .. scriptCode .. "\n")
		
		if setclipboard then
			setclipboard(scriptCode)
			setConsoleMessage("Script Copied & Printed to Console!", Color3.fromRGB(100, 255, 150))
		else
			setConsoleMessage("Printed to Console (Press F9/DevConsole)!", Color3.fromRGB(255, 255, 100))
		end
	end
end)

AutoScanBtn.MouseButton1Click:Connect(function()
	scannedVoxelsBuffer = autoScanTerrain()
end)

QuickCopyBtn.MouseButton1Click:Connect(function()
	local voxels = autoScanTerrain()
	if #voxels == 0 then return end

	scannedVoxelsBuffer = voxels
	local payload = {
		Title = "Scan " .. (#savedStorage + 1),
		Voxels = voxels
	}
	table.insert(savedStorage, payload)
	saveStorageToFile()
	refreshResultList()
	setConsoleMessage("Auto Scanned & Saved (" .. #voxels .. " voxels)", Color3.fromRGB(150, 255, 150))
end)

ClearBtn.MouseButton1Click:Connect(function()
	savedStorage = {}
	multiSelectedMap = {}
	scannedVoxelsBuffer = {}
	saveStorageToFile()
	refreshResultList()
	setConsoleMessage("Storage cleared!")
end)

SaveBtn.MouseButton1Click:Connect(function()
	saveStorageToFile()
	setConsoleMessage("Saved data to file successfully")
end)

-- Refresh List
refreshResultList = function()
	closeAllDropdowns()
	for _, btn in ipairs(listButtons) do
		btn:Destroy()
	end
	listButtons = {}

	for idx, itemData in ipairs(savedStorage) do
		local isMultiSelected = multiSelectedMap[idx]

		local itemFrame = Instance.new("Frame")
		itemFrame.Size = UDim2.new(1, -4, 0, 18)
		itemFrame.LayoutOrder = idx
		itemFrame.BackgroundColor3 = isMultiSelected and Color3.fromRGB(80, 50, 50) or Color3.fromRGB(25, 25, 25)
		itemFrame.Parent = ResultFrame

		local cornerFrame = Instance.new("UICorner")
		cornerFrame.CornerRadius = UDim.new(0, 3)
		cornerFrame.Parent = itemFrame

		local itemMenuBtn = Instance.new("TextButton")
		itemMenuBtn.Size = UDim2.new(0, 16, 1, 0)
		itemMenuBtn.Position = UDim2.new(0, 2, 0, 0)
		itemMenuBtn.BackgroundTransparency = 1
		itemMenuBtn.Text = "⋮"
		itemMenuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		itemMenuBtn.TextSize = 10
		itemMenuBtn.Font = Enum.Font.SourceSansBold
		itemMenuBtn.ZIndex = 2
		itemMenuBtn.Parent = itemFrame

		local itemBtn = Instance.new("TextButton")
		itemBtn.Size = UDim2.new(1, -20, 1, 0)
		itemBtn.Position = UDim2.new(0, 20, 0, 0)
		itemBtn.BackgroundTransparency = 1
		itemBtn.Text = idx .. ". " .. itemData.Title .. " (" .. #itemData.Voxels .. ")"
		itemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
		itemBtn.TextXAlignment = Enum.TextXAlignment.Left
		itemBtn.TextSize = 8
		itemBtn.Font = Enum.Font.SourceSans
		itemBtn.Parent = itemFrame

		itemBtn.MouseButton1Click:Connect(function()
			scannedVoxelsBuffer = itemData.Voxels
			executePrecisePaste(itemData.Voxels)
		end)

		itemMenuBtn.MouseButton1Click:Connect(function()
			closeAllDropdowns()
			DropdownOverlay.Visible = true

			local popMenu = Instance.new("Frame")
			popMenu.Size = UDim2.new(0, 65, 0, 20)
			popMenu.Position = UDim2.new(0, 20, 0, math.clamp(itemFrame.AbsolutePosition.Y - ResultFrame.AbsolutePosition.Y + 100, 10, 180))
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
				saveStorageToFile()
				refreshResultList()
				setConsoleMessage("Item deleted from storage")
			end)
		end)

		table.insert(listButtons, itemFrame)
	end

	ResultFrame.CanvasSize = UDim2.new(0, 0, 0, ResultListLayout.AbsoluteContentSize.Y)
end

-- Header Dropdown Menu
HeaderMenuBtn.MouseButton1Click:Connect(function()
	if DropdownOverlay.Visible then
		closeAllDropdowns()
		return
	end
	closeAllDropdowns()
	DropdownOverlay.Visible = true

	local menuFrame = Instance.new("Frame")
	menuFrame.Size = UDim2.new(0, 90, 0, 40)
	menuFrame.Position = UDim2.new(1, -95, 0, 22)
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
	selectAllBtn.Size = UDim2.new(1, 0, 0, 19)
	selectAllBtn.BackgroundTransparency = 1
	selectAllBtn.Text = "☑️ Select All"
	selectAllBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	selectAllBtn.TextSize = 8
	selectAllBtn.Font = Enum.Font.SourceSans
	selectAllBtn.ZIndex = 12
	selectAllBtn.Parent = menuFrame

	local deleteSelectedBtn = Instance.new("TextButton")
	deleteSelectedBtn.Size = UDim2.new(1, 0, 0, 19)
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
		saveStorageToFile()
		refreshResultList()
		setConsoleMessage("Selected items deleted")
	end)
end)

DropdownOverlay.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		closeAllDropdowns()
	end
end)

-- Auto Load Storage
if readfile and isfile and isfile("saved_build_data.dat") then
	pcall(function()
		local content = readfile("saved_build_data.dat")
		local decoded = HttpService:JSONEncode(content)
		if type(decoded) == "table" then
			savedStorage = decoded
			refreshResultList()
			setConsoleMessage("Loaded saved terrain data")
		end
	end)
end
