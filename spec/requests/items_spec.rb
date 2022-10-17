require 'rails_helper'

RSpec.describe "Items", type: :request do
  let!(:merchant) { create :merchant }
  let!(:items) { create_list(:item, 10, merchant: merchant) }
  let!(:item) { items.first }

  describe "items index" do
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
    end
  end
end
