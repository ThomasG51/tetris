function drawGrid(grid, tetrominos)

  for row=1, grid.height do
    for column=1, grid.width do
      if grid.cells[row][column] == 0 then
        love.graphics.setColor(1, 1, 1, 0.2)
      else
        local color = tetrominos[grid.cells[row][column]].color
        love.graphics.setColor(color[1], color[2], color[3])
      end
      love.graphics.rectangle("fill", grid.offsetX + (grid.cellSize * (column - 1)), grid.cellSize * (row - 1), (grid.cellSize - 1), (grid.cellSize - 1))
    end
  end

end