
puts 'Creating default admin user...'
Lato::User.create!(
  first_name: 'Admin',
  last_name: 'Admin',
  email: 'admin@mail.com',
  password: 'Password1!',
  password_confirmation: 'Password1!',
  accepted_privacy_policy_version: 1,
  accepted_terms_and_conditions_version: 1,
  lato_spaces_admin: true
)
puts 'Default lato user created successfully!'

10.times do |index|
  group = LatoSpaces::Group.create!(
    name: "Group #{index + 1}"
  )
  group.lato_spaces_memberships.create!(
    lato_user_id: Lato::User.first.id
  )
end

10.times do
  product = Product.create!
  if [true, false].sample
    product.add_to_lato_spaces_group LatoSpaces::Group.all.sample.id
    product.add_to_lato_spaces_group LatoSpaces::Group.all.sample.id
  end
end

10.times do
  ProductRequired.create!(lato_spaces_group_id: LatoSpaces::Group.all.sample.id)
end

10.times do
  product = ProductUnique.create!
  if [true, false].sample
    product.add_to_lato_spaces_group LatoSpaces::Group.all.sample.id
  end
end
