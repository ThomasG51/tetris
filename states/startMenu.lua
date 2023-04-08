function startMenu()

  gameMode = 'menu'

  soundPlay:stop()
  soundGameOver:stop()
  soundMenu:play()

  love.graphics.setFont(fontMenu)
end