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
        render_json(items)
      end

      def show
        item = ItemSerializer.new(Item.find(params[:id]))
        render_json(item)
      end

      def create
        merchant = Merchant.find(params[:item][:merchant_id])
        item = ItemSerializer.new(merchant.items.create(item_params))
        render_json(item)
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price)
      end

      def render_json(object)
        render json: object.serializable_hash
      end
    end    
  end
end

