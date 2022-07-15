# frozen_string_literal: true

require_relative 'cell'

# Grid of cells that die, live and reproduce
class Grid
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :rows, :integer
  attribute :columns, :integer
  attribute :phase_duration, :float
  attribute :phases, :integer

  attr_reader :cells, :phase

  def initialize(**args)
    super(**args)
    @phase = 0
  end

  def cell_lives
    cells.map { |row| row.map(&:live) }
  end

  def cell_lives=(next_lives)
    next_lives.each_with_index do |row, cell_row|
      row.each_with_index do |life, cell_column|
        @cells[cell_row][cell_column].live = life
      end
    end
  end

  def print
    data = {
      cells: cells.map { |row| row.map(&:character).join }.join("\n"),
      phase: @phase
    }

    ActionCable.server.broadcast('print_channel', data)
  end

  def next_phase
    self.cell_lives = cells.map { |row| row.map(&:next?) }
    @phase += 1
  end

  def play
    generate_cells

    loop do
      print
      break if phase >= phases

      sleep(phase_duration)
      next_phase
    end
  end

  def generate_cells
    @cells = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Cell.new(self, [row, column])
      end
    end

    @phase = 1
  end
end
