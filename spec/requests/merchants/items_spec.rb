require 'rails_helper'

RSpec.describe "Merchant/Items", type: :request do
  let!(:merchant) { create :merchant }
  let!(:items) { create_list(:item, 10, merchant: merchant) }
  let!(:item) { items.first }
  let!(:other_merchant) { create :merchant }
  let!(:other_items) { create_list(:item, 10, merchant: other_merchant)}

  describe 'merchant items index' do

    before { get "/api/v1/merchants/#{merchant.id}/items" }

    it 'returns all items from a given merchant' do
      expect(Item.all.count).to eq(20)
      expect(json[:data].count).to eq(10)
    end

    it 'does not return items from another merchant' do
      json[:data].each do |item|
        expect(item[:attributes][:merchant_id]).to eq(merchant.id)
        expect(item[:attributes][:merchant_id]).not_to eq(other_merchant.id)
      end
    end

    it 'does not return items if given a bad merchant id' do
      get '/api/v1/merchants/1242991922/items'
      expect(response).to have_http_status(404)
      expect(json).to have_key(:data)
      expect(json[:data][:message]).to eq("Could not complete query")
    end
  end
end