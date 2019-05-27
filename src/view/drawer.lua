return {
    draw = function(game)
        if game.isLost then
            love.graphics.print("Loser!", 235, 235)
        elseif game.isWon then
            love.graphics.print("You won!", 235, 235)
        else
            for _, object in pairs(game.objects) do
                if object.type == "coin" then
                    love.graphics.setColor({ math.random(), math.random(), math.random() })
                    love.graphics.circle('fill', object.coordinates.x + 5, object.coordinates.y + 5, 5, 5)
                else
                    love.graphics.setColor(object.color)
                    love.graphics.rectangle('fill', object.coordinates.x, object.coordinates.y, 10, 10)
                end
            end
        end
    end
}