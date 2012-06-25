class AuthenticationController < ApplicationController

  # Hero when user is not signed in
  def sign_in_with_twitter
  end

  # Twitter login
  #
  # Stores a request token in the session and redirects the user to Twitter's login page
  def login
    @request_token = twitter_api.connection.consumer.get_request_token(oauth_callback: callback_url)
    session[:request_token] = @request_token
    redirect_to @request_token.authorize_url
  end

  # Callback for Twitter
  #
  # Gets the access token, stores returned OAuth data in the session and redirects the user
  # to the app's root
  def callback
    @request_token = session[:request_token]
    @access_token = @request_token.get_access_token

    session[:oauth_token] = @access_token.token
    session[:oauth_token_secret] = @access_token.secret

    current_user = twitter_api.account_verify_credentials
    
    session[:user_attributes] = {
      id: current_user.id,
      screen_name: current_user.screen_name,
      profile_image_url: current_user.profile_image_url,
      profile_image_url_https: current_user.profile_image_url_https
    }

    redirect_to :root
  end

end
