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
       property = Property.new(uprn: row[:uprn])
       property.build_address(
                  full: row[:full].blank? ? row[:address] : row[:full],
                  town: row[:town],
                  postcode: row[:postcode],
                  map_east: row[:map_east],
                  map_north: row[:map_north])

       if property.invalid?
         message = "Planning application reference: #{row[:reference]} has invalid property: #{property.address.errors.full_messages.join(",")}"
         raise PlanningApplicationImporterInvalidRow.new(message)
       end
     end
     yield property
   end

   class PlanningApplicationImporterInvalidRow < StandardError; end
end
