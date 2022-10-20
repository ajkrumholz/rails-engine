require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe 'class methods' do
    describe 'search methods' do
      let!(:merchant) { create :merchant }
      let!(:other_merchant) { create :merchant }
      
      describe '::name_query' do
        let!(:item_1) { create :item, name: "angry albatross", merchant: merchant }
        let!(:item_2) { create :item, name: "sleuthy seagull", merchant: merchant }
        let!(:item_3) { create :item, name: "loopy albatross", merchant: other_merchant }
        let!(:item_4) { create :item, name: "jessica albatross", merchant: merchant }

        it 'returns all items matching a fragment of name' do
          query = Item.name_query('alba') 
          expect(query.first).to be_an(Item)
          expect(query).to include(item_1, item_3, item_4)
          expect(query).not_to include(item_2)
        end

        it 'returns matches ignoring case' do
          query = Item.name_query('AlBa') 

          expect(query).to include(item_1, item_3, item_4)
          expect(query).not_to include(item_2)
        end

        it 'orders results alphabetically' do
          query = Item.name_query('alba') 
          
          expect(query).to eq([item_1, item_4, item_3])
        end
      end

      describe 'price_queries' do
        let!(:item_1) { create :item, unit_price: 4.99, merchant: merchant }
        let!(:item_2) { create :item, unit_price: 9.99, merchant: merchant }
        let!(:item_3) { create :item, unit_price: 14.99, merchant: other_merchant }
        let!(:item_4) { create :item, unit_price: 20.99, merchant: merchant }
      
        describe '::min_query' do
          it 'returns items with unit_price >= min_price' do
            query = Item.min_query(5.00)
            expect(query).to include(item_2, item_3, item_4)
            expect(query).not_to include(item_1)
          end
        end

        describe '::max_query' do
          it 'returns items with unit_price <= to max_price' do
            query = Item.max_query(20.00)
            expect(query).to include(item_1, item_2, item_3)
            expect(query).not_to include(item_4)
          end
        end

        describe '::range_query' do
          it 'returns items with unit_price <= max and >= min' do
            query = Item.range_query(5.00, 20.00)
            expect(query).to include(item_2, item_3)
            expect(query).not_to include(item_1, item_4)
          end
        end
      end
    end
  end
end
