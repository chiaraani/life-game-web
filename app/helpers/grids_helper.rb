# frozen_string_literal: true

# Helpers for grid views
module GridsHelper
  def step_of(model, attribute)
    { step: model.type_of(attribute) == :integer ? 1 : 'any' }
  end
end
