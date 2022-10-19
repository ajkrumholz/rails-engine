require 'rails_helper'

RSpec.describe 'Item Searches' do
  describe 'get item/find_all' do
    describe 'searching name by fragment' do
      let!(:merchant) { create :merchant}
      let!(:other_merchant) { create :merchant }
      let!(:item_1) { create :item, name: 'sandy beach', description: 'granules', merchant: merchant}
      let!(:item_2) { create :item, name: 'rocks', description: 'little pebbles', merchant: merchant }
      let!(:item_3) { create :item, name: 'after dinner mint', description: 'Sand-dollar minties', merchant: other_merchant}
      let!(:uri) { '/api/v1/items/find_all'}

      it 'finds all items matching a query' do
        get "#{uri}?name=sand"
        expect(response).to be_successful
        expect(json).to have_key(:data)
        found_names = json[:data].map { |item| item[:attributes][:name] }
        expect(found_names).to include(item_1.name, item_3.name)
        expect(found_names).not_to include(item_2.name)
      end

      it 'matches queries regardless of case' do
        get "#{uri}?name=Sand"
        found_names = json[:data].map { |item| item[:attributes][:name] }
        expect(found_names).to include(item_1.name, item_3.name)
      end

      it 'sorts results alphabetically' do
        get "#{uri}?name=Sand"
        found_names = json[:data].map { |item| item[:attributes][:name] }
        expect(found_names.first).to eq(item_3.name)
        expect(found_names.second).to eq(item_1.name)
      end

      describe 'sad paths' do
        it 'returns an error if an item cannot be found' do
          get "#{uri}?name=cliff"
          expect(json).to have_key(:data)
          expect(json[:data][:error]).to include("Could not locate resource with name like cliff")
        end
        
        it 'returns an error if missing parameters' do
          get uri
          expect(json[:data][:message]).to eq("Could not complete query")
          expect(json[:data][:error]).to include("Parameter cannot be missing")
        end
  
        it 'returns an error if name is empty' do
          get "#{uri}?name="
          expect(json[:data][:message]).to eq("Could not complete query")
          expect(json[:data][:error]).to include("Parameter cannot be missing")
        end
      end
    end
  end
end