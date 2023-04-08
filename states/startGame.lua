function startGame(tetrominos, currentTetrominos, dropTimer, dropSpeed, grid)

  gameMode = 'play'
  
  soundMenu:stop()
  soundPlay:play()
  
  initGrid(grid)
  
  spawnTetrominos(tetrominos, currentTetrominos, dropTimer, dropSpeed, grid)

  love.graphics.setFont(fontPlay)
end