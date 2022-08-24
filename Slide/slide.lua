local args ={...}
local path = "/anime/"
local filelist = fs.list(path)
local mons = {"back","left"}
local curFile = 1
local file = fs.open(path.. filelist[1],"rb")

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
	
    local width, height = mon.getSize()
	width = math.min(read16(), width)
    height = math.min(read16(), height)
    local comAm=read16() - 1
    mon.setCursorPos(1,1)
    for i= 0,comAm do 
        mon.setPaletteColor(bit.blshift(1,i), readCl())
    end
    for y = 1, height do
        for x =1, width do
			mon.setCursorPos(x,y)
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
	os.startTimer(3)
    file = fs.open(path .. filelist[curFile],"rb")
    
    curFile = curFile + 1
    if(curFile > #filelist) then curFile = 1 end
    
    for i = 1,#mons do
		file.seek("set",0)
        drawPic(mons[i])
    end

    os.pullEvent("timer")
end