# Local authority

["buckinghamshire", "lambeth", "southwark"].each do |name|
  api_client = ApiClient.find_or_create_by(client_name: name)

  LocalAuthority.find_or_create_by!(name:, api_client:)

  User.find_or_create_by!(email: "#{name}@example.com") do |user|
    user.password = "secretpassword"
    user.password_confirmation = "secretpassword"
  end
end
