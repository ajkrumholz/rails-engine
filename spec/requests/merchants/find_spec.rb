require 'rails_helper'

RSpec.describe 'Merchant searches' do
  describe 'get merchant/find' do
    let!(:shrimp) { create :merchant, name: "Red Shrimp" }
    
    it 'returns a merchant by matching a fragment of their name' do
      get '/api/v1/merchants/find?name=Red'
      expect(response).to have_http_status(200)
      expect(json[:data][:attributes][:name]).to eq(shrimp.name)
    end

    it 'returns merchant when case doesnt match' do
      get '/api/v1/merchants/find?name=red'
      expect(json[:data][:attributes][:name]).to eq(shrimp.name)
    end

    it 'when more than one merchant matches, returns first alpha' do
      blue = create(:merchant, name: "Blue Shrimp")
      get '/api/v1/merchants/find?name=Shrimp'
      expect(json[:data][:attributes][:name]).to eq(blue.name)
    end
  end

  describe 'get merchant/find_all' do
    let!(:aardvark) { create :merchant, name: 'Aardvark Waffles' }
    let!(:gorilla) { create :merchant, name: 'Gorilla Waffles' }
    let!(:elephant) { create :merchant, name: 'Elephant Waffles' }
    let!(:giraffe) { create :merchant, name: 'Giraffe Pancakes'}

    it 'returns all merchants matching the fragment' do
      get '/api/v1/merchants/find_all?name=waffles'
      name_array = json[:data].map { |merchant| merchant[:attributes][:name] }
      expect(name_array).to include(aardvark.name, gorilla.name, elephant.name)
      expect(name_array).not_to include(giraffe.name)
    end
  end
end