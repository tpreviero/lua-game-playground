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
    x = (config.gameHeight / 2) + 1,
    y = (config.gameWidth / 2)+1,
})

local otherHero = heroes.create("Other hero", {
    x = (config.gameHeight / 2),
    y = (config.gameWidth / 2)+1,
})

local objects = {
    myHero,
    otherHero,
    monsters.create({
        x = (config.gameHeight / 4)*1,
        y = 0,
    }),
    monsters.create({
        x = (config.gameHeight / 4)*2,
        y = 0,
    }),
    monsters.create({
        x = (config.gameHeight / 4)*3,
        y = 0,
    }),
    monsters.create({
        x = 0,
        y = (config.gameWidth / 4)*1,
    }),
    monsters.create({
        x = 0,
        y = (config.gameWidth / 4)*2,
    }),
    monsters.create({
        x = 0,
        y = (config.gameWidth / 4)*3,
    }),

    monsters.create({
        x = config.gameHeight-1,
        y = (config.gameWidth / 4)*1,
    }),
    monsters.create({
        x = config.gameHeight-1,
        y = (config.gameWidth / 4)*2,
    }),
    monsters.create({
        x = config.gameHeight-1,
        y = (config.gameWidth / 4)*3,
    }),

    monsters.create({
        x = (config.gameHeight / 4)*1,
        y = config.gameWidth-1,
    }),
    monsters.create({
        x = (config.gameHeight / 4)*2,
        y = config.gameWidth-1,
    }),
    monsters.create({
        x = (config.gameHeight / 4)*3,
        y = config.gameWidth-1,
    }),
}

for i = 0, (config.gameHeight / 2)+1 do
    for j = 0, config.gameWidth / 2 do
        local x = config.gameHeight / 2 / 2 + i
        local y = config.gameWidth / 2 / 2 + j
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
        game.width * 10,
        game.height * 10, {
            minwidth = game.width * 10,
            minheight = game.height * 10 })

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

