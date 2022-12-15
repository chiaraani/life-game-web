# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Grids', type: :request do
  describe 'GET /' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /play' do
    subject!(:create) { post('/play', params:) }

    context 'with correct parameters' do
      let(:params) do
        { grid_data: { rows: '3', columns: '3', phase_duration: '0.01',
                       phases: '2' } }
      end

      let(:job_params) do
        { 'rows' => 3,
          'columns' => 3,
          'phase_duration' => 0.01,
          'phases' => 2 }
      end

      it { expect(response).to have_http_status(:created) }
      it { expect(response).to render_template(:play) }

      it 'performs Play Job' do
        expect(PlayJob).to have_been_enqueued.with(job_params)
      end
    end

    context 'with wrong parameters' do
      let(:params) do
        { grid_data: { rows: '1000', columns: 'ajkd', phases: '' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template(:new) }

      it 'informs Number of rows is out of range' do
        expect(response.body).to include 'Number of rows must be in 1..100'
      end

      it 'informs Number of columns must be a number' do
        expect(response.body).to include 'Number of columns is not a number'
      end

      it 'informs Number of phases must be filled' do
        expect(response.body).to include CGI.escapeHTML('Number of phases can\'t be blank')
      end
    end
  end
end
