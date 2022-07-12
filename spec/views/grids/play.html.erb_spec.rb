# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'grids/play', type: :view do
  before do
    assign(:grid, Grid.new(rows: 3, columns: 3))
    render
  end

  it('renders div#grid') { assert_select 'div#grid' }
  it('renders p#phase with "Phase 1"') { assert_select 'p#phase', text: 'Phase 1' }
end
