-- =================================================================
-- SKRIP EMOTE KATALOG + 3 LIST ACTION MENU (PLAY/STOP/COPY)
-- =================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local copyToClipboard = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard)

local catalogItems = {}
local currentPage = 1
local itemsPerPage = 9
local currentKeyword = "Dance"

-- Variabel Animasi Character
local currentTrack = nil
local playingAssetId = nil

-- -----------------------------------------------------------------
-- 1. FUNGSI FETCH EMOTE FROM CATALOG
-- -----------------------------------------------------------------
local function fetchCatalogData(keyword)
    local encodedKeyword = HttpService:UrlEncode(keyword)
    -- Category Emote Animations
    local url = "https://catalog.roblox.com/v2/search/items/details?urlLocale=id_id&keyword=" .. encodedKeyword .. "&category=11&subcategory=38&limit=120"
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and response then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if decodeSuccess and data and data.data then
            return data.data
        end
    end
    return {}
end

-- -----------------------------------------------------------------
-- 2. FUNGSI PLAY & STOP ANIMASI EMOTE
-- -----------------------------------------------------------------
local function stopEmote()
    if currentTrack then
        currentTrack:Stop()
        currentTrack:Destroy()
        currentTrack = nil
    end
    playingAssetId = nil
end

local function playEmote(assetId)
    stopEmote()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. tostring(assetId)
        
        local success, track = pcall(function()
            return humanoid:LoadAnimation(animation)
        end)
        
        if success and track then
            currentTrack = track
            playingAssetId = assetId
            currentTrack:Play()
            return true
        end
    end
    return false
end

-- -----------------------------------------------------------------
-- 3. SCREEN GUI & NOTIFIKASI
-- -----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EmoteTesterCatalogGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Pop-Up Notifikasi
local notifLabel = Instance.new("TextLabel")
notifLabel.Size = UDim2.new(0, 140, 0, 22)
notifLabel.Position = UDim2.new(0.5, -70, 0.1, 0)
notifLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
notifLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
notifLabel.TextSize = 10
notifLabel.Font = Enum.Font.SourceSansBold
notifLabel.Visible = false
notifLabel.ZIndex = 30
notifLabel.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 5)
notifCorner.Parent = notifLabel

local function showNotif(text)
    notifLabel.Text = text
    notifLabel.Visible = true
    task.delay(1.2, function()
        notifLabel.Visible = false
    end)
end

-- -----------------------------------------------------------------
-- 4. IKON TOKO UTAMA (32x32 TRANSPARAN + GARIS BERJALAN)
-- -----------------------------------------------------------------
local shopIcon = Instance.new("TextButton")
shopIcon.Name = "ShopIcon"
shopIcon.Size = UDim2.new(0, 32, 0, 32)
shopIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
shopIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.BackgroundTransparency = 0.6
shopIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.TextSize = 15
shopIcon.Text = "🕺"
shopIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 8)
iconCorner.Parent = shopIcon

local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 2
iconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
iconStroke.Parent = shopIcon

local iconGradient = Instance.new("UIGradient")
iconGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(0.9, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
iconGradient.Parent = iconStroke

-- Drag Logic Icon
local dragging, dragInput, dragStart, startPos
shopIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = shopIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

shopIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        shopIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- -----------------------------------------------------------------
-- 5. MAIN FRAME KATALOG (PERSEGI 210x210 + GARIS BERJALAN)
-- -----------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 210, 0, 210)
mainFrame.Position = UDim2.new(0.5, -105, 0.5, -105)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
mainGradient.Parent = mainStroke

-- Animasi Garis Putih Berjalan
RunService.RenderStepped:Connect(function(deltaTime)
    local rotationStep = deltaTime * 120
    mainGradient.Rotation = (mainGradient.Rotation + rotationStep) % 360
    iconGradient.Rotation = (iconGradient.Rotation + rotationStep) % 360
end)

-- Header Bar
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -24, 0, 20)
titleLabel.Position = UDim2.new(0, 6, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Emote Catalog"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 11
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -20, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 9
closeBtn.Parent = mainFrame

-- Search Bar
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -42, 0, 20)
searchBox.Position = UDim2.new(0, 6, 0, 24)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "Cari emote..."
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.TextSize = 10
searchBox.Text = currentKeyword
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainFrame

local searchCorner = Instance.new("UICorner") searchCorner.CornerRadius = UDim.new(0, 4) searchCorner.Parent = searchBox

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0, 28, 0, 20)
searchBtn.Position = UDim2.new(1, -32, 0, 24)
searchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
searchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBtn.Text = "🔍"
searchBtn.TextSize = 10
searchBtn.Parent = searchBtn

local searchBtnCorner = Instance.new("UICorner") searchBtnCorner.CornerRadius = UDim.new(0, 4) searchBtnCorner.Parent = searchBtn
searchBtn.Parent = mainFrame

-- Container Grid 3x3
local gridFrame = Instance.new("Frame")
gridFrame.Size = UDim2.new(1, -12, 0, 140)
gridFrame.Position = UDim2.new(0, 6, 0, 48)
gridFrame.BackgroundTransparency = 1
gridFrame.Parent = mainFrame

local uIGridLayout = Instance.new("UIGridLayout")
uIGridLayout.CellSize = UDim2.new(0, 62, 0, 42)
uIGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
uIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uIGridLayout.Parent = gridFrame

-- Bottom Navigation
local pageLabel = Instance.new("TextLabel")
pageLabel.Size = UDim2.new(0, 60, 0, 16)
pageLabel.Position = UDim2.new(0.5, -30, 1, -18)
pageLabel.BackgroundTransparency = 1
pageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
pageLabel.TextSize = 9
pageLabel.Text = "1/1"
pageLabel.Parent = mainFrame

local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.new(0, 40, 0, 16)
prevBtn.Position = UDim2.new(0, 6, 1, -18)
prevBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.Text = "< Prev"
prevBtn.TextSize = 9
prevBtn.Parent = mainFrame

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 40, 0, 16)
nextBtn.Position = UDim2.new(1, -46, 1, -18)
nextBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Text = "Next >"
nextBtn.TextSize = 9
nextBtn.Parent = mainFrame

-- -----------------------------------------------------------------
-- 6. MENU POP-UP 3 LIST (MUNCUL SAAT ITEM EMOTE DIKLIK)
-- -----------------------------------------------------------------
local actionMenuFrame = Instance.new("Frame")
actionMenuFrame.Name = "ActionMenuFrame"
actionMenuFrame.Size = UDim2.new(0, 95, 0, 85)
actionMenuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
actionMenuFrame.Visible = false
actionMenuFrame.ZIndex = 20
actionMenuFrame.Parent = screenGui

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 6)
actionCorner.Parent = actionMenuFrame

local actionLayout = Instance.new("UIListLayout")
actionLayout.Padding = UDim.new(0, 4)
actionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
actionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
actionLayout.Parent = actionMenuFrame

-- List 1: COPY (HIJAU)
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 85, 0, 22)
copyBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 10
copyBtn.Text = "📋 COPY ID"
copyBtn.ZIndex = 21
copyBtn.Parent = actionMenuFrame
local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(0, 4) cCorner.Parent = copyBtn

-- List 2: PLAY / STOP (HIJAU / MERAH)
local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(0, 85, 0, 22)
playBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playBtn.Font = Enum.Font.SourceSansBold
playBtn.TextSize = 10
playBtn.Text = "▶ PLAY"
playBtn.ZIndex = 21
playBtn.Parent = actionMenuFrame
local pCorner = Instance.new("UICorner") pCorner.CornerRadius = UDim.new(0, 4) pCorner.Parent = playBtn

-- List 3: CANCEL (MERAH)
local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0, 85, 0, 22)
cancelBtn.BackgroundColor3 = Color3.fromRGB(198, 40, 40)
cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cancelBtn.Font = Enum.Font.SourceSansBold
cancelBtn.TextSize = 10
cancelBtn.Text = "✖ CANCEL"
cancelBtn.ZIndex = 21
cancelBtn.Parent = actionMenuFrame
local cnCorner = Instance.new("UICorner") cnCorner.CornerRadius = UDim.new(0, 4) cnCorner.Parent = cancelBtn

local selectedAssetId = nil

-- -----------------------------------------------------------------
-- 7. RENDER LOGIC & EVENT LISTENERS
-- -----------------------------------------------------------------
local function renderPage(page)
    actionMenuFrame.Visible = false
    for _, child in ipairs(gridFrame:GetChildren()) do
        if child:IsA("ImageButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local totalPages = math.max(1, math.ceil(#catalogItems / itemsPerPage))
    currentPage = math.clamp(page, 1, totalPages)
    pageLabel.Text = string.format("%d / %d", currentPage, totalPages)
    
    local startIndex = (currentPage - 1) * itemsPerPage + 1
    local endIndex = math.min(startIndex + itemsPerPage - 1, #catalogItems)
    
    for i = startIndex, endIndex do
        local itemData = catalogItems[i]
        local assetId = tostring(itemData.id)
        
        local itemCard = Instance.new("ImageButton")
        itemCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        itemCard.AutoButtonColor = true
        itemCard.Parent = gridFrame
        
        local cardCorner = Instance.new("UICorner") cardCorner.CornerRadius = UDim.new(0, 4) cardCorner.Parent = itemCard
        
        local itemIcon = Instance.new("ImageLabel")
        itemIcon.Size = UDim2.new(0, 24, 0, 24)
        itemIcon.Position = UDim2.new(0.5, -12, 0, 2)
        itemIcon.BackgroundTransparency = 1
        itemIcon.Image = "rbxthumb://type=Asset&id=" .. assetId .. "&w=150&h=150"
        itemIcon.Parent = itemCard
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -2, 0, 14)
        nameLabel.Position = UDim2.new(0, 1, 1, -15)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = itemData.name or "Emote"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 7
        nameLabel.TextWrapped = true
        nameLabel.TextYAlignment = Enum.TextYAlignment.Top
        nameLabel.Parent = itemCard
        
        -- KLIK KARTU EMOTE -> MUNCIULKAN POP-UP 3 LIST ACTION MENU
        itemCard.MouseButton1Click:Connect(function()
            selectedAssetId = assetId
            
            -- Atur posisi Pop-up di dekat kartu yang diklik
            local cardPos = itemCard.AbsolutePosition
            actionMenuFrame.Position = UDim2.new(0, cardPos.X + 65, 0, cardPos.Y)
            
            -- Perbarui warna & teks tombol Play jika emote ini sedang dimainkan
            if playingAssetId == selectedAssetId then
                playBtn.BackgroundColor3 = Color3.fromRGB(198, 40, 40) -- Merah
                playBtn.Text = "⏹ STOP"
            else
                playBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50) -- Hijau
                playBtn.Text = "▶ PLAY"
            end
            
            actionMenuFrame.Visible = true
        end)
    end
end

local function performSearch()
    local text = searchBox.Text
    if text and text ~= "" then
        currentKeyword = text
        catalogItems = fetchCatalogData(currentKeyword)
        renderPage(1)
    end
end

-- EVENT ACTIONS:
-- 1. Klik Copy ID
copyBtn.MouseButton1Click:Connect(function()
    if selectedAssetId and copyToClipboard then
        copyToClipboard(selectedAssetId)
        showNotif("Copied: " .. selectedAssetId)
    end
    actionMenuFrame.Visible = false
end)

-- 2. Klik Play / Stop Animasi
playBtn.MouseButton1Click:Connect(function()
    if selectedAssetId then
        if playingAssetId == selectedAssetId then
            stopEmote()
            showNotif("Emote Stopped")
        else
            local played = playEmote(selectedAssetId)
            if played then
                showNotif("Playing Emote!")
            else
                showNotif("Playback Failed!")
            end
        end
    end
    actionMenuFrame.Visible = false
end)

-- 3. Klik Cancel
cancelBtn.MouseButton1Click:Connect(function()
    actionMenuFrame.Visible = false
end)

-- Buka/Tutup GUI Utama lewat Icon Toko
shopIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        if #catalogItems == 0 then
            catalogItems = fetchCatalogData(currentKeyword)
        end
        renderPage(currentPage)
    else
        actionMenuFrame.Visible = false
    end
end)

searchBtn.MouseButton1Click:Connect(performSearch)
searchBox.FocusLost:Connect(function(enter) if enter then performSearch() end end)
closeBtn.MouseButton1Click:Connect(function() 
    mainFrame.Visible = false 
    actionMenuFrame.Visible = false
end)

prevBtn.MouseButton1Click:Connect(function() 
    if currentPage > 1 then renderPage(currentPage - 1) end 
end)

nextBtn.MouseButton1Click:Connect(function() 
    local totalPages = math.ceil(#catalogItems / itemsPerPage)
    if currentPage < totalPages then renderPage(currentPage + 1) end 
end)
