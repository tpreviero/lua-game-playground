local config = require("config")

local _M = {}

function nextCoordinates(object, moves)
    local nextCoordinates = object.coordinates
    for _, move in pairs(moves) do
        nextCoordinates = object[move](object)
    end

    return nextCoordinates
end

function _M.create(game)

    local mover = {}

    function heroCan(hero, moves)
        local nextCoordinates = nextCoordinates(hero, moves)

        if nextCoordinates.x >= 0 and nextCoordinates.x < game.width then
            if nextCoordinates.y >= 0 and nextCoordinates.y < game.height then
                local objectAtNextCoordinates = game:objectAt(nextCoordinates)
                if objectAtNextCoordinates == nil or objectAtNextCoordinates.type == "coin" then
                    return true
                end
                if objectAtNextCoordinates.type ~= "monster" and mover.can(objectAtNextCoordinates, moves) then
                    return true
                end
            end
        end

        return false
    end

    function monsterCan(hero, moves)
        local nextCoordinates = nextCoordinates(hero, moves)

        if nextCoordinates.x >= 0 and nextCoordinates.x < game.width then
            if nextCoordinates.y >= 0 and nextCoordinates.y < game.height then
                local objectAtNextCoordinates = game:objectAt(nextCoordinates)
                if objectAtNextCoordinates == nil or objectAtNextCoordinates.type == "hero" then
                    return true
                end
            end
        end
        return false
    end

    function wallCan(hero, moves)
        local nextCoordinates = nextCoordinates(hero, moves)

        if nextCoordinates.x >= 0 and nextCoordinates.x < game.width then
            if nextCoordinates.y >= 0 and nextCoordinates.y < game.height then
                local objectAtNextCoordinates = game:objectAt(nextCoordinates)
                if objectAtNextCoordinates == nil then
                    return true
                end
                if mover.can(objectAtNextCoordinates, moves) then
                    return true
                end
            end
        end

        return false
    end

    function mover.can(object, moves)
        if object.type == "hero" then
            return heroCan(object, moves)
        elseif object.type == "monster" then
            return monsterCan(object, moves)
        elseif object.type == "wall" then
            return wallCan(object, moves)
        end
        return false
    end

    function mover.move(object, moves)
        local nextCoordinates = nextCoordinates(object, moves)

        local objectAtNextCoordinates = game:objectAt(nextCoordinates)
        if objectAtNextCoordinates ~= nil then
            if (object.type == "monster" and objectAtNextCoordinates.type == "hero") or (object.type == "hero" and objectAtNextCoordinates.type == "monster") then
                game:lost()
            elseif object.type == "hero" and objectAtNextCoordinates.type == "coin" then
                object.points = object.points + config.coinValue
                game:removeObjectAt(nextCoordinates)
            else
                mover.move(objectAtNextCoordinates, moves)
            end
        end

        object.coordinates = nextCoordinates
    end

    return mover
end

return _M