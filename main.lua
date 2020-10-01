require 'cupid'

local Threesome = require 'threesome'
local lue = require 'lue'
local Util = require 'util'
local cron = require 'cron'
local velocity = 1.8

function love.load()
    love.window.setMode(640, 360, { fullscreen = false, centered = true, resizable = false})

    love.graphics.setDefaultFilter('linear', 'nearest')

    Threesome:init()
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
        player = Threesome:getPlayer()

        if love.keyboard.isDown('w') then
            player.x = player.x + velocity * math.cos( player.angle )
            player.y = player.y + velocity * math.sin( player.angle )
        end
        if love.keyboard.isDown('s') then
            player.x = player.x - velocity * math.cos( player.angle )
            player.y = player.y - velocity * math.sin( player.angle )
        end
        if love.keyboard.isDown('a') then
            player.x = player.x - (velocity * 2) * math.cos( player.angle + 90 )
            player.y = player.y - (velocity * 2) * math.sin( player.angle + 90 )
        end
        if love.keyboard.isDown('d') then
            player.x = player.x - (velocity * 2) * math.cos( player.angle - 90 )
            player.y = player.y - (velocity * 2) * math.sin( player.angle - 90 )
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