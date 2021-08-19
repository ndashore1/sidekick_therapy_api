# frozen_string_literal: true

class V1::SessionsController < ApplicationController
  skip_before_action :user_login, only: :create
  before_action :check_valid_email_and_password, only: :create

  def create
    user = User.find_by(email: sign_in_params[:email].downcase)
    user = user&.authenticate(sign_in_params[:password]) ? user : nil
    unless user
      return render_error_response(I18n.t("users.not_found_in_database",
                                          authentication_keys: "email"))
    end

    token = assign_jwt_token({ auth_token: user.auth_token })
    render_success_response(I18n.t("users.sessions.signed_in"),
                            UserSerializer.new(user, token: token))
  end

  def sign_out
    @current_user.regenerate_auth_token
    render_success_response(I18n.t("users.sessions.signed_out"))
  end

  private
  def check_valid_email_and_password
    if sign_in_params[:email].blank? || sign_in_params[:password].blank?
      render_error_response(I18n.t("users.email_or_password_blank",
                                   authentication_keys: "email"))
    end
  end

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
