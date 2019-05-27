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
    x = 240,
    y = 240,
})

local objects = {
    myHero,
    monsters.create({
        x = 130,
        y = 0,
    }),
    monsters.create({
        x = 260,
        y = 0,
    }),
    monsters.create({
        x = 390,
        y = 0,
    }),
}

for i = 1, 27 do
    for j = 1, 27 do
        if i ~= 14 or j ~= 14 then
            table.insert(objects, walls.create({
                x = 100 + (10 * i),
                y = 100 + (10 * j),
            }))
        end
    end
end

local game = game.create(500, 500, objects)

local binder = require("control.binder").create(game)

love.window.setMode(
        game.width,
        game.height, {
            minwidth = game.width,
            minheight = game.height })

binder.bind({
    up = { myHero, "up" };
    down = { myHero, "down" };
    left = { myHero, "left" };
    right = { myHero, "right" };
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

