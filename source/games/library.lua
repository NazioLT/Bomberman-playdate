function hasTypeInTable(table, type)
    for _, value in pairs(table) do
        if value:isa(type) then
            return true
        end
    end

    return false
end

function tileToPixel(i, j)
    return (i + 5) * 16 - 8, j * 16 - 8
end

function pixelToTile(x, y)
    return math.floor((x - 8 - 16 * 5) / 16 + 1 + 0.5), math.floor((y - 8) / 16 + 1 + 0.5)
end