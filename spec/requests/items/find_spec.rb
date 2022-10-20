require 'rails_helper'

RSpec.describe 'Item Searches' do
  describe 'get item/find' do
    let!(:merchant) { create :merchant}
    let!(:uri) { '/api/v1/items/find'}

    describe 'search name' do
      let!(:item_1) { create :item, name: 'sandy beach', description: 'granules', merchant: merchant}
      let!(:item_2) { create :item, name: 'rocks', description: 'little pebbles', merchant: merchant }

      it 'returns a single item matching the fragment' do
        get "#{uri}?name=sand"
        expect(response).to have_http_status(200)
        expect(json[:data]).not_to be_empty
        expect(json[:data][:attributes][:name]).to eq(item_1.name)
      end

      it 'if no item is found' do
        get "#{uri}?name=bart"
        expect(response).to have_http_status(200)
        expect(json[:data]).to be_empty
      end
    end

    describe 'search price' do
      let!(:item_1) { create :item, merchant: merchant, unit_price: 10.99}
      let!(:item_2) { create :item, merchant: merchant, unit_price: 20.99}
      let!(:item_3) { create :item, merchant: merchant, unit_price: 4.99}

      it 'returns a single item matching the characteristics' do
        get "#{uri}?min_price=15"
        expect(json[:data][:attributes][:name]).to eq(item_2.name)

        get "#{uri}?max_price=5"
        expect(json[:data][:attributes][:name]).to eq(item_3.name)

        get "#{uri}?min_price=5&max_price=20"
        expect(json[:data][:attributes][:name]).to eq(item_1.name)
      end
    end
  end

  describe 'get item/find_all' do
    let!(:merchant) { create :merchant}
    let!(:other_merchant) { create :merchant }
    let!(:uri) { '/api/v1/items/find_all'}

    describe 'searching name by fragment' do
      let!(:item_1) { create :item, name: 'sandy beach', description: 'granules', merchant: merchant}
      let!(:item_2) { create :item, name: 'rocks', description: 'little pebbles', merchant: merchant }
      let!(:item_3) { create :item, name: 'after dinner sand mint', description: 'Sand-dollar minties', merchant: other_merchant}

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
        it 'an empty array if no item can be found' do
          get "#{uri}?name=cliff"
          expect(json[:data]).to be_empty
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

    describe 'searching item by price' do
      let!(:item_1) { create :item, merchant: merchant, unit_price: 10.99}
      let!(:item_2) { create :item, merchant: merchant, unit_price: 20.99}
      let!(:item_3) { create :item, merchant: other_merchant, unit_price: 4.99}

      it 'finds items below a maximum price' do
        get "#{uri}?max_price=20"
        expect(response).to be_successful
        expect(json).to_not be_empty
        found_items = json[:data].map { |item| item[:attributes][:name] }
        expect(found_items).to_not be_empty
        expect(found_items).to include(item_1.name, item_3.name)
        expect(found_items).not_to include(item_2.name)
      end

      it 'finds items above a min price' do
        get "#{uri}?min_price=5"
        found_items = json[:data].map { |item| item[:attributes][:name] }
        expect(found_items).to include(item_2.name, item_1.name)
        expect(found_items).not_to include(item_3.name)
      end

      it 'finds items between a min and max price' do
        item_4 = create(:item, merchant: merchant, unit_price: 25.99)
        get "#{uri}?min_price=5&max_price=25"
        found_items = json[:data].map { |item| item[:attributes][:name] }
        expect(found_items).to include(item_2.name, item_1.name)
        expect(found_items).not_to include(item_3.name, item_4.name)
      end

      describe 'sad paths' do
        it 'returns an error if a negative price is specified' do
          get "#{uri}?min_price=-5"
          expect(json[:error]).to include("Query price must be at least 0")
          expect(response).to have_http_status(400)
          get "#{uri}?max_price=-5"
          expect(json[:error]).to include("Query price must be at least 0")
          expect(response).to have_http_status(400)
          get "#{uri}?min_price=-5&max_price=10"
          expect(json[:error]).to include("Query price must be at least 0")
          expect(response).to have_http_status(400)
        end

        it 'return an empty array if no item matches' do
          get "#{uri}?min_price=60&max_price=600"
          expect(json[:data]).to be_empty
        end
      end
    end

    describe 'sad path - both params present' do
      
      it 'returns an error when price and name searched together' do
        message = "Cannot search name and price together"
        get "#{uri}?name=sandy&max_price=5"
        expect(json[:data][:error]).to include(message)
        expect(response).to have_http_status(400)
        get "#{uri}?name=sandy&min_price=5"
        expect(json[:data][:error]).to include(message)
        expect(response).to have_http_status(400)
        get "#{uri}?name=sandy&min_price=5&max_pric=10"
        expect(json[:data][:error]).to include(message)
        expect(response).to have_http_status(400)
      end
    end
  end
end