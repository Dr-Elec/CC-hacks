require("adv")
local NBT = require("NBT")
local GUI = require("GUI")
local enchD = {}
enchD.pages = {}
enchD.curPage = 1
enchD.qRunes = {
    ["0 "] = "{id:\"quark:white_rune\",Count:1b}",
    ["1 "] = "{id:\"quark:orange_rune\",Count:1b}",
    ["2 "] = "{id:\"quark:magenta_rune\",Count:1b}",
    ["3 "] = "{id:\"quark:light_blue_rune\",Count:1b}",
    ["4 "] = "{id:\"quark:yellow_rune\",Count:1b}",
    ["5 "] = "{id:\"quark:lime_rune\",Count:1b}",
    ["6 "] = "{id:\"quark:pink_rune\",Count:1b}",
    ["7 "] = "{id:\"quark:gray_rune\",Count:1b}",
    ["8 "] = "{id:\"quark:light_gray_rune\",Count:1b}",
    ["9 "] = "{id:\"quark:cyan_rune\",Count:1b}",
    ["a "] = "{id:\"quark:purple_rune\",Count:1b}",
    ["b "] = "{id:\"quark:blue_rune\",Count:1b}",
    ["c "] = "{id:\"quark:brown_rune\",Count:1b}",
    ["d "] = "{id:\"quark:green_rune\",Count:1b}",
    ["e "] = "{id:\"quark:red_rune\",Count:1b}",
    ["f "] = "{id:\"quark:black_rune\",Count:1b}",
    ["r "] = "{id:\"quark:rainbow_rune\",Count:1b}"
}
enchD.enchIDs = {
    [" mana_boost "]="ars_nouveau:mana_boost",
    [" mana_regen "]="ars_nouveau:mana_regen",
    [" reactive "]="ars_nouveau:reactive",
    [" holding "]="coth_core:holding",
    [" capacity "]="create:capacity",
    [" potato_recovery "]="create:potato_recovery",
    [" auto_smelt "]="cyclic:auto_smelt",
    [" beekeeper "]="cyclic:beekeeper",
    [" beheading "]="cyclic:beheading",
    [" curse "]="cyclic:curse",

    [" disarm "]="cyclic:disarm",
    [" ender "]="cyclic:ender",
    [" excavate "]="cyclic:excavate",
    [" experience_boost "]="cyclic:experience_boost",
    [" growth "]="cyclic:growth",
    [" launch "]="cyclic:launch",
    [" life_leech "]="cyclic:life_leech",
    [" magnet "]="cyclic:magnet",
    [" quickshot "]="cyclic:quickshot",
    [" reach "]="cyclic:reach",

    [" step "]="cyclic:step",
    [" traveler "]="cyclic:traveler",
    [" venom "]="cyclic:venom",
    [" breaking "]="evilcraft:breaking",
    [" life_stealing "]="evilcraft:life_stealing",
    [" poison_tip "]="evilcraft:poison_tip",
    [" unusing "]="evilcraft:unusing",
    [" vengeance "]="evilcraft:vengeance",
    [" aqua_affinity "]="minecraft:aqua_affinity",
    [" bane_of_arthropods "]="minecraft:bane_of_arthropods",

    [" impaling "]="minecraft:impaling",
    [" infinity "]="minecraft:infinity",
    [" knockback "]="minecraft:knockback",
    [" flame "]="minecraft:flame",
    [" loyalty "]="minecraft:loyalty",
    [" blast_protection "]="minecraft:blast_protection",
    [" channeling "]="minecraft:channeling",
    [" depth_strider "]="minecraft:depth_strider",
    [" efficiency "]="minecraft:efficiency",
    [" feather_falling "]="minecraft:feather_falling",

    [" fire_aspect "]="minecraft:fire_aspect",
    [" fortune "]="minecraft:fortune",
    [" luck_of_the_sea "]="minecraft:luck_of_the_sea",
    [" frost_walker "]="minecraft:frost_walker",
    [" fire_protection "]="minecraft:fire_protection",
    [" looting "]="minecraft:looting",
    [" lure "]="minecraft:lure",
    [" mending "]="minecraft:mending",
    [" multishot "]="minecraft:multishot",
    [" piercing "]="minecraft:piercing",

    [" power "]="minecraft:power",
    [" thorns "]="minecraft:thorns",
    [" protection "]="minecraft:protection",
    [" punch "]="minecraft:punch",
    [" quick_charge "]="minecraft:quick_charge",
    [" respiration "]="minecraft:respiration",
    [" riptide "]="minecraft:riptide",
    [" sharpness "]="minecraft:sharpness",
    [" silk_touch "]="minecraft:silk_touch",
    [" smite "]="minecraft:smite",

    [" soul_speed "]="minecraft:soul_speed",
    [" sweeping "]="minecraft:sweeping",
    [" unbreaking "]="minecraft:unbreaking",
    [" binding_curse "]="minecraft:binding_curse",
    [" vanishing_curse "]="minecraft:vanishing_curse",
    [" projectile_protection "]="minecraft:projectile_protection",

}

function enchD.getEnchs()
    local compl, out = commands.exec("/data get entity @e[type=item,distance=..5,limit=1] Item.tag.Enchantments")
    if not compl then 
        commands.msg("@p", "Drop an item, blyat' !")
        return {}
    end
    out = string.gsub(out[1], "%s+", "")
    -- print(out)
    local f = string.find(out, "%[")
    local g = string.find(out, "%]")
    local data = NBT.ToTable(string.sub(out, f, g))
    return data
end
function enchD.addButton(page, x, y, text, bgColor, textColor, shadow, fn)
    if enchD.pages[page] == nil then
        enchD.pages[page] = {}
    end
    local btn = GUI.addButton(x, y, text, bgColor, textColor, shadow, fn)
    table.insert(enchD.pages[page], btn)
    return btn
end

function enchD.printPage()
    GUI.chBgColAll(colors.black)
    GUI.clearBox(1,2, 31 ,11)
    for i = 1, #enchD.pages[enchD.curPage] do
        local btn = enchD.pages[enchD.curPage][i]
        if btn.sh then
            GUI.printShadow(btn.x,btn.y,#btn.tx)
        end
        GUI.printText(btn.x,btn.y,btn.tx,btn.bg,btn.fg)
    end
end

function enchD.checkButtons(x,y)
    for i = 1, #enchD.pages[enchD.curPage] do
        local btn = enchD.pages[enchD.curPage][i]
        if x >= btn.x and x < btn.x + btn.w and y == btn.y then
            btn.fn(btn)
            break
        end
    end
    for i = 1, #enchD.pages.static do
        if x >= enchD.pages.static[i].x and x < enchD.pages.static[i].x + enchD.pages.static[i].w and y == enchD.pages.static[i].y then
            enchD.pages.static[i].fn(enchD.pages.static[i])
            break
        end
    end
end

return enchD
