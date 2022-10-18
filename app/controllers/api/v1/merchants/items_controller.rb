module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          if Merchant.exists?(params[:merchant_id])
            merchant = Merchant.find(params[:merchant_id])
            items = merchant.items
            render json: ItemSerializer.new(items)
          else
            render json: ErrorSerializer.no_merchant, status: 404
          end
        end
      end
    end
  end
end