local modem = peripheral.find("modem")
local Iport,Oport = 15,16
local commands = {
    [keys.w] = "moveForward",
    [keys.a] = "moveLeft",
    [keys.s] = "moveForward",

    [keys.d] = "moveRight",
    [keys.x] = "switchAutoMine",
}
modem.open(Iport)
while true do
    local ev, a,b,c,d = os.pullEvent()
    if ev == "key" then 
        
    elseif cond then
        
    end
end
