# frozen_string_literal: true

# A cell lives, dies, or is born, and interacts with other neighbour cells.
class Cell
  attr_accessor :live
  attr_reader :grid, :row, :column

  def initialize(grid, coordinates)
    @live = [true, false].sample
    @grid = grid
    @row, @column = coordinates

    neighbours_coordinates
  end

  def next?
    neighbour_count = live_neighbour_count

    if live
      neighbour_count > 1 && neighbour_count < 4
    else
      neighbour_count == 3
    end
  end

  private

  def neighbours_coordinates
    @neighbours_coordinates ||= possible_neighbours.select do |neighbour|
      on_grid?(*neighbour) && neighbour != [row, column]
    end
  end

  def on_grid?(neighbour_row, neighbour_column)
    (0..grid.rows - 1).include?(neighbour_row) && (0..grid.columns - 1).include?(neighbour_column)
  end

  def possible_neighbours
    (row - 1..row + 1).map do |neighbour_row|
      (column - 1..column + 1).map do |neighbour_column|
        [neighbour_row, neighbour_column]
      end
    end.flatten 1
  end

  def live_neighbour_count
    neighbours_coordinates.count do |neighbour|
      grid.cells[neighbour[0]][neighbour[1]].live
    end
  end
end
