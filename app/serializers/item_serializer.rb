class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant

  belongs_to :merchant
end
