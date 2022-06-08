task 'transformer:attach_company' => :environment do
  Experience.find_in_batches do |batch|
    CompanyAttacherJob.perform_later(batch.pluck(:id))
  end
end