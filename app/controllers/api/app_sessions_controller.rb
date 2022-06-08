class Api::AppSessionsController < Api::ApplicationController
  def create
    current_user.app_sessions.create(app_session_params.merge(start_time: Time.current))

    head :ok
  end

  private

  def app_session_params
    params.require(:app_session).permit(:duration)
  end
end
