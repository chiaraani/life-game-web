# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GridsController, type: :routing do
  it 'routes / to grid#new' do
    expect(get('/')).to route_to('grids#new')
  end

  it 'routes / to grid#create' do
    expect(post('/')).to route_to('grids#create')
  end
end
