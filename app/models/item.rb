class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, greater_than: 0
  # validates_format_of :unit_price, :with => /\d{1,6}(\.\d{0,2})/
end
