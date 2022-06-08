class PipelinesExportJob < ApplicationJob
  queue_as :default

  def perform
    filename = 'pipelines.zip'

    File.open(filename, "w") do |zip_file|
      Zip::OutputStream.open(zip_file) { |zos| }

      Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
        Pipeline.includes(candidates: [:experiences, :educations]).find_each do |pipeline|
          csv = ""

          csv << CSV.generate_line(['First name', 'Last name', 'Title', 'Company name', 'Location', 'Email', 'LinkedIn URL', 'Mogul Recruiter URL', 'Assessment', 'Status'])

          pipeline.saved_candidates.each do |saved_candidate|
            csv << CSV.generate_line([saved_candidate.candidate.first_name, saved_candidate.candidate.last_name, saved_candidate.candidate.current_title, saved_candidate.candidate.current_company_name, saved_candidate.candidate.location, saved_candidate.candidate[:email], saved_candidate.candidate.linked_in_url, Rails.application.routes.url_helpers.candidate_url(saved_candidate.candidate), saved_candidate.assessment, saved_candidate.status])
          end

          csv_file = File.open("#{pipeline.created_at.strftime("%m-%d-%Y")}-#{pipeline.user.email}-#{pipeline.name.gsub(/[\s\/\\-]/, "")}-#{SecureRandom.hex(6)}.csv", "w")
          csv_file.write(csv)
          csv_file.close

          zip.add("#{pipeline.created_at.strftime("%m-%d-%Y")}-#{pipeline.user.email}-#{pipeline.name.gsub(/[\s\/\\-]/, "")}-#{SecureRandom.hex(6)}.csv", csv_file.path)
        end
      end

      AdminMailer.pipelines_export(zip_file.path).deliver
    end
  end
end
