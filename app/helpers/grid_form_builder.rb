# frozen_string_literal: true

# Build HTML validations from Active Model Validations for Grid
class GridFormBuilder < ActionView::Helpers::FormBuilder
  def number_field(attribute, **options)
    super attribute,
      required: true,
      step: step_of(attribute),
      min: @object.class.range_of(attribute).min,
      max: @object.class.range_of(attribute).max,
      **options
  end

  private

  def step_of(attribute)
    @object.class.type_of(attribute) == :integer ? 1 : 'any'
  end
end
