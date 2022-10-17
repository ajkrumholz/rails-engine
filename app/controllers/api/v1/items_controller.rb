module Api
  module V1
    class ItemsController < ApplicationController
      def index
        items = ItemSerializer.new(Item.all)
        render json: items.serializable_hash
      end
    end    
  end
end

