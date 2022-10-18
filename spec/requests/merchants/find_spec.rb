require 'rails_helper'

RSpec.describe 'get merchants/find' do
  let!(:shrimp) { create :merchant, name: "Red Shrimp" }
  let!(:duck) { create :merchant, name: "Blue Duck" }
  let!(:badger) { create :merchant, name: "Hardy Badger" }

  it 'returns a merchant by matching a fragment of their name' do
    get '/api/v1/merchants/find?name=Red'
    expect(response).to have_http_status(200)
    expect(json[:data][:attributes][:name]).to eq(shrimp.name)
  end
end