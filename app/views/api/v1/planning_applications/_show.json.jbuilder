# frozen_string_literal: true

json.reference planning_application.reference
json.area planning_application.area
json.description planning_application.description
json.received_at planning_application.received_at.iso8601
json.assessor planning_application.assessor
json.decision planning_application.decision
json.decision_issued_at planning_application.decision_issued_at.iso8601
json.local_authority planning_application.local_authority.name
json.created_at planning_application.created_at.iso8601
json.view_documents planning_application.view_documents
json.properties planning_application.properties do |property|
  json.uprn property.uprn
  json.address property.address.full
  json.code property.code
  json.type property.type
end
