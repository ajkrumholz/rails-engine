require 'rails_helper'

RSpec.describe "Merchants", type: :request do
  let!(:merchants) { create_list(:merchant, 10) }

  describe "GET /index" do
    before { get '/api/v1/merchants' }

    it 'returns all merchants' do
      expect(json).not_to be_empty
      expect(json[:data].size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'has an initial data key' do
      expect(json).to have_key(:data)
    end

    it 'holds the correct data for each merchant' do
      merchants.each_with_index do |merchant, i|
        expect(json[:data][i][:attributes][:name]).to eq(merchant.name)
        expect(json[:data][i][:id]).to eq(merchant.id.to_s)
      end
    end
  end
end
