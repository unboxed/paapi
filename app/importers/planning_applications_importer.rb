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
     Rails.logger.info(exception.message)
     puts exception.message
   end

   def import_planning_applications
     import_rows("PlanningHistory#{local_authority.name.capitalize}.csv")
   end

   def import_rows(filename)
     file = Tempfile.new(["planning_applications", ".csv"])

     s3.get_object(bucket: "paapi-staging-import", key: filename) do |chunk|
       file.write(chunk.dup.force_encoding("utf-8"))
     end

     file.close
     CSV.foreach(file.path,
                 headers: true, header_converters: :symbol,
                 &method(:import_row))
     file.unlink
   end

   def import_row(row)
     with_property(row) do |property|
       PlanningApplication.find_or_initialize_by(reference: row[:reference])
         .update!(
           reference: row[:reference],
           area: row[:area],
           proposal_details: row[:proposal_details],
           received_at: row[:received_at],
           officer_name: row[:officer_name],
           decision: row[:decision],
           decision_issued_at: row[:decision_issued_at],
           view_documents: row[:view_documents],
           property: property,
           local_authority: local_authority)
     end
   end

   def local_authority
     @local_authority ||= LocalAuthority.find_by!(name: local_authority_name)
   end

   def s3
     @_s3 ||= Aws::S3::Client.new
   end

   def with_property(row)
     property = Property.find_by(uprn: row[:uprn])
     unless property
       with_address(row) do |address|
         property = Property.find_or_initialize_by(uprn: row[:uprn])
          .update!(
            type: row[:property_type],
            ward: row[:ward_c],
            ward_name: row[:ward],
            address: address)
       end
     end

     yield property
   end

   def with_address(row)
     Address.find_or_initialize_by(postcode: row[:postcode])
      .update!(
        full: row[:full].blank? ? row[:address] : row[:full],
        town: row[:town],
        map_east: row[:map_east],
        map_north: row[:map_north])

  rescue StandardError => exception
    message = "Planning application reference: #{row[:reference]} has invalid address: #{exception.message}"
    raise PlanningApplicationImporterInvalidRow.new(message)
  end

   class PlanningApplicationImporterInvalidRow < StandardError; end
end
