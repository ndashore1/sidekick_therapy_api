# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/patient_histories", type: :request do
  let!(:patient_user)     { create(:user, user_type: "patient") }
  let!(:therapists_user)  { create(:user, user_type: "therapists") }
  let!(:plan_of_care)     { create(:plan_of_care, user: patient_user) }
  let!(:old_therapist)    { create(:user, user_type: "therapists") }
  let!(:new_therapist)    { create(:user, user_type: "therapists") }
  let!(:patient_header)   { { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: patient_user.auth_token }) } }
  let!(:therapists_header) { { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: therapists_user.auth_token }) } }
  let!(:invalid_attributes) { { comments: nil } }
  let!(:valid_attributes) do
    {
      comments: "Therapists Switched",
      plan_of_care_id: plan_of_care.id.to_s,
      old_therapists_id: old_therapist.id.to_s,
      new_therapists_id: new_therapist.id.to_s
    }
  end

  describe "POST /create" do
    context "when patient logged in" do
      context "with valid parameters" do
        it "creates a new patient history" do
          expect do
            post v1_user_patient_histories_url(patient_user.id),
                 params: { patient_history: valid_attributes }, headers: patient_header, as: :json
          end.to change(PatientHistory, :count).by(1)
        end

        it "renders a JSON response with the new plan_of_care" do
          post v1_user_patient_histories_url(patient_user.id),
               params: { patient_history: valid_attributes }, headers: patient_header, as: :json

          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new plan of care" do
          expect do
            post v1_user_patient_histories_url(patient_user.id), headers: patient_header,
                 params: { patient_history: invalid_attributes }, as: :json
          end.to change(PlanOfCare, :count).by(0)
        end

        it "renders a JSON response with errors for the new plan of care" do
          post v1_user_patient_histories_url(patient_user.id), headers: patient_header,
               params: { patient_history: invalid_attributes }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to eq("application/json; charset=utf-8")
        end
      end
    end
  end
end
