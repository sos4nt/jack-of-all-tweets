module Twitter

  module Connection
    include Logging

    class Error < StandardError ; end
    class UnknownMethod < Error ; end
    class Unauthorized < Error ; end
    class Forbidden < Error ; end
    class InvalidRequest < Error ; end
    class InvalidSeachFormat < Error ; end
    class SearchLimitReached < Error ; end
    class InternalServerError < Error ; end
    class TwitterDown < Error ; end
    class TwitterOverCapacity < Error ; end
    class Timeout < Error ; end

    # The Twitter API version
    API_VERSION = 1

    # The base URI for API calls
    BASE_URI = "https://api.twitter.com"

    # The format for API calls
    FORMAT = "json"

    # @return [RequestInfo] additional information on the last request
    attr_accessor :request_info

    # @return [Boolean] true if the last request exceeded the rate limit
    def rate_limit_exceeded?
      request_info && (
      (request_info.rate_limit_limit > 0 && request_info.rate_limit_remaining == 0) ||
      (request_info.feature_rate_limit_limit > 0 && request_info.feature_rate_limit_remaining == 0)
      )
    end

    # Creates one of the Connection's subclasses instance based on the
    # attributes.
    # @param [Hash] attributes the connection attributes
    # @return [Connection] the Connection instance
    def self.with_attributes(attributes={})
      if attributes.has_key?(:oauth_consumer_key)
        Connection::Identified.new(attributes)
      else
        raise "Connection attributes not supported"
      end
    end

    # Returns an absolute path for the given method name
    # @example
    #    connection.path("users/lookup") # => "/1/users/lookup.json"
    # @param [String] method_name the remote method name
    # @return [String] the API path
    def path(method_name)
      "/#{API_VERSION}/#{method_name}.#{FORMAT}"
    end

    # Constructs a URI from the given method name and parameters
    # @example
    #    uri = connection.uri("users/lookup", {user_name: "123, 456"})
    #    uri.request_uri # => "/1/users/lookup.json?user_name=123%2C+456"
    # @param [String] method_name the remote method name
    # @param [Hash] params additional method parameters
    # @return [URI] the contructed URI
    def uri(method_name, params={})
      u = URI.parse(BASE_URI)
      u.path = path(method_name)
      u.query = params.to_query unless params.empty?
      u
    end
    
    # Converts +:id+ in the given hash into either +:user_id+, +:screen_name+,
    # or a combination of the two
    # @param [Hash] params hash with key +:id+
    # @return [Hash] a new hash with key +screen_name+ and / or +user_id+
    def convert_ids!(params)
      user_ids = []
      screen_names = []
      ids = [params.delete(:ids)] || []
      ids.flatten.each {|id|
        if id.is_a? Integer
          user_ids << id
        elsif id.is_a? String
          screen_names << id
        elsif id.is_a? User
          if id.id
            user_ids << id.id
          elsif id.screen_name
            screen_names << id.screen_name
          end
        end
      }
      params[:user_id] = user_ids.join "," unless user_ids.empty?
      params[:screen_name] = screen_names.join "," unless screen_names.empty?
      params
    end

    # Returns a new hash converting +:id+ to either :user_id+, +screen_name+,
    # or a combination of the two
    # @param [Hash] params hash with key +:id+
    # @return [Hash] a new hash with key +screen_name+ and / or +user_id+
    def convert_ids(params)
      convert_ids!(params.clone)
    end

    # Makes a GET request
    #
    # The parameters are passed via the query string
    # @example
    #   connection.get("users/lookup", {user_name: "123, 345"})
    # @param [String] method_name the remote method to call
    # @param [Hash] params additional method parameters
    # @return [Hash] the remote method's response
    # @see #post
    def get(method_name, params={})
      log_request_start(:get, method_name, params)
      response = make_request(:get, method_name, params)
      if response
        log_request_end(:get, method_name, params, response)
        process_response(response)
      end
    end

    # Makes a POST request
    #
    # @example
    #   connection.post("users/lookup", {user_name: "123, 345"})
    # The parameters are passed via the request header
    # @param [String] method_name the remote method to call
    # @param [Hash] params additional method parameters
    # @return [Hash] the remote method's response
    # @see #get
    def post(method_name, params={})
      log_request_start(:post, method_name, params)
      response = make_request(:post, method_name, params)
      if response
        log_request_end(:post, method_name, params, response)
        process_response(response)
      end
    end

    protected

    def log_request_start(request_method, method_name, params)
      info bold("#{request_method.to_s.upcase} #{method_name} #{params.to_s}")
    end

    def log_request_end(request_method, method_name, params, response)
      info bold(magenta("#{request_method.to_s.upcase} #{method_name} (#{response['X-Runtime'].to_f.round(2)}ms) ")) << response.code
      error red(response.body) if response.code =~ /^[45]/
    end
    
    def process_response(response)
      @request_info = RequestInfo.from_response(response)
      attributes = JSON.parse(response.body, symbolize_names: true)
      error = case response.code.to_i
      when 400 then InvalidRequest
      when 401 then Unauthorized
      when 403 then Forbidden
      when 404 then UnknownMethod
      when 406 then InvalidSeachFormat
      when 420 then SearchLimitReached
      when 500 then InternalServerError
      when 502 then TwitterDown
      when 503 then TwitterOverCapacity
      when 504 then Timeout
      end
      if error
        if attributes.has_key? :error
          message = attributes[:error]
          message << " (#{attributes[:request]})" if attributes.has_key? :request
        elsif attributes.has_key? :errors
          message = attributes[:errors].map {|error| "#{error[:message]} [##{error[:code]}]"}.join "\n"
        else
          message = response.body
        end
        raise error.new(message)
      end
      attributes
    end

  end

end

