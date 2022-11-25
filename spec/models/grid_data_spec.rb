# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridData, type: :model do
  let(:grid_data) { described_class.default }

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

    include_examples 'validates', 'rows', :integer, 1..100
    include_examples 'validates', 'columns', :integer, 1..100
    include_examples 'validates', 'phase_duration', :float, 0.01..5
    include_examples 'validates', 'phases', :integer, 1..100

    describe 'after validation' do
      before do
        allow(grid_data).to receive(:transform_values)
      end

      context 'when valid' do
        it 'transforms values' do
          grid_data.valid?
          expect(grid_data).to have_received(:transform_values)
        end
      end

      context 'when invalid' do
        let(:grid_data) { described_class.new(rows: 'haha') }

        it 'does NOT transform values' do
          grid_data.valid?
          expect(grid_data).not_to have_received(:transform_values)
        end
      end
    end
  end

  describe '#self.type_of' do
    shared_examples 'type of' do |attribute, type|
      it "returns type of #{attribute}" do
        expect(described_class.type_of(attribute)).to eq type
      end
    end

    include_examples 'type of', :rows, :integer
    include_examples 'type of', :columns, :integer
    include_examples 'type of', :phases, :integer
    include_examples 'type of', :phase_duration, :float
  end

  describe '#self.range_of' do
    it 'returns range of rows' do
      expect(described_class.range_of(:rows)).to eq 1..100
    end
  end

  describe '#self.default' do
    subject(:default) { described_class.default }

    it 'returns grid data with default values' do
      expect(default.attributes)
        .to eq Rails.configuration.grid_default.transform_keys(&:to_s)
    end
  end

  describe '#transform_values' do
    subject!(:transform_values) { grid_data.transform_values }

    let(:grid_data) do
      described_class.new(rows: '1', columns: '2', phases: '1', phase_duration: '0.01')
    end

    context 'with type integer' do
      it 'transforms value from string to integer' do
        expect(grid_data.rows).to eq 1
      end
    end

    context 'with type float' do
      it 'transforms value from string to float' do
        expect(grid_data.phase_duration).to eq 0.01
      end
    end
  end

  describe '#to_grid' do
    subject(:grid) { grid_data.to_grid }

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
