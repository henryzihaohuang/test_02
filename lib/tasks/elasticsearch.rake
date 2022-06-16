task 'import:model' => :environment do
  Company.find_in_batches do |batch|
    Elasticsearch.perform_later(batch.pluck(:id), Company)
  end
end