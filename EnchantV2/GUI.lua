local module = {}
local mons = {}
module.buttons = {}
local shadCl = {
    ["fore"] = colors.gray,
    ["back"] = colors.white
}

function module.addMon(mon)
    table.insert(mons, mon)
end
function module.setPal(t)
    for i = 0, 15 do
        if t[i+1] then
            for j = 1, #mons do
                mons[j].setPaletteColor(bit.blshift(1,i), t[i+1])
            end
        end
    end
end
function module.restorePal()
    for i = 0, 15 do
        for j = 1, #mons do
            mons[j].setPaletteColor(bit.blshift(1,i), term.nativePaletteColor(bit.blshift(1,i)))
        end
    end
end
function module.writeAll(text)
    for i = 1, #mons do
        mons[i].write(text);
    end
end
function module.setShadowColor(bg, fg)
    shadCl.back = bg
    shadCl.fore = fg
end
function module.setCursorAll(x, y)
    for i = 1, #mons do
        mons[i].setCursorPos(x, y);
    end
end

function module.clearAll()
    for i = 1, #mons do
        mons[i].clear();
    end
end

function module.setScaleAll(x)
    for i = 1, #mons do
        mons[i].setTextScale(x);
    end
end
module.setScaleAll(1)

function module.chBgColAll(col)
    for i = 1, #mons do
        if mons[i].getBackgroundColor() ~= col then
            mons[i].setBackgroundColor(col)
        end
    end
end

function module.chTxColAll(col)
    for i = 1, #mons do
        if mons[i].getTextColor() ~= col then
            mons[i].setTextColor(col)
        end
    end
end

function module.printText(x, y, text, bgColor, textColor)
    module.chBgColAll(bgColor)
    module.chTxColAll(textColor)
    module.setCursorAll(x, y)
    module.writeAll(text)
end

function module.clearBox(startX, startY, endX, endY)
    module.setCursorAll(startX, startY)
    local w = endX - startX
    for j = startY, endY do
        module.setCursorAll(startX, j)
        module.writeAll(string.rep(" ", w))
    end
end

function module.printShadow(x, y, w)
    module.chBgColAll(shadCl.back)
    module.chTxColAll(shadCl.fore)
    module.setCursorAll(x + w, y);
    module.writeAll(string.char(0x94))
    module.setCursorAll(x, y + 1);
    module.writeAll(string.char(0x82))
    for i = x, x + w - 1 do
        module.writeAll(string.char(0x83))
    end
    module.setCursorAll(x + w, y + 1);
    module.writeAll(string.char(0x81))
end

function module.addButton(x, y, text, bgColor, textColor, shadow, fn)
    if shadow then
        module.printShadow(x, y, #text)
    end
    module.printText(x, y, text, bgColor, textColor)
    table.insert(module.buttons, {
        x = x,
        w = #text,
        y = y,
        fn = fn,
        tx = text,
        fg = textColor,
        bg = bgColor,
        sh = shadow,
        id = #module.buttons + 1
    })
    return module.buttons[#module.buttons]
end

function module.checkButtons(x, y)
    for i = 1, #module.buttons do
        if x >= module.buttons[i].x and x < module.buttons[i].x + module.buttons[i].w and y == module.buttons[i].y then
            module.buttons[i].fn(module.buttons[i])
        end
    end
end

return module
