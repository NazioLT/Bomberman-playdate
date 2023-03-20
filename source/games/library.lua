function getIndexOfObject(table, object)
    for i = 1, #table, 1 do
        if (object == table[i]) then
            return i;
        end
    end
end

function hasTypeInTable(table, type)
    for _, value in pairs(table) do
        if value:isa(type) then
            return true
        end
    end

    return false
end