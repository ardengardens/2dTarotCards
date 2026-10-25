function love.conf(t)
  t.identity = "tarot-reader"          -- name of the save folder (used for temp request files)
  t.window.title = "Three-Card Tarot Reflection"
  t.window.width = 1000
  t.window.height = 820
  t.window.resizable = false
  t.window.msaa = 4                    -- smoother lines for the card art
end
