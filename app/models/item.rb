class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, greater_than: 0

  def self.name_query(query)
    Item.where("name ILIKE ?", "%#{query}%").order(:name)
  end

  def self.min_query(min_price)
    Item.where("unit_price >= ?", min_price)
  end

  def self.max_query(max_price)
    Item.where("unit_price <= ?", max_price)
  end

  def self.range_query(min_price, max_price)
    Item.where("unit_price between ? and ?", min_price, max_price)
  end
end
