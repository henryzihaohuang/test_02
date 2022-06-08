task "aws:create_bucket_for_review_app" => :environment do
  client = Aws::S3::Client.new(region: ENV['AWS_S3_REGION'])

  client.create_bucket(bucket: ENV["HEROKU_APP_NAME"])
end