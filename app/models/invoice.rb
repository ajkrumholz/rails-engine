class Invoice < ApplicationRecord
  enum status: %i(pending in_progess success)
  
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates_presence_of :status
  validates_inclusion_of :status, in: 0..2
end
