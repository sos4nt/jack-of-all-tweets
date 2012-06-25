class UsersController < ApplicationController
  before_filter :require_current_user
  rescue_from Twitter::Connection::InvalidRequest, with: :rate_limit_exceeded

  def index
    # returns up to 5,000 user IDs
    # TODO handle IDs > 5,000
      friends_ids = twitter_api.friends_ids(current_user)

      # for pagination helper
      @total_pages = (friends_ids.count/Settings.followers_per_page.to_f).ceil

      slice = friends_ids.to_a[(current_page - 1) * Settings.followers_per_page, Settings.followers_per_page]
      @users = twitter_api.users_lookup(slice)

      # sort friends by position in friend_id array
      @users.sort! {|x,y| slice.index(x.id) <=> slice.index(y.id) }
  end

  def search
    if query
      @users = twitter_api.users_search(query, current_page, Settings.search_results_per_page)
      @users.delete_if {|user| user.id == current_user.id }
    else
      flash.now[:warning] = t(:empty_search)
    end
  end

  def change_friendships
    follow_ids   = params[:follow_ids] || {}
    unfollow_ids = params[:unfollow_ids] || {}

    following = follow_ids.map { |user_id, _|
      twitter_api.friendships_create(user_id.to_i).screen_name.prepend("@")
    }

    unfollowed = unfollow_ids.map { |user_id, _|
      twitter_api.friendships_destroy(user_id.to_i).screen_name.prepend("@")
    }

    # TODO move markup to somewhere else
    msgs = []
    msgs << t(:unfollowed, user_names: unfollowed.to_sentence) if unfollowed.present?
    msgs << t(:following, user_names: following.to_sentence) if following.present?

    flash[:success] = msgs.join("<br>").html_safe if msgs.present?

    redirect_to :root
  end
  
  private
  
  def rate_limit_exceeded(exception)
    if twitter_api.connection.rate_limit_exceeded?
      flash.now[:error] = t(:rate_limit_exceeded).html_safe
      render
    else
      # re-raise exception if it was not raised due to rate limits
      raise e unless @rate_limit_exceeded
    end
  end

end
