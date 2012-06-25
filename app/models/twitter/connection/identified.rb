module Twitter
  
  module Connection

    class Identified < Base

      include Connection

      # @return [String] the app's OAuth consumer key
      attr_accessor :oauth_consumer_key

      # @return [String] the app's OAuth consumer secret
      attr_accessor :oauth_consumer_secret

      # @return [String] the current user's OAuth token
      attr_accessor :oauth_token

      # @return [String] the current user's OAuth token secret
      attr_accessor :oauth_token_secret

      # Returns the OAuth consumer
      def consumer
        @consumer ||= ::OAuth::Consumer.new(
          @oauth_consumer_key,
          @oauth_consumer_secret,
          site: BASE_URI,
          authorize_path: '/oauth/authenticate'
        ) if @oauth_consumer_key && @oauth_consumer_secret
      end

      # Returns the OAuth access token
      def access_token
        @access_token ||= ::OAuth::AccessToken.new(
          consumer,
          @oauth_token,
          @oauth_token_secret
        ) if @oauth_token && @oauth_token_secret
      end

      protected

      def make_request(request_method, method_name, params={})
        case request_method
        when :get
          uri = uri(method_name, convert_ids(params))
          access_token.get(uri.request_uri)
        when :post
          uri = uri(method_name)
          access_token.post(uri.request_uri, convert_ids(params))
        end
      end

    end

  end

end

