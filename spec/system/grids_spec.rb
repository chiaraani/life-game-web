# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Grids', type: :system do
  before { ActiveJob::Base.queue_adapter = :async }

  describe 'Playing grid' do
    def creating_grid(**options)
      visit root_path

      options[:long] = options.delete :phase_duration if options[:phase_duration].present?
      options.each { |field, value| fill_in field, with: value }
      click_on 'Create grid'
    end

    def expect_phase_to(change_something, phases: 2)
      creating_grid(phase_duration: 0.1 * (phases - 1), phases:)
      expect { sleep(0.1) }.to(change_something)
    end

    let(:phase_paragraph) { find('p', text: /Phase/) }

    it 'renders title' do
      visit root_path
      assert_selector 'h1', text: 'New population of cells in a grid'
    end

    it 'renders 4 rows and 3 columns' do
      creating_grid(rows: 4, columns: 3)
      expect(page).to have_selector(".cells[style='--rows: 4; --columns: 3']")
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

    it 'renders text "finished" when phases are finished' do
      creating_grid(phases: 4)
      assert_no_text('Finished!')
      sleep(0.2)
      assert_text('Finished!')
    end

    it 'renders link to create new grid' do
      creating_grid
      sleep(0.1)
      click_on 'Create another grid'
      assert_selector 'h1', text: 'New population of cells in a grid'
    end

    it 'can play several at the same time' do
      creating_grid(phases: 4, phase_duration: 0.1)
      sleep(0.1)

      expect { creating_grid(phase_duration: 0.1) }
        .to change(phase_paragraph, :text).from('Phase 2').to('Phase 1')
    end
  end
end
