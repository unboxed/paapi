require "rswag/ui"

Rswag::Ui.configure do |c|
  c.swagger_endpoint "/api-docs/v1/swagger_doc.yaml", "Docs"
end
