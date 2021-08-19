# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:patient)          { create(:user, user_type: "patient") }
  let!(:therapists)       { create(:user, user_type: "therapists") }
  let(:valid_headers)     { { "X-AUTH-TOKEN" => "application/json" } }
  let(:invalid_headers)   { { "X-AUTH-TOKEN" => nil } }
  let!(:patient_headers)   { { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: patient.auth_token }) } }
  let!(:therapists_headers) { { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: therapists.auth_token }) } }
  let!(:valid_attributes) {
    {
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: "123456",
      password_confirmation: "123456",
      user_type: "patient"
    }
  }

  let!(:invalid_attributes) {
    {
      name: nil,
      user_type: nil
    }
  }

  describe "GET /users" do
    context "when patient logged in" do
      it "List therapists" do
        get v1_users_url, headers: patient_headers, as: :json
        json = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(json.first["user_type"]).to eq("therapists")
      end
    end

    context "when therapists logged in" do
      it "List patient" do
        get v1_users_path, headers: therapists_headers, as: :json
        json = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(json.first["user_type"]).to eq("patient")
      end
    end
  end

  describe "Post /create" do
    it "create new patient user" do
      post v1_users_url, params: { user: valid_attributes }, headers: valid_headers, as: :json

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end

    it "returns error in creation of patient user." do
      post v1_users_url, params: { user: invalid_attributes }, headers: valid_headers, as: :json

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:bad_request)
    end
  end
end
