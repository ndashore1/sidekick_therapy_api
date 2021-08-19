# frozen_string_literal: true

class Jwt::JsonToken
  class << self
    def encode(payload)
      payload[:exp] = 24.hours.from_now.to_i
      payload[:last_updated_at] = Time.now.to_i
      JWT.encode(payload, secret_key)
    end

    def decode(token)
      body = JWT.decode(token, secret_key)[0]
      HashWithIndifferentAccess.new body
    rescue StandardError => e
      Rails.logger.error e
      nil
    end

    def secret_key
      Rails.application.credentials.secret_token
    end
  end
end
