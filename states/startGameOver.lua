function startGameOver()

  gameMode = 'gameover'

  soundPlay:stop()
  soundMenu:stop()
  soundGameOver:play()
  
  love.graphics.setFont(fontMenu)
end