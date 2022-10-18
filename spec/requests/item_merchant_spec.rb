require 'rails_helper'

RSpec.describe "Item/Merchant", type: :request do
  describe "GET /index" do
    describe 'when an item is specified, returns that items merchant' do
      let!(:merchant) { create :merchant }
      let!(:merchant_2) { create :merchant }
      let!(:item) { create :item, merchant: merchant}
      before { get "/api/v1/items/#{item.id}/merchant" }
      
      it 'returns the Merchant responsible for the item' do
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
      end

      it 'returns the merchants attributes' do
        subject = json[:data]
        expect(subject[:id]).to eq(merchant.id.to_s)
        expect(subject[:id]).not_to eq(merchant.id)
        expect(subject[:type]).to eq('merchant')
        expect(subject[:attributes][:name]).to eq(merchant.name)
      end
    end
  end
end
