class ErrorSerializer

  def self.no_merchant
    { data: {},
      message: "Content could not be located",
      error: nil
    }
  end

  def self.no_item
    { data: [],
      message: "Content could not be located",
      error: nil
    }
  end
  
  def self.no_single_item
    { data: {},
      message: "Content could not be located",
      error: nil
    }
  end

  def self.missing_parameter
    handle_error("Parameter cannot be missing")
  end

  def self.min_greater
    { data: [],
      error: "Min_price cannot be greater than max_price"
    }
  end

  def self.negative_price
    { data: [],
      error: "Query price must be at least 0"
    }
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
