-- Minimal JSON encoder/decoder (enough for the AI provider APIs).
local utf8 = require("utf8")

local json = {}

----------------------------------------------------------------------
-- Encoding
----------------------------------------------------------------------
local escapes = {
  ['"'] = '\\"', ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f",
  ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t",
}

local function escapeChar(c)
  return escapes[c] or string.format("\\u%04x", c:byte())
end

local function isArray(t)
  local n = 0
  for k in pairs(t) do
    if type(k) ~= "number" then return false end
    n = n + 1
  end
  return n == #t
end

local function encode(v)
  local tv = type(v)
  if tv == "string" then
    return '"' .. v:gsub('[%c"\\]', escapeChar) .. '"'
  elseif tv == "number" then
    return string.format("%.14g", v)
  elseif tv == "boolean" then
    return tostring(v)
  elseif tv == "nil" then
    return "null"
  elseif tv == "table" then
    local parts = {}
    if isArray(v) then
      for i = 1, #v do parts[i] = encode(v[i]) end
      return "[" .. table.concat(parts, ",") .. "]"
    end
    for k, val in pairs(v) do
      parts[#parts + 1] = encode(tostring(k)) .. ":" .. encode(val)
    end
    return "{" .. table.concat(parts, ",") .. "}"
  end
  error("cannot encode a value of type " .. tv)
end

function json.encode(v)
  return encode(v)
end

----------------------------------------------------------------------
-- Decoding
----------------------------------------------------------------------
local function skipWhitespace(s, i)
  return s:find("[^ \t\r\n]", i) or (#s + 1)
end

local unescapes = {
  b = "\b", f = "\f", n = "\n", r = "\r", t = "\t",
  ['"'] = '"', ["\\"] = "\\", ["/"] = "/",
}

local function parseString(s, i)
  local buf = {}
  local j = i + 1
  while true do
    local k = s:find('["\\]', j)
    if not k then error("unterminated string") end
    buf[#buf + 1] = s:sub(j, k - 1)
    if s:sub(k, k) == '"' then
      return table.concat(buf), k + 1
    end
    local e = s:sub(k + 1, k + 1)
    if e == "u" then
      local cp = tonumber(s:sub(k + 2, k + 5), 16)
      if not cp then error("bad unicode escape") end
      j = k + 6
      if cp >= 0xD800 and cp <= 0xDBFF and s:sub(j, j + 1) == "\\u" then
        local lo = tonumber(s:sub(j + 2, j + 5), 16)
        if lo and lo >= 0xDC00 and lo <= 0xDFFF then
          cp = 0x10000 + (cp - 0xD800) * 0x400 + (lo - 0xDC00)
          j = j + 6
        end
      end
      if cp >= 0xD800 and cp <= 0xDFFF then cp = 0xFFFD end  -- lone surrogate
      buf[#buf + 1] = utf8.char(cp)
    else
      local c = unescapes[e]
      if not c then error("bad escape sequence") end
      buf[#buf + 1] = c
      j = k + 2
    end
  end
end

local decodeValue

local function parseObject(s, i)
  local obj = {}
  i = skipWhitespace(s, i + 1)
  if s:sub(i, i) == "}" then return obj, i + 1 end
  while true do
    i = skipWhitespace(s, i)
    if s:sub(i, i) ~= '"' then error("expected a string key at position " .. i) end
    local key
    key, i = parseString(s, i)
    i = skipWhitespace(s, i)
    if s:sub(i, i) ~= ":" then error("expected ':' at position " .. i) end
    local val
    val, i = decodeValue(s, i + 1)
    obj[key] = val
    i = skipWhitespace(s, i)
    local d = s:sub(i, i)
    if d == "}" then return obj, i + 1 end
    if d ~= "," then error("expected ',' or '}' at position " .. i) end
    i = i + 1
  end
end

local function parseArray(s, i)
  local arr, n = {}, 0
  i = skipWhitespace(s, i + 1)
  if s:sub(i, i) == "]" then return arr, i + 1 end
  while true do
    local val
    val, i = decodeValue(s, i)
    n = n + 1
    arr[n] = val
    i = skipWhitespace(s, i)
    local d = s:sub(i, i)
    if d == "]" then return arr, i + 1 end
    if d ~= "," then error("expected ',' or ']' at position " .. i) end
    i = i + 1
  end
end

decodeValue = function(s, i)
  i = skipWhitespace(s, i)
  local c = s:sub(i, i)
  if c == "{" then return parseObject(s, i)
  elseif c == "[" then return parseArray(s, i)
  elseif c == '"' then return parseString(s, i)
  elseif s:sub(i, i + 3) == "true" then return true, i + 4
  elseif s:sub(i, i + 4) == "false" then return false, i + 5
  elseif s:sub(i, i + 3) == "null" then return nil, i + 4
  end
  local num = s:match("^-?%d+%.?%d*[eE]?[+-]?%d*", i)
  if num and #num > 0 then return tonumber(num), i + #num end
  error("unexpected character at position " .. i)
end

function json.decode(s)
  local value = decodeValue(s, 1)
  return value
end

return json
