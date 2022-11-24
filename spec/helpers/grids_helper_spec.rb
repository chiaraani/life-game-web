# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridsHelper, type: :helper do
  describe '#step_of' do
    shared_examples 'step of' do |attribute, type, step|
      it "returns #{type} step" do
        expect(helper.step_of(GridData, attribute)).to eq({ step: })
      end
    end

    include_examples 'step of', :rows, :integer, 1
    include_examples 'step of', :phase_duration, :float, 'any'
  end
end
