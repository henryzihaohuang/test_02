class ImportCoresignalCompanyFileJob < ApplicationJob
  queue_as :default

  def perform(filename)
    client = Aws::S3::Client.new(region: ENV['AWS_S3_REGION'])
    decompressor = Zlib::Inflate.new(Zlib::MAX_WBITS + 32)

    all_companies = []

    row_stream(ungzip_stream(decompressor, file_stream(client, filename))).lazy.each do |row|
      company_json = Oj.load(row.gsub(",\n", ''))

      all_companies << {
        uid: company_json["id"],
        name: company_json["name"],
        logo_url: company_json["logo_url"],
        location: company_json["headquarters_new_address"],
        industry: company_json["industry"],
        website: company_json["website"],
        founded: company_json["founded"],
        bio: company_json["description"],
        employees_count: company_json["employees_count"],
        linked_in_url: company_json["canonical_url"],
        created_at: DateTime.now,
        updated_at: DateTime.now
      }
    end

    Company.upsert_all(all_companies, unique_by: :uid)
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
end
