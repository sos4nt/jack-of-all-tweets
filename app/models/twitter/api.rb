module Twitter

  class API < Base

    # @return [Connection] the app's OAuth consumer key
    attr_accessor :connection

    def self.logger
      @@logger ||= Logger.new(Rails.root.join "log", "twitter-#{Rails.env}.log").tap {|logger|
        logger.formatter = Logger::Formatter.new
        logger.datetime_format = "%Y-%m-%d %H:%M:%S "
      }
    end

    # Initializes a new API
    #
    # The attributes are passed to the {Connection}
    def initialize(attributes = {})
      @connection = Connection.with_attributes(attributes)
    end

    # Returns the current user if authentication was successful
    # 
    # Use this method to test if supplied user credentials are valid.
    # @return [User] the current user object
    def account_verify_credentials
      attributes = connection.get("account/verify_credentials")
      User.new(attributes)
    end

    # Allows the authenticating users to unfollow the user specified in the ID parameter.
    #
    # @param [Integer] id either user ID, screen name or {User}
    def friendships_destroy(id)
      attributes = connection.post("friendships/destroy", {ids: id})
      User.new(attributes)
    end

    # Allows the authenticating users to follow the user specified in the ID parameter.
    #
    # @param [Integer] id either user ID, screen name or {User}
    def friendships_create(id)
      attributes = connection.post("friendships/create", {ids: id})
      User.new(attributes)
    end

    # Returns friend IDs for the given user ID or screen name
    # @param id user ID or screen name
    # @param cursor cursor for paging
    # @return [PagedUserIDs] the friend IDs
    def friends_ids(id, cursor=-1)
      attributes = connection.get("friends/ids", {ids: id, cursor: cursor})
      Cursor.new(attributes)
    end

    # Returns up to 100 users worth of extended information, specified by either ID,
    # screen name, or combination of the two.
    #
    # @param [Array] ids user IDs or screen names
    # @return [Array<User>] an array of users
    def users_lookup(ids, include_entities = false)
      attributes_array = connection.post("users/lookup", {ids: ids, include_entities: include_entities})
      attributes_array.map { |attributes|
        User.new(attributes)
      }
    end

    # Runs a search for users similar to Find People button on Twitter.com.
    # The results returned by people search on Twitter.com are the same as those returned by this API request.
    #
    # @param [String] q the search query to run against people search
    # @param [Integer] page specifies the page of results to retrieve
    # @param [Integer] per_page the number of people to retrieve. Maxiumum of 20 allowed per page
    # @return [Array<User>] an array of users
    def users_search(q='', page = nil, per_page = nil, include_entities = false)
      options = { q: q, include_entities: include_entities }
      options[:page] = page if page
      options[:per_page] = per_page if per_page
      attributes_array = connection.get("users/search", options)
      attributes_array.map {|attributes|
        User.new(attributes)
      }
    end

  end

end
