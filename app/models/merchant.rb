class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name

  def self.search(name)
    Merchant.where("name ILIKE ?", "%#{name}%").order(:name)
  end
end
