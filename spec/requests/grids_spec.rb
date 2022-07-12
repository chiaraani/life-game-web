# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Grids', type: :request do
  describe 'GET /' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /' do
    subject! { post('/', params:) }

    context 'with correct parameters' do
      let(:params) do
        { grid: { rows: '3', columns: '3', phase_duration: '0.01', phases: '2' } }
      end

      it('redirects to play') { assert_redirected_to(:play, params:) }
    end

    context 'with wrong parameters' do
      let(:params) do
        { grid: { rows: 'Hello', columns: '3', phase_duration: '0.01' } }
      end

      it('renders new view') { expect(response).to render_template(:new) }
    end
  end
end
