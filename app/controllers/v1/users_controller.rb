# frozen_string_literal: true

class V1::UsersController < ApplicationController
  skip_before_action :user_login, only: :create

  load_and_authorize_resource except: :create

  def index
    users = if @current_user.patient?
      User.therapists
    else
      User.patient
    end

    render json: users, each_serializer: UserSerializer
  end

  def create
    outcome = Users::CreateIntr.run(user_params)

    if outcome.valid?
      return render_success_response(I18n.t("users.signed_up_successfully"),
                                     { auth_token: outcome.result.auth_token })
    end

    render_error_response(outcome.errors.full_messages.to_sentence)
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type,
                                 :gender, :age, :address, :phone_number)
  end
end
