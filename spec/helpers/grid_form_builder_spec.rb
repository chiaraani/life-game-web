# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridFormBuilder, type: :helper do
  def builder(&)
    helper.form_with(
      model: GridData.new, url: root_path, builder: GridFormBuilder, &
    )
  end

  describe '#number_field' do
    def is_expected_to_have_attribute(name, attribute, value = nil)
      builder do |form|
        selector = value ? "input[#{attribute}=#{value}]" : "input[#{attribute}]"
        expect(form.number_field(name)).to have_css(selector)
      end
    end

    it('is required') { is_expected_to_have_attribute(:rows, 'required') }
    it('has min') { is_expected_to_have_attribute(:rows, 'min', 1) }
    it('has max') { is_expected_to_have_attribute(:rows, 'max', 100) }

    shared_examples 'step' do |attribute, step|
      it "has step=#{step}" do
        is_expected_to_have_attribute(attribute, 'step', step)
      end
    end

    include_examples 'step', :rows, 1
    include_examples 'step', :phase_duration, 'any'
  end
end
