# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'grids/new', type: :view do
  let(:form) { "form[action='#{root_path}'][method=post] " }

  def assert_label(attribute)
    assert_select "#{form}label[for=grid_data_#{attribute}]",
text: t('questions')[attribute]
  end

  def assert_field(attribute, range, type)
    step = type == :integer ? '[step=1]' : '[step=any]'

    assert_select [
      form,
      'input',
      "[name='grid_data[#{attribute}]']",
      '[required]',
      step,
      "[min='#{range.min}']",
      "[max='#{range.max}']"
    ].join
  end

  before do
    grid = GridData.new
    assign(:grid_data, grid)
    grid.errors.add :rows, :invalid

    render
  end

  shared_examples 'input' do |attribute, range, type = :integer|
    it "renders #{attribute} label and field" do
      assert_label(attribute)
      assert_field(attribute, range, type)
    end
  end

  include_examples 'input', :rows, 1..100
  include_examples 'input', :columns, 1..100
  include_examples 'input', :phase_duration, 0.01..5, :float
  include_examples 'input', :phases, 1..100

  it 'renders a submit button' do
    assert_select "#{form}input[type=submit]"
  end

  it 'renders errors' do
    expect(rendered).to match(/Number of rows is invalid/)
  end
end
