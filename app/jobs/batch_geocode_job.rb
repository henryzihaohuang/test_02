class BatchGeocodeJob < ApplicationJob
  queue_as :default

  def perform(ids, klass)
    all_models = []

    klass.where(id: ids).each do |model|
      begin
        result = Geocoder.search(model.location.gsub('Greater ', '').gsub(' Area', '')).first

        if result
          model.latitude = result.latitude
          model.longitude = result.longitude
        end

        all_models << model.attributes
      rescue
      end
    end

    klass.upsert_all(all_models)
  end
end