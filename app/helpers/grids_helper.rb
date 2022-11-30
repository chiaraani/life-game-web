# frozen_string_literal: true

# Helpers for grid views
module GridsHelper
  def print_cells(grid)
    safe_join(grid.cells.map { |row| print_row row })
  end

  private

  def print_row(row)
    safe_join(row.map { |cell| print_cell cell })
  end

  def print_cell(cell)
    cell.live ? tag.span(class: 'cell') : tag.span
  end
end
