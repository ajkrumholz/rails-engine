module Api
  module V1
    module Merchants
      class FindController < ApplicationController
        def show
          found_merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(name: :desc).first

          render json: MerchantSerializer.new(found_merchant)
        end
      end
    end
  end
end