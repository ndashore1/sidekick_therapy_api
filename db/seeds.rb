# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
first_names = %w[Bob Alice Joe Amanda Ben John]
last_names = %w[Williams Hawkins Serna Florez Halliday]
user_type = %w[patient therapists]

User.transaction do
  (1..100).map do |num|
    puts "User #{num}"
    name_of_user = "#{first_names.sample}#{last_names.sample}"
    User.create_with(
      name: name_of_user.titleize,
      user_type: user_type.sample,
      password: "123456"
    ).find_or_create_by(email: "#{name_of_user.downcase}@mail.com")
  end
end
