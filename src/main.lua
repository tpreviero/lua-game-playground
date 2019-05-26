math.randomseed(os.time())

local heroes = require("model.objects.hero.hero")
local monsters = require("model.objects.monster.monster")
local walls = require("model.objects.wall.wall")
local game = require("model.game.game")

local drawer = require("view.drawer")

local myHero = heroes.create("My hero")

local game = game.create(500, 500, {
    myHero
}, {
    monsters.create({
        x = 30,
        y = 20,
    })
}, {
    walls.create({
        x = 20,
        y = 20,
    })
})

local binder = require("control.binding").create(game)

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
