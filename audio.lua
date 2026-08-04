-- =================================================================
-- SKRIP KATALOG EXECUTOR (MINI PERSEGI + ANIMASI GARIS BERJALAN)
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
local currentKeyword = "Taxi"
local isSystemOn = false

-- -----------------------------------------------------------------
-- 1. FUNGSI FETCH KATALOG DATA
-- -----------------------------------------------------------------
local function fetchCatalogData(keyword)
    local encodedKeyword = HttpService:UrlEncode(keyword)
    local url = "https://catalog.roblox.com/v2/search/items/details?urlLocale=id_id&keyword=" .. encodedKeyword .. "&taxonomy=ioNxAT977DFP2hMnAJbsbF&salesTypeFilter=1&limit=120"
    
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
-- 2. GUI UTAMA & NOTIFIKASI
-- -----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraMiniCatalogGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Pop-Up Notifikasi Ringkas
local notifLabel = Instance.new("TextLabel")
notifLabel.Size = UDim2.new(0, 130, 0, 20)
notifLabel.Position = UDim2.new(0.5, -65, 0.1, 0)
notifLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
notifLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
notifLabel.TextSize = 10
notifLabel.Font = Enum.Font.SourceSansBold
notifLabel.Visible = false
notifLabel.ZIndex = 20
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
-- 3. IKON TOKO (UKURAN LEBIH KECIL & TRANSPARAN)
-- -----------------------------------------------------------------
local shopIcon = Instance.new("TextButton")
shopIcon.Name = "ShopIcon"
shopIcon.Size = UDim2.new(0, 32, 0, 32) -- Diperkecil ke 32x32
shopIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
shopIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Latar Putih
shopIcon.BackgroundTransparency = 0.6 -- Agak Transparan
shopIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.TextSize = 15
shopIcon.Text = "🛒"
shopIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 8) -- Sudut Melengkung
iconCorner.Parent = shopIcon

-- Border Garis Berjalan pada Ikon
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

-- Drag Logic Ikon Toko
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
-- 4. DROPDOWN MENU LIST (3 TOMBOL)
-- -----------------------------------------------------------------
local listMenuFrame = Instance.new("Frame")
listMenuFrame.Name = "ListMenuFrame"
listMenuFrame.Size = UDim2.new(0, 95, 0, 110)
listMenuFrame.Position = UDim2.new(1, 6, 0, 0)
listMenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
listMenuFrame.Visible = false
listMenuFrame.Parent = shopIcon

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = listMenuFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Parent = listMenuFrame

-- List 1: Copy (Hijau)
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 85, 0, 22)
copyBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 10
copyBtn.Text = "📋 COPY"
copyBtn.Parent = listMenuFrame
local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(0, 4) cCorner.Parent = copyBtn

-- List 2: Play/On-Off (Hijau / Merah)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 85, 0, 22)
toggleBtn.BackgroundColor3 = Color3.fromRGB(198, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 10
toggleBtn.Text = "▶ PLAY (OFF)"
toggleBtn.Parent = listMenuFrame
local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(0, 4) tCorner.Parent = toggleBtn

-- List 3: Cancel (Merah)
local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0, 85, 0, 22)
cancelBtn.BackgroundColor3 = Color3.fromRGB(198, 40, 40)
cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cancelBtn.Font = Enum.Font.SourceSansBold
cancelBtn.TextSize = 10
cancelBtn.Text = "✖ CANCEL"
cancelBtn.Parent = listMenuFrame
local cnCorner = Instance.new("UICorner") cnCorner.CornerRadius = UDim.new(0, 4) cnCorner.Parent = cancelBtn

-- Option Katalog
local catalogToggleBtn = Instance.new("TextButton")
catalogToggleBtn.Size = UDim2.new(0, 85, 0, 22)
catalogToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
catalogToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
catalogToggleBtn.Font = Enum.Font.SourceSansBold
catalogToggleBtn.TextSize = 10
catalogToggleBtn.Text = "🛍️ KATALOG"
catalogToggleBtn.Parent = listMenuFrame
local catCorner = Instance.new("UICorner") catCorner.CornerRadius = UDim.new(0, 4) catCorner.Parent = catalogToggleBtn

-- -----------------------------------------------------------------
-- 5. MAIN FRAME (PERSEGI EMPAT MINI 210x210 & MELENGKUNG)
-- -----------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 210, 0, 210) -- Persegi Empat
mainFrame.Position = UDim2.new(0.5, -105, 0.5, -105)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10) -- Pinggiran Melengkung
mainCorner.Parent = mainFrame

-- Border Garis Berjalan pada GUI Utama
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

-- ANIMASI GARIS BERJALAN WARNA PUTIH
RunService.RenderStepped:Connect(function(deltaTime)
    local rotationStep = deltaTime * 120 -- Kecepatan Putaran Garis
    mainGradient.Rotation = (mainGradient.Rotation + rotationStep) % 360
    iconGradient.Rotation = (iconGradient.Rotation + rotationStep) % 360
end)

-- Title & Close
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -24, 0, 20)
titleLabel.Position = UDim2.new(0, 6, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Katalog Shop"
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
searchBox.PlaceholderText = "Cari..."
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
searchBtn.Parent = mainFrame

local searchBtnCorner = Instance.new("UICorner") searchBtnCorner.CornerRadius = UDim.new(0, 4) searchBtnCorner.Parent = searchBtn

-- Grid Container (Grid 3x3 Presisi)
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

-- Bottom Navigasi
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
-- 6. RENDER LOGIC & EVENT LISTENERS
-- -----------------------------------------------------------------
local function renderPage(page)
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
        nameLabel.Text = itemData.name or "Item"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 7
        nameLabel.TextWrapped = true
        nameLabel.TextYAlignment = Enum.TextYAlignment.Top
        nameLabel.Parent = itemCard
        
        itemCard.MouseButton1Click:Connect(function()
            if copyToClipboard then
                copyToClipboard(assetId)
                showNotif("Copied: " .. assetId)
            else
                showNotif("Clipboard Error!")
            end
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

-- Event Handlers
shopIcon.MouseButton1Click:Connect(function()
    listMenuFrame.Visible = not listMenuFrame.Visible
end)

copyBtn.MouseButton1Click:Connect(function()
    if copyToClipboard then
        copyToClipboard(currentKeyword)
        showNotif("Copied: " .. currentKeyword)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    isSystemOn = not isSystemOn
    if isSystemOn then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
        toggleBtn.Text = "▶ PLAY (ON)"
        showNotif("Status: ON")
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(198, 40, 40)
        toggleBtn.Text = "▶ PLAY (OFF)"
        showNotif("Status: OFF")
    end
end)

cancelBtn.MouseButton1Click:Connect(function()
    listMenuFrame.Visible = false
    mainFrame.Visible = false
    showNotif("Menu Closed")
end)

catalogToggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        if #catalogItems == 0 then
            catalogItems = fetchCatalogData(currentKeyword)
        end
        renderPage(currentPage)
    end
end)

searchBtn.MouseButton1Click:Connect(performSearch)
searchBox.FocusLost:Connect(function(enter) if enter then performSearch() end end)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)
prevBtn.MouseButton1Click:Connect(function() if currentPage > 1 then renderPage(currentPage - 1) end end)
nextBtn.MouseButton1Click:Connect(function() 
    local totalPages = math.ceil(#catalogItems / itemsPerPage)
    if currentPage < totalPages then renderPage(currentPage + 1) end 
end)
