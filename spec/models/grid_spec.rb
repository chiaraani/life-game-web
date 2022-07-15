# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grid, type: :model do
  let(:grid) { described_class.new(**attributes) }
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
  let(:attributes) { default }

  def default(**custom)
    Rails.configuration.grid_default.merge custom do |_key, value, default|
      value.nil? ? default : value
    end
  end

  describe 'type cast' do
    let(:attributes) { default(rows: '2') }

    it 'parses string valid arguments to integer or float' do
      expect(grid.rows).to eq 2
    end
  end

  describe '#generate_cells' do
    subject! { grid.generate_cells }

    rows = 10
    columns = 5
    let(:attributes) { default(rows:, columns:) }

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
  end

  describe '#cell_lives and #cell_lives=' do
    let(:attributes) do
      default(rows: phases[0].length, columns: phases[0][0].length)
    end

    it 'receives table of boolean values and sets cell lives according to it' do
      grid.generate_cells

      grid.cell_lives = phases[0]
      expect(grid.cell_lives).to eq phases[0]
    end
  end

  describe '#print' do
    subject(:print) { grid.print }

    let(:cells) do
      cell_characters = grid.cells.map do |row|
        row.map(&:character).join
      end.join "\n"
    end

    let(:phase) { grid.phase }

    before { grid.generate_cells }

    it 'prints cells and phase' do
      expect { print }.to(
        have_broadcasted_to('print_channel')
        .with(cells:, phase:)
      )
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

    it 'calls #print' do
      allow(grid).to receive(:print)
      play
      expect(grid).to have_received(:print).twice
    end

    it 'goes onto next phase' do
      expect { play }.to change(grid, :phase).by(2)
    end
  end
end
