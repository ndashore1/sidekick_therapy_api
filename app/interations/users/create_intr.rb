# frozen_string_literal: true

class Users::CreateIntr < ApplicationInteraction
  string :name, :email, :password, :password_confirmation, :user_type
  string :gender, :age, :address, :phone_number, default: nil

  def execute
    user = User.new(inputs)
    errors.merge!(user.errors) unless user.save
    user
  end
end
