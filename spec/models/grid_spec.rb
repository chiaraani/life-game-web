# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grid, type: :model do
  described_class.config = {
    default: { rows: 5, columns: 5, phase_duration: 0.01, phases: 2 }
  }

  let(:grid) { described_class.new }

  let(:phases) do
    [
      [
        [false, false, false, true, false],
        [true, false, false, false, true],
        [false, true, false, true, true],
        [true, false, false, true, false],
        [true, true, false, true, false]
      ],
      [
        [false, false, false, false, false],
        [false, false, true, false, true],
        [true, true, true, true, true],
        [true, false, false, true, false],
        [true, true, true, false, false]
      ]
    ]
  end

  describe 'validations' do
    shared_examples 'validates' do |field, type, range|
      it { is_expected.to validate_presence_of field }

      it do
        validate = validate_numericality_of(field)
        expect(subject).to(type == :integer ? validate.only_integer : validate)
      end

      it { is_expected.to validate_inclusion_of(field).in_range(range) }
    end

    include_examples 'validates', 'rows', :integer, 1..50
    include_examples 'validates', 'columns', :integer, 1..50
    include_examples 'validates', 'phase_duration', :float, 0.01..5
    include_examples 'validates', 'phases', :integer, 1..100
  end

  describe '#generate_cells' do
    subject! { grid.generate_cells }

    rows = 10
    columns = 5
    let(:grid) { described_class.new(rows:, columns:) }

    it "generates #{rows} rows" do
      expect(grid.cells.count).to equal rows
    end

    it "generates #{columns} columns" do
      expect(grid.cells.all? { |row| row.count == columns }).to be true
    end

    it 'generates cell objects' do
      expect(
        grid.cells.all? do |row|
          row.all? { |cell| cell.is_a?(Cell) }
        end
      ).to be true
    end

    it 'makes rows variable readonly' do
      expect { grid.rows = 7 }.to raise_error(NoMethodError)
    end

    it 'makes columns variable readonly' do
      expect { grid.columns = 7 }.to raise_error(NoMethodError)
    end
  end

  describe '#cell_lives and #cell_lives=' do
    before { grid.generate_cells }

    it 'receives table of boolean values and sets cell lives according to it' do
      grid.cell_lives = phases[0]
      expect(grid.cell_lives).to eq phases[0]
    end
  end

  describe '#print' do
    it 'prints cells' do
      cell_characters = grid.cells.map do |row|
        "#{row.map(&:character).join}\n"
      end.join

      expect { grid.print }.to output(a_string_starting_with(cell_characters)).to_stdout
    end

    it 'prints current phase' do
      phase_description = "Phase #{grid.phase}\n"
      expect { grid.print }.to output(a_string_ending_with(phase_description)).to_stdout
    end
  end

  describe '#next_phase' do
    before { grid.generate_cells }

    it 'adds 1 to phase variable' do
      expect { grid.next_phase }.to change(grid, :phase).by(1)
    end

    it 'changes cells to next phase' do
      grid.cell_lives = phases[0]
      grid.next_phase
      expect(grid.cell_lives).to(eq(phases[1]))
    end
  end

  describe '#play' do
    subject(:play) { grid.play }

    before { grid.generate_cells }

    it 'calls #print' do
      allow(grid).to receive(:print)
      play
      expect(grid).to have_received(:print).twice
    end

    it 'goes onto next phase' do
      expect { play }.to change(grid, :phase).by(1)
    end
  end
end
