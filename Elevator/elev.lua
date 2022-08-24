local reverse = "top"
local clutch = "bottom"
local input = "left"
local modem = peripheral.wrap("back")
local floors = {"-1", " 1", " 2", " 3"}

local mons = {}
local buttons = {}
local prvFloor =1
local currentFloor , requestedFloor = 1 , 1
local elevMoving = false

local function getMons() 
    local pers = modem.getNamesRemote()
    --textutils.tabulate(pers)
    for i =1, #pers do
        if modem.getTypeRemote(pers[i]) == "monitor" then
            table.insert(mons, peripheral.wrap(pers[i]))
        end
    end
end
getMons()

local function writeAll(text) 
    for i =1,#mons do
        mons[i].write(text);
    end
end

local function setCursorAll(x,y) 
    for i =1,#mons do
        mons[i].setCursorPos(x,y);
    end
end
local function clearAll() 
    for i =1,#mons do
        mons[i].clear();
    end
end

local function setScaleAll(x) 
    for i =1,#mons do
        mons[i].setTextScale(x);
    end
end

local function chBgColAll(col)
    for i =1,#mons do
        if mons[i].getBackgroundColor() ~= col then
            mons[i].setBackgroundColor(col)
        end
    end
end
setScaleAll(1)

local function chTxColAll(col)
    for i =1,#mons do
        if mons[i].getTextColor() ~= col then
            mons[i].setTextColor(col)
        end
    end
end
local function printText(x,y,text,bgColor,textColor) 
    chBgColAll(bgColor)
    chTxColAll(textColor)
    setCursorAll(x,y)
    writeAll(text)
end
local function printShadow(x,y,w)
    chBgColAll(colors.white)
    chTxColAll(colors.lightGray)
    setCursorAll(x+w,y);writeAll(string.char(0x94))
    setCursorAll(x,y+1);writeAll(string.char(0x82))
    for i = x, x+w-1 do 
        writeAll(string.char(0x83))
    end
    setCursorAll(x+w,y+1);writeAll(string.char(0x81))
end
local function createButton(x,y,text,bgColor,textColor,fn)
    printShadow(x,y,#text)
    printText(x,y,text,bgColor,textColor)
    table.insert(buttons,{x=x,w=#text,y=y,fn=fn,tx=text,id = #buttons+1})
end
local function checkButtons(x,y)
    for i = 1,#buttons do
        if x >= buttons[i].x and x < buttons[i].x+buttons[i].w and y == buttons[i].y then
            buttons[i].fn(i)
        end
    end
end

local function elevCall(cr) 
    if cr == currentFloor then 
        return 
    end

    local prv = buttons[requestedFloor]
    printText(prv.x,prv.y,prv.tx,colors.lightBlue,colors.white)
    requestedFloor = cr
    local btn = buttons[cr]
    printText(btn.x,btn.y,btn.tx,colors.lime,colors.white)
    print(currentFloor - requestedFloor)
    if (currentFloor - requestedFloor) < 0 then
        redstone.setOutput(reverse , true)
        print("reverseOn")
    else
        redstone.setOutput(reverse , false)
        print("reverseOff")
    end
    redstone.setOutput(clutch , false)
    elevMoving = true
end

local function getFloor() 
    if redstone.getInput(input) then
        prvFloor = currentFloor
        currentFloor = 16 - redstone.getAnalogInput(input)
    end
    return currentFloor
end
local function lightButton()
    local btn = buttons[prvFloor]
    printText(btn.x,btn.y,btn.tx,colors.lightBlue,colors.white)
    btn = buttons[currentFloor]
    printText(btn.x,btn.y,btn.tx,colors.yellow,colors.white)
end
chBgColAll(colors.white)
clearAll()
printText(1,1,"Elevator",colors.gray,colors.lightGray)

createButton(2,2,floors[1],colors.lightBlue,colors.white,elevCall)
createButton(5,2,floors[2],colors.lightBlue,colors.white,elevCall)

createButton(2,4,floors[3],colors.lightBlue,colors.white,elevCall)
createButton(5,4,floors[4],colors.lightBlue,colors.white,elevCall)
term.clear()
getFloor()
if not redstone.getInput(input) then
    buttons[1].fn(1)
end
lightButton()
while true do
    local evType ,a,b,c,d= os.pullEvent()
    if evType == "redstone" then
        getFloor()
        if currentFloor == requestedFloor then
            redstone.setOutput(clutch,true)
        end
        lightButton()
    end
    if evType == "monitor_touch" then
        checkButtons(b,c)
    end
end