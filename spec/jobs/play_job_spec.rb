# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayJob, type: :job do
  it 'matches with performed job' do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    described_class.perform_later(**Rails.configuration.grid_default)
    expect(described_class).to have_been_performed
  end

  describe 'grid' do
    let(:grid_data) { instance_double(GridData) }
    let(:grid) { instance_double(Grid) }

    before do
      allow(grid).to receive(:play)
      allow(grid_data).to receive(:to_grid).and_return(grid)
      allow(GridData).to receive(:new).and_return(grid_data)
    end

    it 'is created' do
      described_class.perform_later(arg: 1)
      expect(GridData).to have_received(:new).with(arg: 1)
    end

    it 's play method is called' do
      described_class.perform_later(arg: 1)
      expect(grid).to have_received(:play)
    end
  end
end
