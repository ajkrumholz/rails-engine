require 'rails_helper'

RSpec.describe "Merchants", type: :request do
  let!(:merchants) { create_list(:merchant, 10) }

  describe "GET /index" do
    before { get '/api/v1/merchants' }

    it 'returns all merchants' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
