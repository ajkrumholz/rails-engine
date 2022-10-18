module Api
  module V1
    module Merchants
      class FindController < ApplicationController
        def index
          found_merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
          render json: MerchantSerializer.new(found_merchants)
        end

        def show
          found_merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name).first
          render json: MerchantSerializer.new(found_merchant)
        end
      end
    end
  end
end