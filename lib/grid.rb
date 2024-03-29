# frozen_string_literal: true

require_relative 'cell'

# Grid of cells that die, live and reproduce
class Grid
  attr_reader :cells, :phase, :rows, :columns, :phases, :phase_duration
  private attr_writer :cells, :phase

  def initialize(attributes)
    attributes.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
    generate_cells
  end

  def cell_lives
    cells.map { |row| row.map(&:live) }
  end

  def play
    loop do
      yield
      break if phase >= phases

      sleep phase_duration
      next_phase
    end
  end

  private

  def generate_cells
    @cells = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Cell.new(self, [row, column])
      end
    end

    @phase = 1
  end

  def cell_lives=(next_lives)
    next_lives.each_with_index do |row, cell_row|
      row.each_with_index do |life, cell_column|
        cells[cell_row][cell_column].live = life
      end
    end
  end

  def next_phase
    self.cell_lives = cells.map { |row| row.map(&:next?) }
    self.phase = phase + 1
  end
end
