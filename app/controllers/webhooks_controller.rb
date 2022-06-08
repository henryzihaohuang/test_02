class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user

  def sync_user
    User.where(mogul_id: user_params[:mogul_id]).first_or_create(user_params).update(user_params)

    head :ok
  end

  def sync_companies
    data = ActiveSupport::JSON.decode(params[:data])

    data.each do |company|
      company_name = company[0]
      admin = company[1]
      if company[2]
        recruiter_emails = company[2...(company.size)]
      end

      user = User.where("lower(email) = ?", admin.downcase).first
      if user
        user.company_name = company_name
        user.company_id = user.id
        user.save
      end

      if recruiter_emails && recruiter_emails.any?
        recruiter_emails.each do |recruiter_email|
          recruiter = User.where("lower(email) = ?", recruiter_email.downcase).first

          if recruiter
            recruiter.company_id = user.id

            recruiter.save
          end
        end
      end
    end

    head :ok
  end

  private

  def user_params
    params.require(:user).permit(:mogul_id,
                                 :email,
                                 :password_digest)
  end
end
