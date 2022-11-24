# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridData, type: :model do
  it 'has correct attributes' do
    expect(described_class.attribute_names).to eq %w[rows columns phases phase_duration]
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

  describe '#self.default' do
    subject(:default) { described_class.default }

    it 'returns grid data with default values' do
      expect(default.attributes)
        .to eq Rails.configuration.grid_default.transform_keys(&:to_s)
    end
  end

  describe '#self.min_and_max' do
    it 'returns min and max of attribute' do
      expect(described_class.min_and_max(:rows)).to eq({ min: 1, max: 50 })
    end
  end

  describe '#self.type_of' do
    shared_examples 'type' do |attribute, type|
      it 'returns type of attribute' do
        expect(described_class.type_of(attribute)).to eq(type)
      end
    end

    include_examples 'type', :rows, :integer
    include_examples 'type', :phase_duration, :float
  end

  describe '#to_grid' do
    subject(:grid) { grid_data.to_grid }

    let(:grid_data) { described_class.default }

    let(:grid_attributes) do
      described_class.attribute_names.index_with do |key|
        grid.instance_variable_get("@#{key}")
      end
    end

    it('returns a Grid') { is_expected.to be_a Grid }

    it 'transfers data to Grid' do
      expect(grid_attributes).to eq grid_data.attributes
    end
  end
end
