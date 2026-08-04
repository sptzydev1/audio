local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Detect fungsi Copy Clipboard dari Executor
local copyToClipboard = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard)

-- 1. FUNGSI AMBIL DATA KATALOG
local function fetchCatalogData()
    local url = "https://catalog.roblox.com/v2/search/items/details?urlLocale=id_id&keyword=Taxi&taxonomy=ioNxAT977DFP2hMnAJbsbF&salesTypeFilter=1&limit=120"
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

local catalogItems = fetchCatalogData()
local currentPage = 1
local itemsPerPage = 9 -- Format Grid 3x3

-- 2. MEMBUAT GUI UTAMA
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TaxiShopGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Notification Label (Muncul saat ID berhasil di-copy)
local notifLabel = Instance.new("TextLabel")
notifLabel.Size = UDim2.new(0, 200, 0, 30)
notifLabel.Position = UDim2.new(0.5, -100, 0.15, 0)
notifLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notifLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
notifLabel.TextSize = 12
notifLabel.Font = Enum.Font.SourceSansBold
notifLabel.Visible = false
notifLabel.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notifLabel

local function showNotif(text)
    notifLabel.Text = text
    notifLabel.Visible = true
    task.delay(1.5, function()
        notifLabel.Visible = false
    end)
end

-- Tombol Icon Toko (Melayang & Bisa Digeser)
local shopIcon = Instance.new("TextButton")
shopIcon.Name = "ShopIcon"
shopIcon.Size = UDim2.new(0, 50, 0, 50)
shopIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
shopIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
shopIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.TextSize = 24
shopIcon.Text = "🛒"
shopIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 12)
iconCorner.Parent = shopIcon

-- Fitur Dragging untuk Icon Toko
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

-- Main Frame (Modal Persegi Empat di Tengah)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 440)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title & Close Button
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Katalog Taxi"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame

-- Container Item (Grid 3x3)
local gridFrame = Instance.new("Frame")
gridFrame.Size = UDim2.new(1, -20, 0, 330)
gridFrame.Position = UDim2.new(0, 10, 0, 45)
gridFrame.BackgroundTransparency = 1
gridFrame.Parent = mainFrame

local uIGridLayout = Instance.new("UIGridLayout")
uIGridLayout.CellSize = UDim2.new(0, 100, 0, 100)
uIGridLayout.CellPadding = UDim2.new(0, 12, 0, 10)
uIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uIGridLayout.Parent = gridFrame

-- Navigasi Halaman
local pageLabel = Instance.new("TextLabel")
pageLabel.Size = UDim2.new(0, 100, 0, 30)
pageLabel.Position = UDim2.new(0.5, -50, 1, -35)
pageLabel.BackgroundTransparency = 1
pageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
pageLabel.TextSize = 14
pageLabel.Text = "Hal 1"
pageLabel.Parent = mainFrame

local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.new(0, 60, 0, 30)
prevBtn.Position = UDim2.new(0, 10, 1, -35)
prevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.Text = "< Prev"
prevBtn.Parent = mainFrame

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 60, 0, 30)
nextBtn.Position = UDim2.new(1, -70, 1, -35)
nextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Text = "Next >"
nextBtn.Parent = mainFrame

-- 3. FUNGSI RENDER HALAMAN ITEM + FITUR AUTO COPY ID
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
        
        -- Kartu dijadikan ImageButton agar bisa diklik
        local itemCard = Instance.new("ImageButton")
        itemCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        itemCard.AutoButtonColor = true
        itemCard.Parent = gridFrame
        
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 6)
        cardCorner.Parent = itemCard
        
        -- 1. ICON (Gambar Item)
        local itemIcon = Instance.new("ImageLabel")
        itemIcon.Size = UDim2.new(0, 60, 0, 60)
        itemIcon.Position = UDim2.new(0.5, -30, 0, 5)
        itemIcon.BackgroundTransparency = 1
        itemIcon.Image = "rbxthumb://type=Asset&id=" .. assetId .. "&w=150&h=150"
        itemIcon.Parent = itemCard
        
        -- 2. NAME (Nama Item)
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -6, 0, 30)
        nameLabel.Position = UDim2.new(0, 3, 1, -32)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = itemData.name or "Item"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 10
        nameLabel.TextWrapped = true
        nameLabel.TextYAlignment = Enum.TextYAlignment.Top
        nameLabel.Parent = itemCard
        
        -- EVENT KLIK: COPY ID KE CLIPBOARD
        itemCard.MouseButton1Click:Connect(function()
            if copyToClipboard then
                copyToClipboard(assetId)
                showNotif("Copied ID: " .. assetId)
            else
                showNotif("Executor tidak support setclipboard!")
            end
        end)
    end
end

-- 4. EVENT LISTENERS (BUKA/TUTUP & PAGINATION)
shopIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
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

