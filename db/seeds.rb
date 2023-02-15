# Local authority

["buckinghamshire", "lambeth", "southwark"].each do |name|
  api_client = ApiClient.find_or_create_by(client_name: name)

  LocalAuthority.find_or_create_by!(name:, api_client:)
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?