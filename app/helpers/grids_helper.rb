# frozen_string_literal: true

# Helpers for grid views
module GridsHelper
  def min_and_max(model, attribute)
    validator = model.validators_on(attribute).find do |v|
      v.is_a? ActiveModel::Validations::InclusionValidator
    end

    range = validator.instance_variable_get('@delimiter')

    { min: range.min, max: range.max }
  end

  def type(model, attribute)
    validator = model.validators_on(attribute).find do |v|
      v.is_a? ActiveModel::Validations::NumericalityValidator
    end

    options = validator.instance_variable_get('@options')
    options[:only_integer] ? :integer : :float
  end

  def step(*args)
    { step: type(*args) == :integer ? 1 : 'any' }
  end
end
