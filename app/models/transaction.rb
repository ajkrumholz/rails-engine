class Transaction < ApplicationRecord
  enum result: %i(failed success)
  
  belongs_to :invoice

  validates_presence_of :result
  validates_inclusion_of :result, in: 0..1
end
