require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:result).in?(0..1) }
  end
end
