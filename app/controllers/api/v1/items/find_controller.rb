module Api
  module V1
    module Items
      class FindController < ApplicationController
        before_action :set_vars
                
        def index
          if params_valid?
            result = search
            if result.empty?
              render json: ErrorSerializer.no_item
            else
              render json: ItemSerializer.new(result), status: 200
            end
          end
        end

        def show
          if params_valid?
            result = search
            if result.empty?
              render json: ErrorSerializer.no_item
            else
              render json: ItemSerializer.new(result.first), status: 200
            end
          end
        end

        private
        def search
          if name_query?
            result = Item.name_query(@name)
          elsif min_query?
            result = Item.min_query(@min_price)
          elsif max_query?
            result = Item.max_query(@max_price)
          elsif range_query?
            result = Item.range_query(@min_price, @max_price)
          end
        end
        
        def set_vars
          @name = params[:name]
          @min_price = params[:min_price]
          @max_price = params[:max_price]
        end

        def params_valid?
          if name_and_price?
            render json: ErrorSerializer.invalid_search, status: 400
            return false
          elsif negative_price?(@max_price) || negative_price?(@min_price)
            render json: ErrorSerializer.negative_price, status: 400
            return false
          elsif missing_query? || blank_query?
            render json: ErrorSerializer.missing_parameter, status: 400
            return false
          else
            return true
          end
        end

        def name_and_price?
          @name.present? && (@min_price.present? || @max_price.present?)
        end

        def negative_price?(price)
          price.present? && price.to_i < 0
        end
        
        # def min_greater
        #   if @min_price.present? && @max_price.present?
        #     @min_price.to_i > @max_price.to_i
        #   end
        # end
        
        def missing_query?
          @name.nil? && @min_price.nil? && @max_price.nil?
        end
        
        def blank_query?
          @name == "" || @min_price == "" || @max_price == ""
        end

        def name_query?
          @name.present?
        end

        def min_query?
          @min_price.present? && !@max_price.present?
        end

        def max_query?
          @max_price.present? && !@min_price.present?
        end

        def range_query?
          @min_price.present? && @max_price.present?
        end
      end
    end
  end
end
