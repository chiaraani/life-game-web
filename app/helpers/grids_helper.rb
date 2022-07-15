# frozen_string_literal: true

# Helpers for grid views
module GridsHelper
  def min_and_max(attribute)
    validator = GridData.validators_on(attribute).find do |v|
      v.is_a? ActiveModel::Validations::NumericalityValidator
    end

    range = validator.instance_variable_get('@options')[:in]

    { min: range.min, max: range.max }
  end

  def type_of(attribute)
    Grid.attribute_types[attribute.to_s].to_s.split(':')[-2].downcase.to_sym
  end

  def step(attribute)
    { step: type_of(attribute) == :integer ? 1 : 'any' }
  end
end
