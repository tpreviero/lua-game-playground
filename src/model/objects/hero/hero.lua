local movable = require("model.objects.movable")

local _M = {
    step = 10
}

function _M.create(name, coordinates)
    local hero = {
        type = "hero",
        name = name,
        color = {
            math.random(), math.random(), math.random()
        },
        coordinates = coordinates or {
            x = 0,
            y = 0,
        },
    }

    return movable.makeMovable(hero)
end

return _M