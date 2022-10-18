module Api
  module V1
    class ItemsController < ApplicationController
      def index
        items = ItemSerializer.new(Item.all)
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

      def update
        item = Item.find(params[:id])
        merchant_id = params[:item][:merchant_id]
        if merchant_id
          merchant = Merchant.find(merchant_id)
        else
          merchant = item.merchant
        end

        if !item || !merchant
          render json: {data: nil}, status: 404
        end

        item.update(item_params)
        if item.save
          serializer = ItemSerializer.new(item)
          render_json(serializer)
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def render_json(object)
        render json: object.serializable_hash
      end
    end    
  end
end

