local RS = peripheral.find("rsBridge")
function RS.getUsedItemDiskStorage()
    local items = RS.listItems()
    local bytes = 0
    for i = 1, #items do 
        bytes = bytes + items[i].amount
    end
    return bytes
end

function RS.getUsedFluidDiskStorage()
    local fluids = RS.listFluids()
    local bytes = 0
    for i = 1, #fluids do 
        bytes = bytes + fluids[i].amount
    end
    return bytes 
end
return RS
