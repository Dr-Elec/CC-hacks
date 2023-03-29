local dx, dz = 4, 4;
local dir = 0;
local dirTable = { string.char(24), string.char(26), string.char(25), string.char(27) };

local function check()
    local res, data = turtle.inspect();
    if (res) then
        if (data.tags["c:buds"] == true or data.tags["c:clusters"] == true) then
            turtle.dig("left");
        end
    end
    res, data = turtle.inspectUp();
    if (res) then
        if (data.tags["c:buds"] == true or data.tags["c:clusters"] == true) then
            turtle.digUp("left");
        end
    end
    res, data = turtle.inspectDown();
    if (res) then
        if (data.tags["c:buds"] == true or data.tags["c:clusters"] == true) then
            turtle.digDown("left");
        end
    end
end

while true do
    for z = 1, dz do
        for x = 1, dx do
            turtle.turnRight();
            turtle.forward();
            check()
            turtle.back();
            turtle.turnLeft();
            turtle.forward();

            turtle.turnRight();
            check();
            turtle.turnLeft();
            turtle.forward();

            if (x ~= dx) then
                turtle.turnRight();
                turtle.forward();
                check()
                turtle.back();
                turtle.turnLeft();
                turtle.forward();
            else
                turtle.turnRight();
                turtle.forward();
                check()
                turtle.forward();
                turtle.turnRight();
            end
        end
        for x = dx, 0, -1 do
            turtle.forward()
            check()
            turtle.forward();
            check()
        end
        if (z ~= dz) then
            turtle.forward();
            turtle.turnLeft();
            turtle.forward();
            turtle.turnLeft();
        else
            turtle.forward();
            turtle.turnRight()
            for i = 1, (dz * 3) -1 do 
                turtle.forward();
            end
            turtle.turnRight()
        end
    end
    os.pullEvent();

end
-- check()
