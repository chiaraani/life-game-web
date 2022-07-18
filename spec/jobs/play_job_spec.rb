# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayJob, type: :job do
  it 'matches with performed job' do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    described_class.perform_later(**Rails.configuration.grid_default)
    expect(described_class).to have_been_performed
  end

  it 'calls Grid.play' do
    grid = instance_double(Grid)
    allow(grid).to receive(:play)
    allow(Grid).to receive(:new).and_return(grid)

    described_class.perform_later(arg: 1)

    expect(Grid).to have_received(:new).with(arg: 1)
    expect(grid).to have_received(:play)
  end
end
