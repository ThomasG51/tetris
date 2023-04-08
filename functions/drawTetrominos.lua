function drawTetrominos(tetrominos, color, grid, currentColumn, currentRow)
  
  for row=1, #tetrominos do
    for column=1, #tetrominos do
      
      -- Choix de la couleur du la case
      if tetrominos[row][column] == 1 then
        -- Position du tetrominos sur la grille
        local x = (currentColumn * grid.cellSize) + (grid.offsetX + ((column-1) * grid.cellSize))
        local y = (currentRow * grid.cellSize) + ((row-1) * grid.cellSize)
        
        love.graphics.setColor(color[1], color[2], color[3])
        love.graphics.rectangle("fill", x, y, grid.cellSize-1, grid.cellSize-1)
      end
      
    end
  end
  
end