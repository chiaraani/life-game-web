# frozen_string_literal: true

# Validate grid data
class GridData
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  %i[game_id rows columns phases phase_duration].each { |name| attribute name }

  validates(*attribute_names, presence: true)
  validates :rows, :columns, numericality: { only_integer: true, in: 1..100 }
  validates :phase_duration, numericality: { in: 0.01..5 }
  validates :phases, numericality: { only_integer: true, in: 1..100 }

  after_validation :transform_values, if: ->(model) { model.errors.empty? }

  def self.default
    new('game_id' => SecureRandom.uuid, **Rails.configuration.grid_default)
  end

  def self.type_of(attribute)
    if numericality_validator(attribute).nil?
      :string
    elsif numericality_validator(attribute).options[:only_integer]
      :integer
    else
      :float
    end
  end

  def self.range_of(attribute)
    numericality_validator(attribute).options[:in]
  end

  def transform_values
    attributes.each do |key, value|
      send("#{key}=", value.send("to_#{self.class.type_of(key)[0]}"))
    end
  end

  def to_grid
    Grid.new(**attributes.transform_keys(&:to_sym))
  end

  def self.numericality_validator(attribute)
    validators_on(attribute).find do |v|
      v.is_a? ActiveModel::Validations::NumericalityValidator
    end
  end
  private_class_method :numericality_validator
end
