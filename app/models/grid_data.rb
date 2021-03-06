# frozen_string_literal: true

# Validate grid data
class GridData
  include ActiveModel::Model
  include ActiveModel::Attributes

  Grid.attribute_names.each { |name| attribute name }

  validates(*attribute_names, presence: true)
  validates :rows, :columns, numericality: { only_integer: true, in: 1..50 }
  validates :phase_duration, numericality: { in: 0.01..5 }
  validates :phases, numericality: { only_integer: true, in: 1..100 }

  def self.default
    new(**Rails.configuration.grid_default)
  end
end
