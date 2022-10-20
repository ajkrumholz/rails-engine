class ErrorSerializer

  def self.no_merchant
    handle_error("Merchant could not be located")
  end

  def self.no_content
    { data: {},
      message: "Content could not be located",
      error: nil
    }
  end
  
  def self.missing_parameter
    handle_error("Parameter cannot be missing")
  end

  def self.no_match(name)
    handle_error("Could not locate resource with name like #{name}")
  end

  def self.negative_price
    { data: [],
      error: "Query price must be at least 0"
    }
  end

  def self.min_greater
    handle_error("Max price must be greater than min price")
  end

  def self.invalid_search
    handle_error("Cannot search name and price together")
  end
  
  private

  def self.handle_error(message)
    { data: { 
        message: "Could not complete query",
        error: [
          message
        ]
      }
    }
  end
end
