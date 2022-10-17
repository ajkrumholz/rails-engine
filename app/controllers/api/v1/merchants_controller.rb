module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        merchants = MerchantSerializer.new(Merchant.all)
        render json: merchants.serializable_hash
      end

      def show
        merchant = MerchantSerializer.new(Merchant.find(params[:id]))
        render json: merchant.serializable_hash
      end
    end
  end
end
