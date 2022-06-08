task 'importer:import_user_data' => :environment do
  s3 = Aws::S3::Resource.new(region: ENV['AWS_S3_REGION'])
  bucket = s3.bucket(ENV['AWS_S3_CORESIGNAL_BUCKET'])

  bucket.objects(prefix: 'member/202109/').each do |object|
    if object.key.include?('.gz')
      ImportCoresignalUserFileJob.perform_later(object.key)
    end
  end
end

task 'importer:import_company_data' => :environment do
  s3 = Aws::S3::Resource.new(region: ENV['AWS_S3_REGION'])
  bucket = s3.bucket(ENV['AWS_S3_CORESIGNAL_BUCKET'])

  bucket.objects(prefix: 'company/202109/').each do |object|
    if object.key.include?('.gz')
      ImportCoresignalCompanyFileJob.perform_later(object.key)
    end
  end
end