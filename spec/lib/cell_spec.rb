# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cell do
  subject(:cell) { grid.cells[0][1] }

  let(:grid) do
    Grid.new Rails.configuration.grid_default.merge(grid_attributes)
  end

  let(:grid_attributes) { {} }

  it 'is live or dead' do
    expect(cell.live).to be(true).or be(false)
  end

  it 'belongs to a grid' do
    expect(cell.grid).to be_a(Grid)
  end

  describe '#next?' do
    subject(:cell) { grid.cells[1][1] }

    let(:grid_attributes) { { columns: 5, rows: 3 } }

    shared_examples 'next' do |description, cells, will_live|
      it description do
        grid.send(:cell_lives=, cells)
        expect(cell.next?).to match(will_live)
      end
    end

    context 'without neighbours' do
      include_examples 'next', 'dies',
        [
          [false, false, false, true, false],
          [false, true, false, false, true],
          [false, false, false, true, true]
        ], false
    end

    context 'with one neighbour' do
      include_examples 'next', 'dies',
        [
          [false, false, true, true, false],
          [false, true, false, false, true],
          [false, false, false, true, true]
        ], false
    end

    context 'with two neighbours' do
      include_examples 'next', 'lives',
        [
          [false, false, true, true, false],
          [true, true, false, false, true],
          [false, false, false, true, true]
        ], true
    end

    context 'with three neighbours' do
      include_examples 'next', 'lives',
        [
          [false, false, true, true, false],
          [true, true, true, false, true],
          [false, false, false, true, true]
        ], true
    end

    context 'with four neighbours' do
      include_examples 'next', 'dies',
        [
          [false, true, true, true, false],
          [true, true, true, false, true],
          [false, false, false, true, true]
        ], false
    end

    context 'with five neighbours' do
      include_examples 'next', 'dies',
        [
          [false, true, true, true, false],
          [true, true, true, false, true],
          [false, true, false, true, true]
        ], false
    end

    context 'with three neighbours and empty' do
      include_examples 'next', 'is born',
        [
          [false, false, true, true, false],
          [true, false, false, false, true],
          [false, true, false, true, true]
        ], true
    end

    context 'with two neighbours and empty' do
      include_examples 'next', 'is not born',
        [
          [false, false, false, true, false],
          [true, false, false, false, true],
          [false, true, false, true, true]
        ], false
    end
  end
end
