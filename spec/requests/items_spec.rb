require 'rails_helper'

RSpec.describe "Items", type: :request do
  let!(:merchant) { create :merchant }
  let!(:items) { create_list(:item, 10, merchant: merchant) }
  let!(:item) { items.first }

  describe "items index" do
    describe 'all items index' do
      before :each do 
        get "/api/v1/items"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all items' do
        expect(json).to_not be_empty
        expect(json[:data].count).to eq(10)
      end

      it 'returns attributes for each item' do
        items.each_with_index do |item, i|
          subject = json[:data][i]
          expect(subject[:id]).to eq(item.id.to_s)
          expect(subject[:type]).to eq('item')
          expect(subject[:attributes][:name]).to eq(item.name)
          expect(subject[:attributes][:description]).to eq(item.description)
          expect(subject[:attributes][:unit_price]).to eq(item.unit_price)
          expect(subject[:attributes][:merchant_id]).to eq(item.merchant.id)
        end
      end
    end

    describe 'merchant items index' do
      let!(:other_merchant) { create :merchant }
      let!(:other_items) { create_list(:item, 10, merchant: other_merchant)}

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
    end
  end

  describe 'items show' do
    before :each do
      get "/api/v1/items/#{item.id}"
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns a single item by id' do
      expect(json).to_not be_empty
      expect(json[:data][:id]).to eq(item.id.to_s)
    end

    it 'returns the items attributes' do 
      subject = json[:data][:attributes]

      expect(subject[:name]).to eq(item.name)
      expect(subject[:description]).to eq(item.description)
      expect(subject[:unit_price]).to eq(item.unit_price)
      expect(subject[:merchant_id]).to eq(item.merchant.id)
    end
  end
end
