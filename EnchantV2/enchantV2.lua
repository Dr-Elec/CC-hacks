require("adv")
local enchD = require("enchantV2data")
local GUI = require("GUI")
local NBT = require("NBT")

GUI.addMon(peripheral.wrap("top"))
local title = "  Super Enchanter v0.2.0 pre-alpha 1  " -- len == width
local width, height = peripheral.call("top", "getSize")
local pageButtons = {}
local rainbowCurCol = 1
local curEnchs = {}
local selectedEnch = ""
local EnchsPoses = {}
function updateRainbow()
    local cl = bit.blshift(1,rainbowCurCol)
    GUI.printText(2,8,"r ",cl,cl)
end
enchD.curPage = " 1 "
function chPage(btn)
    local prv = pageButtons[enchD.curPage]
    GUI.printText(prv.x, prv.y, prv.tx, prv.bg, prv.fg)
    enchD.curPage = btn.tx
    GUI.printText(btn.x, btn.y, btn.tx, btn.fg, colors.white)
    enchD.printPage()
    if btn.tx == " R " then
        updateRainbow()
    end
end
function cross(btn)
    commands.exec("/data modify entity @e[type=item,distance=..5,limit=1] Item.tag.Unbreakable set value 0")
    commands.msg("@p", "F*ck You!")
end
function get()
    curEnchs= enchD.getEnchs()
    for i = 1, #curEnchs do
        EnchsPoses[curEnchs[i].id] = i
    end
end
function list()
    local str = ""
    for i =1 ,#curEnchs do
        str = str .. curEnchs[i].id .. " = " .. curEnchs[i].lvl .. "\n"
    end
    print(table.serialize(EnchsPoses,true ))
    commands.msg("@p", '\n'..str)
end
function apply()
    local siz = #curEnchs
    local i = 1
    while true do 
        if i > #curEnchs then break end
        if curEnchs[i].lvl == 0 then
            EnchsPoses[curEnchs[i].id] =nil
            --table.remove(EnchsPoses,curEnchs[i].id)
            table.remove(curEnchs,i)
            i = i-1
        end
        i = i+1
    end
    local str = "[".. NBT.ToNBT(curEnchs).. "]"
    commands.exec("data merge entity @e[type=item,distance=..5,limit=1] {Item:{tag:{Enchantments:"..str.."}}}")
end
function chLevel(btn)
    local pos = EnchsPoses[selectedEnch]
    if btn.tx == " + " then
        curEnchs[pos].lvl = curEnchs[pos].lvl + 1
        local str = " "..string.ensure_width(tostring(curEnchs[pos].lvl), 2).." "
        GUI.printText(width - 5, 9, str,colors.gray,colors.white)
    else
        curEnchs[pos].lvl = curEnchs[pos].lvl - 1
        if curEnchs[pos].lvl < 0 then curEnchs[pos].lvl =0 end
        local str = " "..string.ensure_width(tostring(curEnchs[pos].lvl), 2).." "
        GUI.printText(width - 5, 9, str,colors.gray,colors.white)
    end
end

function setEnch(btn)
    selectedEnch = enchD.enchIDs[btn.tx]
    if not EnchsPoses[selectedEnch] then
        table.insert(curEnchs,{["id"]= selectedEnch,["lvl"]=0})
        EnchsPoses[selectedEnch] = #curEnchs
    end
    local pos = EnchsPoses[selectedEnch]
    local str = " "..string.ensure_width(tostring(curEnchs[pos].lvl), 2).." "
    GUI.printText(width - 5, 9, str,colors.gray,colors.white)
end

function setRune(btn)
    local _, out = commands.exec("data merge entity @e[type=item,distance=..5,limit=1] {Item:{tag:{\"quark:RuneAttached\":1b,\"quark:RuneColor\":".. enchD.qRunes[btn.tx].."}}}")
    commands.msg("@p "..out[1])
end

pal = {[4]=0x5C82E6,[2]=0xD48F04,[12]=0x072E7A}
GUI.setPal(pal)
GUI.setShadowColor(colors.black, colors.gray)
GUI.chBgColAll(colors.black)
GUI.clearAll()

GUI.printText(1, 1, title, colors.gray, colors.lightGray)
enchD.addButton("static", width, 1, "X", colors.gray, colors.red, false, cross)
pageButtons = {
    [" 1 "] = enchD.addButton("static", 1, height, " 1 ", colors.black, colors.red, false, chPage),
    [" 2 "] = enchD.addButton("static", 5, height, " 2 ", colors.black, colors.orange, false, chPage),
    [" 3 "] = enchD.addButton("static", 9, height, " 3 ", colors.black, colors.brown, false, chPage),
    [" 4 "] = enchD.addButton("static", 13, height, " 4 ", colors.black, colors.green, false, chPage),
    [" 5 "] = enchD.addButton("static", 17, height, " 5 ", colors.black, colors.lightBlue, false, chPage),
    [" 6 "] = enchD.addButton("static", 21, height, " 6 ", colors.black, colors.blue, false, chPage),
    [" 7 "] = enchD.addButton("static", 25, height, " 7 ", colors.black, colors.purple, false, chPage),
    [" R "] = enchD.addButton("static", 29, height, " R ", colors.black, colors.magenta, false, chPage)
}

enchD.addButton("static", width - 5, 3, " Get ", colors.brown, colors.white, true, get)
enchD.addButton("static", width - 6, 5, " List ", colors.purple, colors.white, true, list)
enchD.addButton("static", width - 6, height, " Apply ", colors.blue, colors.white, false, apply)

enchD.addButton("static", width - 7, 7, " - ", colors.red, colors.white, true, chLevel)
enchD.addButton("static", width - 3, 7, " + ", colors.green, colors.white, true, chLevel)

GUI.printText(width - 7, 9, "  0  ",colors.gray,colors.white)
---------------------page 1-----------------
enchD.addButton(" 1 ", 2, 2, " mana_boost ", colors.red, colors.white, true, setEnch)
enchD.addButton(" 1 ", 2, 4, " mana_regen ", colors.red, colors.white, true, setEnch)
enchD.addButton(" 1 ", 2, 6, " reactive ", colors.red, colors.white, true, setEnch)
enchD.addButton(" 1 ", 2, 8, " holding ", colors.red, colors.black, true, setEnch)
enchD.addButton(" 1 ", 2, 10, " curse ", colors.red, colors.white, true, setEnch)

enchD.addButton(" 1 ", 19, 2, " capacity ", colors.red, colors.white, true, setEnch)
enchD.addButton(" 1 ", 17, 4, " auto_smelt ", colors.red, colors.white, true, setEnch)
enchD.addButton(" 1 ", 18, 6, " beekeeper ", colors.red, colors.white, true, setEnch)
enchD.addButton(" 1 ", 18, 8, " beheading ", colors.red, colors.white, true, setEnch)
enchD.addButton(" 1 ", 12, 10, " potato_recovery ", colors.red, colors.white, true, setEnch)
---------------------page 2------------------
enchD.addButton(" 2 ", 2, 2, " disarm ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 2, 4, " ender ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 2, 6, " excavate ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 2, 8, " growth ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 2, 10, " launch ", colors.orange, colors.white, true, setEnch)

enchD.addButton(" 2 ", 18, 2, " quickshot ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 11, 4, " experience_boost ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 21, 6, " magnet ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 22, 8, " reach ", colors.orange, colors.white, true, setEnch)
enchD.addButton(" 2 ", 17, 10, " life_leech ", colors.orange, colors.white, true, setEnch)
---------------------page 3-----------------
enchD.addButton(" 3 ", 2, 2, " unusing  ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 2, 4, " traveler ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 2, 6, " venom ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 2, 8, " breaking ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 2, 10, " step ", colors.brown, colors.white, true, setEnch)

enchD.addButton(" 3 ", 17, 2, " poison_tip ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 14, 4, " life_stealing ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 18, 6, " vengeance ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 14, 8, " aqua_affinity ", colors.brown, colors.white, true, setEnch)
enchD.addButton(" 3 ", 9, 10, " bane_of_arthropods ", colors.brown, colors.white, true, setEnch)
---------------------page 4-----------------
enchD.addButton(" 4 ", 2, 2, " impaling  ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 2, 4, " infinity ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 2, 6, " knockback ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 2, 8, " flame ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 2, 10, " loyalty ", colors.green, colors.white, true, setEnch)

enchD.addButton(" 4 ", 17, 2, " channeling ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 17, 4, " efficiency ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 14, 6, " depth_strider ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 11, 8, " blast_protection ", colors.green, colors.white, true, setEnch)
enchD.addButton(" 4 ", 12, 10, " feather_falling ", colors.green, colors.white, true, setEnch)
---------------------page 5-----------------
enchD.addButton(" 5 ", 2, 2, " power  ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 2, 4, " thorns ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 2, 6, " protection ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 2, 8, " punch ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 2, 10, " quick_charge ", colors.lightBlue, colors.white, true, setEnch)

enchD.addButton(" 5 ", 16, 2, " respiration ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 20, 4, " riptide ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 18, 6, " sharpness ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 17, 8, " silk_touch ", colors.lightBlue, colors.white, true, setEnch)
enchD.addButton(" 5 ", 22, 10, " smite ", colors.lightBlue, colors.white, true, setEnch)
---------------------page 6-----------------
enchD.addButton(" 6 ", 2, 2, " soul_speed  ", colors.blue, colors.white, true, setEnch)
enchD.addButton(" 6 ", 2, 4, " sweeping ", colors.blue, colors.white, true, setEnch)
enchD.addButton(" 6 ", 2, 6, " binding_curse ", colors.blue, colors.white, true, setEnch)
enchD.addButton(" 6 ", 2, 8, " vanishing_curse ", colors.blue, colors.white, true, setEnch)
enchD.addButton(" 6 ", 2, 10, " projectile_protection ", colors.blue, colors.white, true, setEnch)

enchD.addButton(" 6 ", 16, 2, " unbreaking ", colors.blue, colors.white, true, setEnch)
enchD.addButton(" 6 ", 19, 4, " mending ", colors.blue, colors.white, true, setEnch)
---------------------page 7-----------------
enchD.addButton(" 7 ", 2, 2, " lure ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 2, 4, " fortune ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 2, 6, " looting ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 2, 8, " punch ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 2, 10, " frost_walker ", colors.purple, colors.white, true, setEnch)

enchD.addButton(" 7 ", 11, 2, " luck_of_the_sea ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 15, 4, " fire_aspect ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 17, 6, " multishot ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 11, 8, " fire_protection ", colors.purple, colors.white, true, setEnch)
enchD.addButton(" 7 ", 18, 10, " piercing ", colors.purple, colors.white, true, setEnch)
---------------------page R-----------------
enchD.addButton(" R ", 2, 4, "0 ", colors.white, colors.white, false, setRune)
enchD.addButton(" R ", 5, 4, "1 ", colors.orange, colors.orange, false, setRune)
enchD.addButton(" R ", 8, 4, "2 ", colors.magenta, colors.magenta, false, setRune)
enchD.addButton(" R ", 11, 4, "3 ", colors.lightBlue, colors.lightBlue, false, setRune)

enchD.addButton(" R ", 14, 4, "4 ", colors.yellow, colors.yellow, false, setRune)
enchD.addButton(" R ", 17, 4, "5 ", colors.lime, colors.lime, false, setRune)
enchD.addButton(" R ", 20, 4, "6 ", colors.pink, colors.pink, false, setRune)
enchD.addButton(" R ", 23, 4, "7 ", colors.gray, colors.gray, false, setRune)

enchD.addButton(" R ", 2, 6, "8 ", colors.lightGray, colors.lightGray, false, setRune)
enchD.addButton(" R ", 5, 6, "9 ", colors.cyan, colors.cyan, false, setRune)
enchD.addButton(" R ", 8, 6, "a ", colors.purple, colors.purple, false, setRune)
enchD.addButton(" R ", 11, 6, "b ", colors.blue, colors.blue, false, setRune)

enchD.addButton(" R ", 14, 6, "c ", colors.brown, colors.brown, false, setRune)
enchD.addButton(" R ", 17, 6, "d ", colors.green, colors.green, false, setRune)
enchD.addButton(" R ", 20, 6, "e ", colors.red, colors.red, false, setRune)
enchD.addButton(" R ", 23, 6, "f ", colors.black, colors.black, false, setRune)

enchD.addButton(" R ", 2, 8, "r ", colors.green, colors.green, false, setRune)
enchD.printPage()
os.startTimer(0.25)
while true do
    local evType, a, b, c, d = os.pullEventRaw()
    if evType == "monitor_touch" then
        enchD.checkButtons(b, c)
    end
    if evType == "terminate" then
        GUI.restorePal()
        break
    end
    if evType == "timer" then
        if enchD.curPage == " R " then
            updateRainbow()
        end
        rainbowCurCol = rainbowCurCol + 1
        if rainbowCurCol > 14 then rainbowCurCol = 0 end
        os.startTimer(0.25)
    end
end

