require "csv"

class PlanningApplicationsImporter
 def call
   import_planning_applications
 rescue StandardError => exception
   log_exception(exception)
 end

 private

   def log_exception(exception)
     Rails.logger.info(exception.message)
     puts exception.message
   end

   def import_planning_applications
     import_rows("PlanningHistoryBucks.csv")
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
           proposal: row[:proposal],
           received_at: row[:received_at],
           officer_name: row[:officer_name],
           decision: row[:decision],
           decision_issued_at: row[:decision_issued_at],
           property: property,
           local_authority: local_authority)
     end
   end

   # Not sure how to get the local_authority
   # Suggestion was from the file name
   # I would need to know that this was the file to import.
   # File name could have a date and I could keep a "last imported local_authority: Buckinghamshire, date: 3/9/2023"
   def local_authority
     @local_authority ||= LocalAuthority.find_or_create_by(name: "Bucks")
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
                  longitude: row[:map_east],
                  latitude: row[:map_north])

       if property.invalid?
         message = "Planning application reference: #{row[:reference]} has invalid property: #{property.address.errors.full_messages.join(",")}"
         raise PlanningApplicationImporterInvalidRow.new(message)
       end
     end
     yield property
   end

   class PlanningApplicationImporterInvalidRow < StandardError; end
end
