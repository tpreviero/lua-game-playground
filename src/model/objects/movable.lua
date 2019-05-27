local config = require("config")

local _M = {}

function _M.makeMovable(object, pushable)
    function object.up(self)
        return {
            x = self.coordinates.x,
            y = self.coordinates.y - config.step,
        }
    end

    function object.down(self)
        return {
            x = self.coordinates.x,
            y = self.coordinates.y + config.step,
        }
    end

    function object.left(self)
        return {
            x = self.coordinates.x - config.step,
            y = self.coordinates.y,
        }
    end

    function object.right(self)
        return {
            x = self.coordinates.x + config.step,
            y = self.coordinates.y,
        }
    end

    function object.isPushable(self)
        return pushable
    end

    return object
end

return _M