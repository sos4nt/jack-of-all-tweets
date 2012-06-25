module Twitter

  class Base

    def initialize(attributes = {})
      attributes.each { |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      }
    end

  end

end
