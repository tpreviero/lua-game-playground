math.randomseed(os.time())
math.random()
math.random()
math.random()

local heroes = require("model.objects.hero.hero")
local monsters = require("model.objects.monster.monster")
local walls = require("model.objects.wall.wall")
local game = require("model.game.game")

local drawer = require("view.drawer")

local myHero = heroes.create("My hero", {
    x = 24,
    y = 24,
})

local otherHero = heroes.create("Other hero", {
    x = 23,
    y = 24,
})

local objects = {
    myHero,
    otherHero,
    monsters.create({
        x = 13,
        y = 0,
    }),
    monsters.create({
        x = 26,
        y = 0,
    }),
    monsters.create({
        x = 39,
        y = 0,
    }),
}

for i = 1, 27 do
    for j = 1, 27 do
        if (i ~= 14 and i ~= 13) or j ~= 14 then
            table.insert(objects, walls.create({
                x = 10 + i,
                y = 10 + j,
            }))
        end
    end
end

local game = game.create(50, 50, objects)

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

