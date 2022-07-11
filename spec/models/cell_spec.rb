# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cell, type: :model do
  subject(:cell) { Grid.new.cells[0][1] }

  it 'is live or dead' do
    expect(cell.live).to be(true).or be(false)
  end

  it 'belongs to a grid' do
    expect(cell.grid).to be_a(Grid)
  end

  it('has row coordinate') { expect(cell.row).to eq 0 }
  it('has column coordinate') { expect(cell.column).to eq 1 }

  describe '#character' do
    subject(:cell) { described_class.new(Grid.new, [1, 1], live) }

    context 'with live = true' do
      let(:live) { true }

      it 'returns bright indian red ⦿' do
        expect(cell.character).to eq Rainbow('⦿ ').indianred.bright
      end
    end

    context 'with live = false' do
      let(:live) { false }

      it 'returns a space' do
        expect(cell.character).to eq '  '
      end
    end
  end

  describe '#neighbours_coordinates' do
    rows = 10
    columns = 10
    let(:grid) { Grid.new(rows:, columns:) }

    shared_examples 'neighbours coordinates of' do |coordinates, neighbours|
      it "returns coordinates of neighbours of #{coordinates} cell" do
        cell = grid.cells[coordinates[0]][coordinates[1]]
        expect(cell.neighbours_coordinates).to match(neighbours.sort)
      end
    end

    context 'with internal coordinates' do
      include_examples 'neighbours coordinates of', [1, 1],
        [[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 0], [2, 1], [2, 2]]
    end

    context 'with corner coordinates' do
      include_examples 'neighbours coordinates of', [0, 0],
        [[0, 1], [1, 0], [1, 1]]

      include_examples 'neighbours coordinates of', [rows - 1, 0],
        [[rows - 1, 1], [rows - 2, 0], [rows - 2, 1]]

      include_examples 'neighbours coordinates of', [0, columns - 1],
        [[0, columns - 2], [1, columns - 1], [1, columns - 2]]

      include_examples 'neighbours coordinates of', [rows - 1, columns - 1],
        [[rows - 1, columns - 2], [rows - 2, columns - 1], [rows - 2, columns - 2]]
    end

    context 'with edge coordinates' do
      include_examples 'neighbours coordinates of', [0, 1],
        [[0, 0], [0, 2], [1, 0], [1, 1], [1, 2]]

      include_examples 'neighbours coordinates of', [1, 0],
        [[0, 0], [0, 1], [1, 1], [2, 1], [2, 0]]

      include_examples 'neighbours coordinates of', [rows - 1, 1],
        [[rows - 1, 0], [rows - 1, 2], [rows - 2, 0], [rows - 2, 1], [rows - 2, 2]]

      include_examples 'neighbours coordinates of', [1, columns - 1],
        [[0, columns - 1], [0, columns - 2], [1, columns - 2], [2, columns - 1], [2, columns - 2]]
    end
  end

  describe '#next?' do
    subject(:cell) { grid.cells[1][1] }

    let(:grid) { Grid.new(rows: 3, columns: 5) }

    shared_examples 'next' do |description, cells, will_live|
      it description do
        grid.cell_lives = cells
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
