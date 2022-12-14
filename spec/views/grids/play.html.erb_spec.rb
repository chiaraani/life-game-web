# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'grids/play', type: :view do
  before do
    assign(:grid, Grid.new(rows: 3, columns: 3))
    assign(:job_id, 'this_job')
  end

  it('renders div#grid') do
    render
    assert_select 'div#grid'
  end

  it('calls turbo') do
    allow(view).to receive(:turbo_stream_from).with(:play, 'this_job')
    render
    expect(view).to have_received(:turbo_stream_from).with(:play, 'this_job')
  end
end
