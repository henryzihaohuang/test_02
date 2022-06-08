require 'zip'

class PipelinesController < ApplicationController
  def index
    @pipelines = current_user.pipelines.reverse_chronological
  end

  def show
    @pipeline = current_user.pipelines.find(params[:id])
    @saved_candidates = @pipeline.saved_candidates.page(params[:page])
  end

  def destroy
    pipeline = current_user.pipelines.find(params[:id])

    pipeline.destroy

    redirect_to pipelines_url
  end

  def download
    pipeline = current_user.pipelines.includes(candidates: [:experiences, :educations]).find(params[:id])

    headers["X-Accel-Buffering"] = "no"
    headers["Cache-Control"] = "no-cache"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] = %(attachment; filename="#{pipeline.name}.csv")
    headers["Last-Modified"] = Time.zone.now.ctime.to_s

    self.response_body = Enumerator.new do |y|
      y << CSV.generate_line(['First name', 'Last name', 'Title', 'Company name', 'Location', 'Email', 'LinkedIn URL', 'Mogul Recruiter URL', 'Assessment', 'Status'])

      pipeline.saved_candidates.each do |saved_candidate|
        y << CSV.generate_line([saved_candidate.candidate.first_name, saved_candidate.candidate.last_name, saved_candidate.candidate.current_title, saved_candidate.candidate.current_company_name, saved_candidate.candidate.location, saved_candidate.candidate.get_email, saved_candidate.candidate.linked_in_url, candidate_url(saved_candidate.candidate), saved_candidate.assessment, saved_candidate.status])
      end
    end
  end
end
