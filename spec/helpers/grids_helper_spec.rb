# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridsHelper, type: :helper do
  describe '#min_and_max' do
    it 'returns min and max of attribute' do
      expect(helper.min_and_max(Grid, :rows)).to eq({ min: 1, max: 50 })
    end
  end

  describe '#type' do
    shared_examples 'type' do |attribute, type|
      it 'returns type of attribute' do
        expect(helper.type(Grid, attribute)).to eq(type)
      end
    end

    include_examples 'type', :rows, :integer
    include_examples 'type', :phase_duration, :float
  end

  describe '#step' do
    shared_examples 'step' do |attribute, type, step|
      it "returns #{type} step" do
        expect(helper.step(Grid, attribute)).to eq({ step: step })
      end
    end

    include_examples 'step', :rows, :integer, 1
    include_examples 'step', :phase_duration, :float, 'any'
  end
end
