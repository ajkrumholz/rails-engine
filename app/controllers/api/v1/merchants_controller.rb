module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        @merchants = Merchant.all
        json_response(@merchants)
      end
    end
  end
end
