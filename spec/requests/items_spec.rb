require 'rails_helper'

RSpec.describe "Items", type: :request do
  let!(:merchant) { create :merchant }
  let!(:items) { create_list(:item, 10, merchant: merchant) }
  let!(:item) { items.first }

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
        expect(subject[:type]).to eq('item')
        expect(subject[:attributes][:name]).to eq(item.name)
        expect(subject[:attributes][:description]).to eq(item.description)
        expect(subject[:attributes][:unit_price]).to eq(item.unit_price.to_s)
        expect(subject[:attributes][:merchant_id]).to eq(item.merchant.id)
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
      expect(subject[:unit_price]).to eq(item.unit_price.to_s)
      expect(subject[:merchant_id]).to eq(item.merchant.id)
    end
  end

  describe 'items/create' do
    let!(:merchant) { create :merchant }
    let!(:item_params) { {
      name: Faker::Commerce.product_name,
      description: Faker::Marketing.buzzwords,
      unit_price: 10.99,
      merchant_id: merchant.id
     } }
    let!(:headers) { {"CONTENT_TYPE" => "application/json"} }

    before { post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params) }

    it 'creates a new item' do
      created_item = Item.last
      subject = json[:data][:attributes]
      expect(response).to have_http_status(201)
      expect(json).not_to be_empty
      expect(subject[:name]).to eq(Item.last.name)
      expect(subject[:description]).to eq(Item.last.description)
      expect(subject[:unit_price]).to eq(Item.last.unit_price.to_s)
    end
  end

  describe 'item/destroy' do
    let!(:merchant) { create :merchant }
    let!(:item) { create :item, merchant: merchant}

    before { delete "/api/v1/items/#{item.id}" }

    it 'deletes an item given an id' do
      expect(response).to have_http_status(200)
      expect(json[:data][:id]).to eq(item.id.to_s)
      expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'item/update' do
    let!(:merchant) { create :merchant }
    let!(:item) { create :item, merchant: merchant }

    let!(:item_params) { { name: 'Sonic Hamburger Milkshake' } }
    let!(:headers) { { "CONTENT_TYPE" => 'application/json' } }

    it 'updates an attribute for an item' do
      put "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
      expect(response).to be_successful
      expect(json[:data][:id]).to eq(item.id.to_s)
      expect(json[:data][:attributes][:name]).to eq('Sonic Hamburger Milkshake')
    end

    it 'will return 404 if nonexistent id is provided' do
      put "/api/v1/items/10402941", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(404)
      expect(json[:message]).to eq "Couldn't find Item with 'id'=10402941"
    end

    it 'will return 404 if bad merchant id provided' do
      item_params = { name: 'Sonic Hamburger Milkshake', merchant_id: 14029291 }
      put "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(404)
    end
  end
end
