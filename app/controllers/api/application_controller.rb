class Api::ApplicationController < ApplicationController
  protect_from_forgery

  before_action :authenticate_user!

  def current_user
    @user ||= User.where(auth_token: request.headers['X-Auth-Token']).first
  end

  def authenticate_user!
    unless current_user
      head :unauthorized
    end
  end
end
