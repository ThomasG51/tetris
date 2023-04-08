function initGrid(grid)

  grid.cellSize = WINDOW_HEIGHT / grid.height
  grid.offsetX = (WINDOW_WIDTH / 2) - ((grid.width * grid.cellSize) / 2)
  
  for row=1, grid.height do
    -- creation de la ligne dans le tableau des cellules
    grid.cells[row] = {} 
    
    for column=1, grid.width do
        grid.cells[row][column] = 0
    end
  end

end