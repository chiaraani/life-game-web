# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrintChannel, type: :channel do
  it 'successfully subcribes' do
    subscribe
    expect(subscription).to be_confirmed
  end
end
