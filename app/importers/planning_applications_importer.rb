# frozen_string_literal: true

require "csv"

class PlanningApplicationsImporter
  def initialize(local_authority_name:)
    @local_authority_name = local_authority_name.downcase
  end

  def call
    import_planning_applications
  rescue StandardError => e
    log_exception(e)
  end

  private

  attr_reader :local_authority_name

  def log_exception(exception)
    broadcast(message: exception.message)
    broadcast(message: "Expected S3 filepath: paapi-staging-import/#{filename}")
  end

  def broadcast(message:)
    Rails.logger.info(message)
    Rails.logger.debug message
  end

  def import_planning_applications
    import_rows
  end

  def filename
    "#{local_authority_name}/PlanningHistory#{local_authority_name.capitalize}.csv"
  end

  def import_rows
    file = Tempfile.new(["planning_applications", ".csv"])
    write_tempfile(file)
    file.close

    CSV.read(file.path, headers: true, header_converters: :symbol).each do |row|
      import_row(row)
    end

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
    Rails.root.join("tmp", filename).read
  end

  def import_row(row)
    PlanningApplicationCreation.new(
      **row.to_h.merge(local_authority:)
    ).perform
  end

  def local_authority
    @local_authority ||= LocalAuthority.find_by!(name: local_authority_name)
  end

  def s3
    @s3 ||= Aws::S3::Client.new
  end
end
