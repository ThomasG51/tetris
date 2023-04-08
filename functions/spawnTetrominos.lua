function spawnTetrominos(tetrominos, currentTetrominos, dropTimer, dropSpeed, grid)

  currentTetrominos.shape = math.random(1, #tetrominos)
  currentTetrominos.rotation = math.random(1, #tetrominos[currentTetrominos.shape])
  
  currentTetrominos.positionX = math.floor((grid.width - #tetrominos[currentTetrominos.shape].shape[currentTetrominos.rotation]) / 2)
  currentTetrominos.positionY = 1

  fallLimit = true

  dropTimer = dropSpeed
  
  if collide (tetrominos, currentTetrominos, grid) then
    startGameOver()
  end

end