module Api
  module V1
    class ItemsController < ApplicationController
      def index
        items = ItemSerializer.new(Item.all)
        render json: items.serializable_hash
      end

      def show
        item = ItemSerializer.new(Item.find(params[:id]))
        render json: item.serializable_hash
      end
    end    
  end
end

