require("adv")

local RS = require("RS")
local GUI = require("GUI")
--local RS = require("fuck")
GUI.addMon(peripheral.find("monitor"))

local width,height = GUI.getSize()

GUI.chBgColAll(colors.black)
GUI.setShadowColor(colors.black, colors.gray)

GUI.clearAll()
os.startTimer(1)
while true do
    local ev,a,b,c,d = os.pullEvent()
    if ev == "timer" then
        GUI.progress(2,height-3,width-1,RS.getUsedItemDiskStorage(),RS.getMaxItemDiskStorage(),colors.white,colors.green, true)
        GUI.progress(2,height-1,width-1,RS.getUsedFluidDiskStorage(),RS.getMaxFluidDiskStorage(),colors.white,colors.blue, true)
        os.startTimer(1)
    end
end
