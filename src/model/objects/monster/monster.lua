local _M = {
    color = {
        math.random(), math.random(), math.random()
    },
    step = 10,
}

function _M.create(coordinates)
    local monster = {
        color = _M.color,
        coordinates = coordinates or {
            x = 0,
            y = 0,
        },
    }

    function monster.up()
        monster.coordinates.y = monster.coordinates.y - _M.step
    end

    function monster.down()
        monster.coordinates.y = monster.coordinates.y + _M.step
    end

    function monster.left()
        monster.coordinates.x = monster.coordinates.x - _M.step
    end

    function monster.right()
        monster.coordinates.x = monster.coordinates.x + _M.step
    end

    return monster
end

return _M