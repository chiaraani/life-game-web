# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grid do
  let(:grid) do
    described_class.new Rails.configuration.grid_default.merge(attributes)
  end

  let(:attributes) { {} }

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
    let(:rows) { 10 }
    let(:columns) { 5 }
    let(:attributes) { { 'rows' => rows, 'columns' => columns } }

    it('has 10 rows') { expect(grid.cells.count).to eq rows }

    it 'has 5 columns' do
      expect(grid.cells.all? { |row| row.count == columns }).to be true
    end

    it 'has cell objects that belong to grid' do
      expect(
        grid.cells.all? do |row|
          row.all? { |cell| cell.is_a?(Cell) && cell.grid.equal?(grid) }
        end
      ).to be true
    end
  end

  describe '#cell_lives' do
    it 'returns cell lives' do
      grid.send(:cell_lives=, phases[0])
      expect(grid.cell_lives).to eq phases[0]
    end
  end

  describe '#play' do
    subject(:play) { grid.play { 'display data' } }

    before { allow(grid).to receive(:sleep) }

    it 'calls block on each step' do
      expect { |block| grid.play(&block) }.to yield_control.twice
    end

    it 'increases phase attribute' do
      expect { play }.to change(grid, :phase).by(1)
    end

    it 'changes cell lives to next phase' do
      grid.send(:cell_lives=, phases[0])
      play
      expect(grid.cell_lives).to(eq(phases[1]))
    end

    it 'sleeps phase duration' do
      play
      expect(grid).to have_received(:sleep).with(0.01).once
    end
  end
end
