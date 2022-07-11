# frozen_string_literal: true

require_relative 'cell'

# Grid of cells that die, live and reproduce
class Grid
  class << self
    attr_accessor :config
  end

  self.config = {
    default: { rows: 50, columns: 50, phase_duration: 1, phases: 10 }
  }

  include ActiveModel::Model

  validates :rows, :columns, :phases, presence: true, numericality: { only_integer: true }
  validates :rows, :columns, inclusion: { in: 1..50 }
  validates :phase_duration, presence: true, numericality: true, inclusion: { in: 0.01..5 }
  validates :phases, inclusion: { in: 1..100 }

  attr_accessor :rows, :columns, :phase_duration, :phases
  attr_reader :cells, :phase

  def initialize(**args)
    args.merge(self.class.config[:default], args).each_pair do |key, value|
      instance_variable_set("@#{key}", value)
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
    system 'clear'

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

    instance_eval { undef :rows= }
    instance_eval { undef :columns= }
  end
end
