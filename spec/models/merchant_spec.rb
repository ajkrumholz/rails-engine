require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'class methods' do
    describe 'search' do
      let!(:aardvark) { create :merchant, name: 'Aardvark Waffles' }
      let!(:gorilla) { create :merchant, name: 'Gorilla Waffles' }
      let!(:elephant) { create :merchant, name: 'Elephant Waffles' }
      let!(:giraffe) { create :merchant, name: 'Giraffe Pancakes'}
      let!(:result) { Merchant.search("waffles") }

      it 'returns a collection of merchants matching a query' do
        expect(result).to include(aardvark, gorilla, elephant)
        expect(result).not_to include(giraffe)
      end

      it 'returns the collection ordered alpha by name' do
        expect(result).to eq([aardvark, elephant, gorilla])
      end
    end
  end
end
