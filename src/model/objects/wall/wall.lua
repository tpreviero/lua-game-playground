local movable = require("model.objects.movable")

local _M = {
    color = {
        math.random(), math.random(), math.random()
    },
    dimension = 10,
}

function _M.create(coordinates)
    local wall = {
        type = "wall",
        color = _M.color,
        coordinates = coordinates,
    }

    return movable.makeMovable(wall, true)
end

return _M