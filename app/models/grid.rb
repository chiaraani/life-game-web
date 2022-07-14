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

  validates(*attribute_names, presence: true)
  validates :rows, :columns, numericality: { in: 1..50 }
  validates :phase_duration, numericality: { in: 0.01..5 }
  validates :phases, numericality: { in: 1..100 }

  attr_reader :cells, :phase

  def initialize(**args)
    super Rails.configuration.grid_default.merge args.to_h do |_key, value, default|
      value.nil? ? default : value
    end
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
    cells.each { |row| Rails.logger.debug row.map(&:character).join }
    Rails.logger.debug { "Phase #{phase}" }
  end

  def next_phase
    self.cell_lives = cells.map { |row| row.map(&:next?) }
    @phase += 1
  end

  def play
    generate_cells
    print

    2.upto(@phases) do
      sleep(@phase_duration)
      next_phase
      print
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
