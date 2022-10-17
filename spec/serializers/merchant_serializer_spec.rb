require 'rails_helper'

RSpec.describe MerchantSerializer do
  let!(:merchant) { create :merchant }
  let!(:serializer) { MerchantSerializer.new(merchant)}
  # let!(:serialization) { serializer.serializable_hash }
  let!(:subject) { JSON.parse(serializer.to_json, symbolize_names: true) }

  it 'returns information about a merchant' do
    expect(subject).to be_a Hash
    expect(subject[:data][:attributes][:name]).to eq(merchant.name)
    expect(subject[:data][:type]).to eq("merchant")
  end
end