# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  include JsonResponses

  included do
    attr_accessor :current_user

    def user_login
      auth_token = parse_auth_token
      return render_error_response(I18n.t("api.jwt.auth_token_missing")) unless auth_token

      begin
        decoded = Jwt::JsonToken.decode(auth_token)
      rescue StandardError => e
        puts "Rescued: #{e.inspect}"
        return render_error_response(I18n.t("api.jwt.unexpected_error"), { errorCode: 500 })
      end
      return render_unauthorized_response(I18n.t("api.jwt.auth_token_not_authorized")) if decoded.nil?

      @current_user = User.find_by(auth_token: decoded["auth_token"])

      return render_not_found_response(I18n.t("users.not_found_in_database")) unless @current_user
    end

    private
    def parse_auth_token
      request.headers["X-AUTH-TOKEN"]
    end
  end
end
