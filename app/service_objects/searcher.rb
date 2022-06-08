class Searcher
  RESULTS_PER_PAGE = 10

  def initialize
  end

  def search(query, options)
    filters = {}
    page = options[:page] || 1
    boost_by_distance = {}

    if options[:gender_diverse] && options[:gender_diverse] == 'true'
      filters[:gender_diverse] = true
    end
    if options[:ethnically_diverse] && options[:ethnically_diverse] == 'true'
      filters[:ethnically_diverse] = true
    end
    if options[:veteran] && options[:veteran] == 'true'
      filters[:veteran] = true
    end
    if options[:has_disability] && options[:has_disability] == 'true'
      filters[:has_disability] = true
    end
    if options[:open_to_opportunities] && options[:open_to_opportunities] == 'true'
      filters[:open_to_opportunities] = true
    end
    if options[:student] && options[:student] == 'true'
      filters[:student] = true
    end
    if options[:companies]
      filters[:company_names] = options[:companies].select {|company| company.present? }
    end
    if options[:industries]
      filters[:industry] = options[:industries].select {|industry| industry.present? }
    end
    if options[:titles]
      filters[:titles] = options[:titles].select {|title| title.present? }
    end
    if options[:years_of_experiences]
      filters[:years_of_experience] = options[:years_of_experiences].select {|years_of_experience| years_of_experience.present? }
    end
    if options[:company_headcounts]
      filters[:current_company_headcount] = options[:company_headcounts].select {|company_headcount| company_headcount.present? }
    end

    candidates = Candidate.search(misspellings: false,
                                  where: filters,
                                  boost_by_distance: boost_by_distance,
                                  page: page,
                                  per_page: RESULTS_PER_PAGE,
                                  aggs: {
                                    company_names: {},
                                    industry: {},
                                    titles: {},
                                    years_of_experience: {},
                                    current_company_headcount: {}
                                  },
                                  select: false,
                                  body_options: {
                                    track_total_hits: true
                                  }) do |body|
      query_string_query = {
        query_string: {
          query: query,
          fields: ["tier1^10", "tier2^2", "tier3"],
          default_operator: "AND"
        }
      }

      if body[:query][:bool] # this means other filters are active, which we don't want to overwrite
        body[:query][:bool][:must] = query_string_query
      else
        body[:query] = {
          bool: {
            must: query_string_query
          }
        }
      end

      if options[:us_only]
        body[:query][:bool][:filter] ||= []

        boundary_geojson = get_boundary_geojson({ location: "United States" })

        body[:query][:bool][:filter] << {
          geo_shape: {
            location: {
              shape: {
                type: boundary_geojson["type"].downcase,
                coordinates: boundary_geojson["coordinates"]
              },
              "relation": "intersects"
            }
          }
        }
      end
      if options[:locations]
        locations = options[:locations].select {|location| location[:location].present? }

        location_conditions = locations.collect do |location|
          boundary_geojson = get_boundary_geojson(location)

          if boundary_geojson
            {
              geo_shape: {
                location: {
                  shape: {
                    type: boundary_geojson["type"].downcase,
                    coordinates: boundary_geojson["coordinates"]
                  },
                  "relation": "intersects"
                }
              }
            }
          end
        end.compact

        body[:query][:bool][:filter] ||= []

        body[:query][:bool][:filter] << {
          bool: {
            should: location_conditions
          }
        }
      end

      if options[:keywords].present?
        query_string_keyword = {
          query_string: {
            query: options[:keywords],
            fields: ["full_text"],
            default_operator: "AND"
          }
        }

        body[:query][:bool][:filter] ||= []

        body[:query][:bool][:filter] << query_string_keyword
      end
    end

    [candidates, candidates.total_count, candidates.aggs]
  end

  # Refactor the below out
  def miles_to_meters(miles)
    miles * 1609.34
  end

  def get_boundary_geojson(location)
    result = Geocoder.search(location[:location]).first

    if result
      Rails.cache.fetch("boundary_geojson/location:#{location[:location]}/radius:#{location[:radius]}") {
        if result.data["types"].include?("administrative_area_level_1")
          # result.data["formatted_address"] results in strings like "Washington, USA"
          # which trips up OSM when setting state parameter
          query_string = "state=#{URI::Parser.new.escape(location[:location])}"
        else
          query_string = "q=#{URI::Parser.new.escape(result.data["formatted_address"])}"
        end
        query_string += "&format=json&polygon_geojson=1"

        response = HTTParty.get("https://nominatim.openstreetmap.org/search?#{query_string}")

        json = JSON.parse(response.body)

        geojson = json.select {|result| result["class"] == "boundary" }.first["geojson"]

        geo_shape = RGeo::GeoJSON.decode(geojson, geo_factory: RGeo::Geographic.simple_mercator_factory(uses_lenient_assertions:true))
        geo_shape = geo_shape.buffer(location[:radius] ? miles_to_meters(location[:radius].to_i) : 0)

        RGeo::GeoJSON.encode(geo_shape)
      }
    end
  end
end