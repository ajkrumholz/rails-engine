module Api
  module V1
    module Items
      class FindController < ApplicationController
        def index
          if !params[:name].present?
            if !params[:max_price].present? && !params[:min_price].present?
            render json: ErrorSerializer.missing_parameter
            else
              if params[:max_price].present? && !params[:min_price]
                result = Item.where("unit_price <= ?", params[:max_price])
              elsif !params[:max_price].present? && params[:min_price].present?
                result = Item.where("unit_price >= ?", params[:min_price])
              else
                result = Item.where("unit_price between ? and ?", params[:min_price], params[:max_price])
              end
              render json: ItemSerializer.new(result)
            end
          elsif params[:max_price].present? || params[:min_price].present?
            #bad search error
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