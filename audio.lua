local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function getRandomName()
    local str = ""
    for i = 1, 16 do
        str = str .. string.char(math.random(97, 122))
    end
    return str
end

local function cleanInput(text)
    if not text then return "" end
    text = string.gsub(text, "^%s+", "")
    text = string.gsub(text, "%s+$", "")
    text = string.gsub(text, "[%c%z]", "")
    return text
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local copyToClipboard = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard)

local catalogItems = {}
local currentPage = 1
local itemsPerPage = 9
local currentKeyword = "Dance"

local currentTrack = nil
local playingAssetId = nil

local function fetchCatalogData(keyword)
    local sanitized = cleanInput(keyword)
    if sanitized == "" then return nil end
    
    local encodedKeyword = HttpService:UrlEncode(sanitized)
    local url = "https://catalog.roblox.com/v1/search/items/details?Keyword=" .. encodedKeyword .. "&Limit=120"
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and response then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if decodeSuccess and data and data.data and #data.data > 0 then
            return data.data
        end
    end
    return nil
end

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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = getRandomName()
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local notifLabel = Instance.new("TextLabel")
notifLabel.Name = getRandomName()
notifLabel.Size = UDim2.new(0, 150, 0, 22)
notifLabel.Position = UDim2.new(0.5, -75, 0.1, 0)
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

local function showNotif(text, isError)
    notifLabel.Text = text
    notifLabel.TextColor3 = isError and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(85, 255, 127)
    notifLabel.Visible = true
    task.delay(1.5, function()
        notifLabel.Visible = false
    end)
end

local shopIcon = Instance.new("TextButton")
shopIcon.Name = getRandomName()
shopIcon.Size = UDim2.new(0, 32, 0, 32)
shopIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
shopIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.BackgroundTransparency = 0.6
shopIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.TextSize = 15
shopIcon.Text = "🛒"
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

local mainFrame = Instance.new("Frame")
mainFrame.Name = getRandomName()
mainFrame.Size = UDim2.new(0, 210, 0, 225)
mainFrame.Position = UDim2.new(0.5, -105, 0.5, -112)
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

RunService.RenderStepped:Connect(function(deltaTime)
    local rotationStep = deltaTime * 120
    mainGradient.Rotation = (mainGradient.Rotation + rotationStep) % 360
    iconGradient.Rotation = (iconGradient.Rotation + rotationStep) % 360
end)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = getRandomName()
titleLabel.Size = UDim2.new(1, -24, 0, 20)
titleLabel.Position = UDim2.new(0, 6, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Marketplace"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 11
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Name = getRandomName()
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -20, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 9
closeBtn.Parent = mainFrame

local searchBox = Instance.new("TextBox")
searchBox.Name = getRandomName()
searchBox.Size = UDim2.new(1, -42, 0, 20)
searchBox.Position = UDim2.new(0, 6, 0, 24)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "Cari barang..."
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.TextSize = 10
searchBox.Text = currentKeyword
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainFrame

local searchCorner = Instance.new("UICorner") searchCorner.CornerRadius = UDim.new(0, 4) searchCorner.Parent = searchBox

local searchBtn = Instance.new("TextButton")
searchBtn.Name = getRandomName()
searchBtn.Size = UDim2.new(0, 28, 0, 20)
searchBtn.Position = UDim2.new(1, -32, 0, 24)
searchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
searchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBtn.Text = "🔍"
searchBtn.TextSize = 10
searchBtn.Parent = mainFrame

local searchBtnCorner = Instance.new("UICorner") searchBtnCorner.CornerRadius = UDim.new(0, 4) searchBtnCorner.Parent = searchBtn

local gridFrame = Instance.new("Frame")
gridFrame.Name = getRandomName()
gridFrame.Size = UDim2.new(1, -12, 0, 140)
gridFrame.Position = UDim2.new(0, 6, 0, 48)
gridFrame.BackgroundTransparency = 1
gridFrame.Parent = mainFrame

local uIGridLayout = Instance.new("UIGridLayout")
uIGridLayout.CellSize = UDim2.new(0, 62, 0, 42)
uIGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
uIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uIGridLayout.Parent = gridFrame

local pageLabel = Instance.new("TextLabel")
pageLabel.Name = getRandomName()
pageLabel.Size = UDim2.new(0, 60, 0, 16)
pageLabel.Position = UDim2.new(0.5, -30, 1, -30)
pageLabel.BackgroundTransparency = 1
pageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
pageLabel.TextSize = 9
pageLabel.Text = "1/1"
pageLabel.Parent = mainFrame

local prevBtn = Instance.new("TextButton")
prevBtn.Name = getRandomName()
prevBtn.Size = UDim2.new(0, 40, 0, 16)
prevBtn.Position = UDim2.new(0, 6, 1, -30)
prevBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.Text = "< Prev"
prevBtn.TextSize = 9
prevBtn.Parent = mainFrame

local nextBtn = Instance.new("TextButton")
nextBtn.Name = getRandomName()
nextBtn.Size = UDim2.new(0, 40, 0, 16)
nextBtn.Position = UDim2.new(1, -46, 1, -30)
nextBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Text = "Next >"
nextBtn.TextSize = 9
nextBtn.Parent = mainFrame

local copyrightLabel = Instance.new("TextLabel")
copyrightLabel.Name = getRandomName()
copyrightLabel.Size = UDim2.new(1, 0, 0, 12)
copyrightLabel.Position = UDim2.new(0, 0, 1, -14)
copyrightLabel.BackgroundTransparency = 1
copyrightLabel.Text = "© IkyyXD"
copyrightLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
copyrightLabel.TextSize = 8
copyrightLabel.Font = Enum.Font.SourceSansItalic
copyrightLabel.Parent = mainFrame

local actionMenuFrame = Instance.new("Frame")
actionMenuFrame.Name = getRandomName()
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

local copyBtn = Instance.new("TextButton")
copyBtn.Name = getRandomName()
copyBtn.Size = UDim2.new(0, 85, 0, 22)
copyBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 10
copyBtn.Text = "📋 COPY ID"
copyBtn.ZIndex = 21
copyBtn.Parent = actionMenuFrame
local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(0, 4) cCorner.Parent = copyBtn

local playBtn = Instance.new("TextButton")
playBtn.Name = getRandomName()
playBtn.Size = UDim2.new(0, 85, 0, 22)
playBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playBtn.Font = Enum.Font.SourceSansBold
playBtn.TextSize = 10
playBtn.Text = "▶ PLAY"
playBtn.ZIndex = 21
playBtn.Parent = actionMenuFrame
local pCorner = Instance.new("UICorner") pCorner.CornerRadius = UDim.new(0, 4) pCorner.Parent = playBtn

local cancelBtn = Instance.new("TextButton")
cancelBtn.Name = getRandomName()
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

local function renderPage(page)
    actionMenuFrame.Visible = false
    for _, child in ipairs(gridFrame:GetChildren()) do
        if child:IsA("ImageButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local totalItems = #catalogItems
    local totalPages = math.ceil(totalItems / itemsPerPage)
    if totalPages < 1 then totalPages = 1 end
    
    currentPage = math.clamp(page, 1, totalPages)
    pageLabel.Text = string.format("%d / %d", currentPage, totalPages)
    
    local startIndex = (currentPage - 1) * itemsPerPage + 1
    local endIndex = math.min(startIndex + itemsPerPage - 1, totalItems)
    
    for i = startIndex, endIndex do
        local itemData = catalogItems[i]
        local assetId = tostring(itemData.id)
        
        local itemCard = Instance.new("ImageButton")
        itemCard.Name = getRandomName()
        itemCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        itemCard.AutoButtonColor = true
        itemCard.Parent = gridFrame
        
        local cardCorner = Instance.new("UICorner") cardCorner.CornerRadius = UDim.new(0, 4) cardCorner.Parent = itemCard
        
        local itemIcon = Instance.new("ImageLabel")
        itemIcon.Name = getRandomName()
        itemIcon.Size = UDim2.new(0, 24, 0, 24)
        itemIcon.Position = UDim2.new(0.5, -12, 0, 2)
        itemIcon.BackgroundTransparency = 1
        itemIcon.Image = "rbxthumb://type=Asset&id=" .. assetId .. "&w=150&h=150"
        itemIcon.Parent = itemCard
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = getRandomName()
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
            selectedAssetId = assetId
            
            local cardPos = itemCard.AbsolutePosition
            actionMenuFrame.Position = UDim2.new(0, cardPos.X + 65, 0, cardPos.Y)
            
            if playingAssetId == selectedAssetId then
                playBtn.BackgroundColor3 = Color3.fromRGB(198, 40, 40)
                playBtn.Text = "⏹ STOP"
            else
                playBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
                playBtn.Text = "▶ PLAY"
            end
            
            actionMenuFrame.Visible = true
        end)
    end
end

local function performSearch()
    local text = cleanInput(searchBox.Text)
    if text ~= "" then
        local newData = fetchCatalogData(text)
        if newData then
            currentKeyword = text
            catalogItems = newData
            renderPage(1)
            showNotif("Found " .. #catalogItems .. " items", false)
        else
            showNotif("Tidak ditemukan!", true)
        end
    else
        showNotif("Input Kosong!", true)
    end
end

copyBtn.MouseButton1Click:Connect(function()
    if selectedAssetId and copyToClipboard then
        copyToClipboard(selectedAssetId)
        showNotif("Copied: " .. selectedAssetId, false)
    end
    actionMenuFrame.Visible = false
end)

playBtn.MouseButton1Click:Connect(function()
    if selectedAssetId then
        if playingAssetId == selectedAssetId then
            stopEmote()
            showNotif("Stopped", false)
        else
            local played = playEmote(selectedAssetId)
            if played then
                showNotif("Playing!", false)
            else
                showNotif("Failed!", true)
            end
        end
    end
    actionMenuFrame.Visible = false
end)

cancelBtn.MouseButton1Click:Connect(function()
    actionMenuFrame.Visible = false
end)

shopIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        if #catalogItems == 0 then
            local data = fetchCatalogData(currentKeyword)
            if data then
                catalogItems = data
            end
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
