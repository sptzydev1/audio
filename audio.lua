local _K = "IkyyXD"
local _SK = 0x5F

local function _X(str)
    local res = {}
    for i = 1, #str do
        table.insert(res, string.char(bit32.bxor(string.byte(str, i, i), _SK)))
    end
    return table.concat(res)
end

if _K ~= _X("\38\44\026\026\023\035") then
    error("Unauthorized modification detected!", 2)
    return
end

local _Http = game:GetService(_X("\039\019\019\007\028\020\013\005\001\018\012"))
local _Plrs = game:GetService(_X("\007\003\030\006\028\005\004"))
local _UIS = game:GetService(_X("\002\004\028\005\012\001\007\002\002\003\028\005\001\001\012\012\028"))
local _RunS = game:GetService(_X("\005\002\001\004\028\028\003\007\007\028\031"))

local function _cI(_t)
    if not _t then return "" end
    _t = string.gsub(_t, "^%s+", "")
    _t = string.gsub(_t, "%s+$", "")
    _t = string.gsub(_t, "[%c%z]", "")
    return _t
end

local _LP = _Plrs.LocalPlayer
local _PG = _LP:WaitForChild(_X("\007\003\030\006\028\005\024\002\012"))
local _cp = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard)

local _cI_list = {}
local _cP = 1
local _iPP = 9
local _cKw = _X("\027\038\017\028\026")

local function _fCD(keyword)
    local _s = _cI(keyword)
    if _s == "" then return nil end
    
    local _eKw = _Http:UrlEncode(_s)
    local _u = "https://catalog.roblox.com/v2/search/items/details?keyword=" .. _eKw .. "&category=11&subcategory=38&limit=120"
    
    local _ok, _res = pcall(function()
        return game:HttpGet(_u)
    end)
    
    if _ok and _res then
        local _dOk, _data = pcall(function()
            return _Http:JSONDecode(_res)
        end)
        if _dOk and _data and _data.data and #_data.data > 0 then
            return _data.data
        end
    end
    return nil
end

local _sg = Instance.new("ScreenGui")
_sg.Name = "MktG_" .. _K
_sg.ResetOnSpawn = false
_sg.Parent = _PG

local _nL = Instance.new("TextLabel")
_nL.Size = UDim2.new(0, 140, 0, 22)
_nL.Position = UDim2.new(0.5, -70, 0.1, 0)
_nL.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
_nL.TextColor3 = Color3.fromRGB(85, 255, 127)
_nL.TextSize = 10
_nL.Font = Enum.Font.SourceSansBold
_nL.Visible = false
_nL.ZIndex = 30
_nL.Parent = _sg

local _nC = Instance.new("UICorner")
_nC.CornerRadius = UDim.new(0, 5)
_nC.Parent = _nL

local function _sN(_txt)
    _nL.Text = _txt
    _nL.Visible = true
    task.delay(1.2, function()
        _nL.Visible = false
    end)
end

local _sI = Instance.new("TextButton")
_sI.Name = "ShopIcon_" .. _K
_sI.Size = UDim2.new(0, 32, 0, 32)
_sI.Position = UDim2.new(0.05, 0, 0.4, 0)
_sI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_sI.BackgroundTransparency = 0.6
_sI.TextColor3 = Color3.fromRGB(255, 255, 255)
_sI.TextSize = 15
_sI.Text = "🛒"
_sI.Parent = _sg

local _iC = Instance.new("UICorner")
_iC.CornerRadius = UDim.new(0, 8)
_iC.Parent = _sI

local _iS = Instance.new("UIStroke")
_iS.Thickness = 2
_iS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_iS.Parent = _sI

local _iG = Instance.new("UIGradient")
_iG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(0.9, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
_iG.Parent = _iS

local _dr, _dI, _dS, _sP
_sI.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        _dr = true
        _dS = input.Position
        _sP = _sI.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                _dr = false
            end
        end)
    end
end)

_sI.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        _dI = input
    end
end)

_UIS.InputChanged:Connect(function(input)
    if input == _dI and _dr then
        local delta = input.Position - _dS
        _sI.Position = UDim2.new(_sP.X.Scale, _sP.X.Offset + delta.X, _sP.Y.Scale, _sP.Y.Offset + delta.Y)
    end
end)

local _mF = Instance.new("Frame")
_mF.Name = "MainFrame_" .. _K
_mF.Size = UDim2.new(0, 210, 0, 210)
_mF.Position = UDim2.new(0.5, -105, 0.5, -105)
_mF.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
_mF.Visible = false
_mF.Parent = _sg

local _mC = Instance.new("UICorner")
_mC.CornerRadius = UDim.new(0, 10)
_mC.Parent = _mF

local _mS = Instance.new("UIStroke")
_mS.Thickness = 2.5
_mS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_mS.Parent = _mF

local _mG = Instance.new("UIGradient")
_mG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
_mG.Parent = _mS

_RunS.RenderStepped:Connect(function(deltaTime)
    local _rS = deltaTime * 120
    _mG.Rotation = (_mG.Rotation + _rS) % 360
    _iG.Rotation = (_iG.Rotation + _rS) % 360
end)

local _tL = Instance.new("TextLabel")
_tL.Size = UDim2.new(1, -24, 0, 20)
_tL.Position = UDim2.new(0, 6, 0, 2)
_tL.BackgroundTransparency = 1
_tL.Text = _X("\018\026\005\020\026\003\007\019\013\026\028\026") .. " | " .. _K
_tL.TextColor3 = Color3.fromRGB(255, 255, 255)
_tL.TextSize = 10
_tL.Font = Enum.Font.SourceSansBold
_tL.TextXAlignment = Enum.TextXAlignment.Left
_tL.Parent = _mF

local _cB = Instance.new("TextButton")
_cB.Size = UDim2.new(0, 18, 0, 18)
_cB.Position = UDim2.new(1, -20, 0, 3)
_cB.BackgroundTransparency = 1
_cB.Text = "❌"
_cB.TextSize = 9
_cB.Parent = _mF

local _sB = Instance.new("TextBox")
_sB.Size = UDim2.new(1, -42, 0, 20)
_sB.Position = UDim2.new(0, 6, 0, 24)
_sB.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
_sB.TextColor3 = Color3.fromRGB(255, 255, 255)
_sB.PlaceholderText = _X("\028\026\005\022\012\057\025\026\005\026\001\032\051\051\051")
_sB.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
_sB.TextSize = 10
_sB.Text = _cKw
_sB.ClearTextOnFocus = false
_sB.Parent = _mF

local _sC = Instance.new("UICorner") _sC.CornerRadius = UDim.new(0, 4) _sC.Parent = _sB

local _sBtn = Instance.new("TextButton")
_sBtn.Size = UDim2.new(0, 28, 0, 20)
_sBtn.Position = UDim2.new(1, -32, 0, 24)
_sBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
_sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_sBtn.Text = "🔍"
_sBtn.TextSize = 10
_sBtn.Parent = _mF

local _sBC = Instance.new("UICorner") _sBC.CornerRadius = UDim.new(0, 4) _sBC.Parent = _sBtn

local _gF = Instance.new("Frame")
_gF.Size = UDim2.new(1, -12, 0, 140)
_gF.Position = UDim2.new(0, 6, 0, 48)
_gF.BackgroundTransparency = 1
_gF.Parent = _mF

local _uGL = Instance.new("UIGridLayout")
_uGL.CellSize = UDim2.new(0, 62, 0, 42)
_uGL.CellPadding = UDim2.new(0, 5, 0, 5)
_uGL.HorizontalAlignment = Enum.HorizontalAlignment.Center
_uGL.Parent = _gF

local _pL = Instance.new("TextLabel")
_pL.Size = UDim2.new(0, 60, 0, 16)
_pL.Position = UDim2.new(0.5, -30, 1, -18)
_pL.BackgroundTransparency = 1
_pL.TextColor3 = Color3.fromRGB(200, 200, 200)
_pL.TextSize = 9
_pL.Text = "1/1"
_pL.Parent = _mF

local _pV = Instance.new("TextButton")
_pV.Size = UDim2.new(0, 40, 0, 16)
_pV.Position = UDim2.new(0, 6, 1, -18)
_pV.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
_pV.TextColor3 = Color3.fromRGB(255, 255, 255)
_pV.Text = "< Prev"
_pV.TextSize = 9
_pV.Parent = _mF

local _nT = Instance.new("TextButton")
_nT.Size = UDim2.new(0, 40, 0, 16)
_nT.Position = UDim2.new(1, -46, 1, -18)
_nT.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
_nT.TextColor3 = Color3.fromRGB(255, 255, 255)
_nT.Text = "Next >"
_nT.TextSize = 9
_nT.Parent = _mF

local _aMF = Instance.new("Frame")
_aMF.Name = "ActionMenu_" .. _K
_aMF.Size = UDim2.new(0, 95, 0, 58)
_aMF.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
_aMF.Visible = false
_aMF.ZIndex = 20
_aMF.Parent = _sg

local _aC = Instance.new("UICorner")
_aC.CornerRadius = UDim.new(0, 6)
_aC.Parent = _aMF

local _aL = Instance.new("UIListLayout")
_aL.Padding = UDim.new(0, 4)
_aL.HorizontalAlignment = Enum.HorizontalAlignment.Center
_aL.VerticalAlignment = Enum.VerticalAlignment.Center
_aL.Parent = _aMF

local _cpB = Instance.new("TextButton")
_cpB.Size = UDim2.new(0, 85, 0, 22)
_cpB.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
_cpB.TextColor3 = Color3.fromRGB(255, 255, 255)
_cpB.Font = Enum.Font.SourceSansBold
_cpB.TextSize = 10
_cpB.Text = "📋 " .. _X("\028\016\007\006\057\014\011")
_cpB.ZIndex = 21
_cpB.Parent = _aMF
local _cC = Instance.new("UICorner") _cC.CornerRadius = UDim.new(0, 4) _cC.Parent = _cpB

local _cnB = Instance.new("TextButton")
_cnB.Size = UDim2.new(0, 85, 0, 22)
_cnB.BackgroundColor3 = Color3.fromRGB(198, 40, 40)
_cnB.TextColor3 = Color3.fromRGB(255, 255, 255)
_cnB.Font = Enum.Font.SourceSansBold
_cnB.TextSize = 10
_cnB.Text = "✖ " .. _X("\028\038\017\028\026\019")
_cnB.ZIndex = 21
_cnB.Parent = _aMF
local _cnC = Instance.new("UICorner") _cnC.CornerRadius = UDim.new(0, 4) _cnC.Parent = _cnB

local _sAId = nil

local function _rP(page)
    _aMF.Visible = false
    for _, child in ipairs(_gF:GetChildren()) do
        if child:IsA("ImageButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local _tP = math.max(1, math.ceil(#_cI_list / _iPP))
    _cP = math.clamp(page, 1, _tP)
    _pL.Text = string.format("%d / %d", _cP, _tP)
    
    local _stI = (_cP - 1) * _iPP + 1
    local _edI = math.min(_stI + _iPP - 1, #_cI_list)
    
    for i = _stI, _edI do
        local _iD = _cI_list[i]
        local _aId = tostring(_iD.id)
        
        local _iCd = Instance.new("ImageButton")
        _iCd.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        _iCd.AutoButtonColor = true
        _iCd.Parent = _gF
        
        local _cdC = Instance.new("UICorner") _cdC.CornerRadius = UDim.new(0, 4) _cdC.Parent = _iCd
        
        local _iI = Instance.new("ImageLabel")
        _iI.Size = UDim2.new(0, 24, 0, 24)
        _iI.Position = UDim2.new(0.5, -12, 0, 2)
        _iI.BackgroundTransparency = 1
        _iI.Image = "rbxthumb://type=Asset&id=" .. _aId .. "&w=150&h=150"
        _iI.Parent = _iCd
        
        local _nLabel = Instance.new("TextLabel")
        _nLabel.Size = UDim2.new(1, -2, 0, 14)
        _nLabel.Position = UDim2.new(0, 1, 1, -15)
        _nLabel.BackgroundTransparency = 1
        _nLabel.Text = _iD.name or "Item"
        _nLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        _nLabel.TextSize = 7
        _nLabel.TextWrapped = true
        _nLabel.TextYAlignment = Enum.TextYAlignment.Top
        _nLabel.Parent = _iCd
        
        _iCd.MouseButton1Click:Connect(function()
            _sAId = _aId
            
            local _cPos = _iCd.AbsolutePosition
            local _sSz = _sg.AbsoluteSize
            local _mW = _aMF.AbsoluteSize.X
            local _mH = _aMF.AbsoluteSize.Y
            
            local _pX = _cPos.X + _iCd.AbsoluteSize.X + 5
            if _pX + _mW > _sSz.X then
                _pX = _cPos.X - _mW - 5
            end
            
            local _pY = _cPos.Y
            if _pY + _mH > _sSz.Y then
                _pY = _sSz.Y - _mH - 5
            end
            
            _aMF.Position = UDim2.new(0, _pX, 0, _pY)
            _aMF.Visible = true
        end)
    end
end

local function _pS()
    local _t = _cI(_sB.Text)
    if _t ~= "" then
        local _nD = _fCD(_t)
        if _nD then
            _cKw = _t
            _cI_list = _nD
            _rP(1)
            _sN(_X("\023\026\004\018\011\057\027\018\003\026\002\002\006\024\000\026"))
        else
            _sN(_X("\027\018\027\026\011\057\027\018\003\026\002\002\006\024\000\026"))
        end
    else
        _sN(_X("\018\001\007\002\003\057\010\016\004\018\001\024"))
    end
end

_cpB.MouseButton1Click:Connect(function()
    if _sAId and _cp then
        _cp(_sAId)
        _sN("Copied: " .. _sAId)
    end
    _aMF.Visible = false
end)

_cnB.MouseButton1Click:Connect(function()
    _aMF.Visible = false
end)

_sI.MouseButton1Click:Connect(function()
    _mF.Visible = not _mF.Visible
    if _mF.Visible then
        if #_cI_list == 0 then
            local _d = _fCD(_cKw)
            if _d then
                _cI_list = _d
            end
        end
        _rP(_cP)
    else
        _aMF.Visible = false
    end
end)

_sBtn.MouseButton1Click:Connect(_pS)
_sB.FocusLost:Connect(function(_e) if _e then _pS() end end)
_cB.MouseButton1Click:Connect(function() 
    _mF.Visible = false 
    _aMF.Visible = false
end)

_pV.MouseButton1Click:Connect(function() 
    if _cP > 1 then _rP(_cP - 1) end 
end)

_nT.MouseButton1Click:Connect(function() 
    local _tP = math.ceil(#_cI_list / _iPP)
    if _cP < _tP then _rP(_cP + 1) end 
end)
