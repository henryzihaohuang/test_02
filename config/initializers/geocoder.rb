Geocoder.configure({
  lookup: :google,
  api_key: ENV["GOOGLE_MAPS_GEOCODING_API_KEY"],
  cache: Redis.new(url: ENV['REDISCLOUD_URL'])
})