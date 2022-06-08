class PrioritizeImportCoresignalFileJob < ApplicationJob
  queue_as :urgent

  def perform(filename)
    client = Aws::S3::Client.new(region: ENV['AWS_S3_REGION'])
    decompressor = Zlib::Inflate.new(Zlib::MAX_WBITS + 32)

    row_stream(ungzip_stream(decompressor, file_stream(client, filename))).lazy.each do |row|
      candidate_json = JSON.parse(row.gsub(",\n", ''))

      sex_guesser = SexGuesser::Categorizer.new
      ethnicity_guesser = EthnicityGuesser::Categorizer.new

      result = Candidate.upsert({
        uid: candidate_json['id'],
        full_name: candidate_json['name'],
        location: candidate_json['location'],
        bio: candidate_json['summary'],
        industry: candidate_json['industry'],
        linked_in_url: candidate_json['canonical_url'],
        avatar_url: candidate_json['logo_url'],
        sex_guess: sex_guesser.guess_sex(candidate_json['name'].split(' ').first),
        ethnicity_guess: ethnicity_guesser.guess(candidate_json['name'].split(' ').last),
        created_at: DateTime.now,
        updated_at: DateTime.now
      }, unique_by: :uid)

      candidate_id = result.rows.first.first

      educations = candidate_json['member_education_collection'].collect do |education_json|
        if education_json['deleted'] != 1
          start_month = nil
          start_year = nil

          if education_json['date_from']
            begin
              start_date = Date.parse(education_json['date_from'])

              start_year = start_date.year
              start_month = start_date.month
            rescue
              start_year = education_json['date_from'].to_i
            end
          end

          end_month = nil
          end_year = nil

          if education_json['date_to']
            begin
              end_date = Date.parse(education_json['date_to'])

              end_year = end_date.year
              end_month = end_date.month
            rescue
              end_year = education_json['date_to'].to_i
            end
          end

          {
            candidate_id: candidate_id,
            uid: education_json['id'],
            school_name: education_json['title'],
            school_url: education_json['school_url'],
            degree: education_json['subtitle'],
            start_year: start_year,
            start_month: start_month,
            end_year: end_year,
            end_month: end_month,
            description: education_json['description'],
            activities_and_societies: education_json['activities_and_societies'],
            created_at: DateTime.now,
            updated_at: DateTime.now
          }
        end
      end.compact

      if educations.present?
        Education.upsert_all(educations, unique_by: :uid)
      end

      experiences = candidate_json['member_experience_collection'].collect do |experience_json|
        if experience_json['deleted'] != 1
          start_month = nil
          start_year = nil

          if experience_json['date_from']
            begin
              start_date = Date.parse(experience_json['date_from'])

              start_year = start_date.year
              start_month = start_date.month
            rescue
              start_year = experience_json['date_from'].to_i
            end
          end

          end_month = nil
          end_year = nil

          if experience_json['date_to']
            begin
              end_date = Date.parse(experience_json['date_to'])

              end_year = end_date.year
              end_month = end_date.month
            rescue
              end_year = experience_json['date_to'].to_i
            end
          end

          {
            candidate_id: candidate_id,
            uid: experience_json['id'],
            title: experience_json['title'],
            company_name: experience_json['company_name'],
            company_linked_in_url: experience_json['company_url'],
            location: experience_json['location'],
            start_year: start_year,
            start_month: start_month,
            end_year: end_year,
            end_month: end_month,
            description: experience_json['description'],
            created_at: DateTime.now,
            updated_at: DateTime.now
          }
        end
      end.compact

      if experiences.present?
        Experience.upsert_all(experiences, unique_by: :uid)
      end

      candidate = Candidate.find(candidate_id)

      reindex(candidate)
    end
  end

  def row_stream(ungzip_stream)
    buffer = ""

    Enumerator.new do |row_stream|
      ungzip_stream.each do |decompressed_chunk|
        buffer += decompressed_chunk

        new_buffer = ""

        buffer.each_line do |line|
          if line != "[\n" && line != "]\n"
            line.ends_with?("\n") ? row_stream << line : new_buffer += line
          end
        end

        buffer = new_buffer
      end
    end
  end

  def ungzip_stream(decompressor, file_stream)
    Enumerator.new do |ungzip_stream|
      file_stream.each do |compressed_chunk|
        decompressor.inflate(compressed_chunk) do |decompressed_chunk|
          ungzip_stream << decompressed_chunk
        end
      end
    end
  end

  def file_stream(client, filename)
    response = client.get_object(bucket: ENV['AWS_S3_CORESIGNAL_BUCKET'], key: filename)

    Enumerator.new do |aws_stream_enum|
      response.body.each do |chunk|
        aws_stream_enum << chunk
      end
    end
  end

  def reindex(candidate)
    unless candidate.latitude && candidate.longitude
      result = Geocoder.search(candidate.location.gsub('Greater ', '').gsub(' Area', '')).first

      if result
        candidate.update_columns(latitude: result.latitude,
                                 longitude: result.longitude)
      end
    end

    candidate.reindex
  end
end