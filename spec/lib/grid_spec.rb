# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grid do
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

  let :allow_to_broadcast_grid do
    allow(Turbo::StreamsChannel).to receive(:broadcast_update_to)
  end

  let :expect_to_have_broadcasted_grid do
    expect(Turbo::StreamsChannel).to have_received(:broadcast_update_to).with(
      streamable,
      target: 'grid',
      partial: 'grids/grid',
      locals: { grid: }
    )
  end

  describe 'cells' do
    rows = 10
    columns = 5
    subject(:grid) { described_class.new(rows:, columns:) }

    it "has #{rows} rows" do
      expect(grid.cells.count).to eq rows
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

  describe '#broadcast_to' do
    let(:streamable) { [:play, 'my_job'] }

    it 'broadcasts grid with Turbo' do
      allow_to_broadcast_grid
      grid.broadcast_to(*streamable)
      expect_to_have_broadcasted_grid
    end
  end

  describe '#next_phase' do
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
    subject(:play) { grid.play(job_id) }

    let(:job_id) { 'job3' }
    let(:streamable) { [:play, job_id] }

    before { allow(grid).to receive(:sleep) }

    it 'calls #print' do
      allow(grid).to receive(:broadcast_to)
      play
      expect(grid).to have_received(:broadcast_to).with(*streamable).twice
    end

    it 'goes onto next phase' do
      expect { play }.to change(grid, :phase).by(1)
    end

    it 'sleeps loading time' do
      play
      expect(grid).to(
        have_received(:sleep)
        .with(Rails.configuration.grid_loading_time).once
      )
    end

    it 'sleeps phase duration' do
      play
      expect(grid).to have_received(:sleep).with(0.01).once
    end
  end
end
