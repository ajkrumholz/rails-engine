module Api
  module V1
    module Merchants
      class FindController < ApplicationController
        before_action :set_vars

        def index
          if valid_params?
            result = merchant_search
            if result.nil?
              render json: ErrorSerializer.no_merchant
            else
              render json: MerchantSerializer.new(result)
            end
          end
        end

        def show
          if valid_params?
            result = merchant_search.first
            if result.nil?
              render json: ErrorSerializer.no_merchant
            else
            render json: MerchantSerializer.new(result)
            end
          end
        end

        private

        def merchant_search
          Merchant.search(@name)
        end

        def valid_params?
          if @name.nil? || @name == ""
            render json: ErrorSerializer.missing_parameter, status: 400
            return false
          else
            true
          end
        end

        def set_vars
          @name = params[:name]
        end
      end
    end
  end
end