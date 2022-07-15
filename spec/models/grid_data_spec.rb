# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridData, type: :model do
  it 'has same attributes as Grid model' do
    expect(described_class.attribute_names).to eq Grid.attribute_names
  end

  describe 'validations' do
    shared_examples 'validates' do |field, type, range|
      it { is_expected.to validate_presence_of(field) }

      it do
        validate = validate_numericality_of(field)
        validate = validate.only_integer if type == :integer
        expect(subject).to validate
      end

      it do
        expect(subject).to validate_inclusion_of(field)
          .in_range(range)
          .with_message("must be in #{range}")
      end
    end

    include_examples 'validates', 'rows', :integer, 1..50
    include_examples 'validates', 'columns', :integer, 1..50
    include_examples 'validates', 'phase_duration', :float, 0.01..5
    include_examples 'validates', 'phases', :integer, 1..100
  end

  describe '#default' do
    subject(:default) { described_class.default }

    it 'returns grid data with default values' do
      expect(default.attributes).to eq Rails.configuration.grid_default
    end
  end
end
