class CompaniesController < ApplicationController
  def dashboard
    @recruiter_id = params[:recruiter_id].present? ? params[:recruiter_id] : nil
    @date_range_filter = params[:date_range].present? ? params[:date_range] : "this_week"

    case @date_range_filter
    when "past_week"
      date_range = 1.week.ago..Date.today.end_of_day
    when "past_month"
      date_range = 1.month.ago..Date.today.end_of_day
    when "year_to_date"
      date_range = Date.today.beginning_of_year..Date.today.end_of_day
    when "custom"
      if params[:custom_date_range].present?
        custom_date_range_start, custom_date_range_end = params[:custom_date_range].split(" - ").collect {|date_string| Date.strptime(date_string, "%m/%d/%Y") }
      else
        custom_date_range_start = Date.today
        custom_date_range_end = Date.tomorrow
      end

      @custom_date_range_start_string = custom_date_range_start ? custom_date_range_start.strftime("%m/%d/%Y") : Date.today.strftime("%m/%d/%Y")
      @custom_date_range_end_string = custom_date_range_end ? custom_date_range_end.strftime("%m/%d/%Y") : Date.tomorrow.strftime("%m/%d/%Y")

      date_range = custom_date_range_start..custom_date_range_end
    else
      date_range = 1.week.ago..Date.today.end_of_day
    end

    @number_of_recruiters = current_user.number_of_recruiters
    @candidates_sourced = current_user.candidates_sourced(date_range, @recruiter_id)
    @candidates_saved = current_user.candidates_saved(date_range, @recruiter_id)
    @searches_performed = current_user.searches_performed(date_range, @recruiter_id)
    @pipelines_saved = current_user.pipelines_saved(date_range, @recruiter_id)
    @time_spent = ActiveSupport::Duration.build(current_user.time_spent(date_range, @recruiter_id))
  end
end
