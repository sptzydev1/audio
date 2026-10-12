-- ======================================================
-- STARTERGUI COPIER & PASTER (CLEAN SOURCE FIX)
-- COPYRIGHT (C) IkyyXD - ALL RIGHTS RESERVED
-- ======================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local guiName = "Project GUI"
pcall(function()
	if game.Name and game.Name ~= "" then
		guiName = game.Name
	end
end)

local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("IkyyGuiCopyTool")
if oldGui then oldGui:Destroy() end

--------------------------------------------------
-- 1. UTAMA: SCREEN GUI & FLOATING ICON
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyGuiCopyTool"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 32, 0, 32)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -16)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "🗂️"
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 200)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -100)
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
-- 2. WATERMARK BAWAH (@IkyyXD)
--------------------------------------------------
local BottomWatermark = Instance.new("TextLabel")
BottomWatermark.Size = UDim2.new(1, 0, 0, 16)
BottomWatermark.Position = UDim2.new(0, 0, 1, -16)
BottomWatermark.BackgroundTransparency = 1
BottomWatermark.Text = "StarterGui Copier by @IkyyXD"
BottomWatermark.TextColor3 = Color3.fromRGB(150, 150, 150)
BottomWatermark.TextSize = 10
BottomWatermark.Font = Enum.Font.SourceSansBold
BottomWatermark.Parent = MainFrame

--------------------------------------------------
-- 3. PANEL KIRI: INFO & PANDUAN
--------------------------------------------------
local PageKiri = Instance.new("Frame")
PageKiri.Size = UDim2.new(0, 130, 1, -22)
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
TitleKiri.Text = "INFO FITUR"
TitleKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKiri.TextSize = 10
TitleKiri.Font = Enum.Font.SourceSansBold
TitleKiri.Parent = PageKiri

local InfoContainer = Instance.new("TextLabel")
InfoContainer.Size = UDim2.new(1, -12, 1, -26)
InfoContainer.Position = UDim2.new(0, 6, 0, 22)
InfoContainer.BackgroundTransparency = 1
InfoContainer.Text = "• Clean Source Fix\n• Target: StarterGui\n• Support ScreenGui\n• Auto Save File\n• Aman untuk Studio"
InfoContainer.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoContainer.TextSize = 9
InfoContainer.Font = Enum.Font.SourceSans
InfoContainer.TextXAlignment = Enum.TextXAlignment.Left
InfoContainer.TextYAlignment = Enum.TextYAlignment.Top
InfoContainer.Parent = PageKiri

--------------------------------------------------
-- 4. PANEL KANAN: KONTROL & LIST DATA
--------------------------------------------------
local PageKanan = Instance.new("Frame")
PageKanan.Size = UDim2.new(0, 268, 1, -22)
PageKanan.Position = UDim2.new(0, 142, 0, 6)
PageKanan.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PageKanan.Parent = MainFrame

local UICornerKanan = Instance.new("UICorner")
UICornerKanan.CornerRadius = UDim.new(0, 6)
UICornerKanan.Parent = PageKanan

local TitleKanan = Instance.new("TextLabel")
TitleKanan.Size = UDim2.new(1, -12, 0, 18)
TitleKanan.Position = UDim2.new(0, 6, 0, 2)
TitleKanan.BackgroundTransparency = 1
TitleKanan.Text = "STARTERGUI STORAGE"
TitleKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKanan.TextSize = 10
TitleKanan.Font = Enum.Font.SourceSansBold
TitleKanan.TextXAlignment = Enum.TextXAlignment.Left
TitleKanan.Parent = PageKanan

local CopyAllBtn = Instance.new("TextButton")
CopyAllBtn.Size = UDim2.new(1, -12, 0, 20)
CopyAllBtn.Position = UDim2.new(0, 6, 0, 22)
CopyAllBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
CopyAllBtn.Text = "📥 Copy Semua dari StarterGui"
CopyAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyAllBtn.TextSize = 9
CopyAllBtn.Font = Enum.Font.SourceSansBold
CopyAllBtn.Parent = PageKanan

local UICornerCopyBtn = Instance.new("UICorner")
UICornerCopyBtn.CornerRadius = UDim.new(0, 4)
UICornerCopyBtn.Parent = CopyAllBtn

local ResultFrame = Instance.new("ScrollingFrame")
ResultFrame.Size = UDim2.new(1, -12, 0, 75)
ResultFrame.Position = UDim2.new(0, 6, 0, 46)
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
ConsoleLog.Position = UDim2.new(0, 6, 0, 126)
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
-- 5. FUNGSI MEMBERSIHKAN TAG HTML KODE
--------------------------------------------------
local function cleanHtmlTags(str)
	if type(str) ~= "string" then return str end
	-- Menghapus tag HTML seperti <font ...> dan </font> atau <b> </b>
	local clean = str:gsub("<[^>]+>", "")
	return clean
end

--------------------------------------------------
-- 6. SERIALIZER & DESERIALIZER MENDALAM KHUSUS GUI
--------------------------------------------------
local savedStorage = {}
local listButtons = {}

local function saveStorageToFile()
	if writefile then
		pcall(function()
			writefile("saved_gui_data.dat", HttpService:JSONEncode(savedStorage))
		end)
	end
end

local function setConsoleMessage(text, color)
	ConsoleLog.Text = "> " .. text
	ConsoleLog.TextColor3 = color or Color3.fromRGB(150, 255, 150)
end

local function serializeGuiDeep(inst)
	local data = {
		Name = inst.Name,
		ClassName = inst.ClassName,
		Children = {}
	}

	pcall(function()
		if inst:IsA("GuiObject") then
			data.Size = {inst.Size.X.Scale, inst.Size.X.Offset, inst.Size.Y.Scale, inst.Size.Y.Offset}
			data.Position = {inst.Position.X.Scale, inst.Position.X.Offset, inst.Position.Y.Scale, inst.Position.Y.Offset}
			data.BackgroundColor3 = {inst.BackgroundColor3.R, inst.BackgroundColor3.G, inst.BackgroundColor3.B}
			data.BackgroundTransparency = inst.BackgroundTransparency
			data.Visible = inst.Visible
			data.ZIndex = inst.ZIndex
			data.Rotation = inst.Rotation
		end

		if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
			data.Text = inst.Text
			data.TextColor3 = {inst.TextColor3.R, inst.TextColor3.G, inst.TextColor3.B}
			data.TextSize = inst.TextSize
			data.Font = inst.Font.Name
			data.TextXAlignment = inst.TextXAlignment.Name
			data.TextYAlignment = inst.TextYAlignment.Name
			data.TextWrapped = inst.TextWrapped
		end

		if inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
			data.Image = inst.Image
			data.ImageColor3 = {inst.ImageColor3.R, inst.ImageColor3.G, inst.ImageColor3.B}
			data.ImageTransparency = inst.ImageTransparency
		end

		if inst:IsA("ScrollingFrame") then
			data.CanvasSize = {inst.CanvasSize.X.Scale, inst.CanvasSize.X.Offset, inst.CanvasSize.Y.Scale, inst.CanvasSize.Y.Offset}
			data.ScrollBarThickness = inst.ScrollBarThickness
		end
		
		if inst:IsA("UIStroke") then
			data.Thickness = inst.Thickness
			data.Color = {inst.Color.R, inst.Color.G, inst.Color.B}
			data.Transparency = inst.Transparency
		end

		if inst:IsA("UICorner") then
			data.CornerRadiusScale = inst.CornerRadius.Scale
			data.CornerRadiusOffset = inst.CornerRadius.Offset
		end
		
		if inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
			-- Membersihkan tag HTML dari sumber kode agar kembali murni
			data.ScriptSource = cleanHtmlTags(inst.Source)
		end
	end)

	for _, child in ipairs(inst:GetChildren()) do
		table.insert(data.Children, serializeGuiDeep(child))
	end

	return data
end

local function deserializeGuiDeep(data)
	local inst
	pcall(function()
		inst = Instance.new(data.ClassName)
	end)

	if not inst then
		inst = Instance.new("Folder")
	end

	inst.Name = data.Name or "PastedGUI"

	pcall(function()
		if inst:IsA("GuiObject") and data.Size then
			inst.Size = UDim2.new(unpack(data.Size))
		end
		if inst:IsA("GuiObject") and data.Position then
			inst.Position = UDim2.new(unpack(data.Position))
		end
		if inst:IsA("GuiObject") and data.BackgroundColor3 then
			inst.BackgroundColor3 = Color3.new(unpack(data.BackgroundColor3))
		end
		if inst:IsA("GuiObject") and data.BackgroundTransparency then inst.BackgroundTransparency = data.BackgroundTransparency end
		if inst:IsA("GuiObject") and data.Visible ~= nil then inst.Visible = data.Visible end
		if inst:IsA("GuiObject") and data.ZIndex then inst.ZIndex = data.ZIndex end
		if inst:IsA("GuiObject") and data.Rotation then inst.Rotation = data.Rotation end

		if (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then
			if data.Text then inst.Text = data.Text end
			if data.TextColor3 then inst.TextColor3 = Color3.new(unpack(data.TextColor3)) end
			if data.TextSize then inst.TextSize = data.TextSize end
			if data.Font and Enum.Font[data.Font] then inst.Font = Enum.Font[data.Font] end
			if data.TextXAlignment and Enum.TextXAlignment[data.TextXAlignment] then inst.TextXAlignment = Enum.TextXAlignment[data.TextXAlignment] end
			if data.TextYAlignment and Enum.TextYAlignment[data.TextYAlignment] then inst.TextYAlignment = Enum.TextYAlignment[data.TextYAlignment] end
			if data.TextWrapped ~= nil then inst.TextWrapped = data.TextWrapped end
		end

		if (inst:IsA("ImageLabel") or inst:IsA("ImageButton")) then
			if data.Image then inst.Image = data.Image end
			if data.ImageColor3 then inst.ImageColor3 = Color3.new(unpack(data.ImageColor3)) end
			if data.ImageTransparency then inst.ImageTransparency = data.ImageTransparency end
		end

		if inst:IsA("ScrollingFrame") then
			if data.CanvasSize then inst.CanvasSize = UDim2.new(unpack(data.CanvasSize)) end
			if data.ScrollBarThickness then inst.ScrollBarThickness = inst.ScrollBarThickness end
		end
		
		if inst:IsA("UIStroke") then
			if data.Thickness then inst.Thickness = data.Thickness end
			if data.Color then inst.Color = Color3.new(unpack(data.Color)) end
			if data.Transparency then inst.Transparency = data.Transparency end
		end

		if inst:IsA("UICorner") then
			if data.CornerRadiusScale and data.CornerRadiusOffset then
				inst.CornerRadius = UDim.new(data.CornerRadiusScale, data.CornerRadiusOffset)
			end
		end
		
		if (inst:IsA("LocalScript") or inst:IsA("ModuleScript")) and data.ScriptSource then
			inst.Source = data.ScriptSource
		end
	end)

	if data.Children then
		for _, childData in ipairs(data.Children) do
			local childInst = deserializeGuiDeep(childData)
			if childInst then
				childInst.Parent = inst
			end
		end
	end

	return inst
end

--------------------------------------------------
-- 7. FUNGSI TOMBOL INTERAKSI & REFRESH LIST
--------------------------------------------------
local function refreshResultList()
	for _, btn in ipairs(listButtons) do
		btn:Destroy()
	end
	listButtons = {}

	for idx, itemData in ipairs(savedStorage) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Size = UDim2.new(1, -4, 0, 18)
		itemFrame.LayoutOrder = idx
		itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		itemFrame.Parent = ResultFrame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 3)
		corner.Parent = itemFrame

		local pasteBtn = Instance.new("TextButton")
		pasteBtn.Size = UDim2.new(1, -22, 1, 0)
		pasteBtn.Position = UDim2.new(0, 4, 0, 0)
		pasteBtn.BackgroundTransparency = 1
		pasteBtn.Text = idx .. ". " .. itemData.Title .. " (" .. #itemData.Items .. " GUI)"
		pasteBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
		pasteBtn.TextXAlignment = Enum.TextXAlignment.Left
		pasteBtn.TextSize = 8
		pasteBtn.Font = Enum.Font.SourceSansBold
		pasteBtn.Parent = itemFrame

		local delBtn = Instance.new("TextButton")
		delBtn.Size = UDim2.new(0, 14, 1, 0)
		delBtn.Position = UDim2.new(1, -16, 0, 0)
		delBtn.BackgroundTransparency = 1
		delBtn.Text = "×"
		delBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
		delBtn.TextSize = 12
		delBtn.Font = Enum.Font.SourceSansBold
		delBtn.Parent = itemFrame

		pasteBtn.MouseButton1Click:Connect(function()
			setConsoleMessage("Pasting to StarterGui...", Color3.fromRGB(100, 200, 255))
			task.spawn(function()
				for _, guiData in ipairs(itemData.Items) do
					local newGui = deserializeGuiDeep(guiData)
					if newGui then
						newGui.Parent = StarterGui
					end
				end
				setConsoleMessage("Successfully pasted to StarterGui!", Color3.fromRGB(150, 255, 150))
			end)
		end)

		delBtn.MouseButton1Click:Connect(function()
			table.remove(savedStorage, idx)
			saveStorageToFile()
			refreshResultList()
			setConsoleMessage("Item deleted from storage")
		end)

		table.insert(listButtons, itemFrame)
	end

	ResultFrame.CanvasSize = UDim2.new(0, 0, 0, ResultListLayout.AbsoluteContentSize.Y)
end

CopyAllBtn.MouseButton1Click:Connect(function()
	task.spawn(function()
		local copiedItems = {}
		setConsoleMessage("Scanning StarterGui...", Color3.fromRGB(255, 220, 100))

		for _, child in ipairs(StarterGui:GetChildren()) do
			if child.Name ~= "IkyyGuiCopyTool" then
				table.insert(copiedItems, serializeGuiDeep(child))
			end
		end

		if #copiedItems == 0 then
			setConsoleMessage("StarterGui is empty!", Color3.fromRGB(255, 100, 100))
			return
		end

		local payload = {
			Title = guiName,
			Items = copiedItems
		}

		table.insert(savedStorage, payload)
		saveStorageToFile()
		refreshResultList()
		setConsoleMessage("Saved " .. #copiedItems .. " GUI from StarterGui!", Color3.fromRGB(150, 255, 150))
	end)
end)

if readfile and isfile and isfile("saved_gui_data.dat") then
	pcall(function()
		local content = readfile("saved_gui_data.dat")
		local decoded = HttpService:JSONDecode(content)
		if type(decoded) == "table" then
			savedStorage = decoded
			refreshResultList()
			setConsoleMessage("Loaded saved GUI data")
		end
	end)
end
