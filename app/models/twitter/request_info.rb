module Twitter

  class RequestInfo < Base

    # @return [Integer] the overall hourly rate limit
    # @example
    #   request_info.rate_limit_limit # => 350
    attr_accessor :rate_limit_limit

    # @return [Integer] the overall remaining requests
    # @example
    #   request_info.rate_limit_remaining # => 342
    attr_accessor :rate_limit_remaining

    # @return [Time] the overall reset time
    # @example
    #   request_info.rate_limit_reset # => 2012-06-25 15:42:59 +0200
    attr_accessor :rate_limit_reset

    # @return [String] the overall rate limit scope
    # @example
    #   request_info.rate_limit_class # => "api_identified"
    attr_accessor :rate_limit_class

    # @return [Integer] the feature specific hourly rate limit
    # @example
    #   request_info.feature_rate_limit_limit # => 180
    attr_accessor :feature_rate_limit_limit

    # @return [Integer] the feature specific remaining requests
    # @example
    #   request_info.feature_rate_limit_remaining # => 176
    attr_accessor :feature_rate_limit_remaining

    # @return [Time] the feature specific reset time
    # @example
    #   request_info.feature_rate_limit_reset # => 2012-06-25 16:05:43 +0200,
    attr_accessor :feature_rate_limit_reset

    # @return [String] the feature specific rate limit scope
    # @example
    #   request_info.feature_rate_limit_class # => "usersearch"
    attr_accessor :feature_rate_limit_class

    # @return [Float] the request duration
    # @example
    #   request_info.runtime # => 0.21619
    attr_accessor :runtime

    # @return [RequestInfo] Returns a RequestInfo constructed from the response headers
    def self.from_response(response)
      request_info = RequestInfo.new.tap {|r|
        r.rate_limit_limit             = response['X-RateLimit-Limit'].to_i                 if response['X-RateLimit-Limit']
        r.rate_limit_remaining         = response['X-RateLimit-Remaining'].to_i             if response['X-RateLimit-Remaining']
        r.rate_limit_reset             = Time.at(response['X-RateLimit-Reset'].to_i)        if response['X-RateLimit-Reset']
        r.rate_limit_class             = response['X-RateLimit-Class'].to_s                 if response['X-RateLimit-Class']
        r.feature_rate_limit_limit     = response['X-FeatureRateLimit-Limit'].to_i          if response['X-RateLimit-Limit']
        r.feature_rate_limit_remaining = response['X-FeatureRateLimit-Remaining'].to_i      if response['X-RateLimit-Remaining']
        r.feature_rate_limit_reset     = Time.at(response['X-FeatureRateLimit-Reset'].to_i) if response['X-RateLimit-Reset']
        r.feature_rate_limit_class     = response['X-FeatureRateLimit-Class'].to_s          if response['X-RateLimit-Class']
        r.runtime                      = response['X-Runtime'].to_f                         if response['X-Runtime']
      }
    end

  end

end
