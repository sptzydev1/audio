local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Detect fungsi Copy Clipboard dari Executor
local copyToClipboard = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard)

local catalogItems = {}
local currentPage = 1
local itemsPerPage = 9 -- Format Grid 3x3
local currentKeyword = "Taxi"

-- 1. FUNGSI AMBIL DATA KATALOG
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

-- 2. MEMBUAT GUI UTAMA (UKURAN DIPERKECIL: 270 x 360)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniCatalogShopGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Notification Label (Pesan Pop-up saat ID di-copy)
local notifLabel = Instance.new("TextLabel")
notifLabel.Size = UDim2.new(0, 160, 0, 24)
notifLabel.Position = UDim2.new(0.5, -80, 0.12, 0)
notifLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notifLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
notifLabel.TextSize = 11
notifLabel.Font = Enum.Font.SourceSansBold
notifLabel.Visible = false
notifLabel.ZIndex = 10
notifLabel.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 6)
notifCorner.Parent = notifLabel

local function showNotif(text)
    notifLabel.Text = text
    notifLabel.Visible = true
    task.delay(1.2, function()
        notifLabel.Visible = false
    end)
end

-- Tombol Icon Toko (Bisa Digeser / Draggable)
local shopIcon = Instance.new("TextButton")
shopIcon.Name = "ShopIcon"
shopIcon.Size = UDim2.new(0, 42, 0, 42)
shopIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
shopIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
shopIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.TextSize = 20
shopIcon.Text = "🛒"
shopIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = shopIcon

-- Fitur Dragging Icon Toko
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

-- Main Frame (Kecil di Tengah Screen)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 270, 0, 360)
mainFrame.Position = UDim2.new(0.5, -135, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar & Close Button
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 0, 30)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Katalog Shop"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -27, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 11
closeBtn.Parent = mainFrame

-- FITUR SEARCH INPUT BAR
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -55, 0, 24)
searchBox.Position = UDim2.new(0, 8, 0, 32)
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "Cari item..."
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.TextSize = 12
searchBox.Text = "Taxi"
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 5)
searchCorner.Parent = searchBox

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0, 35, 0, 24)
searchBtn.Position = UDim2.new(1, -43, 0, 32)
searchBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
searchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBtn.Text = "🔍"
searchBtn.TextSize = 12
searchBtn.Parent = mainFrame

local searchBtnCorner = Instance.new("UICorner")
searchBtnCorner.CornerRadius = UDim.new(0, 5)
searchBtnCorner.Parent = searchBtn

-- Container Item (Grid 3x3)
local gridFrame = Instance.new("Frame")
gridFrame.Size = UDim2.new(1, -16, 0, 255)
gridFrame.Position = UDim2.new(0, 8, 0, 62)
gridFrame.BackgroundTransparency = 1
gridFrame.Parent = mainFrame

local uIGridLayout = Instance.new("UIGridLayout")
uIGridLayout.CellSize = UDim2.new(0, 78, 0, 78)
uIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
uIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uIGridLayout.Parent = gridFrame

-- Navigasi Halaman (Bottom Bar)
local pageLabel = Instance.new("TextLabel")
pageLabel.Size = UDim2.new(0, 80, 0, 25)
pageLabel.Position = UDim2.new(0.5, -40, 1, -30)
pageLabel.BackgroundTransparency = 1
pageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
pageLabel.TextSize = 11
pageLabel.Text = "Hal 1"
pageLabel.Parent = mainFrame

local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.new(0, 48, 0, 22)
prevBtn.Position = UDim2.new(0, 8, 1, -28)
prevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.Text = "< Prev"
prevBtn.TextSize = 11
prevBtn.Parent = mainFrame

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 48, 0, 22)
nextBtn.Position = UDim2.new(1, -56, 1, -28)
nextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Text = "Next >"
nextBtn.TextSize = 11
nextBtn.Parent = mainFrame

-- 3. FUNGSI RENDER HALAMAN
local function renderPage(page)
    for _, child in ipairs(gridFrame:GetChildren()) do
        if child:IsA("ImageButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local totalPages = math.max(1, math.ceil(#catalogItems / itemsPerPage))
    currentPage = math.clamp(page, 1, totalPages)
    pageLabel.Text = string.format("Hal %d / %d", currentPage, totalPages)
    
    local startIndex = (currentPage - 1) * itemsPerPage + 1
    local endIndex = math.min(startIndex + itemsPerPage - 1, #catalogItems)
    
    for i = startIndex, endIndex do
        local itemData = catalogItems[i]
        local assetId = tostring(itemData.id)
        
        local itemCard = Instance.new("ImageButton")
        itemCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        itemCard.AutoButtonColor = true
        itemCard.Parent = gridFrame
        
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 5)
        cardCorner.Parent = itemCard
        
        -- 1. ICON (Gambar Item)
        local itemIcon = Instance.new("ImageLabel")
        itemIcon.Size = UDim2.new(0, 46, 0, 46)
        itemIcon.Position = UDim2.new(0.5, -23, 0, 4)
        itemIcon.BackgroundTransparency = 1
        itemIcon.Image = "rbxthumb://type=Asset&id=" .. assetId .. "&w=150&h=150"
        itemIcon.Parent = itemCard
        
        -- 2. NAME (Nama Item)
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -4, 0, 22)
        nameLabel.Position = UDim2.new(0, 2, 1, -24)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = itemData.name or "Item"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 8
        nameLabel.TextWrapped = true
        nameLabel.TextYAlignment = Enum.TextYAlignment.Top
        nameLabel.Parent = itemCard
        
        -- CLICK EVENT: COPY ID
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

-- FUNGSI UNTUK MELAKUKAN PENCARIAN
local function performSearch()
    local text = searchBox.Text
    if text and text ~= "" then
        currentKeyword = text
        catalogItems = fetchCatalogData(currentKeyword)
        renderPage(1)
    end
end

-- 4. EVENT LISTENERS
searchBtn.MouseButton1Click:Connect(performSearch)
searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        performSearch()
    end
end)

shopIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        if #catalogItems == 0 then
            catalogItems = fetchCatalogData(currentKeyword)
        end
        renderPage(currentPage)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

prevBtn.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        renderPage(currentPage - 1)
    end
end)

nextBtn.MouseButton1Click:Connect(function()
    local totalPages = math.ceil(#catalogItems / itemsPerPage)
    if currentPage < totalPages then
        renderPage(currentPage + 1)
    end
end)
