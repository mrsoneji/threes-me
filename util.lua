local Util = {}
local Util_mt = {__index = Util}

local _ = require 'underscore'

function Util:check_collision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2+w2 and
    x2 < x1+w1 and
    y1 < y2+h2 and
    y2 < y1+h1
end

function Util:generate_numbers(up_to)
  local return_value = { }
  for i = 1, up_to do
    table.insert(return_value, i)
  end
  return return_value
end

function Util:find_index(list, x, y)
  local index={}

  for k,v in pairs(list) do
   if (index[v.x] == nil) then
    index[v.x] = {}
   end
   index[v.x][v.y]=k
  end

  return index[x][y]
end

function Util:hex2rgb(hex)
  hex = hex:gsub("#","")
  return { r = tonumber("0x"..hex:sub(1,2)) / 255,
    g = tonumber("0x"..hex:sub(3,4)) / 255, 
    b = tonumber("0x"..hex:sub(5,6))  / 255
  }
end

function Util:hex2rgb_raw(hex)
  hex = hex:gsub("#","")
  return { tonumber("0x"..hex:sub(1,2)) / 255,
    tonumber("0x"..hex:sub(3,4)) / 255, 
    tonumber("0x"..hex:sub(5,6))  / 255
  }
end

function Util:branch(condition, true_func, false_func, ...)
  if (condition == true) then
    true_func(unpack(arg))
  else
    false_func(unpack(arg))
  end
end

function Util:inspect(obj)
  if type(obj) ~= 'table' then
     return tostring(obj)
  else
     local pairs = _.map(_.keys(obj), 
       function (k)
           return tostring(k) .. " = " .. Util:inspect(obj[k])
       end)
     return "{ " .. _.join(pairs, ", ") .. " }"
  end
end

function Util:file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

function Util:explode(inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end

function Util:trim(s)
  return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

return Util