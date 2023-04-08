function collide(tetrominos, currentTetrominos, grid)

  local shape = tetrominos[currentTetrominos.shape].shape[currentTetrominos.rotation]
  
  for row=1, #shape do
    for column=1, #shape[row] do
      -- position du la piece sur la grille
      local gridCol = column + currentTetrominos.positionX
      local gridRow = row + currentTetrominos.positionY
      
      -- on verifie uniquement la forme du tetros (1)
      if shape[row][column] == 1 then
        if gridCol <= 0 or gridCol > grid.width then
          return true
        end
        
        if gridRow > grid.height then
          return true
        end
        
        if grid.cells[gridRow][gridCol] ~= 0 then
          return true
        end
      end
    end
  end
  
  return false

end