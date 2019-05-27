local mover = require("model.game.mover")

local _M = {}

function _M.create(height, width, objects)

    local game = {
        height = height,
        width = width,
        objects = objects,
        isLost = false,
        isWon = false,
    }

    local mover = mover.create(game)

    function game.objectAt(self, coordinates)
        for _, v in pairs(self.objects) do
            if v.coordinates.x == coordinates.x and v.coordinates.y == coordinates.y then
                return v
            end
        end
        return nil
    end

    function game.isValidMove(self, object, move)
        return mover.can(object, { move })
    end

    function game.executeMove(self, object, move)
        mover.move(object, { move })
    end

    function game.move(self, object, move)
        if self:isValidMove(object, move) then
            self:executeMove(object, move)
        end
    end

    function game.feedMonster(self, object, move)
        local coordinates = object[move](object)
        local objectAtNextPosition = self:objectAt(coordinates)
        return objectAtNextPosition ~= nil and (objectAtNextPosition.type == "monster" or objectAtNextPosition.type == "hero")
    end

    function game.find(self, type)
        local result = {}
        for _, object in pairs(self.objects) do
            if object.type == type then
                table.insert(result, object)
            end
        end
        return result
    end

    function game.lost(self)
        self.isLost = true
    end

    function game.won(self)
        self.isWon = true
    end

    function game.randomMoveOrCoinify(self, monster)
        function FYShuffle(tInput)
            local tReturn = {}
            for i = #tInput, 1, -1 do
                local j = math.random(i)
                tInput[i], tInput[j] = tInput[j], tInput[i]
                table.insert(tReturn, tInput[i])
            end
            return tReturn
        end

        local possibleMoves = FYShuffle({ "up", "up_right", "right", "down_right", "down", "down_left", "left", "up_left" })
        for _, move in pairs(possibleMoves) do
            if self:isValidMove(monster, move) then
                self:move(monster, move)
                return
            end
        end
        monster.type = "coin"
    end

    function game.moveMonsters(self)
        local hero = self:find("hero")[1] -- get the first hero for the moment
        local monsters = self:find("monster")

        if #monsters == 0 then
            self:won()
        end

        for _, monster in pairs(monsters) do
            if hero.coordinates.x > monster.coordinates.x then
                if hero.coordinates.y > monster.coordinates.y then
                    if self:isValidMove(monster, "down_right") then
                        self:move(monster, "down_right")
                    elseif self:isValidMove(monster, "right") then
                        self:move(monster, "right")
                    else
                        self:randomMoveOrCoinify(monster)
                    end
                elseif hero.coordinates.y < monster.coordinates.y then
                    if self:isValidMove(monster, "up_right") then
                        self:move(monster, "up_right")
                    elseif self:isValidMove(monster, "right") then
                        self:move(monster, "right")
                    else
                        self:randomMoveOrCoinify(monster)
                    end
                else
                    if self:isValidMove(monster, "right") then
                        self:move(monster, "right")
                    elseif self:isValidMove(monster, "down_right") then
                        self:move(monster, "down_right")
                    elseif self:isValidMove(monster, "up_right") then
                        self:move(monster, "up_right")
                    else
                        self:randomMoveOrCoinify(monster)
                    end
                end
            elseif hero.coordinates.x < monster.coordinates.x then
                if hero.coordinates.y > monster.coordinates.y then
                    if self:isValidMove(monster, "down_left") then
                        self:move(monster, "down_left")
                    elseif self:isValidMove(monster, "left") then
                        self:move(monster, "left")
                    else
                        self:randomMoveOrCoinify(monster)
                    end
                elseif hero.coordinates.y < monster.coordinates.y then
                    if self:isValidMove(monster, "up_left") then
                        self:move(monster, "up_left")
                    elseif self:isValidMove(monster, "left") then
                        self:move(monster, "left")
                    else
                        self:randomMoveOrCoinify(monster)
                    end
                else
                    if self:isValidMove(monster, "left") then
                        self:move(monster, "left")
                    elseif self:isValidMove(monster, "down_left") then
                        self:move(monster, "down_left")
                    elseif self:isValidMove(monster, "up_left") then
                        self:move(monster, "up_left")
                    else
                        self:randomMoveOrCoinify(monster)
                    end
                end
            elseif hero.coordinates.y > monster.coordinates.y then
                if self:isValidMove(monster, "down") then
                    self:move(monster, "down")
                elseif self:isValidMove(monster, "down_right") then
                    self:move(monster, "down_right")
                elseif self:isValidMove(monster, "down_left") then
                    self:move(monster, "down_left")
                else
                    self:randomMoveOrCoinify(monster)
                end
            elseif hero.coordinates.y < monster.coordinates.y then
                if self:isValidMove(monster, "up") then
                    self:move(monster, "up")
                elseif self:isValidMove(monster, "up_right") then
                    self:move(monster, "up_right")
                elseif self:isValidMove(monster, "up_left") then
                    self:move(monster, "up_left")
                else
                    self:randomMoveOrCoinify(monster)
                end
            end
        end
    end

    return game
end

return _M