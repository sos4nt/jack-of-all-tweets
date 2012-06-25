module Twitter

  # A Twitter user object.
  #
  # Documentation was extracted from https://dev.twitter.com/docs/platform-objects/users
  class User < Base
    # @return [Boolean] Indicates that the user has an account with "contributor mode"
    #   enabled, allowing for Tweets issued by the user to be co-authored by another
    #   account. Rarely +true+.
    attr_accessor :contributors_enabled

    # @example
    #   "Mon Nov 29 21:18:15 +0000 2010"
    # @return [String] The UTC datetime that the user account was created on Twitter.
    attr_accessor :created_at

    # @return [Boolean] When +true+, indicates that the user has not altered the theme
    #   or background of their user profile.
    attr_accessor :default_profile

    # @return [Boolean] When +true+, indicates that the user has not uploaded their own
    #   avatar and a default egg avatar is used instead.
    attr_accessor :default_profile_image

    # @example
    #   "The Real Twitter API."
    # @return [String,nil]  The user-defined UTF-8 string describing their account. 
    attr_accessor :description

    # @return [Integer] The number of tweets this user has favorited in the account's
    #    lifetime. British spelling used in the field name for historical reasons. 
    attr_accessor :favourites_count

    # @return [Boolean] When +true+, indicates that the authenticating user has issued
    #   a follow request to this protected user account.
    attr_accessor :follow_request_sent

    # @deprecated
    attr_accessor :following

    # @return [Integer] The number of followers this account currently has. Under certain
    #  conditions of duress, this field will temporarily indicate +0+.
    attr_accessor :followers_count

    # @return [Integer] The number of users this account is following (AKA their
    #  "followings"). Under certain conditions of duress, this field will temporarily
    #  indicate +0+.
    attr_accessor :friends_count

    # @return [Boolean] When +true+, indicates that the user has enabled the possibility
    #   of geotagging their Tweets. 
    attr_accessor :geo_enabled

    # @return [Integer] The unique identifier for this {User}.
    attr_accessor :id

    # @return [Boolean] When +true+, indicates that the user is a participant in Twitter's
    #   {http://translate.twttr.com/ translator community}.
    attr_accessor :is_translator

    # @example
    #   "en"
    # @return [String] The ISO 639-1 two-letter character code for the user's self-declared
    #  user interface language. May or may not have anything to do with the content of
    #  their Tweets.
    attr_accessor :lang

    # @return [Integer] The number of public lists that this user is a member of.
    attr_accessor :listed_count

    # @example
    #   "San Francisco, CA"
    # @return [String,nil] The user-defined location for this account's profile. Not
    #   necessarily a location nor parseable. This field will occasionally be fuzzily
    #   interpreted by the Search service.
    attr_accessor :location

    # @example
    #   "Twitter API"
    # @return [String] The name of the user, as they've defined it. Not necessarily
    #   a person's name. Typically capped at 20 characters, but subject to change.
    attr_accessor :name

    # @deprecated
    attr_accessor :notifications

    # @example
    #   "e8f2f7"
    # @return [String] The hexadecimal color chosen by the user for their background.
    attr_accessor :profile_background_color

    # @example
    #   "http://a2.twimg.com/profile_background_images/229557229/twitterapi-bg.png"
    # @return [String] A HTTP-based URL pointing to the background image the user has
    #   uploaded for their profile.
    attr_accessor :profile_background_image_url

    # @example
    #   "https://si0.twimg.com/profile_background_images/229557229/twitterapi-bg.png"
    # @return [String] A HTTPS-based URL pointing to the background image the user
    #   has uploaded for their profile.
    attr_accessor :profile_background_image_url_https

    # @return [Boolean] When true, indicates that the user's {#profile_background_image_url}
    #   should be tiled when displayed.
    attr_accessor :profile_background_tile

    # @example
    #   "http://a2.twimg.com/profile_images/1438634086/avatar_normal.png"
    # @return [String] A HTTP-based URL pointing to the user's avatar image.
    attr_accessor :profile_image_url

    # @example
    #   "https://s01.twimg.com/profile_images/1438634086/avatar_normal.png"
    # @return [String] A HTTPS-based URL pointing to the user's avatar image.
    attr_accessor :profile_image_url_https

    # @example
    #   "0094C2"
    # @return [String] The hexadecimal color the user has chosen to display links with
    #   in their Twitter UI.
    attr_accessor :profile_link_color

    # @example
    #   "0094C2"
    # @return [String] The hexadecimal color the user has chosen to display sidebar
    #   borders with in their Twitter UI.
    attr_accessor :profile_sidebar_border_color

    # @example
    #   "a9d9f1"
    # @return [String] The hexadecimal color the user has chosen to display sidebar
    #   backgrounds with in their Twitter UI.
    attr_accessor :profile_sidebar_fill_color

    # @example
    #   "437792"
    # @return [String] The hexadecimal color the user has chosen to display text with
    #   in their Twitter UI.
    attr_accessor :profile_text_color

    # @return [Boolean] When true, indicates the user wants their uploaded background
    #   image to be used.
    attr_accessor :profile_use_background_image

    # @return [Boolean] When true, indicates that this user has chosen to protect their
    #   Tweets. 
    attr_accessor :protected

    # @example
    #   "twitterapi"
    # @return [String] The screen name, handle, or alias that this user identifies
    #   themselves with. screen_names are unique but subject to change. Use {#id} as
    #   a user identifier whenever possible. Typically a maximum of 15 characters long,
    #   but some historical accounts may exist with longer names.
    attr_accessor :screen_name

    # @return [Boolean] Indicates that the user would like to see media inline.
    #   Somewhat disused.
    attr_accessor :show_all_inline_media

    # @example
    #   {
    #     "coordinates": nil,
    #     "favorited": false,
    #     "truncated": false,
    #     "created_at": "Tue Apr 17 16:38:18 +0000 2012",
    #     "id_str": "192290904646754304",
    #     "entities": {
    #       "urls": [],
    #       "hashtags": [],
    #       "user_mentions": [
    #         {
    #           "name": "Micah McVicker",
    #           "id_str": "166661446",
    #           "id": 166661446,
    #           "indices": [
    #             0,
    #             14
    #           ],
    #           "screen_name": "MicahMcVicker"
    #         }
    #       ]
    #     },
    #     "in_reply_to_user_id_str": "166661446",
    #     "contributors": nil,
    #     "text": "@MicahMcVicker make sure you're using include_rts=true and no other filters, then walking your timeline by since_id and max_id",
    #     "retweet_count": 0,
    #     "in_reply_to_status_id_str": "192290470427246594",
    #     "id": 192290904646754304,
    #     "geo": nil,
    #     "retweeted": false,
    #     "in_reply_to_user_id": 166661446,
    #     "place": nil,
    #     "in_reply_to_screen_name": "MicahMcVicker",
    #     "source": "<a href=\"http://sites.google.com/site/yorufukurou/\" rel=\"nofollow\">YoruFukurou</a>",
    #     "in_reply_to_status_id": 192290470427246594
    #   }
    # @return [Hash,nil] If possible, the user's most recent tweet or retweet. In
    #   some circumstances, this data cannot be provided and this field will be
    #   omitted, +nil+, or empty. Perspectival attributes within tweets embedded within
    #   users cannot always be relied upon. 
    attr_accessor :status

    # @return [Integer] The number of tweets (including retweets) issued by the
    #   user.
    attr_accessor :statuses_count

    # @example
    #   "Pacific Time (US & Canada)"
    # @return [String,nil] A string describing the Time Zone this user declares
    #   themselves within.
    attr_accessor :time_zone

    # @example
    #   "http://dev.twitter.com"
    # @return [String,nil] A URL provided by the user in association with their
    #   profile.
    attr_accessor :url

    # @example
    #   -18000
    # @return [Integer,nil] A URL provided by the user in association with their
    #   profile.
    attr_accessor :utc_offset

    # @return [Boolean] When +true+, indicates that the user has a verified account.
    attr_accessor :verified

    # @example
    #   "GR, HK, MY"
    # @return [String] When present, indicates a textual representation of the
    #   two-letter country codes this user is withheld from.
    attr_accessor :withheld_in_countries

    # @example
    #   "user"
    # @return [String] When present, indicates whether the content being withheld
    #   is the "status" or a "user.
    attr_accessor :withheld_scope

  end

end
