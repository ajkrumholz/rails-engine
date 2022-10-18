module Api
  module V1
    class ItemsController < ApplicationController
      def index
        if params[:merchant_id].present?
          merchant = Merchant.find(params[:merchant_id])
          items = ItemSerializer.new(merchant.items)
        else
          items = ItemSerializer.new(Item.all)
        end
        render json: items.serializable_hash
      end

      def show
        item = ItemSerializer.new(Item.find(params[:id]))
        render json: item.serializable_hash
      end
    end    
  end
end

