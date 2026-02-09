do
    local function set_readonly_safe(tbl, state)
        if setreadonly then
            pcall(setreadonly, tbl, state)
        end
    end
    
    local function add_to_library(lib, name, func)
        if not lib then return end
        
        local success = pcall(function()
            set_readonly_safe(lib, false)
            rawset(lib, name, func)
            set_readonly_safe(lib, true)
        end)
        
        if not success and lib == string then
            local mt = debug.getmetatable("")
            if mt then
                set_readonly_safe(mt, false)
                pcall(function()
                    local idx = mt.__index
                    if type(idx) == "table" then
                        idx[name] = func
                    end
                end)
                set_readonly_safe(mt, true)
            end
        end
    end
    
    if string then
        add_to_library(string, "trim", function(str)
            return str:match("^%s*(.-)%s*$")
        end)
        
        add_to_library(string, "split", function(str, sep)
            sep = sep or ","
            local result = {}
            local pattern = "([^" .. sep:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1") .. "]+)"
            for match in str:gmatch(pattern) do
                table.insert(result, match)
            end
            if #result == 0 then
                result = {str}
            end
            return result
        end)
        
        add_to_library(string, "startswith", function(str, prefix)
            return str:sub(1, #prefix) == prefix
        end)
        
        add_to_library(string, "endswith", function(str, suffix)
            return str:sub(-#suffix) == suffix
        end)
        
        add_to_library(string, "contains", function(str, search)
            return str:find(search, 1, true) ~= nil
        end)
        
        add_to_library(string, "count", function(str, pattern)
            local count = 0
            local init = 1
            while true do
                local pos = str:find(pattern, init, true)
                if not pos then break end
                count = count + 1
                init = pos + 1
            end
            return count
        end)
        
        add_to_library(string, "replace", function(str, old, new)
            local result = ""
            local i = 1
            while i <= #str do
                local s = str:find(old, i, true)
                if not s then
                    result = result .. str:sub(i)
                    break
                end
                result = result .. str:sub(i, s - 1) .. new
                i = s + #old
            end
            return result
        end)
        
        add_to_library(string, "padleft", function(str, len, char)
            char = char or " "
            if #str >= len then return str end
            return string.rep(char, len - #str) .. str
        end)
        
        add_to_library(string, "padright", function(str, len, char)
            char = char or " "
            if #str >= len then return str end
            return str .. string.rep(char, len - #str)
        end)
        
        add_to_library(string, "escape", function(str)
            local escapes = {
                ["\n"] = "\\n",
                ["\r"] = "\\r",
                ["\t"] = "\\t",
                ["\\"] = "\\\\",
                ["\""] = "\\\"",
                ["'"] = "\\'",
            }
            local out = {}
            for i = 1, #str do
                local c = str:sub(i, i)
                out[i] = escapes[c] or c
            end
            return table.concat(out)
        end)
        
        add_to_library(string, "unescape", function(str)
            local unescapes = {
                n = "\n",
                r = "\r",
                t = "\t",
                ["\\"] = "\\",
                ["\""] = "\"",
                ["'"] = "'",
            }
            local out = {}
            local i = 1
            while i <= #str do
                if str:sub(i, i) == "\\" and i < #str then
                    local next_char = str:sub(i + 1, i + 1)
                    table.insert(out, unescapes[next_char] or next_char)
                    i = i + 2
                else
                    table.insert(out, str:sub(i, i))
                    i = i + 1
                end
            end
            return table.concat(out)
        end)
    end
    
    if table then
        add_to_library(table, "find", function(tbl, value, init)
            init = init or 1
            for i = init, #tbl do
                if tbl[i] == value then
                    return i
                end
            end
            return nil
        end)
        
        add_to_library(table, "filter", function(tbl, predicate)
            local result = {}
            for i, v in ipairs(tbl) do
                if predicate(v, i) then
                    table.insert(result, v)
                end
            end
            return result
        end)
        
        add_to_library(table, "map", function(tbl, transformer)
            local result = {}
            for i, v in ipairs(tbl) do
                result[i] = transformer(v, i)
            end
            return result
        end)
        
        add_to_library(table, "reduce", function(tbl, reducer, initial)
            local i = 1
            local accumulator = initial
            
            if accumulator == nil then
                if #tbl == 0 then return nil end
                accumulator = tbl[1]
                i = 2
            end
            
            for idx = i, #tbl do
                accumulator = reducer(accumulator, tbl[idx], idx)
            end
            return accumulator
        end)
        
        add_to_library(table, "slice", function(tbl, start_idx, end_idx)
            local n = #tbl
            start_idx = start_idx or 1
            end_idx = end_idx or n
            
            if start_idx < 0 then start_idx = n + start_idx + 1 end
            if end_idx < 0 then end_idx = n + end_idx + 1 end
            
            if start_idx < 1 then start_idx = 1 end
            if end_idx > n then end_idx = n end
            
            local result = {}
            for i = start_idx, end_idx do
                table.insert(result, tbl[i])
            end
            return result
        end)
        
        add_to_library(table, "flat", function(tbl, depth)
            depth = depth or 1
            local result = {}
            
            local function flatten(t, current_depth)
                for _, v in ipairs(t) do
                    if type(v) == "table" and current_depth < depth then
                        flatten(v, current_depth + 1)
                    else
                        table.insert(result, v)
                    end
                end
            end
            
            flatten(tbl, 0)
            return result
        end)
        
        add_to_library(table, "keys", function(tbl)
            local result = {}
            for k in pairs(tbl) do
                table.insert(result, k)
            end
            return result
        end)
        
        add_to_library(table, "values", function(tbl)
            local result = {}
            for _, v in pairs(tbl) do
                table.insert(result, v)
            end
            return result
        end)
        
        add_to_library(table, "merge", function(t1, t2)
            for k, v in pairs(t2) do
                t1[k] = v
            end
            return t1
        end)
        
        add_to_library(table, "reverse", function(tbl)
            local i, j = 1, #tbl
            while i < j do
                tbl[i], tbl[j] = tbl[j], tbl[i]
                i = i + 1
                j = j - 1
            end
            return tbl
        end)
        
        add_to_library(table, "shuffle", function(tbl)
            for i = #tbl, 2, -1 do
                local j = math.random(1, i)
                tbl[i], tbl[j] = tbl[j], tbl[i]
            end
            return tbl
        end)
        
        add_to_library(table, "copy", function(tbl)
            local result = {}
            for k, v in pairs(tbl) do
                result[k] = v
            end
            return result
        end)
        
        add_to_library(table, "deepcopy", function(tbl, seen)
            if type(tbl) ~= "table" then return tbl end
            
            seen = seen or {}
            if seen[tbl] then return seen[tbl] end
            
            local result = {}
            seen[tbl] = result
            
            for k, v in pairs(tbl) do
                result[table.deepcopy(k, seen)] = table.deepcopy(v, seen)
            end
            
            return setmetatable(result, getmetatable(tbl))
        end)
        
        add_to_library(table, "equal", function(t1, t2)
            if t1 == t2 then return true end
            if type(t1) ~= "table" or type(t2) ~= "table" then return false end
            
            for k, v in pairs(t1) do
                if type(v) == "table" then
                    if not table.equal(v, t2[k]) then return false end
                else
                    if v ~= t2[k] then return false end
                end
            end
            
            for k in pairs(t2) do
                if t1[k] == nil then return false end
            end
            
            return true
        end)
    end
    
    if math then
        add_to_library(math, "clamp", function(value, min, max)
            return math.min(math.max(value, min), max)
        end)
        
        add_to_library(math, "lerp", function(a, b, t)
            return a + (b - a) * t
        end)
        
        add_to_library(math, "round", function(value, decimals)
            decimals = decimals or 0
            local mult = 10 ^ decimals
            if value >= 0 then
                return math.floor(value * mult + 0.5) / mult
            else
                return math.ceil(value * mult - 0.5) / mult
            end
        end)
        
        add_to_library(math, "sign", function(value)
            if value > 0 then return 1
            elseif value < 0 then return -1
            else return 0 end
        end)
        
        add_to_library(math, "map", function(value, in_min, in_max, out_min, out_max)
            return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
        end)
        
        add_to_library(math, "isnan", function(value)
            return value ~= value
        end)
        
        add_to_library(math, "isinf", function(value)
            return value == math.huge or value == -math.huge
        end)
        
        add_to_library(math, "average", function(...)
            local args = {...}
            if #args == 0 then return 0 end
            local sum = 0
            for i = 1, #args do
                sum = sum + args[i]
            end
            return sum / #args
        end)
        
        add_to_library(math, "median", function(...)
            local args = {...}
            if #args == 0 then return 0 end
            table.sort(args)
            local mid = math.floor(#args / 2) + 1
            if #args % 2 == 0 then
                return (args[mid - 1] + args[mid]) / 2
            else
                return args[mid]
            end
        end)
    end
    
    if not _G.vector then
        _G.vector = {}
    end
    
    local function get_xyz(v)
        if type(v) ~= "table" then
            return 0, 0, 0
        end
        return v.x or v[1] or 0,
               v.y or v[2] or 0,
               v.z or v[3] or 0
    end
    
    _G.vector.create = function(x, y, z)
        return {x = x, y = y, z = z}
    end
    
    _G.vector.magnitude = function(v)
        local x, y, z = get_xyz(v)
        return math.sqrt(x * x + y * y + z * z)
    end
    
    _G.vector.normalize = function(v)
        local x, y, z = get_xyz(v)
        local mag = math.sqrt(x * x + y * y + z * z)
        if mag > 0 then
            return {x = x / mag, y = y / mag, z = z / mag}
        end
        return {x = 0, y = 0, z = 0}
    end
    
    _G.vector.dot = function(v1, v2)
        local x1, y1, z1 = get_xyz(v1)
        local x2, y2, z2 = get_xyz(v2)
        return x1 * x2 + y1 * y2 + z1 * z2
    end
    
    _G.vector.cross = function(v1, v2)
        local x1, y1, z1 = get_xyz(v1)
        local x2, y2, z2 = get_xyz(v2)
        return {
            x = y1 * z2 - z1 * y2,
            y = z1 * x2 - x1 * z2,
            z = x1 * y2 - y1 * x2
        }
    end
    
    _G.vector.lerp = function(v1, v2, t)
        local x1, y1, z1 = get_xyz(v1)
        local x2, y2, z2 = get_xyz(v2)
        return {
            x = x1 + (x2 - x1) * t,
            y = y1 + (y2 - y1) * t,
            z = z1 + (z2 - z1) * t
        }
    end
    
    _G.vector.angle = function(v1, v2)
        local dot = _G.vector.dot(v1, v2)
        local mag1 = _G.vector.magnitude(v1)
        local mag2 = _G.vector.magnitude(v2)
        if mag1 > 0 and mag2 > 0 then
            return math.acos(math.clamp(dot / (mag1 * mag2), -1, 1))
        end
        return 0
    end
    
    _G.vector.distance = function(v1, v2)
        local x1, y1, z1 = get_xyz(v1)
        local x2, y2, z2 = get_xyz(v2)
        local dx, dy, dz = x2 - x1, y2 - y1, z2 - z1
        return math.sqrt(dx * dx + dy * dy + dz * dz)
    end
    
    _G.vector.add = function(v1, v2)
        local x1, y1, z1 = get_xyz(v1)
        local x2, y2, z2 = get_xyz(v2)
        return {x = x1 + x2, y = y1 + y2, z = z1 + z2}
    end
    
    _G.vector.subtract = function(v1, v2)
        local x1, y1, z1 = get_xyz(v1)
        local x2, y2, z2 = get_xyz(v2)
        return {x = x1 - x2, y = y1 - y2, z = z1 - z2}
    end
    
    _G.vector.multiply = function(v, scalar)
        local x, y, z = get_xyz(v)
        return {x = x * scalar, y = y * scalar, z = z * scalar}
    end
    
    _G.vector.divide = function(v, scalar)
        if scalar == 0 then return {x = 0, y = 0, z = 0} end
        local x, y, z = get_xyz(v)
        return {x = x / scalar, y = y / scalar, z = z / scalar}
    end
    
    if bit32 then
        local MASK = 0xFFFFFFFF
        
        add_to_library(bit32, "rotl", function(x, disp)
            disp = disp % 32
            x = bit32.band(x, MASK)
            return bit32.bor(
                bit32.band(bit32.lshift(x, disp), MASK),
                bit32.rshift(x, 32 - disp)
            )
        end)
        
        add_to_library(bit32, "rotr", function(x, disp)
            disp = disp % 32
            x = bit32.band(x, MASK)
            return bit32.bor(
                bit32.rshift(x, disp),
                bit32.band(bit32.lshift(x, 32 - disp), MASK)
            )
        end)
        
        add_to_library(bit32, "countbits", function(x)
            local count = 0
            while x > 0 do
                count = count + bit32.band(x, 1)
                x = bit32.rshift(x, 1)
            end
            return count
        end)
    end
    
    if utf8 and bit32 then
        add_to_library(utf8, "validate", function(str)
            local i = 1
            local len = #str
            while i <= len do
                local c = str:byte(i)
                local bytes = 0
                
                if c < 0x80 then 
                    bytes = 1
                elseif bit32.band(c, 0xE0) == 0xC0 then 
                    bytes = 2
                elseif bit32.band(c, 0xF0) == 0xE0 then 
                    bytes = 3
                elseif bit32.band(c, 0xF8) == 0xF0 then 
                    bytes = 4
                else 
                    return false, i 
                end
                
                for j = 2, bytes do
                    if i + j - 1 > len then return false, i end
                    local b = str:byte(i + j - 1)
                    if bit32.band(b, 0xC0) ~= 0x80 then
                        return false, i
                    end
                end
                
                i = i + bytes
            end
            return true
        end)
        
        if utf8.codes and utf8.char then
            add_to_library(utf8, "reverse", function(str)
                local chars = {}
                for p, c in utf8.codes(str) do
                    table.insert(chars, 1, utf8.char(c))
                end
                return table.concat(chars)
            end)
        end
    end
    
    if os then
        add_to_library(os, "timems", function()
            return os.clock() * 1000
        end)
        
        if tick then
            add_to_library(os, "clockms", function()
                return tick() * 1000
            end)
        end
    end
end
