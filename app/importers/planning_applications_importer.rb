require "csv"

class PlanningApplicationsImporter
  def initialize(local_authority_name:)
    @local_authority_name = local_authority_name.downcase
  end

  def call
    import_planning_applications
  rescue StandardError => exception
    log_exception(exception)
  end

  private

  attr_reader :local_authority_name

  def log_exception(exception)
    broadcast(message: exception.message)
    broadcast(message: "Expected S3 filepath: paapi-staging-import/#{filename}")
  end

  def broadcast(message:)
    Rails.logger.info(message)
    puts message
  end

  def import_planning_applications
    import_rows(filename: filename)
  end

  def filename
    "#{local_authority_name}/PlanningHistory#{local_authority_name.capitalize}.csv"
  end

  def import_rows(filename:)
    file = Tempfile.new(["planning_applications", ".csv"])
    write_tempfile(file)
    file.close

    CSV.foreach(file.path,
                headers: true, header_converters: :symbol,
                &method(:import_row))
    file.unlink
  end

  def write_tempfile(file)
    if ENV["LOCAL_IMPORT_FILE"] == "true"
      file.write(local_import_file)
    else
      s3.get_object(bucket: "paapi-staging-import", key: filename) do |chunk|
        file.write(chunk.dup.force_encoding("utf-8"))
      end
    end
  end

  def local_import_file
    File.read(Rails.root.join("tmp", filename))
  end

  def import_row(row)
    PlanningApplicationCreation.new(
      local_authority: local_authority,
      reference: row[:reference],
      area: row[:area],
      description: row[:description],
      received_at: row[:received_at],
      assessor: row[:assessor],
      decision: row[:decision],
      decision_issued_at: row[:decision_issued_at],
      view_documents: row[:view_documents],
      uprn: row[:uprn],
      property_code: row[:property_code],
      property_type: row[:property_type],
      full: row[:full],
      address: row[:address],
      town: row[:town],
      postcode: row[:postcode],
      map_east: row[:map_east],
      map_north: row[:map_north],
      ward_code: row[:ward_code],
      ward_name: row[:ward_name],
    ).perform
  end

  def local_authority
    @local_authority ||= LocalAuthority.find_by!(name: local_authority_name)
  end

  def s3
    @_s3 ||= Aws::S3::Client.new
  end
end
