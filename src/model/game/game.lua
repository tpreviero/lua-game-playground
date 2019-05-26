local _M = {}

function _M.create(height, width, heroes, monsters, walls)

    local field = {}

    for _, hero in ipairs(heroes) do
        field[hero.coordinates.x] = field[hero.coordinates.x] or {}
        field[hero.coordinates.x][hero.coordinates.y] = hero
    end
    for _, monster in ipairs(monsters) do
        field[monster.coordinates.x] = field[monster.coordinates.x] or {}
        if field[monster.coordinates.x][monster.coordinates.y] ~= nil then
            error("Cannot place monster in a coordinate where a hero is already.")
        end
        field[monster.coordinates.x][monster.coordinates.y] = monster
    end
    for _, wall in ipairs(walls) do
        field[wall.coordinates.x] = field[wall.coordinates.x] or {}
        if field[wall.coordinates.x][wall.coordinates.y] ~= nil then
            error("Cannot place a wall in a coordinate where a hero or a monster is already.")
        end
        field[wall.coordinates.x][wall.coordinates.y] = wall
    end

    local game = {
        height = height,
        width = width,
        field = field,
    }

    function game.isValid(object, method)
        local coordinates = object[method](object)
        if coordinates.x >= 0 and coordinates.x < game.width then
            if coordinates.y >= 0 and coordinates.y < game.height then
                return true
            end
        end
        return false
    end

    return game
end

return _M