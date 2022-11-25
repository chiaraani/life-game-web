# frozen_string_literal: true

# Validate grid data
class GridData
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  %i[rows columns phases phase_duration].each { |name| attribute name }

  validates(*attribute_names, presence: true)
  validates :rows, :columns, numericality: { only_integer: true, in: 1..100 }
  validates :phase_duration, numericality: { in: 0.01..5 }
  validates :phases, numericality: { only_integer: true, in: 1..100 }

  after_validation :transform_values, if: ->(model) { model.errors.empty? }

  def self.default
    new(**Rails.configuration.grid_default)
  end

  def self.type_of(attribute)
    numericality_options(attribute)[:only_integer] ? :integer : :float
  end

  def self.range_of(attribute)
    numericality_options(attribute)[:in]
  end

  def transform_values
    attributes.each do |key, value|
      methods = { integer: :to_i, float: :to_f }
      send("#{key}=", value.send(methods[self.class.type_of(key)]))
    end
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

  private_class_method :numericality_options
end
