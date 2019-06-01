math.randomseed(os.time())
math.random()
math.random()
math.random()

local heroes = require("model.objects.hero.hero")
local monsters = require("model.objects.monster.monster")
local walls = require("model.objects.wall.wall")
local game = require("model.game.game")
local config = require("config")

local drawer = require("view.drawer")

local myHero = heroes.create("My hero", {
    x = math.floor(config.gameHeight / 2) + 1,
    y = math.floor(config.gameWidth / 2) + 1,
})

local otherHero = heroes.create("Other hero", {
    x = (config.gameHeight / 2),
    y = (config.gameWidth / 2) + 1,
})

local objects = {
    myHero,
    otherHero,
}

for i = 0, config.monsterNumber do
    local x = 0
    local y = 0
    local edge = math.floor(math.random(1, 4))
    if edge == 1 then
        x = math.floor(math.random(config.gameHeight))
    elseif edge == 2 then
        y = math.floor(math.random(config.gameWidth))
    elseif edge == 3 then
        x = config.gameHeight - 1
        y = math.floor(math.random(config.gameWidth))
    elseif edge == 4 then
        x = math.floor(math.random(config.gameHeight))
        y = config.gameWidth - 1
    end
    table.insert(objects, monsters.create({
        x = x,
        y = y,
    }))
end

for i = 0, (config.gameHeight / 2) + 1 do
    for j = 0, config.gameWidth / 2 do
        local x = math.floor(config.gameHeight / 2 / 2) + i
        local y = math.floor(config.gameWidth / 2 / 2) + j
        if (x ~= myHero.coordinates.x and x ~= otherHero.coordinates.x) or y ~= myHero.coordinates.y then
            table.insert(objects, walls.create({
                x = x,
                y = y,
            }))
        end
    end
end

local game = game.create(config.gameHeight, config.gameWidth, objects)

local binder = require("control.binder").create(game)

love.window.setTitle("MazeR")
love.window.setMode(
        game.width * config.drawingStep,
        game.height * config.drawingStep, {
            minwidth = game.width * config.drawingStep,
            minheight = game.height * config.drawingStep })

binder.bind({
    up = { myHero, "up" },
    down = { myHero, "down" },
    left = { myHero, "left" },
    right = { myHero, "right" },
    w = { otherHero, "up" };
    s = { otherHero, "down" };
    a = { otherHero, "left" };
    d = { otherHero, "right" };
})

function love.draw()
    drawer.draw(game)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    else
        binder.dispatch(key)
    end
end

local timer = 0
local speed = 2
function love.update(dt)
    if timer > 1 then
        timer = timer - 1
        game:moveMonsters()
    end
    timer = timer + dt * speed
end

