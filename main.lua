require 'cupid'

local Threesome = require 'threesome'

local lue = require 'lue'

local Util = require 'util'

local cron = require 'cron'

local player = { }
local velocity = 0.8

function love.load()
    love.window.setMode(1280, 720, { fullscreen = false, centered = true, resizable = true, minwidth = 640, minheight = 480})

    love.graphics.setDefaultFilter('linear','nearest')

    Threesome:init()

    player = Threesome:getPlayer()
end

function love:keyreleased(key, code)
    if key == 'escape' then
      love.event.quit()
    end
    if key == 'tab' then
        showMap = not showMap
    end
end

function love.draw()
    Threesome:render()
    if showMap then Threesome:renderMiniMap() end
end

function love.update(dt)
    lue:update(dt)

    if love.keyboard.isDown('w', 'a', 's', 'd', 'left', 'right') then
        if love.keyboard.isDown('w') then
            player.x = player.x + velocity * math.cos( player.angle )
            player.y = player.y + velocity * math.sin( player.angle )
        end
        if love.keyboard.isDown('s') then
            player.x = player.x - velocity * math.cos( player.angle )
            player.y = player.y - velocity * math.sin( player.angle )
        end
        if love.keyboard.isDown('a') then
            player.x = player.x - (velocity * 4) * math.cos( player.angle + 90 )
            player.y = player.y - (velocity * 4) * math.sin( player.angle + 90 )
        end
        if love.keyboard.isDown('d') then
            player.x = player.x - (velocity * 4) * math.cos( player.angle - 90 )
            player.y = player.y - (velocity * 4) * math.sin( player.angle - 90 )
        end
        if love.keyboard.isDown('left') then
            player.angle = player.angle - .026
        end
        if love.keyboard.isDown('right') then
            player.angle = player.angle + .026
        end

        Threesome:setPlayer(player)
    end
end