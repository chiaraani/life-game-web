# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'grids/_grid', type: :view do
  subject(:render_grid) { render partial: 'grids/grid', locals: { grid: } }

  let(:grid) { Grid.new(rows: 2, columns: 2) }
  let(:live_tag) { tag.span(class: 'cell') }
  let(:dead_tag) { tag.span }
  let(:cells_html) { [live_tag, dead_tag, live_tag, live_tag].join }

  before do
    grid.instance_variable_set '@phase', 17
    grid.cell_lives = [[true, false], [true, true]]
    render_grid
  end

  it 'renders grid\'s phase' do
    expect(rendered).to include('Phase 17')
  end

  it 'renders rows and columns as style variables' do
    assert_select '[style=?]', '--rows: 2; --columns: 2'
  end

  it 'renders live cells with class cell and dead with class empty' do
    expect(rendered).to include cells_html
  end
end
