module Api
  module V1
    module Merchants
      class FindController < ApplicationController
        def index
          if !params[:name].present?
            render json: ErrorSerializer.missing_parameter
          else
            found_merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
            render json: MerchantSerializer.new(found_merchants)
          end
        end

        def show
          if !params[:name].present?
            render json: ErrorSerializer.missing_parameter
          else
            found_merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name).first
            if found_merchant.nil?
              render json: ErrorSerializer.no_match(params[:name])
            else
              render json: MerchantSerializer.new(found_merchant)
            end
          end
        end
      end
    end
  end
end