# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :twitter_api, :current_user, :request_info, :query
  helper_method :total_pages, :current_page, :next_page, :previous_page
  rescue_from Twitter::Connection::Unauthorized, OAuth::Unauthorized, with: :destroy_session

  # Returns a {Twitter::API} instance
  #
  # If no instance exists, a new one is inititalized from the session data
  # @return [Twitter::API] the Twitter API instance
  def twitter_api
    @twitter_api ||= Twitter::API.new(
      oauth_consumer_key: Settings.oauth.consumer_key,
      oauth_consumer_secret: Settings.oauth.consumer_secret,
      oauth_token: session[:oauth_token],
      oauth_token_secret: session[:oauth_token_secret]
    )
  end

  # @return [String, nil] the global query if any
  def query
    @query ||= params[:q]
  end
  
  # Twitter logout
  def destroy_session
    reset_session
    flash[:notice] = t(:signed_out)
    redirect_to sign_in_with_twitter_path
  end
  
  
  def require_current_user
    redirect_to sign_in_with_twitter_path unless current_user
  end

  # Returns the current {Twitter::User}
  #
  # If no instance exists, a new one is inititalized from the session data
  # @return [Twitter::User] the current user
  def current_user
    @current_user ||= Twitter::User.new(session[:user_attributes]) if session[:user_attributes]
  end

  # Returns the {Twitter::RequestInfo}
  #
  # If +@request_info+ is not explicitly set in the controller this returns
  # the RequestInfo of the last request
  def request_info
    @request_info ||= twitter_api.connection.request_info
  end

  # Returns the total number of pages
  #
  # The number of pages has to be set from the controller
  # @example
  #   class ItemsController < ApplicationController
  #     def index
  #       @items = (1..100).to_a # 100 items
  #       @total_pages = (@items.count/20.0).ceil # 20 per page
  #     end
  #   end
  # @return [Integer,nil] the total number of pages
  def total_pages
    @total_pages
  end

  # Returns the current page number
  #
  # The page number is extracted from the params hash and is clipped to
  # 1 ≤ current_page ≤ +@total_pages+
  # @return [Integer] the current page number
  def current_page
    page = params[:page].try(&:to_i) || 1
    page = 1 if page < 1
    page = @total_pages if @total_pages && page > @total_pages
    page
  end

  # Returns next page number of +nil+ if current page is the last page
  # @return [Integer, nil] the next page number
  def next_page
    @total_pages && current_page == @total_pages ? nil : current_page + 1
  end

  # Returns previous page number of +nil+ if current page is the first page
  # @return [Integer, nil] the previous page number
  def previous_page
    current_page == 1 ? nil : current_page - 1
  end

end
