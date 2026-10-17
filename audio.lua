-- ======================================================
-- SPTZYY X IKYYXD - FULL INTEGRATED DANCE TOOL & MANAGER
-- ======================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")

-- Clean Up GUI Lama
if PlayerGui and PlayerGui:FindFirstChild("SptzyyDanceUI") then
    PlayerGui.SptzyyDanceUI:Destroy()
end

--------------------------------------------------
-- STATE & MEMORY
--------------------------------------------------
local isLoggerEnabled = true
local isAutoSaveEnabled = true
local savedDances = {}

--------------------------------------------------
-- HELPER: DRAGGABLE GUI LOGIC
--------------------------------------------------
local function makeDraggable(topBarObject, objectToMove)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        objectToMove.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    topBarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = objectToMove.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

--------------------------------------------------
-- 1. SCREEN GUI & FLOATING ICON
--------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SptzyyDanceUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui or CoreGui

-- Floating Icon (💃)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 36, 0, 36)
ToggleButton.Position = UDim2.new(0, 12, 0.5, -18)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleButton.Text = "💃"
ToggleButton.TextSize = 16
ToggleButton.Active = true
ToggleButton.Parent = screenGui

local UICornerIcon = Instance.new("UICorner")
UICornerIcon.CornerRadius = UDim.new(0, 8)
UICornerIcon.Parent = ToggleButton

local UIStrokeIcon = Instance.new("UIStroke")
UIStrokeIcon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeIcon.Thickness = 1.5
UIStrokeIcon.Parent = ToggleButton

makeDraggable(ToggleButton, ToggleButton)

-- Main Frame (360x380)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 380)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStrokeMain.Thickness = 1.5
UIStrokeMain.Parent = mainFrame

-- Gradient Glowing Effect
local UIGradientIcon = Instance.new("UIGradient")
UIGradientIcon.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
})
UIGradientIcon.Parent = UIStrokeIcon

local UIGradientMain = Instance.new("UIGradient")
UIGradientMain.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
})
UIGradientMain.Parent = UIStrokeMain

local rotationAngle = 0
RunService.RenderStepped:Connect(function(dt)
    rotationAngle = (rotationAngle + (dt * 120)) % 360
    UIGradientIcon.Rotation = rotationAngle
    UIGradientMain.Rotation = rotationAngle
end)

ToggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Top Header (Draggable Handle)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
header.BorderSizePixel = 0
header.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Dance Scanner & TXT Manager"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

makeDraggable(header, mainFrame)

-- Container Pages
local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -75)
container.Position = UDim2.new(0, 0, 0, 35)
container.BackgroundTransparency = 1
container.Parent = mainFrame

--------------------------------------------------
-- SPLASH SCREEN
--------------------------------------------------
local splashFrame = Instance.new("Frame")
splashFrame.Size = UDim2.new(1, 0, 1, 0)
splashFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
splashFrame.ZIndex = 10
splashFrame.Parent = container

local splashTitle = Instance.new("TextLabel")
splashTitle.Size = UDim2.new(1, 0, 0, 40)
splashTitle.Position = UDim2.new(0, 0, 0.4, -20)
splashTitle.BackgroundTransparency = 1
splashTitle.Text = "SPT ZYY × IkyyXD"
splashTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
splashTitle.TextSize = 24
splashTitle.Font = Enum.Font.GothamBlack
splashTitle.ZIndex = 11
splashTitle.Parent = splashFrame

local splashSub = Instance.new("TextLabel")
splashSub.Size = UDim2.new(1, 0, 0, 20)
splashSub.Position = UDim2.new(0, 0, 0.4, 20)
splashSub.BackgroundTransparency = 1
splashSub.Text = "Initializing System..."
splashSub.TextColor3 = Color3.fromRGB(180, 180, 180)
splashSub.TextSize = 11
splashSub.Font = Enum.Font.Gotham
splashSub.ZIndex = 11
splashSub.Parent = splashFrame

--------------------------------------------------
-- PAGES SETUP
--------------------------------------------------
local homePage = Instance.new("Frame")
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.Visible = false
homePage.Parent = container

local scannerPage = Instance.new("Frame")
scannerPage.Size = UDim2.new(1, 0, 1, 0)
scannerPage.BackgroundTransparency = 1
scannerPage.Visible = false
scannerPage.Parent = container

local outputPage = Instance.new("Frame")
outputPage.Size = UDim2.new(1, 0, 1, 0)
outputPage.BackgroundTransparency = 1
outputPage.Visible = false
outputPage.Parent = container

-- --- HOME PAGE ---
local homeTitle = Instance.new("TextLabel")
homeTitle.Size = UDim2.new(1, -20, 0, 25)
homeTitle.Position = UDim2.new(0, 10, 0, 5)
homeTitle.BackgroundTransparency = 1
homeTitle.Text = "Pilih File TXT Internal:"
homeTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
homeTitle.TextSize = 12
homeTitle.Font = Enum.Font.GothamMedium
homeTitle.TextXAlignment = Enum.TextXAlignment.Left
homeTitle.Parent = homePage

local homeScroll = Instance.new("ScrollingFrame")
homeScroll.Size = UDim2.new(1, -20, 1, -35)
homeScroll.Position = UDim2.new(0, 10, 0, 30)
homeScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
homeScroll.BorderSizePixel = 0
homeScroll.ScrollBarThickness = 5
homeScroll.Parent = homePage

local homeListLayout = Instance.new("UIListLayout")
homeListLayout.Padding = UDim.new(0, 5)
homeListLayout.Parent = homeScroll

local homeCorner = Instance.new("UICorner")
homeCorner.CornerRadius = UDim.new(0, 8)
homeCorner.Parent = homeScroll

-- --- SCANNER PAGE ---
local PageKiri = Instance.new("Frame")
PageKiri.Size = UDim2.new(0, 120, 1, -10)
PageKiri.Position = UDim2.new(0, 10, 0, 5)
PageKiri.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
PageKiri.Parent = scannerPage

local UICornerKiri = Instance.new("UICorner")
UICornerKiri.CornerRadius = UDim.new(0, 6)
UICornerKiri.Parent = PageKiri

local TitleKiri = Instance.new("TextLabel")
TitleKiri.Size = UDim2.new(1, 0, 0, 20)
TitleKiri.Position = UDim2.new(0, 0, 0, 4)
TitleKiri.BackgroundTransparency = 1
TitleKiri.Text = "SETTINGS"
TitleKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKiri.TextSize = 10
TitleKiri.Font = Enum.Font.GothamBold
TitleKiri.Parent = PageKiri

local LoggerToggle = Instance.new("TextButton")
LoggerToggle.Size = UDim2.new(1, -12, 0, 28)
LoggerToggle.Position = UDim2.new(0, 6, 0, 30)
LoggerToggle.BackgroundColor3 = Color3.fromRGB(35, 65, 35)
LoggerToggle.Text = "Logger [ON]"
LoggerToggle.TextColor3 = Color3.fromRGB(150, 255, 150)
LoggerToggle.TextSize = 10
LoggerToggle.Font = Enum.Font.GothamBold
LoggerToggle.Parent = PageKiri

local UICornerT1 = Instance.new("UICorner")
UICornerT1.CornerRadius = UDim.new(0, 6)
UICornerT1.Parent = LoggerToggle

local AutoSaveToggle = Instance.new("TextButton")
AutoSaveToggle.Size = UDim2.new(1, -12, 0, 28)
AutoSaveToggle.Position = UDim2.new(0, 6, 0, 65)
AutoSaveToggle.BackgroundColor3 = Color3.fromRGB(35, 65, 35)
AutoSaveToggle.Text = "Auto Save [ON]"
AutoSaveToggle.TextColor3 = Color3.fromRGB(150, 255, 150)
AutoSaveToggle.TextSize = 10
AutoSaveToggle.Font = Enum.Font.GothamBold
AutoSaveToggle.Parent = PageKiri

local UICornerT2 = Instance.new("UICorner")
UICornerT2.CornerRadius = UDim.new(0, 6)
UICornerT2.Parent = AutoSaveToggle

local PageKanan = Instance.new("Frame")
PageKanan.Size = UDim2.new(1, -150, 1, -10)
PageKanan.Position = UDim2.new(0, 140, 0, 5)
PageKanan.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
PageKanan.Parent = scannerPage

local UICornerKanan = Instance.new("UICorner")
UICornerKanan.CornerRadius = UDim.new(0, 6)
UICornerKanan.Parent = PageKanan

local TitleKanan = Instance.new("TextLabel")
TitleKanan.Size = UDim2.new(1, 0, 0, 20)
TitleKanan.Position = UDim2.new(0, 0, 0, 4)
TitleKanan.BackgroundTransparency = 1
TitleKanan.Text = "LIVE DANCE LOG"
TitleKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleKanan.TextSize = 10
TitleKanan.Font = Enum.Font.GothamBold
TitleKanan.Parent = PageKanan

local DanceFrame = Instance.new("ScrollingFrame")
DanceFrame.Size = UDim2.new(1, -12, 1, -65)
DanceFrame.Position = UDim2.new(0, 6, 0, 26)
DanceFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
DanceFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DanceFrame.ScrollBarThickness = 3
DanceFrame.Parent = PageKanan

local UICornerDance = Instance.new("UICorner")
UICornerDance.CornerRadius = UDim.new(0, 4)
UICornerDance.Parent = DanceFrame

local DanceListLayout = Instance.new("UIListLayout")
DanceListLayout.Padding = UDim.new(0, 3)
DanceListLayout.Parent = DanceFrame

local ConsoleLog = Instance.new("TextLabel")
ConsoleLog.Size = UDim2.new(1, -12, 0, 30)
ConsoleLog.Position = UDim2.new(0, 6, 1, -34)
ConsoleLog.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
ConsoleLog.Text = "> System Ready..."
ConsoleLog.TextColor3 = Color3.fromRGB(150, 255, 150)
ConsoleLog.TextSize = 9
ConsoleLog.Font = Enum.Font.Code
ConsoleLog.TextXAlignment = Enum.TextXAlignment.Left
ConsoleLog.TextYAlignment = Enum.TextYAlignment.Top
ConsoleLog.TextWrapped = true
ConsoleLog.Parent = PageKanan

local UICornerConsole = Instance.new("UICorner")
UICornerConsole.CornerRadius = UDim.new(0, 4)
UICornerConsole.Parent = ConsoleLog

-- --- OUTPUT PAGE ---
local copyOutputBtn = Instance.new("TextButton")
copyOutputBtn.Size = UDim2.new(1, -20, 0, 26)
copyOutputBtn.Position = UDim2.new(0, 10, 0, 5)
copyOutputBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 230)
copyOutputBtn.Text = "📋 Copy Semua Output"
copyOutputBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyOutputBtn.Font = Enum.Font.GothamBold
copyOutputBtn.TextSize = 11
copyOutputBtn.Parent = outputPage

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyOutputBtn

local outputScroll = Instance.new("ScrollingFrame")
outputScroll.Size = UDim2.new(1, -20, 1, -40)
outputScroll.Position = UDim2.new(0, 10, 0, 35)
outputScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
outputScroll.BorderSizePixel = 0
outputScroll.ScrollBarThickness = 6
outputScroll.Parent = outputPage

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 6)
outputCorner.Parent = outputScroll

local outputBox = Instance.new("TextBox")
outputBox.Size = UDim2.new(1, -12, 1, 0)
outputBox.Position = UDim2.new(0, 6, 0, 4)
outputBox.BackgroundTransparency = 1
outputBox.Text = "Pilih file .txt di Home untuk mulai memproses...\n(Bisa diedit & di-copy manual)"
outputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
outputBox.TextSize = 12
outputBox.Font = Enum.Font.Code
outputBox.TextXAlignment = Enum.TextXAlignment.Left
outputBox.TextYAlignment = Enum.TextYAlignment.Top
outputBox.ClearTextOnFocus = false
outputBox.TextEditable = true
outputBox.TextWrapped = true
outputBox.Parent = outputScroll

local function updateCanvas()
    local TextService = game:GetService("TextService")
    local textSize = TextService:GetTextSize(outputBox.Text, outputBox.TextSize, outputBox.Font, Vector2.new(outputScroll.AbsoluteSize.X - 20, 999999))
    outputScroll.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 20)
end
outputBox:GetPropertyChangedSignal("Text"):Connect(updateCanvas)

-- Handler Tombol Copy Output
copyOutputBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(outputBox.Text)
        copyOutputBtn.Text = "✓ Berhasil Di-copy ke Clipboard!"
        task.wait(1.5)
        copyOutputBtn.Text = "📋 Copy Semua Output"
    else
        copyOutputBtn.Text = "Blok teks manual di bawah"
        task.wait(1.5)
        copyOutputBtn.Text = "📋 Copy Semua Output"
    end
end)

--------------------------------------------------
-- BOTTOM BAR & NAVIGATION
--------------------------------------------------
local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, 0, 0, 40)
bottomBar.Position = UDim2.new(0, 0, 1, -40)
bottomBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
bottomBar.BorderSizePixel = 0
bottomBar.Parent = mainFrame

local copyrightLabel = Instance.new("TextLabel")
copyrightLabel.Size = UDim2.new(0, 110, 1, 0)
copyrightLabel.Position = UDim2.new(0, 10, 0, 0)
copyrightLabel.BackgroundTransparency = 1
copyrightLabel.Text = "© sptzyy × IkyyXD"
copyrightLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
copyrightLabel.TextSize = 10
copyrightLabel.Font = Enum.Font.GothamBold
copyrightLabel.TextXAlignment = Enum.TextXAlignment.Left
copyrightLabel.Parent = bottomBar

local tabHomeBtn = Instance.new("TextButton")
tabHomeBtn.Size = UDim2.new(0, 60, 0, 26)
tabHomeBtn.Position = UDim2.new(1, -200, 0, 7)
tabHomeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tabHomeBtn.Text = "Home"
tabHomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabHomeBtn.Font = Enum.Font.GothamMedium
tabHomeBtn.TextSize = 10
tabHomeBtn.Parent = bottomBar

local tabHomeCorner = Instance.new("UICorner")
tabHomeCorner.CornerRadius = UDim.new(0, 6)
tabHomeCorner.Parent = tabHomeBtn

local tabScanBtn = Instance.new("TextButton")
tabScanBtn.Size = UDim2.new(0, 60, 0, 26)
tabScanBtn.Position = UDim2.new(1, -135, 0, 7)
tabScanBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabScanBtn.Text = "Scanner"
tabScanBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tabScanBtn.Font = Enum.Font.GothamMedium
tabScanBtn.TextSize = 10
tabScanBtn.Parent = bottomBar

local tabScanCorner = Instance.new("UICorner")
tabScanCorner.CornerRadius = UDim.new(0, 6)
tabScanCorner.Parent = tabScanBtn

local tabOutputBtn = Instance.new("TextButton")
tabOutputBtn.Size = UDim2.new(0, 60, 0, 26)
tabOutputBtn.Position = UDim2.new(1, -70, 0, 7)
tabOutputBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabOutputBtn.Text = "Output"
tabOutputBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tabOutputBtn.Font = Enum.Font.GothamMedium
tabOutputBtn.TextSize = 10
tabOutputBtn.Parent = bottomBar

local tabOutputCorner = Instance.new("UICorner")
tabOutputCorner.CornerRadius = UDim.new(0, 6)
tabOutputCorner.Parent = tabOutputBtn

local function switchTab(page)
    homePage.Visible = (page == "Home")
    scannerPage.Visible = (page == "Scanner")
    outputPage.Visible = (page == "Output")
    
    tabHomeBtn.BackgroundColor3 = (page == "Home") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
    tabScanBtn.BackgroundColor3 = (page == "Scanner") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
    tabOutputBtn.BackgroundColor3 = (page == "Output") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
end

tabHomeBtn.MouseButton1Click:Connect(function() switchTab("Home") end)
tabScanBtn.MouseButton1Click:Connect(function() switchTab("Scanner") end)
tabOutputBtn.MouseButton1Click:Connect(function() switchTab("Output") end)

--------------------------------------------------
-- CEK NAMA (LOGIKA WEB API + MARKETPLACE)
--------------------------------------------------
local function getDanceName(assetId, fallbackName)
    local danceName = "Unknown / Private"
    
    -- 1. Web API Roblox Economy
    local reqSuccess, response = pcall(function()
        return game:HttpGet("https://economy.roblox.com/v2/assets/" .. tostring(assetId) .. "/details")
    end)
    
    if reqSuccess and response then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if decodeSuccess and data and data.Name then
            return data.Name
        end
    end
    
    -- 2. Fallback MarketplaceService
    local mpSuccess, assetInfo = pcall(function()
        return MarketplaceService:GetProductInfo(assetId, Enum.InfoType.Asset)
    end)
    
    if mpSuccess and assetInfo and assetInfo.Name then
        return assetInfo.Name
    end

    if fallbackName and fallbackName ~= "Animation" and fallbackName ~= "AnimationTrack" then
        return fallbackName
    end

    return "Dance_" .. tostring(assetId)
end

--------------------------------------------------
-- SCANNER & LIVE LOGGER LOGIC
--------------------------------------------------
local function setConsoleMessage(text, color)
    ConsoleLog.Text = "> " .. text
    ConsoleLog.TextColor3 = color or Color3.fromRGB(150, 255, 150)
end

LoggerToggle.MouseButton1Click:Connect(function()
    isLoggerEnabled = not isLoggerEnabled
    LoggerToggle.BackgroundColor3 = isLoggerEnabled and Color3.fromRGB(35, 65, 35) or Color3.fromRGB(65, 35, 35)
    LoggerToggle.Text = "Logger [" .. (isLoggerEnabled and "ON" or "OFF") .. "]"
    LoggerToggle.TextColor3 = isLoggerEnabled and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
    setConsoleMessage("Logger: " .. (isLoggerEnabled and "ACTIVE" or "STANDBY"))
end)

AutoSaveToggle.MouseButton1Click:Connect(function()
    isAutoSaveEnabled = not isAutoSaveEnabled
    AutoSaveToggle.BackgroundColor3 = isAutoSaveEnabled and Color3.fromRGB(35, 65, 35) or Color3.fromRGB(65, 35, 35)
    AutoSaveToggle.Text = "Auto Save [" .. (isAutoSaveEnabled and "ON" or "OFF") .. "]"
    AutoSaveToggle.TextColor3 = isAutoSaveEnabled and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
    setConsoleMessage("Auto Save: " .. (isAutoSaveEnabled and "ACTIVE" or "STANDBY"))
end)

local function refreshDanceList()
    for _, child in ipairs(DanceFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for idx, danceData in ipairs(savedDances) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, -4, 0, 20)
        itemFrame.LayoutOrder = idx
        itemFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        itemFrame.Parent = DanceFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = itemFrame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -22, 1, 0)
        btn.Position = UDim2.new(0, 4, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = idx .. ". " .. danceData.Name
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextSize = 9
        btn.Font = Enum.Font.Gotham
        btn.Parent = itemFrame

        btn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(danceData.Id)
                setConsoleMessage("Copied ID: " .. danceData.Name)
            else
                setConsoleMessage("ID: " .. danceData.Id)
            end
        end)

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 16, 1, 0)
        delBtn.Position = UDim2.new(1, -18, 0, 0)
        delBtn.BackgroundTransparency = 1
        delBtn.Text = "×"
        delBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        delBtn.TextSize = 12
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Parent = itemFrame

        delBtn.MouseButton1Click:Connect(function()
            table.remove(savedDances, idx)
            refreshDanceList()
        end)
    end

    DanceFrame.CanvasSize = UDim2.new(0, 0, 0, DanceListLayout.AbsoluteContentSize.Y)
end

local function hookAnimator(animator)
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not isLoggerEnabled then return end
        if track and track.Animation and track.Animation.AnimationId ~= "" then
            local rawId = track.Animation.AnimationId
            local cleanId = string.match(rawId, "%d+")
            if not cleanId then return end
            
            local fullAssetId = "rbxassetid://" .. cleanId

            for _, d in ipairs(savedDances) do
                if d.Id == fullAssetId then return end
            end

            task.spawn(function()
                local danceName = getDanceName(tonumber(cleanId), track.Name)

                table.insert(savedDances, {Name = danceName, Id = fullAssetId})
                refreshDanceList()

                setConsoleMessage("[LOGGED] " .. danceName, Color3.fromRGB(255, 220, 100))

                if writefile and isAutoSaveEnabled then
                    pcall(function()
                        local logEntry = string.format("name dance : %s\nid dance : %s\n----------------------------------------\n", danceName, fullAssetId)
                        if appendfile then
                            appendfile("saved_dances.txt", logEntry)
                        else
                            local existing = isfile("saved_dances.txt") and readfile("saved_dances.txt") or ""
                            writefile("saved_dances.txt", existing .. logEntry)
                        end
                    end)
                end
            end)
        end
    end)
end

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
    hookAnimator(animator)

    LocalPlayer.CharacterAdded:Connect(function(newChar)
        local h = newChar:WaitForChild("Humanoid")
        local a = h:FindFirstChildOfClass("Animator") or h
        hookAnimator(a)
    end)
end)

--------------------------------------------------
-- TXT READER & AUTO SAVE PROCESSOR
--------------------------------------------------
local function processTxtFile(content, fileName)
    switchTab("Output")
    outputBox.Text = "Membaca file: " .. fileName .. "\nMengambil ID & Nama Animasi...\n\n"
    
    local ids = {}
    for idStr in content:gmatch("(%d+)") do
        if #idStr >= 6 and not table.find(ids, tonumber(idStr)) then
            table.insert(ids, tonumber(idStr))
        end
    end

    if #ids == 0 then
        outputBox.Text = "Tidak ditemukan ID dance yang valid di file " .. fileName
        return
    end

    task.spawn(function()
        outputBox.Text = ""
        local fullOutput = ""
        
        for _, assetId in ipairs(ids) do
            local danceName = getDanceName(assetId)
            local entry = "name dance : " .. danceName .. "\nid dance : rbxassetid://" .. tostring(assetId) .. "\n----------------------------------------\n"
            
            fullOutput = fullOutput .. entry
            outputBox.Text = fullOutput
            updateCanvas()
            task.wait(0.08)
        end
        
        if writefile then
            local cleanName = fileName:gsub("%.txt$", "")
            local newFileName = cleanName .. "_output_sptzyy.txt"
            local saveSuccess = pcall(function()
                writefile(newFileName, fullOutput)
            end)
            
            if saveSuccess then
                outputBox.Text = outputBox.Text .. "\n[✓ AUTO SAVE SUCCESS]: Disimpan ke " .. newFileName
            end
            updateCanvas()
        end
    end)
end

local function loadInternalFiles()
    for _, child in ipairs(homeScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    if listfiles and readfile then
        local success, files = pcall(function() return listfiles("") end)
        if success and files then
            local count = 0
            for _, filePath in ipairs(files) do
                if filePath:sub(-4):lower() == ".txt" then
                    count = count + 1
                    local fileName = filePath:match("[^/%\\]+$") or filePath
                    
                    local fileBtn = Instance.new("TextButton")
                    fileBtn.Size = UDim2.new(1, -8, 0, 32)
                    fileBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
                    fileBtn.Text = "  📄 " .. fileName
                    fileBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
                    fileBtn.TextSize = 11
                    fileBtn.Font = Enum.Font.GothamMedium
                    fileBtn.TextXAlignment = Enum.TextXAlignment.Left
                    fileBtn.Parent = homeScroll
                    
                    local btnCorner = Instance.new("UICorner")
                    btnCorner.CornerRadius = UDim.new(0, 6)
                    btnCorner.Parent = fileBtn
                    
                    fileBtn.MouseButton1Click:Connect(function()
                        local readSuccess, content = pcall(function() return readfile(filePath) end)
                        if readSuccess then
                            processTxtFile(content, fileName)
                        else
                            outputBox.Text = "Gagal membaca file: " .. fileName
                        end
                    end)
                end
            end
            homeScroll.CanvasSize = UDim2.new(0, 0, 0, homeListLayout.AbsoluteContentSize.Y)
            if count == 0 then
                outputBox.Text = "Tidak ada file .txt di folder executor."
            end
        end
    else
        outputBox.Text = "Executor kamu tidak mendukung 'listfiles' / 'readfile'."
    end
end

-- Init Splash Animation
task.spawn(function()
    task.wait(1.5)
    TweenService:Create(splashFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(splashTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(splashSub, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.4)
    splashFrame:Destroy()
    switchTab("Home")
    loadInternalFiles()
end)
