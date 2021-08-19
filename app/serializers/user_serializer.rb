# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attribute :token, if: :token
  attributes :id, :name, :email, :age, :gender, :user_type, :address, :phone_number,
             :created_at, :updated_at

  def token
    @instance_options[:token].presence
  end
end
