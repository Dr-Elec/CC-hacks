local stressReader = peripheral.wrap("bottom")
local motor = peripheral.wrap("left")
local mon = peripheral.find("monitor")
local maxRPM = 256
local maxStress = 8192
os.startTimer(3) -- dt
local pause = true
motor.stop()
mon.setTextScale(1.75)
while true do
    local ev, a, b, c, d = os.pullEvent()
    if ev == "timer" then
        if motor.getSpeed() == 0 then
            pause = false
            motor.setSpeed(1)
        end
        if stressReader.getBlockData().Speed ~= 0 then
            local RPM = 0
            local stress = stressReader.getBlockData().Network.Stress
            if stress > 0 then
                RPM = math.ceil(stress / 32)
                motor.setSpeed(RPM)
            else
                motor.stop()
                pause = true
            end
            mon.setCursorPos(1,1)
            mon.write(stress .. " su/".. maxStress .. " su         ")
            mon.setCursorPos(1,2)
            mon.write(RPM .. " RPM/".. maxRPM .. " RPM         ")
        end
        os.startTimer(3)
    end
end
