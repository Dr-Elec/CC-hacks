local spL = peripheral.wrap("speaker_1")
local spR = peripheral.wrap("speaker_0")
local args = {...}

function bit.get(input,i)
    return bit.brshift()
end

local file = fs.open(args[1],"rb")
local name = peripheral.getName(spL)

local samlplesNL, samlplesNR = {}, {}
local samlplesOL, samlplesOR = {}, {}

local size = fs.getSize(args[1])

print(args[1])
print(size)
print("--------------------------------------------")

local function Uint8toInt32(val)
    local minus = bit.band(val, 128)
    if minus == 128 then 
        local mask = 0xFF
        val = bit.band(bit.bnot(val), mask)
        val = -val + 1 -- heavy!
    end
    return val
end
local rest = 1024 * 128 
local function isEnd()
    local pos = file.seek("cur",0)

    local rest= (size - pos ) / 2
    if rest > (1024 * 128) then 
        rest = 1024 * 128 
    end
end
local function getData()
    for i = 1, rest do
        samlplesNL[i] = Uint8toInt32(file.read())
        samlplesNR[i] = Uint8toInt32(file.read())
    end
end
-- if file.seek("cur",0) == size then
--     break;
-- end

----------init
getData()
samlplesOL = samlplesNL
samlplesOR = samlplesNR
spL.playAudio(samlplesOL,3)
spR.playAudio(samlplesOR,3) 


local reqL,reqR = true, true
while true do
    if reqL and reqR then
        getData()
        reqL,reqR = false, false
    end
    local _, sp = os.pullEvent("speaker_audio_empty")
    if sp == name then
        spL.playAudio(samlplesOL,3)
        samlplesOL = samlplesNL
        reqL = true
    else
        spR.playAudio(samlplesOR,3) 
        samlplesOR = samlplesNR
        reqR = true
    end
    
end