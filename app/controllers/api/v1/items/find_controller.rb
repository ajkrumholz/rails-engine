module Api
  module V1
    module Items
      class FindController < ApplicationController
        before_action :set_vars
                
        def index
          validate_params
          if name_query
            result = Item.name_query(@name)
          elsif min_query
            result = Item.min_query(@min_price)
          elsif max_query
            result = Item.max_query(@max_price)
          elsif range_query
            result = Item.range_query(@min_price, @max_price)
          end
          render json: ItemSerializer.new(result)
        end

        private

        def set_vars
          @name = params[:name]
          @min_price = params[:min_price]
          @max_price = params[:max_price]
        end

        def validate_params
          name_and_price?
          negative_price?(@min_price)
          negative_price?(@max_price)
          min_greater
          missing_query
          blank_query
        end

        def name_and_price?
          if @name.present? && (@min_price.present? || @max_price.present?)
            render json: ErrorSerializer.invalid_search, status: 400
          end
        end

        def negative_price?(price)
          if price.present? && price < "0"
            render json: ErrorSerializer.negative_price, status: 400
          end
        end

        def min_greater
          if @min_price.present? && @max_price.present?
            if @min_price.to_i > @max_price.to_i
              render json: ErrorSerializer.min_greater, status: 400
            end
          end
        end

        def missing_query
          if !@name && !@min_price && !@max_price
            render json: ErrorSerializer.missing_parameter, status: 400
          end
        end

        def blank_query
          if @name.blank? || @min_price.blank? || @max_price.blank?
            render json: ErrorSerializer.missing_parameter, status: 400
          end
        end

        def name_query
          @name.present?
        end

        def min_query
          @min_price.present? && !@max_price.present?
        end

        def max_query
          @max_price.present? && !@min_price.present?
        end

        def range_query
          @min_price.present? && @max_price.present?
        end
      end
    end
  end
end

























        #   if params[:name].present?
        #     if params[:min_price].present? || params[:max_price].present?
        #       render json: ErrorSerializer.invalid_search, status: 400 and return
        #     else
        #       result = Item.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
        #     end
        #   elsif params[:min_price].present? && !params[:max_price].present?
        #     if params[:min_price] < "0"
        #       render json: ErrorSerializer.negative_price, status: 400 and return
        #     else
        #       result = Item.where("unit_price >= ?", params[:min_price])
        #     end
        #   elsif !params[:min_price].present? && params[:max_price].present?
        #     if params[:max_price] < "0"
        #       render json: ErrorSerializer.negative_price, status: 400 and return
        #     else
        #       result = Item.where("unit_price <= ?", params[:max_price])
        #     end
        #   elsif params[:min_price].present? && params[:max_price].present?
        #     require 'pry'; binding.pry
        #     if params[:min_price] < "0" || params[:max_price] < "0"
        #       render json: ErrorSerializer.negative_price, status: 400 and return
        #     elsif params[:min_price].to_i > params[:max_price].to_i
        #       render json: ErrorSerializer.min_greater, status: 400 and return
        #     else
        #       result = Item.where("unit_price between ? and ?", params[:min_price], params[:max_price])
        #     end
        #   else
        #     render json: ErrorSerializer.missing_parameter and return
        #   end
        #   if result.empty?
        #     render json: ErrorSerializer.no_item
        #   else
        #     render json: ItemSerializer.new(result)
        #   end
        # end

