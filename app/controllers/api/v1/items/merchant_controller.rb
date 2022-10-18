module Api
  module V1
    module Items
      class MerchantController < ApplicationController
        def index
          item = Item.find(params[:item_id])
          merchant_id = item.merchant.id
          merchant = MerchantSerializer.new(Merchant.find(merchant_id))
          render json: merchant.serializable_hash
        end
      end
    end
  end
end


