# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonResponses
  include Authentication

  before_action :user_login

  def current_ability
    @current_ability ||= Ability.new(@current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"

    render_exception_response(exception.message)
  end

  private
  def assign_jwt_token(payload)
    Jwt::JsonToken.encode(payload)
  end
end
