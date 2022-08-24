local ccstr = require("cc.strings")
function math.round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

function table.serialize(array, prettyLook, indentationWidth, indentUsingTabs, recursionStackLimit)
    -- checkArg(1, array, "table")

    recursionStackLimit = recursionStackLimit or math.huge
    local indentationSymbolAdder = string.rep(indentUsingTabs and "	" or " ", indentationWidth or 2)
    local equalsSymbol = prettyLook and " = " or "="

    local function serializeRecursively(array, currentIndentationSymbol, currentRecusrionStack)
        local result, nextIndentationSymbol, keyType, valueType, stringValue = {"{"}, currentIndentationSymbol ..
            indentationSymbolAdder

        if prettyLook then
            table.insert(result, "\n")
        end

        for key, value in pairs(array) do
            keyType, valueType, stringValue = type(key), type(value), tostring(value)

            if prettyLook then
                table.insert(result, nextIndentationSymbol)
            end

            if keyType == "number" then
                table.insert(result, "[")
                table.insert(result, key)
                table.insert(result, "]")
                table.insert(result, equalsSymbol)
            elseif keyType == "string" then
                -- Короч, если типа начинается с буковки, а также если это алфавитно-нумерическая поеботня
                if prettyLook and key:match("^%a") and key:match("^[%w%_]+$") then
                    table.insert(result, key)
                else
                    table.insert(result, "[\"")
                    table.insert(result, key)
                    table.insert(result, "\"]")
                end

                table.insert(result, equalsSymbol)
            end

            if valueType == "number" or valueType == "boolean" or valueType == "nil" then
                table.insert(result, stringValue)
            elseif valueType == "string" or valueType == "function" then
                table.insert(result, "\"")
                table.insert(result, stringValue)
                table.insert(result, "\"")
            elseif valueType == "table" then
                if currentRecusrionStack < recursionStackLimit then
                    table.insert(result, table.concat(
                        serializeRecursively(value, nextIndentationSymbol, currentRecusrionStack + 1)))
                else
                    table.insert(result, "\"…\"")
                end
            end

            table.insert(result, ",")

            if prettyLook then
                table.insert(result, "\n")
            end
        end

        -- Удаляем запятую
        if prettyLook then
            if #result > 2 then
                table.remove(result, #result - 1)
            end

            table.insert(result, currentIndentationSymbol)
        else
            if #result > 1 then
                table.remove(result, #result)
            end
        end

        table.insert(result, "}")

        return result
    end

    return table.concat(serializeRecursively(array, "", 1))
end

function table.unserialize(serializedString)
    -- checkArg(1, serializedString, "string")

    local result, reason = load("return " .. serializedString)
    if result then
        result, reason = pcall(result)
        if result then
            return reason
        else
            return nil, reason
        end
    else
        return nil, reason
    end
end

string.wrap = ccstr.wrap
string.ensure_width = ccstr.ensure_width

function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function string.trim(s)
    return s:match "^%s*(.-)%s*$"
 end

return {
    loaded = true
}
