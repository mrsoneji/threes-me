require 'cupid'
local vivid = require 'vivid'
local lue = require 'lue'

local map = {}
local showMap = true
local show3d = true
local player = { x = 0, y = 0, angle = 45 }
local distance = 100 -- Distance between the player and the ray, in pixels.
local velocity = 0.8

function love.load()
    love.window.setMode(1280, 720, { fullscreen = false, centered = true, resizable = true, minwidth = 640, minheight = 480})

    love.graphics.setDefaultFilter('linear','nearest')

    map[0] = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}
    map[1] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[2] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[3] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[4] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[5] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[6] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[7] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[8] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[9] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[10] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[11] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[12] = {5, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}
    map[13] = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}
    map[14] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[15] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[16] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[17] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[18] = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5}
    map[19] = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}
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
    -- Render the player
    local fov = 3.1415 / 2

    local rays = 1280
    for q = 1, rays do
        local angle = player.angle - fov / 2 + fov * q / 100;

        for c = 0, 450, 1 do
            local x = math.floor((player.x + c * math.cos(angle)) / 64)
            local y = math.floor((player.y + c * math.sin(angle)) / 36)

            if x < 0 or y < 0 then break end

            if map[y][x] == 5 then
                if show3d == true then
                    local column_height = (720 / c) * 50                   
                    love.graphics.setColor(1, 0, 0, 1 - (1 / 1000 * (c * 2)))
                    love.graphics.rectangle( "fill", (q * 1024 / 100), 720 / 2 - (column_height / 2), 1024 / 100, column_height )
                end

                if showMap == true then
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.line( player.x, player.y, player.x + c * math.cos(angle), player.y + c * math.sin(angle) )
                end
                break
            end
        end
    end

    if showMap == true then
        for i = 0, 19 do
            for j = 0, 19 do
                if map[j][i] == 5 then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.rectangle( "fill", i * 64, j * 36, 64, 36 )
                end
            end
        end

        love.graphics.line( player.x, player.y, player.x + 20 * math.cos(player.angle), player.y + 20 * math.sin(player.angle) )
    end

    love.graphics.setColor(1, 1, 1)
end

function love.update(dt)
    lue:update(dt)
    
    if love.keyboard.isDown('w', 'a', 's', 'd') then
        if love.keyboard.isDown('w') then
            player.x = player.x + velocity * math.cos( player.angle )
            player.y = player.y + velocity * math.sin( player.angle )
        end
        if love.keyboard.isDown('s') then
            player.x = player.x - velocity * math.cos( player.angle )
            player.y = player.y - velocity * math.sin( player.angle )
        end
        if love.keyboard.isDown('a') then
            player.angle = player.angle - .008
        end
        if love.keyboard.isDown('d') then
            player.angle = player.angle + .008
        end
    end
end