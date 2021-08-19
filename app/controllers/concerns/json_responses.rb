# frozen_string_literal: true

module JsonResponses
  extend ActiveSupport::Concern

  private
  def render_error_response(message, data = {})
    render_response(message, :bad_request, data)
  end

  def render_exception_response(message)
    render_response(message, :forbidden)
  end

  def render_data(message, data = {})
    render_response(message, :ok, data)
  end

  def render_success_response(message, data = {})
    render_response(message, :created, data)
  end

  def render_not_found_response(message)
    render_response(message, :not_found)
  end

  def render_unauthorized_response(message)
    render_response(message, :unauthorized)
  end

  def render_internal_server_error_response(message)
    render json: { errorMessage: message, errorCode: 500 }, status: :internal_server_error
  end

  def render_response(message, code, data = {})
    render json: { responseMessage: message, data: data }, status: code
  end
end
