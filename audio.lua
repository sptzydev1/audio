-- ======================================================
-- REMOTE & MULTI-PART COPY & PASTE TOOL (DARK WHITE)
-- COPYRIGHT (C) IkyyXD - ALL RIGHTS RESERVED
-- ======================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Fungsi Helper untuk Log Output Roblox Studio Lite
local function logInfo(message)
	print("[IkyyXD CopyTool] " .. message)
end

local function logError(message)
	warn("[IkyyXD CopyTool - ERROR] " .. message)
end

logInfo("Initializing Script by IkyyXD...")

-- Clean up GUI lama jika ada
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DeltaCopyToolGui")
if oldGui then oldGui:Destroy() end

--------------------------------------------------
-- 1. TAMPILAN GUI KOMPAK & FLOATING ICON (DARK WHITE)
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCopyToolGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Icon Floating Button (Draggable & Animated)
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

-- Main Frame (Design Dark White)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 350)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -175)
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

-- Gradient untuk Animasi Sinar Putih Berjalan pada Pinggiran Border
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

--------------------------------------------------
-- ANIMASI BERJALAN PINGGIRAN (WHITE GLOW ANIMATION)
--------------------------------------------------
local rotationAngle = 0
RunService.RenderStepped:Connect(function(dt)
	rotationAngle = (rotationAngle + (dt * 120)) % 360
	UIGradientIcon.Rotation = rotationAngle
	UIGradientMain.Rotation = rotationAngle
end)

-- Header Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.Position = UDim2.new(0, 0, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "PART COPIER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -16, 0, 18)
StatusLabel.Position = UDim2.new(0, 8, 0, 26)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Fitur Copy: NONAKTIF [OFF]"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Parent = MainFrame

-- Copyright Label Watermark
local CopyrightLabel = Instance.new("TextLabel")
CopyrightLabel.Size = UDim2.new(1, -16, 0, 16)
CopyrightLabel.Position = UDim2.new(0, 8, 1, -18)
CopyrightLabel.BackgroundTransparency = 1
CopyrightLabel.Text = "© Copyright IkyyXD"
CopyrightLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
CopyrightLabel.TextSize = 10
CopyrightLabel.Font = Enum.Font.SourceSansItalic
CopyrightLabel.Parent = MainFrame

--------------------------------------------------
-- 2. INPUT SEARCH & CONTAINER TOMBOL
--------------------------------------------------
local SearchInput = Instance.new("TextBox")
SearchInput.Size = UDim2.new(1, -16, 0, 28)
SearchInput.Position = UDim2.new(0, 8, 0, 46)
SearchInput.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
SearchInput.PlaceholderText = "Ketik Nama Model/Folder..."
SearchInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
SearchInput.Text = ""
SearchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchInput.TextSize = 12
SearchInput.Font = Enum.Font.SourceSans
SearchInput.Parent = MainFrame

local UICornerInput = Instance.new("UICorner")
UICornerInput.CornerRadius = UDim.new(0, 6)
UICornerInput.Parent = SearchInput

local UIStrokeInput = Instance.new("UIStroke")
UIStrokeInput.Color = Color3.fromRGB(60, 60, 60)
UIStrokeInput.Thickness = 1
UIStrokeInput.Parent = SearchInput

-- Container Tombol
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -16, 1, -100)
Container.Position = UDim2.new(0, 8, 0, 80)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Container

local function createButton(name, text, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.LayoutOrder = order
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(240, 240, 240)
	btn.TextSize = 12
	btn.Font = Enum.Font.SourceSansBold
	btn.Parent = Container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(80, 80, 80)
	stroke.Thickness = 1
	stroke.Parent = btn
	
	return btn
end

local ToggleCopyBtn    = createButton("ToggleCopyBtn", "Fitur Copy: OFF", 1)
local SearchSelectBtn  = createButton("SearchSelectBtn", "Pilih Objek via Nama", 2)
local ClearBtn         = createButton("ClearBtn", "Batal / Reset Pilihan", 3)
local SaveBtn          = createButton("SaveBtn", "Simpan ke File JSON", 4)
local CopyClipboardBtn = createButton("CopyClipboardBtn", "Salin JSON ke Clipboard", 5)
local PasteBtn         = createButton("PasteBtn", "Tempel (Paste) di Game", 6)

--------------------------------------------------
-- 3. LOGIKA COPY JARAK JAUH & SERIALIZATION
--------------------------------------------------
local isCopyEnabled = false
local selectedPartsList = {}

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local function updateStatus(msg)
	if msg then
		StatusLabel.Text = msg
	else
		if not isCopyEnabled then
			StatusLabel.Text = "Fitur Copy: NONAKTIF [OFF]"
			StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		else
			StatusLabel.Text = "Status: Aktif (" .. #selectedPartsList .. " Part)"
			StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
end

-- Toggle ON/OFF
ToggleCopyBtn.MouseButton1Click:Connect(function()
	isCopyEnabled = not isCopyEnabled
	if isCopyEnabled then
		ToggleCopyBtn.Text = "Fitur Copy: AKTIF [ON]"
		ToggleCopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		ToggleCopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		logInfo("Fitur Copy Diaktifkan.")
	else
		ToggleCopyBtn.Text = "Fitur Copy: NONAKTIF [OFF]"
		ToggleCopyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		ToggleCopyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
		logInfo("Fitur Copy Dimatikan.")
	end
	updateStatus()
end)

-- Rekursif Pengumpulkan Part
local function collectParts(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("BasePart") then
			table.insert(selectedPartsList, child)
		end
		collectParts(child)
	end
end

-- Cari Objek Berdasarkan Nama (Remote Copy)
SearchSelectBtn.MouseButton1Click:Connect(function()
	if not isCopyEnabled then
		updateStatus("Aktifkan Fitur Copy Dulu!")
		logError("Gagal memilih: Fitur Copy belum diaktifkan!")
		return
	end
	
	local query = SearchInput.Text
	if query == "" then
		updateStatus("Ketik nama Model/Folder!")
		logError("Pencarian gagal: Kolom nama kosong.")
		return
	end
	
	selectedPartsList = {}
	local countFound = 0
	
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name:lower() == query:lower() then
			if obj:IsA("BasePart") then
				table.insert(selectedPartsList, obj)
				countFound = countFound + 1
			elseif obj:IsA("Model") or obj:IsA("Folder") then
				collectParts(obj)
				countFound = countFound + 1
			end
		end
	end
	
	if countFound > 0 then
		updateStatus("Terpilih " .. #selectedPartsList .. " Part!")
		logInfo("Ditemukan " .. countFound .. " objek cocok. Total " .. #selectedPartsList .. " part berhasil dipilih.")
	else
		updateStatus("Objek '" .. query .. "' tidak ada!")
		logError("Objek dengan nama '" .. query .. "' tidak ditemukan di Workspace.")
	end
end)

-- Reset Pilihan
ClearBtn.MouseButton1Click:Connect(function()
	selectedPartsList = {}
	updateStatus()
	logInfo("Pilihan part berhasil di-reset.")
end)

-- Serialisasi Data Part
local function serializeParts()
	local data = {}
	for _, part in ipairs(selectedPartsList) do
		if part and part.Parent then
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

-- Simpan File JSON
SaveBtn.MouseButton1Click:Connect(function()
	if not isCopyEnabled then return end
	local data = serializeParts()
	if #data == 0 then
		updateStatus("Gagal: Belum ada part!")
		logError("Gagal menyimpan: Belum ada part yang dipilih.")
		return
	end
	
	local jsonStr = HttpService:JSONEncode(data)
	if writefile then
		writefile("copied_parts.json", jsonStr)
		updateStatus("Tersimpan di JSON!")
		logInfo("Berhasil menyimpan " .. #data .. " part ke file 'copied_parts.json'.")
	else
		updateStatus("Error: No writefile support")
		logError("Eksekutor tidak mendukung fungsi 'writefile'.")
	end
end)

-- Salin Clipboard
CopyClipboardBtn.MouseButton1Click:Connect(function()
	if not isCopyEnabled then return end
	local data = serializeParts()
	if #data == 0 then
		updateStatus("Gagal: Belum ada part!")
		logError("Gagal menyalin: Belum ada part yang dipilih.")
		return
	end
	
	local jsonStr = HttpService:JSONEncode(data)
	if setclipboard then
		setclipboard(jsonStr)
		updateStatus("Disalin ke Clipboard!")
		logInfo("Berhasil menyalin data " .. #data .. " part ke Clipboard.")
	else
		updateStatus("Error: No setclipboard support")
		logError("Eksekutor tidak mendukung fungsi 'setclipboard'.")
	end
end)

-- Tempel (Paste) di Game & Output Log Roblox Studio
PasteBtn.MouseButton1Click:Connect(function()
	local jsonStr = nil
	
	if readfile and pcall(function() jsonStr = readfile("copied_parts.json") end) then
		logInfo("Membaca data dari file 'copied_parts.json'...")
	elseif getclipboard then
		jsonStr = getclipboard()
		logInfo("Membaca data dari Clipboard...")
	end
	
	if not jsonStr or jsonStr == "" then
		updateStatus("Error: Data JSON kosong!")
		logError("Gagal melakukan Paste: Data JSON tidak ditemukan.")
		return
	end
	
	local success, data = pcall(function()
		return HttpService:JSONDecode(jsonStr)
	end)
	
	if not success or type(data) ~= "table" then
		updateStatus("Error: Format JSON salah!")
		logError("Gagal membaca JSON: Format data rusak atau tidak valid.")
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
	
	local pasteMessage = "Berhasil menempel " .. count .. " Part ke dalam Workspace!"
	updateStatus("Berhasil Paste " .. count .. " Part!")
	
	-- Menampilkan Log Output Roblox Studio Lite
	logInfo("========================================")
	logInfo("PASTE SUCCESSFUL!")
	logInfo(pasteMessage)
	logInfo("Folder Target: Workspace." .. folder.Name)
	logInfo("Copyright (C) IkyyXD")
	logInfo("========================================")
end)

logInfo("Script loaded successfully. Created by IkyyXD.")
