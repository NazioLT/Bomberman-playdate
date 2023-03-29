function hasTypeInTable(table, type)
    for _, value in pairs(table) do
        if value:isa(type) then
            return true, value
        end
    end

    return false, nil
end

function tileToPixel(i, j)
    return (i + 5) * 16 - 8, j * 16 - 8
end

function pixelToTile(x, y)
    return math.floor((x - 8 - 16 * 5) / 16 + 1 + 0.5), math.floor((y - 8) / 16 + 1 + 0.5)
end

function bit(p)
    return 2 ^ (p - 1) -- 1-based indexing
end

function hasbit(x, p)
    return x % (p + p) >= p
end

function maskContainsGroup(mask, group)
    return hasbit(mask, bit(group))
end