-- ======================================================
-- PAGE KANAN AUTO-SCAN TERRAIN & PRECISE PASTE
-- COPYRIGHT (C) IkyyXD - ALL RIGHTS RESERVED
-- ======================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
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

-- Floating Icon Kecil
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 32, 0, 32)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -16)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "⚡"
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

-- Main Frame Disesuaikan Khusus Page Kanan
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 162, 0, 235)
MainFrame.Position = UDim2.new(0.5, -81, 0.5, -117)
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
PageKanan.Size = UDim2.new(0, 150, 1, -22)
PageKanan.Position = UDim2.new(0, 6, 0, 6)
PageKanan.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKanan.Parent = MainFrame

local UICornerKanan = Instance.new("UICorner")
UICornerKanan.CornerRadius = UDim.new(0, 6)
UICornerKanan.Parent = PageKanan

local TitleKanan = Instance.new("TextLabel")
TitleKanan.Size = UDim2.new(1, -24, 0, 18)
TitleKanan.Position = UDim2.new(0, 0, 0, 2)
TitleKanan.BackgroundTransparency = 1
TitleKanan.Text = "AUTO COPIER"
TitleKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKanan.TextSize = 10
TitleKanan.Font = Enum.Font.SourceSansBold
TitleKanan.Parent = PageKanan

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
BtnContainer.Size = UDim2.new(1, -12, 0, 84)
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

local AutoScanBtn    = createActionButton("AutoScanBtn", "🔍 Auto Scan Nearby", 1)
local QuickCopyBtn   = createActionButton("QuickCopyBtn", "⚡ Scan & Save Now", 2)
local GenConsoleBtn  = createActionButton("GenConsoleBtn", "📜 Gen Code Console", 3)
local ClearBtn       = createActionButton("ClearBtn", "Reset Storage", 4)
local SaveBtn        = createActionButton("SaveBtn", "Save to File", 5)

local ResultFrame = Instance.new("ScrollingFrame")
ResultFrame.Name = "ResultFrame"
ResultFrame.Size = UDim2.new(1, -12, 0, 50)
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

local ConsoleLog = Instance.new("TextLabel")
ConsoleLog.Name = "ConsoleLog"
ConsoleLog.Size = UDim2.new(1, -12, 0, 32)
ConsoleLog.Position = UDim2.new(0, 6, 0, 162)
ConsoleLog.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
ConsoleLog.Text = "> Auto Copier Ready..."
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
-- FUNGSI SCAN AUTOMATIS TERRAIN & PRECISE OFFSET
--------------------------------------------------
local function autoScanTerrain()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then
		setConsoleMessage("Character not found!", Color3.fromRGB(255, 100, 100))
		return {}
	end

	local centerPos = char.HumanoidRootPart.Position
	local scanRadius = Vector3.new(24, 16, 24) -- Bounding Box Otomatis
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
					-- Hitung posisi spesifik voxel relatif terhadap titik tengah scan
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

-- Eksekusi Paste dengan Rapi Presisi Sesuai Titik Kursor Mouse
local function executePrecisePaste(voxelList)
	if not voxelList or #voxelList == 0 then return end
	if not Mouse.Target then
		setConsoleMessage("Target Mouse hit position missing!", Color3.fromRGB(255, 100, 100))
		return
	end

	local hitPos = Mouse.Hit.Position
	-- Pembulatan Grid (4 stud) agar hasil tempel rapi teratur
	local gridTargetPos = Vector3.new(
		math.floor(hitPos.X / 4 + 0.5) * 4,
		math.floor(hitPos.Y / 4 + 0.5) * 4,
		math.floor(hitPos.Z / 4 + 0.5) * 4
	)

	local total = #voxelList

	task.spawn(function()
		for i, item in ipairs(voxelList) do
			local relVec = Vector3.new(unpack(item.RelPos))
			local spawnPos = gridTargetPos + relVec
			local matEnum = Enum.Material[item.Material] or Enum.Material.Grass

			-- Tempel Voxel dengan Presisi Ukuran Grid Roblox
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
-- GENERATOR KODE UNTUK DEV CONSOLE (F9)
--------------------------------------------------
local function generateConsoleCode(voxelList)
	if not voxelList or #voxelList == 0 then
		setConsoleMessage("No Voxels to Generate!", Color3.fromRGB(255, 100, 100))
		return
	end

	local jsonVoxels = HttpService:JSONEncode(voxelList)
	local standaloneScript = string.format([[
-- ======================================================
-- GENERATED TERRAIN PASTE SCRIPT BY @IkyyXD
-- TOTAL VOXELS: %d
-- ======================================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Terrain = workspace.Terrain
local Mouse = Players.LocalPlayer:GetMouse()

local rawData = %q
local voxels = HttpService:JSONDecode(rawData)

if not Mouse.Target then
    warn("[IkyyCopier] Arahkan kursor mouse ke permukaan objek/terrain terlebih dahulu!")
    return
end

local hitPos = Mouse.Hit.Position
local gridTargetPos = Vector3.new(
    math.floor(hitPos.X / 4 + 0.5) * 4,
    math.floor(hitPos.Y / 4 + 0.5) * 4,
    math.floor(hitPos.Z / 4 + 0.5) * 4
)

print("[IkyyCopier] Memulai Menempel " .. #voxels .. " Voxels...")

task.spawn(function()
    for i, item in ipairs(voxels) do
        local relVec = Vector3.new(unpack(item.RelPos))
        local spawnPos = gridTargetPos + relVec
        local matEnum = Enum.Material[item.Material] or Enum.Material.Grass

        Terrain:FillBlock(CFrame.new(spawnPos), Vector3.new(4, 4, 4), matEnum)

        if i %% 25 == 0 then
            task.wait()
        end
    end
    print("[IkyyCopier] Terrain Berhasil Ditempel Secara Presisi!")
end)
]], #voxelList, jsonVoxels)

	-- Print ke Console F9 dengan format bersih
	print("\n\n" .. string.rep("=", 50))
	print("--- BEGIN GENERATED CODE (" .. #voxelList .. " VOXELS) ---")
	print(standaloneScript)
	print("--- END GENERATED CODE ---")
	print(string.rep("=", 50) .. "\n\n")

	-- Copy ke Clipboard Executor (Jika didukung)
	if setclipboard then
		setclipboard(standaloneScript)
		setConsoleMessage("Code printed to F9 & Copied to Clipboard!", Color3.fromRGB(100, 255, 150))
	else
		setConsoleMessage("Code printed to Console (F9)!", Color3.fromRGB(255, 220, 100))
	end
end

--------------------------------------------------
-- TOMBOL AKSI & HANDLER
--------------------------------------------------
AutoScanBtn.MouseButton1Click:Connect(function()
	scannedVoxelsBuffer = autoScanTerrain()
end)

QuickCopyBtn.MouseButton1Click:Connect(function()
	local voxels = autoScanTerrain()
	if #voxels == 0 then return end

	local payload = {
		Title = "Scan " .. (#savedStorage + 1),
		Voxels = voxels
	}
	table.insert(savedStorage, payload)
	saveStorageToFile()
	refreshResultList()
	setConsoleMessage("Auto Scanned & Saved (" .. #voxels .. " voxels)", Color3.fromRGB(150, 255, 150))
end)

GenConsoleBtn.MouseButton1Click:Connect(function()
	if #scannedVoxelsBuffer > 0 then
		generateConsoleCode(scannedVoxelsBuffer)
	elseif #savedStorage > 0 then
		generateConsoleCode(savedStorage[#savedStorage].Voxels)
	else
		local voxels = autoScanTerrain()
		if #voxels > 0 then
			scannedVoxelsBuffer = voxels
			generateConsoleCode(voxels)
		end
	end
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
		itemFrame.Size = UDim2.new(1, -4, 0, 16)
		itemFrame.LayoutOrder = idx
		itemFrame.BackgroundColor3 = isMultiSelected and Color3.fromRGB(80, 50, 50) or Color3.fromRGB(25, 25, 25)
		itemFrame.Parent = ResultFrame

		local cornerFrame = Instance.new("UICorner")
		cornerFrame.CornerRadius = UDim.new(0, 3)
		cornerFrame.Parent = itemFrame

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

		local itemBtn = Instance.new("TextButton")
		itemBtn.Size = UDim2.new(1, -18, 1, 0)
		itemBtn.Position = UDim2.new(0, 18, 0, 0)
		itemBtn.BackgroundTransparency = 1
		itemBtn.Text = idx .. ". " .. itemData.Title .. " (" .. #itemData.Voxels .. ")"
		itemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
		itemBtn.TextXAlignment = Enum.TextXAlignment.Left
		itemBtn.TextSize = 8
		itemBtn.Font = Enum.Font.SourceSans
		itemBtn.Parent = itemFrame

		-- Klik Item untuk Langsung Paste Presisi
		itemBtn.MouseButton1Click:Connect(function()
			executePrecisePaste(itemData.Voxels)
		end)

		itemMenuBtn.MouseButton1Click:Connect(function()
			closeAllDropdowns()
			DropdownOverlay.Visible = true

			local popMenu = Instance.new("Frame")
			popMenu.Size = UDim2.new(0, 75, 0, 34)
			popMenu.Position = UDim2.new(0, 20, 0, math.clamp(itemFrame.AbsolutePosition.Y - ResultFrame.AbsolutePosition.Y + 108, 10, 180))
			popMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			popMenu.ZIndex = 11
			popMenu.Parent = DropdownOverlay

			local popCorner = Instance.new("UICorner")
			popCorner.CornerRadius = UDim.new(0, 3)
			popCorner.Parent = popMenu

			local popLayout = Instance.new("UIListLayout")
			popLayout.SortOrder = Enum.SortOrder.LayoutOrder
			popLayout.Parent = popMenu

			local genItemBtn = Instance.new("TextButton")
			genItemBtn.Size = UDim2.new(1, 0, 0, 17)
			genItemBtn.BackgroundTransparency = 1
			genItemBtn.Text = "📜 Gen Code"
			genItemBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
			genItemBtn.TextSize = 8
			genItemBtn.Font = Enum.Font.SourceSansBold
			genItemBtn.ZIndex = 12
			genItemBtn.Parent = popMenu

			local delBtn = Instance.new("TextButton")
			delBtn.Size = UDim2.new(1, 0, 0, 17)
			delBtn.BackgroundTransparency = 1
			delBtn.Text = "🗑️ Hapus"
			delBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
			delBtn.TextSize = 8
			delBtn.Font = Enum.Font.SourceSansBold
			delBtn.ZIndex = 12
			delBtn.Parent = popMenu

			genItemBtn.MouseButton1Click:Connect(function()
				generateConsoleCode(itemData.Voxels)
				closeAllDropdowns()
			end)

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
		saveStorageToFile()
		refreshResultList()
		setConsoleMessage("Selected items deleted")
	end)
end)

DropdownOverlay.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
