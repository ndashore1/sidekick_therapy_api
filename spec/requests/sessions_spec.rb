# frozen_string_literal: true

require "rails_helper"
RSpec.describe "Sessions", type: :request do
  let(:valid_headers) { { "ACCEPT" => "application/json" } }
  let(:invalid_headers) { { "X-AUTH-TOKEN" => nil } }
  let!(:user)           { create(:user, user_type: "patient") }
  let(:temp_user)       { create(:user, user_type: "patient") }

  describe "Post /create" do
    it "authenticates the user" do
      post "/api/v1/sessions",
           params: { user: { email: user.email, password: user.password } }, headers: valid_headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end

    it "returns error when user not present in database" do
      post "/api/v1/sessions",
           params: { user: { email: "incorrect@mail.com", password: "123456" } }, headers: valid_headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:bad_request)
    end

    it "returns error when email or password is blank" do
      post "/api/v1/sessions",
           params: { user: { email: nil, password: user.password } }, headers: valid_headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "Delete /sign_out" do
    it "return unauthorized if token is invalid" do
      delete "/api/v1/sessions/sign_out", headers: { "X-AUTH-TOKEN" => "osfjoaeravjrwoejioairweajoaisjoijewr" }

      expect(response).to have_http_status(:unauthorized)
    end

    it "return token not found" do
      delete "/api/v1/sessions/sign_out", headers: invalid_headers

      expect(response).to have_http_status(:bad_request)
    end

    it "returns user not found" do
      token = Jwt::JsonToken.encode({ auth_token: temp_user.auth_token })

      temp_user.delete

      delete "/api/v1/sessions/sign_out", headers: valid_headers.merge!("X-AUTH-TOKEN" => token)

      expect(response).to have_http_status(:not_found)
    end

    it "Destroy the sessions of User" do
      token = Jwt::JsonToken.encode({ auth_token: user.auth_token })

      delete "/api/v1/sessions/sign_out", headers: valid_headers.merge!("X-AUTH-TOKEN" => token)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end
  end
end
