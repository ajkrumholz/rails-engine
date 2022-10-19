module Api
  module V1
    module Items
      class FindController < ApplicationController
        def index
          if !params[:name].present?
            render json: ErrorSerializer.missing_parameter
          else
            result = Item.where("name || description ILIKE ?", "%#{params[:name]}%").order(:name)
            if result.empty?
              render json: ErrorSerializer.no_match(params[:name])
            else
              render json: ItemSerializer.new(result)
            end
          end
        end
      end
    end
  end
end