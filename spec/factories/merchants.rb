FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
  end

  def merchant_with_items(item_count = 10)
    FactoryBot.create(:merchant) do |merchant|
      FactoryBot.create_list(:item, item_count, merchant: merchant)
    end
  end
end