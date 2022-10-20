require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'instance methods' do
    describe 'destroy_if_empty' do
      let!(:merchant) { create :merchant }
      let!(:customer) { create :customer }
      let!(:item_1) { create :item, merchant: merchant }
      let!(:item_2) { create :item, merchant: merchant }

      let!(:invoice_1) { create :invoice, customer: customer, merchant: merchant, status: 0 }
      let!(:invoice_item_1) { create :invoice_item, item: item_1, invoice: invoice_1 }
      
      let!(:invoice_2) { create :invoice, customer: customer, merchant: merchant, status: 0 }
      let!(:invoice_item_2) { create :invoice_item, item: item_1, invoice: invoice_2 }
      let!(:invoice_item_3) { create :invoice_item, item: item_2, invoice: invoice_2 }

      it 'destroys invoice if empty' do
        item_1.destroy
        invoice_1.destroy_if_empty

        expect { item_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect { invoice_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect { invoice_item_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect { invoice_item_2.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect { invoice_2.reload }.not_to raise_error
        expect { invoice_item_2.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
