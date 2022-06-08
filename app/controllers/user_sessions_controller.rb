class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user, except: :destroy

  def new
  end

  def create
    user_session = UserSession.new(user_session_params)

    if user_session.valid?
      cookies.permanent.signed[:user_id] = user_session.user.id

      if current_user.is_company?
        redirect_to dashboard_company_url
      else
        redirect_to root_url
      end
    else
      render :new
    end
  end

  def destroy
    cookies.delete :user_id

    redirect_to root_url
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email,
                                         :password)
  end
end
