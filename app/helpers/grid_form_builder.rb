# frozen_string_literal: true

class GridFormBuilder < ActionView::Helpers::FormBuilder
  def number_field(attribute, **options)
    super attribute,
      required: true,
      step: step_of(attribute),
      min: range(attribute).min,
      max: range(attribute).max,
      **options
  end

  private

  def step_of(attribute)
    type_of(attribute) == :integer ? 1 : 'any'
  end

  def range(attribute)
    range = numericality_options(attribute)[:in]
  end

  def type_of(attribute)
    numericality_options(attribute)[:only_integer] ? :integer : :float
  end

  def numericality_options(attribute)
    validator = @object.class.validators_on(attribute).find do |v|
      v.is_a? ActiveModel::Validations::NumericalityValidator
    end

    validator.instance_variable_get('@options')
  end
end
