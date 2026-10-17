local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")

-- Clean up UI lama jika ada
if PlayerGui and PlayerGui:FindFirstChild("SptzyyDanceUI") then
    PlayerGui.SptzyyDanceUI:Destroy()
end

-- 1. ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SptzyyDanceUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui or CoreGui

-- 2. Frame Utama (Persegi 360x380 di Tengah Layar)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 380)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = mainFrame

-- Top Bar Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
header.BorderSizePixel = 0
header.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Sptzyy TXT Manager"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
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

-- Container Halaman
local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -75)
container.Position = UDim2.new(0, 0, 0, 35)
container.BackgroundTransparency = 1
container.Parent = mainFrame

----------------------------------------------------
-- SPLASH SCREEN
----------------------------------------------------
local splashFrame = Instance.new("Frame")
splashFrame.Size = UDim2.new(1, 0, 1, 0)
splashFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
splashFrame.ZIndex = 10
splashFrame.Parent = container

local splashTitle = Instance.new("TextLabel")
splashTitle.Size = UDim2.new(1, 0, 0, 40)
splashTitle.Position = UDim2.new(0, 0, 0.4, -20)
splashTitle.BackgroundTransparency = 1
splashTitle.Text = "SPT ZYY"
splashTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
splashTitle.TextSize = 28
splashTitle.Font = Enum.Font.GothamBlack
splashTitle.ZIndex = 11
splashTitle.Parent = splashFrame

local splashSub = Instance.new("TextLabel")
splashSub.Size = UDim2.new(1, 0, 0, 20)
splashSub.Position = UDim2.new(0, 0, 0.4, 20)
splashSub.BackgroundTransparency = 1
splashSub.Text = "Loading System..."
splashSub.TextColor3 = Color3.fromRGB(180, 180, 180)
splashSub.TextSize = 12
splashSub.Font = Enum.Font.Gotham
splashSub.ZIndex = 11
splashSub.Parent = splashFrame

----------------------------------------------------
-- PAGES (HOME & OUTPUT)
----------------------------------------------------
local homePage = Instance.new("Frame")
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.Visible = false
homePage.Parent = container

local txtPage = Instance.new("Frame")
txtPage.Size = UDim2.new(1, 0, 1, 0)
txtPage.BackgroundTransparency = 1
txtPage.Visible = false
txtPage.Parent = container

-- --- HOME PAGE CONTENT ---
local homeTitle = Instance.new("TextLabel")
homeTitle.Size = UDim2.new(1, -20, 0, 25)
homeTitle.Position = UDim2.new(0, 10, 0, 10)
homeTitle.BackgroundTransparency = 1
homeTitle.Text = "Pilih File TXT Internal:"
homeTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
homeTitle.TextSize = 12
homeTitle.Font = Enum.Font.GothamMedium
homeTitle.TextXAlignment = Enum.TextXAlignment.Left
homeTitle.Parent = homePage

local homeScroll = Instance.new("ScrollingFrame")
homeScroll.Size = UDim2.new(1, -20, 1, -45)
homeScroll.Position = UDim2.new(0, 10, 0, 40)
homeScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
homeScroll.BorderSizePixel = 0
homeScroll.ScrollBarThickness = 5
homeScroll.Parent = homePage

local homeListLayout = Instance.new("UIListLayout")
homeListLayout.Padding = UDim.new(0, 5)
homeListLayout.Parent = homeScroll

local homeCorner = Instance.new("UICorner")
homeCorner.CornerRadius = UDim.new(0, 8)
homeCorner.Parent = homeScroll

-- --- OUTPUT PAGE CONTENT ---
local outputScroll = Instance.new("ScrollingFrame")
outputScroll.Size = UDim2.new(1, -20, 1, -20)
outputScroll.Position = UDim2.new(0, 10, 0, 10)
outputScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
outputScroll.BorderSizePixel = 0
outputScroll.ScrollBarThickness = 6
outputScroll.Parent = txtPage

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 6)
outputCorner.Parent = outputScroll

local outputBox = Instance.new("TextBox")
outputBox.Size = UDim2.new(1, -12, 1, 0)
outputBox.Position = UDim2.new(0, 6, 0, 4)
outputBox.BackgroundTransparency = 1
outputBox.Text = "Pilih file .txt di Home untuk mulai memproses...\n(Teks di sini dapat kamu edit manual)"
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

----------------------------------------------------
-- BOTTOM TAB BAR & COPYRIGHT
----------------------------------------------------
local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, 0, 0, 40)
bottomBar.Position = UDim2.new(0, 0, 1, -40)
bottomBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
bottomBar.BorderSizePixel = 0
bottomBar.Parent = mainFrame

local copyrightLabel = Instance.new("TextLabel")
copyrightLabel.Size = UDim2.new(0, 100, 1, 0)
copyrightLabel.Position = UDim2.new(0, 10, 0, 0)
copyrightLabel.BackgroundTransparency = 1
copyrightLabel.Text = "© sptzyy"
copyrightLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
copyrightLabel.TextSize = 11
copyrightLabel.Font = Enum.Font.GothamBold
copyrightLabel.TextXAlignment = Enum.TextXAlignment.Left
copyrightLabel.Parent = bottomBar

local tabHomeBtn = Instance.new("TextButton")
tabHomeBtn.Size = UDim2.new(0, 70, 0, 26)
tabHomeBtn.Position = UDim2.new(1, -150, 0, 7)
tabHomeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tabHomeBtn.Text = "Home"
tabHomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabHomeBtn.Font = Enum.Font.GothamMedium
tabHomeBtn.TextSize = 11
tabHomeBtn.Parent = bottomBar

local tabHomeCorner = Instance.new("UICorner")
tabHomeCorner.CornerRadius = UDim.new(0, 6)
tabHomeCorner.Parent = tabHomeBtn

local tabTxtBtn = Instance.new("TextButton")
tabTxtBtn.Size = UDim2.new(0, 70, 0, 26)
tabTxtBtn.Position = UDim2.new(1, -75, 0, 7)
tabTxtBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabTxtBtn.Text = "Output"
tabTxtBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tabTxtBtn.Font = Enum.Font.GothamMedium
tabTxtBtn.TextSize = 11
tabTxtBtn.Parent = bottomBar

local tabTxtCorner = Instance.new("UICorner")
tabTxtCorner.CornerRadius = UDim.new(0, 6)
tabTxtCorner.Parent = tabTxtBtn

local function switchTab(page)
    homePage.Visible = (page == "Home")
    txtPage.Visible = (page == "TXT")
    
    if page == "Home" then
        tabHomeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        tabTxtBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    else
        tabHomeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        tabTxtBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end

tabHomeBtn.MouseButton1Click:Connect(function() switchTab("Home") end)
tabTxtBtn.MouseButton1Click:Connect(function() switchTab("TXT") end)

----------------------------------------------------
-- LOGIKA PARSING TXT & FETCHING NAMA
----------------------------------------------------
local function processTxtFile(content, fileName)
    switchTab("TXT")
    outputBox.Text = "Membaca file: " .. fileName .. "\nMengambil ID & Nama Animasi...\n\n"
    
    -- Ambil semua ID angka dari teks
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
        for _, assetId in ipairs(ids) do
            local danceName = "Unknown / Private"
            
            -- Method 1: Web API Roblox (Mengambil nama asli file animasi)
            local reqSuccess, response = pcall(function()
                return game:HttpGet("https://economy.roblox.com/v2/assets/" .. tostring(assetId) .. "/details")
            end)
            
            if reqSuccess and response then
                local decodeSuccess, data = pcall(function()
                    return HttpService:JSONDecode(response)
                end)
                if decodeSuccess and data and data.Name then
                    danceName = data.Name
                end
            end
            
            -- Method 2: Fallback ke MarketplaceService jika API Web gagal
            if danceName == "Unknown / Private" then
                local mpSuccess, assetInfo = pcall(function()
                    return MarketplaceService:GetProductInfo(assetId, Enum.InfoType.Asset)
                end)
                if mpSuccess and assetInfo and assetInfo.Name then
                    danceName = assetInfo.Name
                end
            end

            local entry = "name dance : " .. danceName .. "\nid dance : rbxassetid://" .. tostring(assetId) .. "\n----------------------------------------\n"
            
            outputBox.Text = outputBox.Text .. entry
            updateCanvas()
            task.wait(0.08)
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
                    fileBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
                    fileBtn.Text = "  📄 " .. fileName
                    fileBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
                    fileBtn.TextSize = 12
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

-- Initialize Splash Screen Animation
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
