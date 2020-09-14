local Threesome = {}
local Threesome_mt = {__index = Threesome}

local vivid = require 'vivid'
local lue = require 'lue'

local map = {}
local showMap = true
local show3d = true
local myPlayer = { x = 0, y = 0, angle = 45 }
local velocity = 0.8

function Threesome:init()
    BlobReader = require('BlobReader')

    file = io.open('levels//c7e1m1.lvl', 'rb')
    blob = BlobReader(file:read('*all'))
    file:close()

    blob:seek(0)

    for i = 0, 63 do
        map[i] = {}
        for j = 0, 63 do
            table.insert(map[i], blob:u16())
        end
    end

    for i = 0, 63 do
        for j = 0, 63 do
            local u16 = blob:u16()
            if u16 == 20 then
                -- Player's start position

                myPlayer.x = 64 * i
                myPlayer.y = 64 * j
            end
        end
    end
end

function Threesome:render()
    -- Set FOV. Here we set the vision range.
    -- Where the nearest fov is to PI, the wider the vision.
    local fov = 3.14159 / 4

    local rays = 1280
    for q = 1, rays do
        local angle = myPlayer.angle - fov / 2 + fov * q / 100;

        for c = 0, 720, 1 do
            local x = math.floor((myPlayer.x + c * math.cos(angle)) / 64)
            local y = math.floor((myPlayer.y + c * math.sin(angle)) / 64)

            -- Let's put some guard clauses here
            if x < 0 or y < 0 then break end
            if map[x] == nil or map[x][y] == nil then break end

            local column_height = (720 / c) * 60
            if map[x][y] == 92 then
                love.graphics.setColor(0, 0, 1, 1 - (1 / 1000 * (c / 1.2)))
                love.graphics.rectangle( "fill", (q * 1024 / 100), 720 / 2 - (column_height / 3), 12, column_height )

                if showMap == true then
                    local relative_myPlayer = { x = myPlayer.x / 1280 * 160, y = myPlayer.y / 720 * 160, angle = myPlayer.angle }
                    local relative_cx = c / 1280 * 160
                    local relative_cy = c / 720 * 160
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.line( relative_myPlayer.x, relative_myPlayer.y, relative_myPlayer.x + relative_cx * math.cos(angle), relative_myPlayer.y + relative_cy * math.sin(angle) )
                end
                break
            elseif map[x][y] == 1 then
                love.graphics.setColor(0, 1, 0, 1 - (1 / 1000 * (c * 2)))
                love.graphics.rectangle( "fill", (q * 1024 / 100), 720 / 2 - (column_height / 3), 12, column_height )

                if showMap == true then
                    local relative_myPlayer = { x = myPlayer.x / 1280 * 160, y = myPlayer.y / 720 * 160, angle = myPlayer.angle }
                    local relative_cx = c / 1280 * 160
                    local relative_cy = c / 720 * 160
                    love.graphics.setColor(1, 0, 1)
                    love.graphics.line( relative_myPlayer.x, relative_myPlayer.y, relative_myPlayer.x + relative_cx * math.cos(angle), relative_myPlayer.y + relative_cy * math.sin(angle) )
                end
                break
            end
        end
    end
end

function Threesome:renderMiniMap()
    local point_size = 8
    local map_limits = { x = #map, y = 0 }

    for i = 0, 63 do
        for j = 0, 63 do
            if map[i][j] == 92 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle( "fill", i * point_size, j * point_size, point_size, point_size )
            end
            if map[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle( "fill", i * point_size, j * point_size, point_size, point_size )
            end
        end
    end
end

function Threesome:setPlayer(player)
    myPlayer = player
end

function Threesome:getPlayer()
    return myPlayer
end

return Threesome