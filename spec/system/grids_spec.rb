# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Grids', type: :system do
  before do
    ActiveJob::Base.queue_adapter = :async
  end

  describe 'Playing grid' do
    def creating_grid(**options)
      visit root_path

      options[:long] = options.delete :phase_duration if options[:phase_duration].present?
      options.each { |field, value| fill_in field, with: value }
      click_on 'Create grid'
    end

    def expect_phase_to(change_something)
      creating_grid(phase_duration: 0.1)
      expect { sleep(0.1) }.to(change_something)
    end

    let(:phase_paragraph) { find('p', text: /Phase/) }

    it 'renders title' do
      visit root_path
      assert_selector 'h1', text: 'New population of cells in a grid'
    end

    it 'renders 4 rows and 3 columns' do
      creating_grid(rows: 4, columns: 3)
      expect(find('.cells')['style']).to eq '--rows: 4; --columns: 3;'
    end

    it 'renders 4 x 3 cells' do
      creating_grid(rows: 4,  columns: 3)
      assert_selector '.cells > span', count: 4 * 3
    end

    it 'goes onto next phase' do
      expect_phase_to(change { phase_paragraph.text.last.to_i }.by(1))
    end

    it 'switches cells to next phase' do
      expect_phase_to(change { find('.cells')['innerHTML'] })
    end

    it 'can play several at the same time' do
      creating_grid(phases: 4, phase_duration: 0.1)
      sleep(Rails.configuration.grid_loading_time + 0.1)

      expect { creating_grid(phase_duration: 0.1) }
        .to change(phase_paragraph, :text).from('Phase 2').to('Phase 1')
    end
  end
end
