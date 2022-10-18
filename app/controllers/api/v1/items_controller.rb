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
        item = merchant.items.create(item_params)
        new_item = ItemSerializer.new(item)
        if item.save
          render json: new_item.serializable_hash, status: 201
        end
      end

      def destroy
        item = Item.find(params[:id])
        item_to_delete = ItemSerializer.new(item)
        item.destroy
        render json: item_to_delete.serializable_hash
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

