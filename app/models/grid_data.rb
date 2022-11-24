# frozen_string_literal: true

# Validate grid data
class GridData
  include ActiveModel::Model
  include ActiveModel::Attributes

  %i[rows columns phases phase_duration].each { |name| attribute name }

  validates(*attribute_names, presence: true)
  validates :rows, :columns, numericality: { only_integer: true, in: 1..50 }
  validates :phase_duration, numericality: { in: 0.01..5 }
  validates :phases, numericality: { only_integer: true, in: 1..100 }

  def self.default
    new(**Rails.configuration.grid_default)
  end

  def self.min_and_max(attribute)
    range = numericality_options(attribute)[:in]
    { min: range.min, max: range.max }
  end

  def self.type_of(attribute)
    numericality_options(attribute)[:only_integer] ? :integer : :float
  end

  def to_grid
    Grid.new(**attributes.transform_keys(&:to_sym))
  end

  def self.numericality_options(attribute)
    validator = validators_on(attribute).find do |v|
      v.is_a? ActiveModel::Validations::NumericalityValidator
    end

    validator.instance_variable_get('@options')
  end
end
