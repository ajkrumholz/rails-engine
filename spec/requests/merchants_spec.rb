require 'rails_helper'

RSpec.describe "Merchants", type: :request do
  let!(:merchants) { create_list(:merchant, 10) }

  describe "merchant index" do
    before { get '/api/v1/merchants' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it 'returns all merchants' do
      expect(json).not_to be_empty
      expect(json[:data].size).to eq(10)
    end
    
    it 'holds the correct data for each merchant' do
      merchants.each_with_index do |merchant, i|
        expect(json[:data][i][:attributes][:name]).to eq(merchant.name)
        expect(json[:data][i][:id]).to eq(merchant.id.to_s)
        expect(json[:data][i][:type]).to eq('merchant')
      end
    end
  end

  describe "merchant show" do
    let!(:merchant) { create :merchant }

    before { get "/api/v1/merchants/#{merchant.id}"}

    it 'returns a record with a given id' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the data for the merchant' do
      expect(json[:data][:attributes][:name]).to eq(merchant.name)
      expect(json[:data][:type]).to eq('merchant')
      expect(json[:data][:id]).to eq(merchant.id.to_s)
    end
  end
end
