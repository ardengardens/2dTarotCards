-- Three-Card Tarot Reflection for LÖVE 11.x
-- Black & white. Click the cards to flip them; the AI reading appears below.
--
-- API keys and model overrides are read from environment variables:
--   ANTHROPIC_API_KEY / OPENAI_API_KEY / GEMINI_API_KEY (or GOOGLE_API_KEY)
--   CLAUDE_MODEL / OPENAI_MODEL / GEMINI_MODEL   (optional)
-- Launch from the same terminal where you set them:  love tarot-love2d

local utf8 = require("utf8")
local json = require("json")

----------------------------------------------------------------------
-- Tarot data (same as tarot.py)
----------------------------------------------------------------------
local CARDS = {
  {"The Fool", "beginnings, openness, spontaneity"},
  {"The Magician", "initiative, resourcefulness, focused action"},
  {"The High Priestess", "intuition, mystery, inner knowing"},
  {"The Empress", "nurturing, creativity, abundance"},
  {"The Emperor", "structure, leadership, boundaries"},
  {"The Hierophant", "tradition, learning, shared values"},
  {"The Lovers", "alignment, relationships, meaningful choices"},
  {"The Chariot", "determination, direction, self-discipline"},
  {"Strength", "courage, patience, gentle confidence"},
  {"The Hermit", "reflection, solitude, inner guidance"},
  {"Wheel of Fortune", "cycles, change, turning points"},
  {"Justice", "accountability, fairness, clear choices"},
  {"The Hanged Man", "pause, surrender, a new perspective"},
  {"Death", "transition, endings, transformation"},
  {"Temperance", "balance, integration, moderation"},
  {"The Devil", "attachment, temptation, limiting patterns"},
  {"The Tower", "disruption, revelation, unstable foundations"},
  {"The Star", "hope, renewal, inspiration"},
  {"The Moon", "uncertainty, dreams, unclear information"},
  {"The Sun", "joy, vitality, clarity"},
  {"Judgement", "reckoning, awakening, answering a call"},
  {"The World", "completion, integration, accomplishment"},
}

local SUITS = {
  {"Wands", "energy, ambition, creativity, action"},
  {"Cups", "emotions, connection, relationships, imagination"},
  {"Swords", "thoughts, communication, decisions, conflict"},
  {"Pentacles", "work, resources, routines, material life"},
}

local RANKS = {
  {"Ace", "a seed, opening, or fresh opportunity"},
  {"Two", "a choice, partnership, or balancing act"},
  {"Three", "growth, collaboration, or early progress"},
  {"Four", "stability, structure, or a pause"},
  {"Five", "friction, challenge, or disruption"},
  {"Six", "support, transition, or regained harmony"},
  {"Seven", "assessment, strategy, or perseverance"},
  {"Eight", "movement, practice, or focused effort"},
  {"Nine", "maturity, resilience, or nearing a threshold"},
  {"Ten", "culmination, responsibility, or a cycle's peak"},
  {"Page", "curiosity, a message, or a learner's outlook"},
  {"Knight", "pursuit, momentum, or an approach in motion"},
  {"Queen", "embodied understanding, care, or inner mastery"},
  {"King", "stewardship, leadership, or mature command"},
}

local SPREAD = {
  "Past / Context",
  "Present / Focus",
  "Possible Direction",
}

-- Keys used in interpretations.lua for the three positions (same order as SPREAD)
local POSITION_KEYS = {"past", "present", "future"}

local READING_INSTRUCTIONS = [[
You are a thoughtful tarot reader giving a three-card reflection with the
positions Past / Context, Present / Focus, and Possible Direction. Treat tarot
as symbolic reflection and entertainment, not certain prediction. Interpret
each card in its position, then close with a short synthesis that speaks to the
user's question. Write in plain text with short paragraphs: no markdown, no
headers, no bullet lists.

Be concise, but do not omit important interpretive details just to meet a word
count. Do not cut off the response mid-sentence. For medical, legal, financial,
or safety-critical questions, encourage evidence-based decisions and qualified
professional support.
]]

local ROMAN = {"I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII",
               "XIII","XIV","XV","XVI","XVII","XVIII","XIX","XX","XXI"}

local function createDeck()
  local deck = {}
  for i, c in ipairs(CARDS) do
    deck[#deck + 1] = {
      name = c[1], keywords = c[2], suit = "Major Arcana",
      label = (i == 1) and "0" or ROMAN[i - 1],
    }
  end
  for _, s in ipairs(SUITS) do
    for _, r in ipairs(RANKS) do
      deck[#deck + 1] = {
        name = r[1] .. " of " .. s[1],
        keywords = r[2] .. "; " .. s[2],
        suit = s[1],
        label = r[1]:upper(),
      }
    end
  end
  return deck
end

local function drawThree(deck)
  local copy = {}
  for i, c in ipairs(deck) do copy[i] = c end
  for i = #copy, 2, -1 do
    local j = love.math.random(i)
    copy[i], copy[j] = copy[j], copy[i]
  end
  return {copy[1], copy[2], copy[3]}
end

local function makeUserPrompt(question, cards)
  local lines = {}
  for i, card in ipairs(cards) do
    lines[#lines + 1] = string.format("%d. %s: %s \226\128\148 %s",
      i, SPREAD[i], card.name, card.keywords)
  end
  return "User's question:\n" .. question .. "\n\nCards drawn:\n" .. table.concat(lines, "\n")
end

----------------------------------------------------------------------
-- AI providers (requests are sent with curl, since LÖVE has no HTTPS)
----------------------------------------------------------------------
local function env(name)
  local v = os.getenv(name)
  if v and v ~= "" then return v end
  return nil
end

local PROVIDERS = {
  claude = {
    label = "Anthropic (Claude)", short = "Claude", keyName = "ANTHROPIC_API_KEY",
    getKey = function() return env("ANTHROPIC_API_KEY") end,
    build = function(key, prompt)
      local model = env("CLAUDE_MODEL") or "claude-opus-5-5"
      return "https://api.anthropic.com/v1/messages",
        {"x-api-key: " .. key, "anthropic-version: 2023-06-01", "content-type: application/json"},
        {model = model, max_tokens = 2400, system = READING_INSTRUCTIONS,
         messages = {{role = "user", content = prompt}}}
    end,
    extract = function(d)
      local out = {}
      for _, block in ipairs(d.content or {}) do
        if block.type == "text" and block.text then out[#out + 1] = block.text end
      end
      return table.concat(out, "\n")
    end,
  },
  openai = {
    label = "OpenAI", short = "OpenAI", keyName = "OPENAI_API_KEY",
    getKey = function() return env("OPENAI_API_KEY") end,
    build = function(key, prompt)
      local model = env("OPENAI_MODEL") or "gpt-6"
      return "https://api.openai.com/v1/responses",
        {"Authorization: Bearer " .. key, "content-type: application/json"},
        {model = model, instructions = READING_INSTRUCTIONS, input = prompt,
         max_output_tokens = 2400}
    end,
    extract = function(d)
      local out = {}
      for _, item in ipairs(d.output or {}) do
        if item.type == "message" then
          for _, part in ipairs(item.content or {}) do
            if part.type == "output_text" and part.text then out[#out + 1] = part.text end
          end
        end
      end
      return table.concat(out, "\n")
    end,
  },
  gemini = {
    label = "Google Gemini", short = "Gemini", keyName = "GEMINI_API_KEY",
    getKey = function() return env("GEMINI_API_KEY") or env("GOOGLE_API_KEY") end,
    build = function(key, prompt)
      local model = env("GEMINI_MODEL") or "gemini-flash-latest"
      return "https://generativelanguage.googleapis.com/v1beta/models/" .. model .. ":generateContent",
        {"x-goog-api-key: " .. key, "content-type: application/json"},
        {systemInstruction = {parts = {{text = READING_INSTRUCTIONS}}},
         contents = {{role = "user", parts = {{text = prompt}}}},
         generationConfig = {maxOutputTokens = 2400}}
    end,
    extract = function(d)
      local out = {}
      local cand = d.candidates and d.candidates[1]
      local parts = cand and cand.content and cand.content.parts or {}
      for _, part in ipairs(parts) do
        if part.text then out[#out + 1] = part.text end
      end
      return table.concat(out, "\n")
    end,
  },
}
----------------------------------------------------------------------
-- Offline mode: builds a reading from interpretations.lua (no API, no internet)
----------------------------------------------------------------------
local function pick(list)
  if type(list) ~= "table" or #list == 0 then return nil end
  return list[love.math.random(#list)]
end

local function loadInterpretations()
  -- Re-read the file every time so edits show up without restarting the game.
  package.loaded["interpretations"] = nil
  local ok, data = pcall(require, "interpretations")
  if not ok then
    error("There is a problem in interpretations.lua:\n" .. tostring(data), 0)
  end
  if type(data) ~= "table" then
    error("interpretations.lua must end with: return { ... }", 0)
  end
  return data
end

local function buildOfflineReading(cards)
  local data = loadInterpretations()
  local cardTexts = data.cards or {}
  local intros = data.intros or {}
  local paragraphs, missing = {}, {}

  for i, card in ipairs(cards) do
    local key = POSITION_KEYS[i]
    local entry = cardTexts[card.name]
    local text = entry and (pick(entry[key]) or pick(entry.any))
    if not text then
      missing[#missing + 1] = card.name
      text = card.name .. " speaks of " .. card.keywords ..
        ". Consider how these themes show up in the area of life your question touches."
    end
    local intro = pick(intros[key])
    local body = intro and (intro .. " " .. text) or text
    paragraphs[#paragraphs + 1] = SPREAD[i] .. ": " .. card.name .. "\n" .. body
  end

  paragraphs[#paragraphs + 1] = pick(data.closings) or
    "Take what resonates and leave the rest. The cards are a mirror for your own reflection, not a forecast."

  if #missing > 0 then
    paragraphs[#paragraphs + 1] = "(No custom text yet for " .. table.concat(missing, ", ") ..
      ". Add it to interpretations.lua to replace the generic wording above.)"
  end

  return table.concat(paragraphs, "\n\n")
end

PROVIDERS.offline = {
  label = "Offline (no API)", short = "Offline", offline = true,
  getKey = function() return true end,
}

local PROVIDER_ORDER = {"claude", "openai", "gemini", "offline"}

-- Runs curl in a background thread so the window never freezes.
local THREAD_CODE = [[
require("love.thread")
local cmd, channelName, headerPath, bodyPath = ...
local channel = love.thread.getChannel(channelName)
local pipe = io.popen(cmd, "r")
if not pipe then
  channel:push("curl could not be started. Is curl installed and on your PATH?")
  return
end
local out = pipe:read("*a")
pipe:close()
os.remove(headerPath)
os.remove(bodyPath)
channel:push(out or "")
]]

----------------------------------------------------------------------
-- State
----------------------------------------------------------------------
local W, H = 1000, 820
local CARD_W, CARD_H, CARD_GAP, CARD_Y = 170, 280, 60, 96
local AREA = {x = 60, y = 424, w = 880, h = 326}   -- reading box

local deck
local screen = "provider"          -- "provider" | "ask" | "reading"
local providerId = nil
local providerMessage = nil
local question = ""
local askMessage = nil
local spread = {}                  -- the three card slots
local reading = nil
local pending = nil
local requestCounter = 0
local buttons = {}
local fonts = {}
local handCursor
local anyHover = false

local function safeText(s)
  s = s or ""
  if utf8.len(s) then return s end
  return (s:gsub("[\128-\255]", "?"))
end

local function cleanText(t)
  t = safeText(t):gsub("\r", "")
  t = t:gsub("%*%*(.-)%*%*", "%1")
  t = t:gsub("^#+%s*", ""):gsub("\n#+%s*", "\n")
  t = t:gsub("`", "")
  t = t:gsub("\n\n\n+", "\n\n")
  return (t:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function shorten(s, n)
  local len = utf8.len(s) or #s
  if len <= n then return s end
  local cut = utf8.offset(s, n + 1) or (#s + 1)
  return s:sub(1, cut - 1) .. "..."
end

----------------------------------------------------------------------
-- Requests
----------------------------------------------------------------------
local function newReadingState()
  return {
    status = "waiting",   -- waiting -> loading -> done | error
    text = "", lines = {}, totalChars = 0,
    shown = 0, scroll = 0, follow = true,
    error = nil, requested = false, delay = 0, dots = 0,
  }
end

-- Wraps the finished text and starts the typewriter display.
local function finishReading(text)
  reading.text = text
  local _, lines = fonts.body:getWrap(text, AREA.w - 48)
  reading.lines = lines
  local total = 0
  for _, line in ipairs(lines) do total = total + (utf8.len(line) or #line) end
  reading.totalChars = total
  reading.shown = 0
  reading.scroll = 0
  reading.follow = true
  reading.status = "done"
end

local function startRequest()
  local provider = PROVIDERS[providerId]

  -- Offline mode: no network, the reading comes from interpretations.lua
  if provider.offline then
    local cards = {}
    for i, slot in ipairs(spread) do cards[i] = slot.card end
    local ok, result = pcall(buildOfflineReading, cards)
    if ok then
      finishReading(safeText(result))
    else
      reading.status = "error"
      reading.error = safeText(tostring(result))
    end
    return
  end

  local key = provider.getKey()
  if not key then
    reading.status = "error"
    reading.error = provider.keyName .. " is not set. Set it in your terminal and launch the game from that terminal."
    return
  end

  local cards = {}
  for i, slot in ipairs(spread) do cards[i] = slot.card end
  local url, headers, body = provider.build(key, makeUserPrompt(question, cards))

  requestCounter = requestCounter + 1
  local id = requestCounter
  local bodyName = "req_" .. id .. "_body.json"
  local headerName = "req_" .. id .. "_headers.txt"
  local okB = love.filesystem.write(bodyName, json.encode(body))
  local okH = love.filesystem.write(headerName, table.concat(headers, "\n") .. "\n")
  if not (okB and okH) then
    reading.status = "error"
    reading.error = "Could not write the temporary request files."
    return
  end

  local dir = love.filesystem.getSaveDirectory()
  local bodyPath = dir .. "/" .. bodyName
  local headerPath = dir .. "/" .. headerName
  local cmd = string.format(
    'curl -sS --max-time 120 -X POST "%s" -H "@%s" --data-binary "@%s" 2>&1',
    url, headerPath, bodyPath)

  local channelName = "tarot_result_" .. id
  local thread = love.thread.newThread(THREAD_CODE)
  thread:start(cmd, channelName, headerPath, bodyPath)
  pending = {thread = thread, channel = love.thread.getChannel(channelName)}
  reading.status = "loading"
end

local function handleResult(raw)
  raw = safeText(raw)
  local ok, data = pcall(json.decode, raw)
  if not ok or type(data) ~= "table" then
    reading.status = "error"
    local snippet = raw:gsub("^%s+", ""):sub(1, 400)
    if snippet == "" then snippet = "(empty response)" end
    reading.error = "Could not read the response:\n" .. snippet
    return
  end
  if data.error then
    local msg = type(data.error) == "table" and (data.error.message or json.encode(data.error))
      or tostring(data.error)
    reading.status = "error"
    reading.error = safeText(msg)
    return
  end
  local ok2, text = pcall(PROVIDERS[providerId].extract, data)
  text = ok2 and cleanText(text) or ""
  if text == "" then
    reading.status = "error"
    reading.error = "The model returned no text. Check the model name and your account access."
    return
  end

  finishReading(text)
end

----------------------------------------------------------------------
-- Screen transitions
----------------------------------------------------------------------
local function resetReading()
  pending = nil          -- any in-flight answer is ignored
  reading = newReadingState()
  spread = {}
end

local function goProvider()
  resetReading()
  question = ""
  askMessage = nil
  screen = "provider"
end

local function goAsk()
  resetReading()
  question = ""
  askMessage = nil
  screen = "ask"
end

local function submitQuestion()
  local q = question:gsub("^%s+", ""):gsub("%s+$", "")
  if q == "" then
    askMessage = "Please enter a question."
    return
  end
  question = q
  askMessage = nil
  resetReading()
  local cards = drawThree(deck)
  for i = 1, 3 do
    spread[i] = {
      card = cards[i],
      x = (W - (3 * CARD_W + 2 * CARD_GAP)) / 2 + (i - 1) * (CARD_W + CARD_GAP),
      y = CARD_Y, w = CARD_W, h = CARD_H,
      flipped = false, t = 0, lift = 0,
    }
  end
  screen = "reading"
end

local function selectProvider(id)
  local p = PROVIDERS[id]
  if not p.getKey() then
    providerMessage = p.keyName .. " is not set.\nSet it in your terminal, then start the game from that same terminal with:  love tarot-love2d"
    return
  end
  providerMessage = nil
  providerId = id
  goAsk()
end

----------------------------------------------------------------------
-- Drawing helpers (black & white only)
----------------------------------------------------------------------
local function pointIn(px, py, x, y, w, h)
  return px >= x and px <= x + w and py >= y and py <= y + h
end

-- Immediate-mode button. Returns true if hovered.
local function button(id, x, y, w, h, label, sub)
  local mx, my = love.mouse.getPosition()
  local hover = pointIn(mx, my, x, y, w, h)
  buttons[#buttons + 1] = {id = id, x = x, y = y, w = w, h = h}
  if hover then anyHover = true end

  love.graphics.setLineWidth(2)
  if hover then
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", x, y, w, h, 6, 6)
    love.graphics.setColor(0, 0, 0)
  else
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", x, y, w, h, 6, 6)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, w, h, 6, 6)
  end
  love.graphics.setFont(fonts.button)
  local fh = fonts.button:getHeight()
  if sub then
    love.graphics.printf(label, x, y + h / 2 - fh + 2, w, "center")
    love.graphics.setFont(fonts.small)
    love.graphics.printf(sub, x, y + h / 2 + 4, w, "center")
  else
    love.graphics.printf(label, x, y + (h - fh) / 2, w, "center")
  end
  return hover
end

local function drawIcon(suit, cx, cy, s)
  love.graphics.setColor(0, 0, 0)
  if suit == "Wands" then
    love.graphics.setLineWidth(7)
    love.graphics.line(cx - s * 0.55, cy + s, cx + s * 0.55, cy - s * 0.85)
    love.graphics.setLineWidth(3)
    for i = 0, 2 do
      local px = cx + s * (0.15 + i * 0.17)
      local py = cy - s * (0.15 + i * 0.3)
      love.graphics.line(px, py, px + s * 0.4, py - s * 0.05)
      love.graphics.line(px, py, px - s * 0.3, py - s * 0.28)
    end
  elseif suit == "Cups" then
    local r = s * 0.7
    local bowlY = cy - s * 0.45
    love.graphics.arc("fill", cx, bowlY, r, 0, math.pi)
    love.graphics.setLineWidth(5)
    love.graphics.line(cx - r, bowlY, cx + r, bowlY)
    love.graphics.setLineWidth(6)
    love.graphics.line(cx, bowlY + r, cx, bowlY + r + s * 0.45)
    love.graphics.line(cx - s * 0.4, bowlY + r + s * 0.45, cx + s * 0.4, bowlY + r + s * 0.45)
  elseif suit == "Swords" then
    love.graphics.polygon("fill", cx - 6, cy - s * 0.8, cx + 6, cy - s * 0.8, cx, cy - s - 8)
    love.graphics.setLineWidth(12)
    love.graphics.line(cx, cy - s * 0.8, cx, cy + s * 0.45)
    love.graphics.setLineWidth(6)
    love.graphics.line(cx - s * 0.45, cy + s * 0.45, cx + s * 0.45, cy + s * 0.45)
    love.graphics.line(cx, cy + s * 0.45, cx, cy + s * 0.9)
    love.graphics.circle("fill", cx, cy + s * 0.98, 6)
  elseif suit == "Pentacles" then
    local R = s * 0.92
    love.graphics.setLineWidth(4)
    love.graphics.circle("line", cx, cy, R)
    love.graphics.setLineWidth(2)
    local pts = {}
    for k = 0, 4 do
      local a = -math.pi / 2 + k * 2 * math.pi / 5
      pts[k] = {cx + math.cos(a) * R * 0.82, cy + math.sin(a) * R * 0.82}
    end
    for k = 0, 4 do
      local p, q = pts[k], pts[(k + 2) % 5]
      love.graphics.line(p[1], p[2], q[1], q[2])
    end
  else -- Major Arcana: radiant sun
    love.graphics.circle("fill", cx, cy, s * 0.36)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", cx, cy, s * 0.5)
    love.graphics.setLineWidth(3)
    for k = 0, 11 do
      local a = k * math.pi / 6
      love.graphics.line(cx + math.cos(a) * s * 0.62, cy + math.sin(a) * s * 0.62,
                         cx + math.cos(a) * s * 0.98, cy + math.sin(a) * s * 0.98)
    end
  end
end

local function drawCardBack(w, h)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, w, h, 10, 10)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(3)
  love.graphics.rectangle("line", 2, 2, w - 4, h - 4, 10, 10)
  love.graphics.setLineWidth(1)
  love.graphics.rectangle("line", 14, 14, w - 28, h - 28, 6, 6)
  local cx, cy = w / 2, h / 2
  for _, r in ipairs({16, 32, 48}) do
    love.graphics.circle("line", cx, cy, r)
  end
  for k = 0, 15 do
    local a = k * math.pi / 8
    love.graphics.line(cx + math.cos(a) * 16, cy + math.sin(a) * 16,
                       cx + math.cos(a) * 48, cy + math.sin(a) * 48)
  end
  love.graphics.circle("fill", cx, cy, 5)
  -- corner diamonds
  for _, p in ipairs({{30, 30}, {w - 30, 30}, {30, h - 30}, {w - 30, h - 30}}) do
    love.graphics.polygon("line", p[1], p[2] - 7, p[1] + 7, p[2], p[1], p[2] + 7, p[1] - 7, p[2])
  end
end

local function drawCardFace(card, w, h)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, w, h, 10, 10)
  love.graphics.setColor(0, 0, 0)
  love.graphics.setLineWidth(3)
  love.graphics.rectangle("line", 2, 2, w - 4, h - 4, 10, 10)
  love.graphics.setLineWidth(1)
  love.graphics.rectangle("line", 10, 10, w - 20, h - 20, 6, 6)

  love.graphics.setFont(fonts.numeral)
  love.graphics.printf(card.label, 10, 18, w - 20, "center")
  love.graphics.line(28, 54, w - 28, 54)

  drawIcon(card.suit, w / 2, h / 2 - 2, 50)

  love.graphics.setColor(0, 0, 0)
  love.graphics.line(28, h - 62, w - 28, h - 62)
  love.graphics.setFont(fonts.cardName)
  local _, lines = fonts.cardName:getWrap(card.name, w - 30)
  local nameH = #lines * fonts.cardName:getHeight()
  love.graphics.printf(card.name, 15, h - 56 + (46 - nameH) / 2, w - 30, "center")
end

local function drawSlot(slot)
  local lift = slot.lift * 8
  local sx = math.max(math.abs(math.cos(math.pi * slot.t)), 0.02)
  love.graphics.push()
  love.graphics.translate(slot.x + slot.w / 2, slot.y + slot.h / 2 - lift)
  love.graphics.scale(sx, 1)
  love.graphics.translate(-slot.w / 2, -slot.h / 2)
  if slot.t >= 0.5 then
    drawCardFace(slot.card, slot.w, slot.h)
  else
    drawCardBack(slot.w, slot.h)
  end
  love.graphics.pop()
end

local function drawTitle(text, y)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fonts.title)
  love.graphics.printf(text, 0, y, W, "center")
end

----------------------------------------------------------------------
-- Screens
----------------------------------------------------------------------
local function drawProviderScreen()
  drawTitle("THREE-CARD TAROT", 100)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fonts.body)
  love.graphics.printf("Choose how to get your reading", 0, 156, W, "center")

  for i, id in ipairs(PROVIDER_ORDER) do
    local p = PROVIDERS[id]
    local sub
    if p.offline then
      sub = "reads interpretations.lua - no API key needed"
    else
      sub = p.getKey() and "API key found" or ("needs " .. p.keyName)
    end
    button("provider:" .. id, 290, 205 + (i - 1) * 70, 420, 60, p.label, sub)
  end

  if providerMessage then
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.body)
    love.graphics.printf(providerMessage, 140, 490, W - 280, "center")
  end

  love.graphics.setColor(0.6, 0.6, 0.6)
  love.graphics.setFont(fonts.small)
  love.graphics.printf("Symbolic reflection and entertainment, not certain prediction.", 0, 760, W, "center")

  -- Diagnostic line: confirms which copy of the game is running
  love.graphics.setColor(0.45, 0.45, 0.45)
  love.graphics.printf("version: offline-mode-v2   |   running from: " .. love.filesystem.getSource(),
    20, 784, W - 40, "center")
end

local function drawAskScreen()
  drawTitle("THREE-CARD TAROT", 70)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fonts.small)
  love.graphics.printf("via " .. PROVIDERS[providerId].short, 0, 112, W, "center")
  love.graphics.setFont(fonts.body)
  love.graphics.printf("Ask your question", 0, 220, W, "center")

  local bx, by, bw, bh = 150, 262, 700, 180
  love.graphics.setLineWidth(2)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", bx, by, bw, bh, 6, 6)

  local lineH = fonts.body:getHeight() * 1.3
  local maxLines = math.floor((bh - 28) / lineH)
  love.graphics.setScissor(bx + 2, by + 2, bw - 4, bh - 4)
  if question == "" then
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setFont(fonts.body)
    love.graphics.print("Type your question here...", bx + 16, by + 14)
  end
  local _, lines = fonts.body:getWrap(question, bw - 32)
  if #lines == 0 then lines = {""} end
  local first = math.max(1, #lines - maxLines + 1)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fonts.body)
  local row = 0
  for i = first, #lines do
    love.graphics.print(lines[i], bx + 16, by + 14 + row * lineH)
    row = row + 1
  end
  if math.floor(love.timer.getTime() * 2) % 2 == 0 then
    local last = lines[#lines]
    local cx = bx + 16 + fonts.body:getWidth(last) + 2
    local cy = by + 14 + (row - 1) * lineH
    love.graphics.rectangle("fill", cx, cy + 2, 2, fonts.body:getHeight() - 2)
  end
  love.graphics.setScissor()

  if askMessage then
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.small)
    love.graphics.printf(askMessage, 0, by + bh + 12, W, "center")
  end

  button("submit", 400, 500, 200, 50, "Draw Cards")
  button("back", 400, 566, 200, 40, "Back")

  love.graphics.setColor(0.6, 0.6, 0.6)
  love.graphics.setFont(fonts.small)
  love.graphics.printf("Enter to draw   |   Esc to go back   |   Ctrl/Cmd+V to paste", 0, 760, W, "center")
end

local function readingTextHeight()
  return #reading.lines * fonts.body:getHeight() * 1.3
end

local function drawReadingBox()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", AREA.x, AREA.y, AREA.w, AREA.h, 6, 6)

  local cx = AREA.x + AREA.w / 2
  love.graphics.setFont(fonts.body)

  if reading.status == "waiting" then
    local flipped = 0
    for _, s in ipairs(spread) do if s.flipped then flipped = flipped + 1 end end
    love.graphics.printf("Click each card to turn it over (" .. flipped .. "/3)",
      AREA.x, AREA.y + AREA.h / 2 - 12, AREA.w, "center")
  elseif reading.status == "loading" then
    local dots = string.rep(".", 1 + math.floor(love.timer.getTime() * 2) % 3)
    love.graphics.printf("Asking " .. PROVIDERS[providerId].short .. " to interpret your spread" .. dots,
      AREA.x, AREA.y + AREA.h / 2 - 12, AREA.w, "center")
  elseif reading.status == "error" then
    love.graphics.printf("Could not generate the interpretation.", AREA.x + 24, AREA.y + 20, AREA.w - 48, "left")
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.printf(reading.error or "Unknown error", AREA.x + 24, AREA.y + 60, AREA.w - 48, "left")
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.small)
    local hint = "Check the API key, model name, account access, connection, and usage limits. Then press New Reading."
    if providerId == "offline" then
      hint = "Fix interpretations.lua and save it, then press New Reading. No restart needed."
    end
    love.graphics.printf(hint, AREA.x + 24, AREA.y + AREA.h - 40, AREA.w - 48, "left")
  else -- done
    local lineH = fonts.body:getHeight() * 1.3
    local x, top = AREA.x + 24, AREA.y + 16
    love.graphics.setScissor(AREA.x + 2, AREA.y + 2, AREA.w - 4, AREA.h - 4)
    local remaining = math.floor(reading.shown)
    for i, line in ipairs(reading.lines) do
      local y = top + (i - 1) * lineH - reading.scroll
      local n = utf8.len(line) or #line
      if y > AREA.y - lineH and y < AREA.y + AREA.h then
        local s = line
        if remaining < n then
          local b = utf8.offset(line, remaining + 1) or (#line + 1)
          s = line:sub(1, b - 1)
        end
        love.graphics.print(s, x, y)
      end
      if remaining < n then break end
      remaining = remaining - n
    end
    love.graphics.setScissor()

    local maxScroll = math.max(0, readingTextHeight() - (AREA.h - 32))
    if maxScroll > 0 then
      local trackH = AREA.h - 20
      local thumbH = math.max(30, trackH * (AREA.h - 32) / readingTextHeight())
      local thumbY = AREA.y + 10 + (trackH - thumbH) * (reading.scroll / maxScroll)
      love.graphics.setLineWidth(1)
      love.graphics.line(AREA.x + AREA.w - 12, AREA.y + 10, AREA.x + AREA.w - 12, AREA.y + AREA.h - 10)
      love.graphics.setLineWidth(5)
      love.graphics.line(AREA.x + AREA.w - 12, thumbY, AREA.x + AREA.w - 12, thumbY + thumbH)
    end
  end
end

local function drawReadingScreen()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fonts.heading)
  love.graphics.printf("THREE-CARD TAROT", 0, 12, W, "center")
  love.graphics.setFont(fonts.small)
  love.graphics.setColor(0.75, 0.75, 0.75)
  love.graphics.printf("\"" .. shorten(question, 170) .. "\"", 60, 48, W - 120, "center")

  local mx, my = love.mouse.getPosition()
  for i, slot in ipairs(spread) do
    drawSlot(slot)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.small)
    love.graphics.printf(SPREAD[i]:upper(), slot.x - 30, slot.y + slot.h + 14, slot.w + 60, "center")
    if not slot.flipped and pointIn(mx, my, slot.x, slot.y - 8, slot.w, slot.h + 8) then
      anyHover = true
    end
  end

  drawReadingBox()

  button("newreading", 780, 766, 180, 38, "New Reading")
  button("provider", 60, 766, 180, 38, "Provider")
  if reading.status == "done" and reading.shown < reading.totalChars then
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.setFont(fonts.small)
    love.graphics.printf("Space or click to skip typing", 260, 776, 480, "center")
  end
end

----------------------------------------------------------------------
-- LÖVE callbacks
----------------------------------------------------------------------
local function loadFont(size)
  if love.filesystem.getInfo("font.ttf") then   -- optional: drop a font.ttf next to main.lua
    return love.graphics.newFont("font.ttf", size)
  end
  return love.graphics.newFont(size)
end

function love.load()
  -- Match the game's 1000x820 layout instead of LÖVE's smaller default window.
  -- Keep resizing disabled for now because the interface uses fixed coordinates.
  love.window.setMode(W, H, {
    resizable = false,
    highdpi = true,
    vsync = 1,
  })

  love.math.setRandomSeed(os.time(), math.floor(love.timer.getTime() * 1000000) % 2147483647)
  love.graphics.setBackgroundColor(0, 0, 0)
  love.keyboard.setKeyRepeat(true)
  handCursor = love.mouse.getSystemCursor("hand")

  fonts.title = loadFont(40)
  fonts.heading = loadFont(26)
  fonts.button = loadFont(20)
  fonts.body = loadFont(18)
  fonts.small = loadFont(14)
  fonts.numeral = loadFont(24)
  fonts.cardName = loadFont(15)

  deck = createDeck()
  reading = newReadingState()
end

function love.update(dt)
  if screen ~= "reading" then return end

  local allFlipped = (#spread == 3)
  for _, slot in ipairs(spread) do
    if slot.flipped then slot.t = math.min(1, slot.t + dt * 2.8) end
    if not (slot.flipped and slot.t >= 1) then allFlipped = false end

    local mx, my = love.mouse.getPosition()
    local hovering = (not slot.flipped) and pointIn(mx, my, slot.x, slot.y - 8, slot.w, slot.h + 8)
    local target = hovering and 1 or 0
    slot.lift = slot.lift + (target - slot.lift) * math.min(1, dt * 14)
  end

  if allFlipped and not reading.requested then
    reading.delay = reading.delay + dt
    if reading.delay > 0.4 then
      reading.requested = true
      startRequest()
    end
  end

  if pending then
    local result = pending.channel:pop()
    if result then
      pending = nil
      handleResult(result)
    else
      local err = pending.thread:getError()
      if err then
        pending = nil
        reading.status = "error"
        reading.error = "The request thread failed: " .. tostring(err)
      end
    end
  end

  if reading.status == "done" and reading.shown < reading.totalChars then
    reading.shown = math.min(reading.totalChars, reading.shown + dt * 110)
    if reading.follow then
      local lineH = fonts.body:getHeight() * 1.3
      local remaining, count = math.floor(reading.shown), 0
      for i, line in ipairs(reading.lines) do
        count = i
        local n = utf8.len(line) or #line
        if remaining < n then break end
        remaining = remaining - n
      end
      local maxScroll = math.max(0, readingTextHeight() - (AREA.h - 32))
      reading.scroll = math.min(maxScroll, math.max(0, count * lineH - (AREA.h - 32) + 6))
    end
  end
end

function love.draw()
  buttons = {}
  anyHover = false
  love.graphics.setLineWidth(1)

  if screen == "provider" then
    drawProviderScreen()
  elseif screen == "ask" then
    drawAskScreen()
  else
    drawReadingScreen()
  end

  love.mouse.setCursor(anyHover and handCursor or nil)
end

local function runAction(id)
  if id:sub(1, 9) == "provider:" then
    selectProvider(id:sub(10))
  elseif id == "submit" then
    submitQuestion()
  elseif id == "back" then
    goProvider()
  elseif id == "newreading" then
    goAsk()
  elseif id == "provider" then
    goProvider()
  end
end

function love.mousepressed(x, y, btn)
  if btn ~= 1 then return end

  for i = #buttons, 1, -1 do
    local b = buttons[i]
    if pointIn(x, y, b.x, b.y, b.w, b.h) then
      runAction(b.id)
      return
    end
  end

  if screen == "reading" then
    for _, slot in ipairs(spread) do
      if not slot.flipped and pointIn(x, y, slot.x, slot.y - 8, slot.w, slot.h + 8) then
        slot.flipped = true
        return
      end
    end
    if reading.status == "done" and reading.shown < reading.totalChars
       and pointIn(x, y, AREA.x, AREA.y, AREA.w, AREA.h) then
      reading.shown = reading.totalChars
    end
  end
end

function love.wheelmoved(_, dy)
  if screen == "reading" and reading.status == "done" then
    local maxScroll = math.max(0, readingTextHeight() - (AREA.h - 32))
    reading.scroll = math.min(maxScroll, math.max(0, reading.scroll - dy * 40))
    reading.follow = false
  end
end

function love.textinput(t)
  if screen == "ask" and #question < 2000 then
    question = question .. t
  end
end

function love.keypressed(key)
  if screen == "ask" then
    if key == "backspace" then
      local off = utf8.offset(question, -1)
      if off then question = question:sub(1, off - 1) end
    elseif key == "return" or key == "kpenter" then
      submitQuestion()
    elseif key == "escape" then
      goProvider()
    elseif key == "v" and love.keyboard.isDown("lctrl", "rctrl", "lgui", "rgui") then
      local clip = love.system.getClipboardText() or ""
      clip = clip:gsub("[\r\n\t]+", " ")
      if utf8.len(clip) and #question + #clip <= 2000 then
        question = question .. clip
      end
    end
  elseif screen == "reading" then
    if key == "space" and reading.status == "done" then
      reading.shown = reading.totalChars
    elseif key == "escape" then
      goAsk()
    end
  elseif screen == "provider" and key == "escape" then
    love.event.quit()
  end
end
