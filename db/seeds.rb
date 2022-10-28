# Local authority

["buckinghamshire", "lambeth", "southwark"].each do |local_authority|
  LocalAuthority.find_or_create_by!(name: local_authority)
end
