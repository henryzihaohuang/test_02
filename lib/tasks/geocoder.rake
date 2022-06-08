task 'geocoder:geocode_candidates' => :environment do
  Candidate.where('id > ?', 250250849).find_in_batches do |batch|
    BatchGeocodeJob.perform_later(batch.pluck(:id), Candidate)
  end
end

task 'geocoder:geocode_companies' => :environment do
  Company.find_in_batches do |batch|
    BatchGeocodeJob.perform_later(batch.pluck(:id), Company)
  end
end