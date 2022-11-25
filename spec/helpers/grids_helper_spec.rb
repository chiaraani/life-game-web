# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridsHelper, type: :helper do
  describe '#print_cells' do
    subject { helper.print_cells grid }

    let(:grid) { Grid.new(rows: 2, columns: 2) }
    let(:cell_lives) { [[true, true], [false, true]] }
    let(:live) { helper.tag.span(class: 'cell') }
    let(:empty) { helper.tag.span }
    let(:result) { [live, live, empty, live].join }

    before { grid.cell_lives = cell_lives }

    it('prints cells') { is_expected.to eq result }
  end
end
