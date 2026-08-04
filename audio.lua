-- ========================================================
-- DELTA EXECUTOR CHAT SYSTEM WITH AUTO-BYPASS FONT
-- ========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Chat = game:GetService("Chat")

local LocalPlayer = Players.LocalPlayer

-- Hapus GUI lama jika ada
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DeltaChatGui")
if oldGui then oldGui:Destroy() end

-----------------------------------------------------------
-- 1. FUNGSI CONVERTER BYPASS FONT (MENGGANTI KARAKTER)
-----------------------------------------------------------
local function BypassText(text)
	-- Mengganti karakter latin standar ke karakter Cyrillic/Unicode khusus 
	-- agar sistem sensor AI Roblox sulit mendeteksinya sebagai kata sensitif
	local charMap = {
		["a"] = "а", ["b"] = "b", ["c"] = "с", ["d"] = "ԁ",
		["e"] = "е", ["f"] = "f", ["g"] = "ɡ", ["h"] = "һ",
		["i"] = "і", ["j"] = "ϳ", ["k"] = "k", ["l"] = "l",
		["m"] = "m", ["n"] = "n", ["o"] = "о", ["p"] = "р",
		["q"] = "ԛ", ["r"] = "r", ["s"] = "ѕ", ["t"] = "t",
		["u"] = "υ", ["v"] = "ν", ["w"] = "ѡ", ["x"] = "х",
		["y"] = "у", ["z"] = "z",
		["A"] = "А", ["B"] = "В", ["C"] = "С", ["E"] = "Е",
		["H"] = "Н", ["I"] = "І", ["J"] = "Ј", ["K"] = "К",
		["M"] = "М", ["O"] = "О", ["P"] = "Р", ["S"] = "Ѕ",
		["T"] = "Т", ["X"] = "Х", ["Y"] = "Ү"
	}
	
	local bypassed = ""
	for i = 1, #text do
		local char = text:sub(i, i)
		bypassed = bypassed .. (charMap[char] or char)
	end
	return bypassed
end

-----------------------------------------------------------
-- 2. TAMPILAN GUI INPUT & FLOATING ICON
-----------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaChatGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Icon Floating Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleButton.Text = "💬"
ToggleButton.TextSize = 26
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = ToggleButton

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Color = Color3.fromRGB(80, 140, 255)
UIStrokeBtn.Thickness = 2
UIStrokeBtn.Parent = ToggleButton

-- Panel Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 270)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.Color = Color3.fromRGB(50, 50, 70)
UIStrokeMain.Thickness = 1.5
UIStrokeMain.Parent = MainFrame

-- Status Label
local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, -20, 0, 25)
TargetLabel.Position = UDim2.new(0, 10, 0, 10)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Mode: Global Chat (Semua Server)"
TargetLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
TargetLabel.TextSize = 13
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = MainFrame

-- Input Target Whisper
local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1, -20, 0, 35)
TargetInput.Position = UDim2.new(0, 10, 0, 40)
TargetInput.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TargetInput.PlaceholderText = "Ketik @username target (Kosongkan utk Global)..."
TargetInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
TargetInput.Text = ""
TargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.TextSize = 14
TargetInput.Font = Enum.Font.SourceSans
TargetInput.Parent = MainFrame

local UICornerTarget = Instance.new("UICorner")
UICornerTarget.CornerRadius = UDim.new(0, 6)
UICornerTarget.Parent = TargetInput

-- Input Message Teks
local MessageInput = Instance.new("TextBox")
MessageInput.Size = UDim2.new(1, -20, 0, 65)
MessageInput.Position = UDim2.new(0, 10, 0, 85)
MessageInput.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MessageInput.PlaceholderText = "Ketik pesan Anda di sini..."
MessageInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
MessageInput.Text = ""
MessageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageInput.TextSize = 14
MessageInput.Font = Enum.Font.SourceSans
MessageInput.TextWrapped = true
MessageInput.TextYAlignment = Enum.TextYAlignment.Top
MessageInput.Parent = MainFrame

local UICornerMsg = Instance.new("UICorner")
UICornerMsg.CornerRadius = UDim.new(0, 6)
UICornerMsg.Parent = MessageInput

-- Toggle Switch Auto-Bypass
local BypassToggle = Instance.new("TextButton")
BypassToggle.Size = UDim2.new(1, -20, 0, 30)
BypassToggle.Position = UDim2.new(0, 10, 0, 160)
BypassToggle.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
BypassToggle.Text = "Anti-Filter Font: AKTIF [ON]"
BypassToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BypassToggle.TextSize = 13
BypassToggle.Font = Enum.Font.SourceSansBold
BypassToggle.Parent = MainFrame

local UICornerBypass = Instance.new("UICorner")
UICornerBypass.CornerRadius = UDim.new(0, 6)
UICornerBypass.Parent = BypassToggle

local useBypass = true
BypassToggle.MouseButton1Click:Connect(function()
	useBypass = not useBypass
	if useBypass then
		BypassToggle.Text = "Anti-Filter Font: AKTIF [ON]"
		BypassToggle.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
	else
		BypassToggle.Text = "Anti-Filter Font: NONAKTIF [OFF]"
		BypassToggle.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
	end
end)

-- Tombol Kirim
local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(1, -20, 0, 35)
SendButton.Position = UDim2.new(0, 10, 0, 200)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
SendButton.Text = "Kirim Pesan"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 15
SendButton.Font = Enum.Font.SourceSansBold
SendButton.Parent = MainFrame

local UICornerSend = Instance.new("UICorner")
UICornerSend.CornerRadius = UDim.new(0, 6)
UICornerSend.Parent = SendButton

-----------------------------------------------------------
-- 3. CHAT LOGIC INTEGRATION
-----------------------------------------------------------
local FakeRemote = Instance.new("BindableEvent")
local activeWhispers = {}

local function SendToOfficialRobloxChat(message)
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		local generalChannel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
		if generalChannel then
			generalChannel:SendAsync(message)
			return
		end
	end

	local defaultChatSystemChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	if defaultChatSystemChatEvents then
		local sayMessageRequest = defaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
		if sayMessageRequest then
			sayMessageRequest:FireServer(message, "All")
			return
		end
	end

	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
		Chat:Chat(LocalPlayer.Character.Head, message, Enum.ChatColor.White)
	end
end

local function findPlayer(query)
	if not query or query == "" then return nil end
	query = query:lower():gsub("^@", "")
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower() == query or p.DisplayName:lower() == query then
			return p
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():find(query, 1, true) == 1 or p.DisplayName:lower():find(query, 1, true) == 1 then
			return p
		end
	end
	return nil
end

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

TargetInput:GetPropertyChangedSignal("Text"):Connect(function()
	local query = TargetInput.Text
	if query == "" then
		FakeRemote:Fire(LocalPlayer, "SetWhisperTarget", nil)
	else
		FakeRemote:Fire(LocalPlayer, "SetWhisperTarget", query)
	end
end)

FakeRemote.Event:Connect(function(sender, action, payload)
	if action == "SetWhisperTarget" then
		if payload == nil then
			activeWhispers[sender] = nil
			TargetLabel.Text = "Mode: Global Chat (Semua Server)"
			TargetLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
		else
			local targetPlayer = findPlayer(payload)
			if targetPlayer and targetPlayer ~= sender then
				activeWhispers[sender] = targetPlayer
				TargetLabel.Text = "Mode: Whisper ke @" .. targetPlayer.DisplayName
				TargetLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
			else
				TargetLabel.Text = "Pemain tidak ditemukan!"
				TargetLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			end
		end
		return
	end
	
	if action == "SendMessage" then
		local message = payload
		if type(message) ~= "string" or message == "" then return end
		
		-- Memproses Anti-Filter Font jika tombol aktif
		if useBypass then
			message = BypassText(message)
		end
		
		local target = activeWhispers[sender]
		
		if target and target.Parent == Players then
			local whisperCommand = "/w @" .. target.Name .. " " .. message
			SendToOfficialRobloxChat(whisperCommand)
		else
			if target then activeWhispers[sender] = nil end
			SendToOfficialRobloxChat(message)
		end
	end
end)

SendButton.MouseButton1Click:Connect(function()
	local msg = MessageInput.Text
	if msg ~= "" then
		FakeRemote:Fire(LocalPlayer, "SendMessage", msg)
		MessageInput.Text = ""
	end
end)
