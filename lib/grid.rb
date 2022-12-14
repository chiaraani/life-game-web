# frozen_string_literal: true

require_relative 'cell'

# Grid of cells that die, live and reproduce
class Grid
  class << self
    attr_accessor :config
  end

  self.config = { default: Rails.configuration.grid_default }

  attr_reader :cells, :phase, :rows, :columns

  def initialize(**args)
    args.merge(self.class.config[:default], args).each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
    generate_cells
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
    Turbo::StreamsChannel.broadcast_update_to(
      'play',
      target: 'grid',
      partial: 'grids/grid',
      locals: { grid: self }
    )
  end

  def next_phase
    self.cell_lives = cells.map { |row| row.map(&:next?) }
    @phase += 1
  end

  def play
    sleep 0.4

    loop do
      print
      break if phase >= @phases

      sleep @phase_duration
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
end
