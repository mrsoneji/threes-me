local Threesome = {}
local Threesome_mt = {__index = Threesome}

local vivid = require 'vivid'

local Util = require 'util'

local map = {}
local showRays = false
local show3d = true
local myPlayer = { x = 0, y = 0, angle = 45, elevation = 100 }
local velocity = 0.8
local minimap_point_size = 8
local colors = {}
local wall_sprite = {}
local viewport_width, viewport_height = 640, 360
local ray_length = 2000

function Threesome:init()
    BlobReader = require('BlobReader')

    file = io.open('levels//c7e1m1.lvl', 'rb')
    blob = BlobReader(file:read('*all'))
    file:close()

    blob:seek(5)

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

    -- Init wall colors randomly
    colors =            vivid.HSLSpread(4, math.random(), 0.3, 0.7)

    -- Create 1D image for 92 tile number
    local tempImage =   love.image.newImageData("assets/tile003.png")

    wall_sprite[92] = {}
    for x = 0, 15 do
        local newData =         love.image.newImageData( 2, 17 )
        for y = 0, 15 do
            local r, g, b, a = tempImage:getPixel(x, y)
            newData:setPixel(1, y, r, g, b, a)
        end
        wall_sprite[92][x] =    love.graphics.newImage(newData)
    end

    tempImage =   love.image.newImageData("assets/tile018.png")

    wall_sprite[1] = {}
    for x = 0, 15 do
        local newData =         love.image.newImageData( 2, 17 )
        for y = 0, 15 do
            local r, g, b, a = tempImage:getPixel(x, y)
            newData:setPixel(1, y, r, g, b, a)
        end
        wall_sprite[1][x] =    love.graphics.newImage(newData)
    end

end

function Threesome:render()
    -- Set FOV. Here we set the vision range.
    -- Where the nearest fov is to PI, the wider the vision.
    local fov = 3.14159 / 4

    local rays = viewport_width
    for q = 1, rays do
        local angle = myPlayer.angle - fov / 2 + fov * q / viewport_width

        for c = 0, ray_length, 1 do
            local xTile = (myPlayer.x + c * math.cos(angle)) / 64
            local yTile = (myPlayer.y + c * math.sin(angle)) / 64
            local x = math.floor(xTile)
            local y = math.floor(yTile)

            -- Let's put some guard clauses here
            if x < 0 or y < 0 then break end
            if map[x] == nil or map[x][y] == nil then break end

            local column_width = c / 64
            local column_height = 64 / (c * math.cos(angle - myPlayer.angle)) * viewport_width
            if map[x][y] == 92 then
                local r, g, b = colors[1]
                r, g, b = vivid.darken(1 / 1000 * c, r, g, b)
                love.graphics.setColor(r, g, b)
                -- love.graphics.rectangle( "fill", (q * viewport_width / rays), viewport_height / 2 - (column_height / 3), viewport_width / rays, column_height )

                local t = {}
                table.insert(t, math.floor(math.mod(xTile, 1) * 16))
                table.insert(t, math.floor(math.mod(yTile, 1) * 16))
                local notNeededValue, uv = nearestValue(t, 0)

                if math.abs(yTile - math.floor(yTile + 0.5)) > math.abs(xTile - math.floor(xTile + 0.5)) then
                    uv = math.floor(math.mod(yTile, 1) * 16)
                else
                    uv = math.floor(math.mod(xTile, 1) * 16)
                end
                love.graphics.draw(wall_sprite[92][uv], (q * viewport_width / rays), viewport_height / 2 - (column_height / 3), 0, viewport_width / rays, column_height / 16)

                if showRays == true then
                    local relative_myPlayer = { x = myPlayer.x / 16, y = myPlayer.y / 16, angle = myPlayer.angle }
                    local relative_cx = c / minimap_point_size 
                    local relative_cy = c / minimap_point_size 
                    love.graphics.setColor(1, 0, 0)

                    x = relative_myPlayer.x * minimap_point_size
                    y = relative_myPlayer.y * minimap_point_size
                    love.graphics.line( x, y, x + relative_cx * math.cos(angle), y + relative_cy * math.sin(angle) )
                end

                break
            elseif map[x][y] == 1 then
                local r, g, b = colors[2]
                r, g, b = vivid.darken(1 / 1000 * c, r, g, b)
                love.graphics.setColor(r, g, b)
                -- love.graphics.rectangle( "fill", (q * viewport_width / rays), viewport_height / 2 - (column_height / 3), viewport_width / rays, column_height )

                local t = {}
                table.insert(t, math.floor(math.mod(xTile, 1) * 16))
                table.insert(t, math.floor(math.mod(yTile, 1) * 16))
                local notNeededValue, uv = nearestValue(t, 0)
                if math.abs(yTile - math.floor(yTile + 0.5)) > math.abs(xTile - math.floor(xTile + 0.5)) then
                    uv = math.floor(math.mod(yTile, 1) * 16)
                else
                    uv = math.floor(math.mod(xTile, 1) * 16)
                end

                love.graphics.draw(wall_sprite[1][uv], (q * viewport_width / rays), viewport_height / 2 - (column_height / 3), 0, viewport_width / rays, column_height / 16)

                if showRays == true then
                    local relative_myPlayer = { x = myPlayer.x / 16, y = myPlayer.y / 16, angle = myPlayer.angle }
                    local relative_cx = c / minimap_point_size 
                    local relative_cy = c / minimap_point_size
                    love.graphics.setColor(1, 0, 1)

                    x = relative_myPlayer.x * minimap_point_size
                    y = relative_myPlayer.y * minimap_point_size
                    love.graphics.line( x, y, x + relative_cx * math.cos(angle), y + relative_cy * math.sin(angle) )
                end
                break
            end
        end
    end
end

function Threesome:renderMiniMap()
    for i = 0, 63 do
        for j = 0, 63 do
            if map[i][j] == 92 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle( "fill", i * minimap_point_size, j * minimap_point_size, minimap_point_size, minimap_point_size )
            end
            if map[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle( "fill", i * minimap_point_size, j * minimap_point_size, minimap_point_size, minimap_point_size )
            end
        end
    end

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle( "fill", math.floor(myPlayer.x / 8), math.floor(myPlayer.y / 8), minimap_point_size / 2, minimap_point_size / 2 )

    love.graphics.draw(wall_sprite[92][1], 10, 10, 0, 5, 5)
end

function Threesome:setPlayer(player)
    local x = math.floor(player.x / 64)
    local y = math.floor(player.y / 64)
    myPlayer = player
end

function Threesome:getPlayer()
    return myPlayer
end

-- Private functions
function renderAccordingTile(xtile, ytile)
    -- Get nearest image column
    print(' :: Data arrived xtile: '..xtile..':: Result: '..(math.mod(xtile, 1) * 64))
    print(' :: Data arrived ytile: '..ytile..':: Result: '..(math.mod(ytile, 1) * 64))
    
end

function nearestValue(table, number)
    local smallestSoFar, smallestIndex
    for i, y in ipairs(table) do
        if not smallestSoFar or (math.abs(number-y) < smallestSoFar) then
            smallestSoFar = math.abs(number-y)
            smallestIndex = i
        end
    end
    return smallestIndex, table[smallestIndex]
end

return Threesome