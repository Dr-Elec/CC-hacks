require("adv")
local NBT = {}

local function tblToNBT(t)
    local nbt = ""
    for k, v in pairs(t) do
        if (type(v) ~= "table") then
            if (t[1] == nil) then
                if (type(v) ~= "string") then
                    nbt = nbt .. k .. ":" .. v .. ","
                else
                    nbt = nbt .. k .. ":\"" .. v .. "\","
                end
            else
                if (type(v) ~= "string") then
                    nbt = nbt .. v .. ","
                else
                    nbt = nbt .. v .. ","
                end
            end
        end
    end
    for k, v in pairs(t) do
        if (type(v) == "table") then
            if (v[1] ~= nil) then
                nbt = nbt .. k .. ":[" .. string.sub(tblToNBT(v), 1, -2) .. "],"
            else
                if (type(k) ~= "number") then
                    nbt = nbt .. k .. ":{" .. string.sub(tblToNBT(v), 1, -2) .. "},"
                else
                    nbt = nbt .. "{" .. string.sub(tblToNBT(v), 1, -2) .. "},"
                end
            end
        end
    end
    return nbt
end
function NBT.ToNBT(t)

    return string.sub(tblToNBT(t), 1, -2)
end
-------------------------------------------------------------
local function getFirstElementPos(input)

end
function NBT.ToTable(input)
    local tbl = {}
    local str = input
    if string.sub(str, 1, 1) == '[' then
        -- local separatedTable = string.split(string.sub(str,2,#str-1),',')    
        while true do
            local last

            if string.sub(str, 2, 2) == '{' then
                last = string.find(str, "}")
                table.insert(tbl, NBT.ToTable(string.sub(str, 2, last)))
            elseif string.sub(str, 2, 2) == '"' then
                last = string.find(str, "\"", 2)
                table.insert(tbl, string.sub(str, 2, last))
            else -- if number
                last = string.find(input, ",") - 1
                if last == nil then
                    last = string.find(input, "]") - 1
                end
                -- if it a number with a postfix
                if tonumber(string.sub(str, 2, last)) == nil then
                    last = last - 1
                end
                table.insert(tbl, tonumber(string.sub(str, 2, last)))
            end

            if string.sub(str, last + 1, last + 1) == ']' then
                break
            end

            str = string.gsub(str, string.sub(str, 2, last + 1), "")
        end
    elseif string.sub(str, 1, 1) == '{' then
        local separatedTable = string.split(string.sub(str, 2, #str - 1), ',')
        for i = 1, #separatedTable do
            local colon = string.find(separatedTable[i], ":")
            local name = string.sub(separatedTable[i], 1, colon - 1)
            if string.sub(name, 1, 1) == "\"" then
                name = string.sub(name, 2, #name - 1)
            end

            local value = string.sub(separatedTable[i], colon + 1, #str)
            if string.sub(value, 1, 1) == "\"" then
                value = string.sub(value, 2, #value - 1)
        
            end
            if string.sub(value, 1, 1) == "{" then
                value = NBT.ToTable(value)
            end
            local ifNumber = tonumber(string.sub(value, 1, #value - 1))
            if ifNumber ~= nil then
                value = ifNumber
            end
            tbl[name] = value
        end
    end
    return tbl
end

--------------------------------------------------
return NBT
