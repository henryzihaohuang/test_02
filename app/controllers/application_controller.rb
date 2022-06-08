class ApplicationController < ActionController::Base
  before_action :authenticate_user

  helper_method :current_user

  def signed_in?
    current_user.present?
  end

  def current_user
    if cookies.signed[:user_id]
      @current_user ||= User.where(id: cookies.signed[:user_id]).first
    end

    @current_user
  end

  def authenticate_user
    unless current_user
      redirect_to sign_in_url
    end
  end
end
