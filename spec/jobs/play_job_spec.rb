# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayJob, type: :job do
  let(:perform) do
    described_class.perform_later(game_id, Rails.configuration.grid_default)
  end

  let(:game_id) { 1 }

  it 'matches with performed job' do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    perform
    expect(described_class).to have_been_performed
  end

  describe 'grid' do
    let(:grid) { instance_double(Grid) }
    let(:perform) { described_class.perform_later(game_id, { arg: 1 }) }

    before do
      allow(grid).to receive(:play)
      allow(Grid).to receive(:new).and_return(grid)
    end

    it 'is created' do
      perform
      expect(Grid).to have_received(:new).with(arg: 1)
    end

    it 'plays' do
      perform
      expect(grid).to have_received(:play)
    end
  end

  describe 'broadcasting grid to channel [:play, game_id]' do
    let :expect_to_have_broadcasted_grid do
      expect(Turbo::StreamsChannel).to have_received(:broadcast_update_to).with(
        [:play, game_id],
        target: 'grid',
        partial: 'grids/grid',
        locals: { grid: instance_of(Grid) }
      ).twice
    end

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_update_to)
    end

    example do
      perform
      expect_to_have_broadcasted_grid
    end
  end
end
