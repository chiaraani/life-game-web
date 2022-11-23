# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grid do
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

  describe 'cells' do
    rows = 10
    columns = 5
    subject(:grid) { described_class.new(rows:, columns:) }

    it "has #{rows} rows" do
      expect(grid.cells.count).to equal rows
    end

    it "has #{columns} columns" do
      expect(grid.cells.all? { |row| row.count == columns }).to be true
    end

    it 'has cell class' do
      expect(
        grid.cells.all? do |row|
          row.all? { |cell| cell.is_a?(Cell) }
        end
      ).to be true
    end
  end

  describe '#cell_lives and #cell_lives=' do
    it 'receives table of boolean values and sets cell lives according to it' do
      grid.cell_lives = phases[0]
      expect(grid.cell_lives).to eq phases[0]
    end
  end
  #   describe '#print' do
  #     it 'prints cells' do
  #       cell_characters = grid.cells.map do |row|
  #         "#{row.map(&:character).join}\n"
  #       end.join
  #
  #       expect { grid.print }.to output(a_string_starting_with(cell_characters)).to_stdout
  #     end
  #
  #     it 'prints current phase' do
  #       phase_description = "Phase #{grid.phase}\n"
  #       expect { grid.print }.to output(a_string_ending_with(phase_description)).to_stdout
  #     end
  #   end
  #
  #   describe '#next_phase' do
  #     it 'adds 1 to phase variable' do
  #       expect { grid.next_phase }.to change(grid, :phase).by(1)
  #     end
  #
  #     it 'changes cells to next phase' do
  #       grid.cell_lives = phases[0]
  #       grid.next_phase
  #       expect(grid.cell_lives).to(eq(phases[1]))
  #     end
  #   end
  #
  #   describe '#play' do
  #     subject(:play) { grid.play }
  #
  #     it 'calls #print' do
  #       allow(grid).to receive(:print)
  #       play
  #       expect(grid).to have_received(:print).twice
  #     end
  #
  #     it 'gos onto next phase' do
  #       expect { play }.to change(grid, :phase).by(1)
  #     end
  #   end
end
