class Invoice < ApplicationRecord
  enum status: %i(pending in_progess success)
  
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  validates_presence_of :status

  def destroy_if_empty
    if items.empty?
      destroy
    end
  end
end
