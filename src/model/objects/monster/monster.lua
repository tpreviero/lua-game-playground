local movable = require("model.objects.movable")
local config = require("config")

local _M = {
    color = {
        math.random(), math.random(), math.random()
    },
    step = 10,
}

function _M.create(coordinates)
    local monster = {
        type = "monster",
        color = _M.color,
        coordinates = coordinates or {
            x = 0,
            y = 0,
        },
    }

    movable.makeMovable(monster, false)

    function monster.up_right(self)
        return {
            x = self.coordinates.x + config.step,
            y = self.coordinates.y - config.step,
        }
    end

    function monster.up_left(self)
        return {
            x = self.coordinates.x - config.step,
            y = self.coordinates.y - config.step,
        }
    end

    function monster.down_right(self)
        return {
            x = self.coordinates.x + config.step,
            y = self.coordinates.y + config.step,
        }
    end

    function monster.down_left(self)
        return {
            x = self.coordinates.x - config.step,
            y = self.coordinates.y + config.step,
        }
    end

    return monster
end

return _M