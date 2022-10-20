module Api
  module V1
    class ItemsController < ApplicationController
      before_action :set_item, only: %i(show destroy update)
      before_action :set_merchant, only: %i(create)

      def index
        render_json(ItemSerializer.new(Item.all))
      end

      def show
        render_json(ItemSerializer.new(@item))
      end

      def create
        item = @merchant.items.create(item_params)
        new_item = ItemSerializer.new(item)
        if item.save
          render json: new_item, status: 201
        end
      end

      def destroy
        item_to_delete = ItemSerializer.new(@item)
        invoices = @item.invoices
        if @item.destroy
          invoices.each { |invoice| invoice.destroy_if_empty }
        end
          render json: item_to_delete
      end

      def update
        valid_merchant
        @item.update(item_params)
        if @item.save
          render_json(ItemSerializer.new(@item))
        end
      end

      private
      def set_item
        @item = Item.find(params[:id])
      end

      def set_merchant
        @merchant = Merchant.find(params[:item][:merchant_id])
      end

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def valid_merchant
        if params[:item][:merchant_id].present?
          set_merchant
        end
      end

      def render_json(object)
        render json: object.serializable_hash
      end
    end    
  end
end

