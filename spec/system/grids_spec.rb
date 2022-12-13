# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Grids', type: :system do
  before do
    ActiveJob::Base.queue_adapter = :async
  end

  describe 'Playing grid' do
    def creating_grid
      visit root_path

      yield
      click_on 'Create grid'
    end

    def fill_in_rows_and_columns(rows, columns)
      fill_in 'rows', with: rows
      fill_in 'columns', with: columns
    end

    def expect_phase_to(change_something)
      creating_grid do
        fill_in 'phases', with: 2
        fill_in 'long', with: 0.1
      end

      expect { sleep(0.1) }.to(change_something)
    end

    let(:phase_paragraph) { find('p', text: /Phase/) }

    it 'renders title' do
      visit root_path
      assert_selector 'h1', text: 'New population of cells in a grid'
    end

    it 'renders 4 rows and 3 columns' do
      creating_grid { fill_in_rows_and_columns(4, 3) }
      expect(find('.cells')['style']).to eq '--rows: 4; --columns: 3;'
    end

    it 'renders 4 x 3 cells' do
      creating_grid { fill_in_rows_and_columns(4, 3) }
      assert_selector '.cells > span', count: 4 * 3
    end

    it 'goes onto next phase' do
      expect_phase_to(change { phase_paragraph.text.last.to_i }.by(1))
    end

    it 'switches cells to next phase' do
      expect_phase_to(change { find('.cells')['innerHTML'] })
    end
  end
end
