require 'rails_helper'

RSpec.describe "Items", type: :request do
  let!(:items) { create_list(:items, 10) }

  describe "items index" do
    before { get "/api/v1/items" }

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
        expect(subject[:type).to eq('item')
        expect(subject[:attributes][:name]).to eq(item.name)
        expect(subject[:attributes][:description]).to eq(item.description)
        expect(subject[:attributes][:unit_price]).to eq(item.unit_price)
      end
    end
  end
end
