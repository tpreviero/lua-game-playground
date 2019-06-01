local config = require("config")

return {
    draw = function(game)
        if game.isLost then
            love.graphics.print("Loser!", config.gameHeight / 2 * config.drawingStep, config.gameWidth / 2 * config.drawingStep)
        elseif game.isWon then
            love.graphics.print("You won!", config.gameHeight / 2 * config.drawingStep, config.gameWidth / 2 * config.drawingStep)
        else
            for _, object in pairs(game.objects) do
                if object.type == "coin" then
                    love.graphics.setColor({ math.random(), math.random(), math.random() })
                    love.graphics.circle('fill', (object.coordinates.x * config.drawingStep) + config.drawingStep / 2, (object.coordinates.y * config.drawingStep) + config.drawingStep / 2, config.drawingStep / 2, config.drawingStep / 2)
                else
                    love.graphics.setColor(object.color)
                    love.graphics.rectangle('fill', (object.coordinates.x * config.drawingStep), object.coordinates.y * config.drawingStep, config.drawingStep, config.drawingStep)
                end
            end
        end
    end
}