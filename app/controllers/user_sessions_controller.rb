require 'json'
require 'net/http'
require 'uri'

class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        redirect_to root_path, notice: "Welcome, #{current_user.name}. You're logged in!"
      else
        render action: :new
      end
    end
  end

  def twitch_login
    redirect_to 'https://api.twitch.tv/kraken/oauth2/authorize?response_type=code&client_id=c6ik95x2hgxhjjmkbhwrszgcpj66ueh&redirect_uri=http://splitsdb.com/login/twitch/auth&scope=user_read'
  end

  def twitch_auth
    post = {
      client_id:     'c6ik95x2hgxhjjmkbhwrszgcpj66ueh',
      client_secret: 'kdmnhh8q72tkm6ypa03hl1wug13pi0m',
      grant_type:    'authorization_code',
      redirect_uri:  'http://splitsdb.com/login/twitch/auth',
      code:          params['code']
    }
    uri = URI.parse "https://api.twitch.tv/kraken/oauth2/token"
    token_resp = Net::HTTP.post_form(uri, post)
    token_resp = JSON.parse token_resp.body
    token      = token_resp['access_token']

    # See if this user has logged in with Twitch before
    user       = User.find_by oauth_token: token

    user_resp  = HTTParty.get 'https://api.twitch.tv/kraken/user?oauth_token=' + token
    user_resp  = JSON.parse user_resp.body
    user       = User.find_by email: user_resp['email']

    if user.blank? # They don't, so make them an account
      user = User.new
      user.name = user_resp['name']
      user.email = user_resp['email']
      user.oauth_token = token
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      user.password = (0...50).map{ o[rand(o.length)] }.join
      if user.save
        current_session = UserSession.create(user, remember_me: true)
        redirect_to root_path, notice: 'Logged in!'
      else
        redirect_to login_path, alert: 'A problem occurred trying to log you in via Twitch. The error reported was ' + user.error + '.'
      end
    else
      user.oauth_token = token
      if user.save
        current_session = UserSession.create(user, remember_me: true)
        redirect_to root_path, notice: "Welcome back, #{user.name}!"
      else
        redirect_to root_path, alert: "We authenticated you via Twitch, but we ran into an account linking issue on our end. We'll try again next time."
      end
    end
  end

  def twitch_new_user
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path, notice: "Successfully logged out."
  end
end
