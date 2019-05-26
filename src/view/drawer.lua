return {
    draw = function(game)
        for _, v in pairs(game.field) do
            for _, object in pairs(v) do
                love.graphics.setColor(object.color)
                love.graphics.rectangle('fill', object.coordinates.x, object.coordinates.y, 10, 10)
            end
        end
    end
}