function removeLine(row, grid)
  
  for row=row, 2, -1 do
    for column=1, grid.width do
      -- on transfert descend la ligne du dessus colonne par colonne
      grid.cells[row][column] = grid.cells[row-1][column]
    end
  end
  
end