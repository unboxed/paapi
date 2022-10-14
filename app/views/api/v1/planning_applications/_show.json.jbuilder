# frozen_string_literal: true

json.id planning_application.id
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
json.property do
  json.uprn planning_application.property.uprn
  json.code planning_application.property.code
  json.type planning_application.property.type
end
json.address planning_application.property.address.full
