class ErrorSerializer

  def self.no_merchant
    # { 
    #   message: "Could not complete query",
    #   error: [
    #     "Merchant could not be located"
    #   ]
    # }
    handle_error("Merchant could not be located")
  end

  def self.missing_parameter
    handle_error("Parameter cannot be missing")
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
