local monitor = peripheral.wrap("top")
term.redirect(monitor)
local title ="Super Enchanter v0.14.1 "
local width, height = term.getSize()
local keepOn = true;
local quarkRunes = { ["0"]="{id:\"quark:white_rune\",Count:1b}",
    ["1"]="{id:\"quark:orange_rune\",Count:1b}",
    ["2"]="{id:\"quark:magenta_rune\",Count:1b}",
    ["3"]="{id:\"quark:light_blue_rune\",Count:1b}",
    ["4"]="{id:\"quark:yellow_rune\",Count:1b}",
    ["5"]="{id:\"quark:lime_rune\",Count:1b}",
    ["6"]="{id:\"quark:pink_rune\",Count:1b}",
    ["7"]="{id:\"quark:gray_rune\",Count:1b}",
    ["8"]="{id:\"quark:light_gray_rune\",Count:1b}",
    ["9"]="{id:\"quark:cyan_rune\",Count:1b}",
    ["a"]="{id:\"quark:purple_rune\",Count:1b}",
    ["b"]="{id:\"quark:blue_rune\",Count:1b}",
    ["c"]="{id:\"quark:brown_rune\",Count:1b}",
    ["d"]="{id:\"quark:green_rune\",Count:1b}",
    ["e"]="{id:\"quark:red_rune\",Count:1b}",
    ["f"]="{id:\"quark:black_rune\",Count:1b}",
    ["r"]="{id:\"quark:rainbow_rune\",Count:1b}"
}
-- Clear the monitor 
term.setBackgroundColor(colors.white)
term.clear()
--Define helping func
local function chBgCol(col)
    if term.getBackgroundColor() ~= col then
        term.setBackgroundColor(col)
    end
end
local function chTxCol(col)
    if term.getTextColor() ~= col then
        term.setTextColor(col)
    end
end
local function printText(x,y,txt,bgCol,txCol) 
    chBgCol(bgCol)
    chTxCol(txCol)
    term.setCursorPos(x,y)
    write(txt)
end
-- Create title bar
chBgCol(colors.gray)
paintutils.drawLine(1,1,width,1)
printText(1,1,title,colors.gray,colors.lightBlue)
printText(width-11, 3,string.char(169).." Copyright",colors.white,colors.lightGray)
printText(width-12,4,"DrElec, 2022",colors.white,colors.lightGray) 
--Create buttons
local buttons = {}

local function createButton(x,y,text,bgColor,textColor,fn)
    printText(x,y,text,bgColor,textColor)
    table.insert(buttons,{x=x,w=x+#text,y=y,fn=fn,tx=text})
end

local function close(bt)
    keepOn = false;
    chBgCol(colors.black)
    chTxCol(colors.white)
    term.clear()
    shell.run("cd /");
    fs.delete("enchant.lua")
    shell.run("wget https://raw.githubusercontent.com/Dr-Elec/CC-hacks/main/enchant.lua")
    os.reboot()
end

local function ench(bt) 
    local command = "data merge entity @e[type=item,distance=..5,limit=1] {Item:{tag:{Unbreakable:1b"
    .. (bt.tx == " Disenchant " and ",Enchantments:[]" or "")
    .. (bt.tx == " Sword " and ",Enchantments:[{id:'minecraft:sharpness',lvl:8s},{id:'minecraft:knockback',lvl:2s},{id:'minecraft:fire_aspect',lvl:3s},{id:'minecraft:looting',lvl:6s},{id:'cyclic:beheading',lvl:5s},{id:'cyclic:magnet',lvl:3s},{id:'cyclic:experience_boost',lvl:5s},{id:'cyclic:ender',lvl:5s},{id:'cyclic:venom',lvl:5s}]" or "")
    .. (bt.tx == " Pickaxe " and ",Enchantments:[{id:\"minecraft:efficiency\",lvl:8s},{id:\"minecraft:fortune\",lvl:5s},{id:'cyclic:magnet',lvl:6s},{id:'cyclic:experience_boost',lvl:5s},{id:'cyclic:excavate',lvl:5s}]" or "")
    .. (bt.tx == " Shovel " and ",Enchantments:[{id:\"minecraft:efficiency\",lvl:8s},{id:'cyclic:magnet',lvl:6s},{id:'cyclic:experience_boost',lvl:5s},{id:'cyclic:excavate',lvl:5s}]" or "")
    .. (bt.tx == " Axe " and ",Enchantments:[{id:\"minecraft:efficiency\",lvl:8s},{id:\"minecraft:sharpness\",lvl:5s},{id:'cyclic:magnet',lvl:6s},{id:'cyclic:experience_boost',lvl:5s}]" or "")
    .. (bt.tx == " Hoe " and ",Enchantments:[{id:\"minecraft:efficiency\",lvl:8s},{id:\"minecraft:fortune\",lvl:5s},{id:'cyclic:magnet',lvl:6s},{id:'cyclic:experience_boost',lvl:5s}]" or "")
    .. (bt.tx == " Helmet " and ",Enchantments:[{id:\"minecraft:protection\",lvl:8s},{id:\"minecraft:thorns\",lvl:5s}]" or "")
    .. "}}}"
    local _, out = commands.exec(command)
    commands.msg("@p "..out[1])
end
--

local function get(bt) 
    local _, out = commands.exec("data get entity @e[type=item,distance=..5,limit=1] Item.tag")
    commands.msg("@p "..out[1])
end
local function prnt(bt) 
    commands.msg("@p "..bt.tx)
end
local function rune(bt) 
    local _, out = commands.exec("data merge entity @e[type=item,distance=..5,limit=1] {Item:{tag:{\"quark:RuneAttached\":1b,\"quark:RuneColor\":".. quarkRunes[bt.tx].."}}}")
    commands.msg("@p "..out[1])
end

createButton(width,1,"X",colors.gray,colors.red,close)
createButton(width-4,1,"G",colors.gray,colors.green,get)

createButton(4,3," Sword ",colors.red,colors.orange,ench)
createButton(3,5," Pickaxe ",colors.blue,colors.lightBlue,ench)
createButton(3,7," Shovel ",colors.brown,colors.yellow,ench)
createButton(5,9," Hoe ",colors.green,colors.magenta,ench)
createButton(5,11," Axe ",colors.cyan,colors.lime,ench)

createButton(16,3," Bow ",colors.cyan,colors.magenta,ench)
createButton(15,5," Helmet ",colors.cyan,colors.magenta,ench)
createButton(14,7," Chestplate ",colors.cyan,colors.magenta,ench)
createButton(15,9," Leggings ",colors.cyan,colors.magenta,ench)
createButton(16,11," Boots ",colors.cyan,colors.magenta,ench)
createButton(27,11," Disenchant ",colors.black,colors.red,ench)

--quark rune menu
printText(width-8,height-5," Rune: ;",colors.gray,colors.white)

createButton(width-8,(height-4),"0",colors.white,colors.black,rune)
createButton(width-7,(height-4),"1",colors.orange,colors.black,rune)
createButton(width-6,(height-4),"2",colors.magenta,colors.black,rune)
createButton(width-5,(height-4),"3",colors.lightBlue,colors.black,rune)
createButton(width-4,(height-4),"4",colors.yellow,colors.black,rune)
createButton(width-3,(height-4),"5",colors.lime,colors.black,rune)
createButton(width-2,(height-4),"6",colors.pink,colors.black,rune)
createButton(width-1,(height-4),"7",colors.gray,colors.black,rune)

createButton(width-8,(height-3),"8",colors.lightGray,colors.black,rune)
createButton(width-7,(height-3),"9",colors.cyan,colors.black,rune)
createButton(width-6,(height-3),"a",colors.purple,colors.black,rune)
createButton(width-5,(height-3),"b",colors.blue,colors.black,rune)
createButton(width-4,(height-3),"c",colors.brown,colors.black,rune)
createButton(width-3,(height-3),"d",colors.green,colors.black,rune)
createButton(width-2,(height-3),"e",colors.red,colors.black,rune)
createButton(width-1,(height-3),"f",colors.black,colors.white,rune)

createButton(width-1,(height-5),"r",colors.red,colors.purple,rune)
--end of quark rune menu
chBgCol(colors.black)
chTxCol(colors.white)

--Event work
while keepOn do
    local  ev, _, xPos, yPos = os.pullEvent("monitor_touch")
    if ev == "monitor_touch" then
        for i = 1,#buttons do
            if xPos >= buttons[i].x and xPos < buttons[i].w and yPos == buttons[i].y then
                buttons[i].fn(buttons[i])
            end
        end
    end  
end




