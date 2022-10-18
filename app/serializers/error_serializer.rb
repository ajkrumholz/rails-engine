class ErrorSerializer

  def self.no_merchant
    { 
      message: "Could not complete query",
      error: [
        "Merchant could not be located"
      ]
    }
  end
end
