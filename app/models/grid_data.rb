# frozen_string_literal: true

# Grid data manager
class GridData
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  %i[rows columns phases phase_duration].each { |name| attribute name }

  validates(*attribute_names, presence: true)
  validates :rows, :columns, numericality: { only_integer: true, in: 1..100 }
  validates :phase_duration, numericality: { in: 0.01..5 }
  validates :phases, numericality: { only_integer: true, in: 1..100 }

  def self.type_of(attribute)
    if numericality_validator(attribute).options[:only_integer]
      :integer
    else
      :float
    end
  end

  def self.range_of(attribute)
    numericality_validator(attribute).options[:in]
  end

  def transform_values
    attribute_names.index_with { |attribute| transform_value(attribute) }
  end

  private

  def transform_value(attribute)
    transform_method_name = "to_#{self.class.type_of(attribute)[0]}"
    attributes[attribute].send(transform_method_name)
  end

  def self.numericality_validator(attribute)
    validators_on(attribute).find do |v|
      v.is_a? ActiveModel::Validations::NumericalityValidator
    end
  end
  private_class_method :numericality_validator
end
