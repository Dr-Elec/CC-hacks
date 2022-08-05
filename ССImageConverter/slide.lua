local args ={...}
local filelist = fs.list(args[1])
local mons = {"back","left"}
local curFile = 1
local file

local mon

local function read16() 
    local val1 = file.read()
    local val2 = file.read()
    val2 = bit.blshift(val2,8)
    val1 = bit.bor(val1,val2)
    return val1
end

local function readCl()
    local b = file.read()
    local g = file.read()
    local r = file.read()
    r = bit.blshift(r,16)
    g = bit.blshift(g,8)
    b = bit.bor(b,g)
    b = bit.bor(b,r)
    return b
end

local function drawPic(side)
    mon = peripheral.wrap(side) 
    mon.setTextScale(0.5)
    local Mwidth, Mheight = mon.getSize()
    local Fwidth = read16()
    local Fheight = read16()

    local comAm=read16()
    mon.setCursorPos(1,1)
    for i= 0,15 do 
        mon.setPaletteColor(bit.blshift(1,i),readCl())
    end
    for y = 1, Fheight do
        for x =1,Fwidth do
            local palB = file.read()
            local palF = bit.band(palB,15)
            palB = bit.brshift(palB,4)
            palB = bit.blshift(1,palB)
            palF = bit.blshift(1,palF)

            local sym = file.read()
            sym = string.char(sym)
            mon.setBackgroundColor(palB)
            mon.setTextColor(palF)
            mon.write(sym)
        end
    end
end



while true do 
    startTimer(3000)
    file = fs.open(filelist[curFile])
    curFile = curFile +1
    if(curFile > #filelist) curFile = 1
    for i = 1,#mons do
        drawPic(mons[i])
    end
    os.pullEvent("timer")
end