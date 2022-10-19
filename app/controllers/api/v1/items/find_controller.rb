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
                if params[:max_price].to_i < 0
                  render json: ErrorSerializer.negative_price and return
                else
                  result = Item.where("unit_price <= ?", params[:max_price])
                end
              elsif !params[:max_price].present? && params[:min_price].present?
                if params[:min_price].to_i < 0
                  render json: ErrorSerializer.negative_price and return
                else
                  result = Item.where("unit_price >= ?", params[:min_price])
                end
              else
                if params[:min_price].to_i < 0 || params[:max_price].to_i < 0
                  render json: ErrorSerializer.negative_price and return
                elsif params[:min_price].to_i > params[:max_price].to_i
                  render json: ErrorSerializer.min_greater and return
                else
                  result = Item.where("unit_price between ? and ?", params[:min_price], params[:max_price])
                end
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