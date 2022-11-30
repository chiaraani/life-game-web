# frozen_string_literal: true

# Helpers for grid views
module GridsHelper
  def print_cells(grid)
    grid.cells.map { |row| print_row row }.join
  end

  private

  def print_row(row)
    row.map { |cell| print_cell cell }.join
  end

  def print_cell(cell)
    cell.live ? tag.span(class: 'cell') : tag.span
  end
end
