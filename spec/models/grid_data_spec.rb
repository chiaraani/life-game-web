# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridData, type: :model do
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

    include_examples 'validates', 'rows', :integer, 1..100
    include_examples 'validates', 'columns', :integer, 1..100
    include_examples 'validates', 'phase_duration', :float, 0.01..5
    include_examples 'validates', 'phases', :integer, 1..100
  end

  describe '#self.type_of' do
    shared_examples 'type of' do |attribute, type|
      it "returns type of #{attribute}" do
        expect(described_class.type_of(attribute)).to eq type
      end
    end

    include_examples 'type of', 'rows', :integer
    include_examples 'type of', 'columns', :integer
    include_examples 'type of', 'phases', :integer
    include_examples 'type of', 'phase_duration', :float
  end

  describe '#self.range_of' do
    it 'returns range of rows' do
      expect(described_class.range_of('rows')).to eq 1..100
    end
  end

  describe '#transform_values' do
    subject(:transform_values) { grid_data.transform_values }

    let(:grid_data) do
      described_class.new(
        rows: '1',
        columns: '2',
        phases: '1',
        phase_duration: '0.01'
      )
    end

    let(:expected_output) do
      {
        'rows' => 1,
        'columns' => 2,
        'phases' => 1,
        'phase_duration' => 0.01
      }
    end

    it 'returns transformed values' do
      expect(grid_data.transform_values).to eq expected_output
    end
  end
end
