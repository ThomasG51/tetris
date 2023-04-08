function transfer(tetrominos, currentTetrominos, grid)

  local shape = tetrominos[currentTetrominos.shape].shape[currentTetrominos.rotation]
  
  for row=1, #shape do
    for column=1, #shape[row] do
      -- position du la piece sur la grille
      local gridCol = column + currentTetrominos.positionX
      local gridRow = row + currentTetrominos.positionY
      
      if shape[row][column] ~= 0 then
        grid.cells[gridRow][gridCol] = currentTetrominos.shape
      end
    end
  end

end