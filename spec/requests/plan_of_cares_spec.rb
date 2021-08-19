# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/plan_of_cares", type: :request do
  # Initialize Test Data
  let(:invalid_headers)   { { "X-AUTH-TOKEN" => nil } }
  let!(:patient_user)     { create(:user, user_type: "patient") }
  let!(:therapists_user)  { create(:user, user_type: "therapists") }
  let!(:plan_of_cares)    { create_list(:plan_of_care, 2, user: patient_user) }
  let!(:plan_of_care)     { plan_of_cares.first }
  let(:valid_attributes)  { { title: Faker::FunnyName.two_word_name } }
  let(:invalid_attributes) { { title: nil } }
  let!(:patient_histories) {
    create(:patient_history,
            plan_of_care_id: plan_of_care.id,
            patient_id: patient_user.id,
            new_therapists_id: therapists_user.id
          )
  }
  let!(:patient_header) {
    { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: patient_user.auth_token }) }
  }

  let!(:therapists_header) {
    { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: therapists_user.auth_token }) }
  }

  let(:valid_attributes_with_therapists) do
    {
      title: Faker::FunnyName.two_word_name,
      therapists_id: therapists_user.id
    }
  end

  describe "GET /index" do
    context "when patient logged in" do
      it "list plan of cares" do
        get v1_plan_of_cares_url, headers: patient_header, as: :json
        json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json.size).to eq(2)
      end
    end

    context "when therapists logged in" do
      it "list plan of cares of patients" do
        get v1_plan_of_cares_url, headers: therapists_header, as: :json
        json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json[0]["id"]).to eq(patient_histories.plan_of_care_id)
      end
    end
  end

  describe "GET /show" do
    context "when patient logged in" do
      it "display info of plan of care" do
        get v1_plan_of_care_url(plan_of_care.id), headers: patient_header, as: :json
        json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json["id"]).to eq(plan_of_care.id)
      end
    end
  end

  describe "POST /create" do
    context "when patient logged in" do
      context "when therapists not selected" do
        context "with valid parameters" do
          it "creates a new plan of care" do
            expect do
              post v1_plan_of_cares_url,
                   params: { plan_of_care: valid_attributes }, headers: patient_header, as: :json
            end.to change(PlanOfCare, :count).by(1)
          end

          it "renders a JSON response with the new plan_of_care" do
            post v1_plan_of_cares_url,
                 params: { plan_of_care: valid_attributes }, headers: patient_header, as: :json

            expect(response).to have_http_status(:created)
            expect(response.content_type).to match(a_string_including("application/json"))
          end
        end

        context "with invalid parameters" do
          it "does not create a new plan of care" do
            expect do
              post v1_plan_of_cares_url,
                   params: { plan_of_care: invalid_attributes }, as: :json
            end.to change(PlanOfCare, :count).by(0)
          end

          it "renders a JSON response with errors for the new plan of care" do
            post v1_plan_of_cares_url,
                 params: { plan_of_care: invalid_attributes }, headers: patient_header, as: :json

            expect(response).to have_http_status(:bad_request)
            expect(response.content_type).to eq("application/json; charset=utf-8")
          end
        end
      end

      context "when therapists selected" do
        context "with valid parameters" do
          it "creates a new plan of care" do
            expect do
              post v1_plan_of_cares_url,
                   params: { plan_of_care: valid_attributes_with_therapists }, headers: patient_header, as: :json
            end.to change(PlanOfCare, :count).by(1)
          end

          it "renders a JSON response with the new plan_of_care" do
            post v1_plan_of_cares_url,
                 params: { plan_of_care: valid_attributes_with_therapists }, headers: patient_header, as: :json

            expect(response).to have_http_status(:created)
            expect(response.content_type).to match(a_string_including("application/json"))
          end
        end
      end
    end

    context "when therapists logged in" do
      context "with valid parameters" do
        it "renders a error of unauthorized" do
          post v1_plan_of_cares_url,
               params: { plan_of_care: valid_attributes }, headers: therapists_header, as: :json

          expect(response).to have_http_status(:forbidden)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "PATCH /update" do
    context "when patient logged in" do
      context "when therapists already selected by patient" do
        context "with valid parameters" do
          let(:new_attributes) do
            { plan_of_care: { title: Faker::FunnyName.three_word_name } }
          end

          it "updates the requested plan of care" do
            patch v1_plan_of_care_url(plan_of_care.id),
                  params: new_attributes, headers: patient_header, as: :json
            plan_of_care.reload

            expect(response).to have_http_status(:created)
            expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
          end
        end

        context "with invalid parameters" do
          it "renders a JSON response with errors for the plan of care" do
            patch v1_plan_of_care_url(plan_of_care.id),
                  params: { plan_of_care: invalid_attributes }, headers: patient_header, as: :json

            expect(response).to have_http_status(:bad_request)
            expect(response.content_type).to eq("application/json; charset=utf-8")
          end
        end
      end

      context "when patient selects therapists" do
        context "with valid parameters" do
          let(:new_attributes) do
            {
              plan_of_care: {
                title: Faker::FunnyName.three_word_name,
                therapists_id: therapists_user.id
              }
            }
          end

          it "renders a JSON response with the plan of care" do
            patch v1_plan_of_care_url(plan_of_cares.last.id),
                  params: new_attributes, headers: patient_header, as: :json

            expect(response).to have_http_status(:created)
            expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
          end
        end
      end
    end

    context "when therapists logged in" do
      context "with valid parameters" do
        let(:new_attributes) do
          { plan_of_care: { title: Faker::FunnyName.three_word_name } }
        end

        it "updates the requested plan of care" do
          patch v1_plan_of_care_url(plan_of_care.id),
                params: new_attributes, headers: therapists_header, as: :json

          expect(response).to have_http_status(:forbidden)
          expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
        end
      end
    end
  end

  describe "DELETE /destroy" do
    context "when patient logged in" do
      it "destroys the requested plan of care" do
        expect do
          delete v1_plan_of_care_url(plan_of_care.id), headers: patient_header, as: :json
        end.to change(PlanOfCare, :count).by(-1)
      end
    end

    context "when therapists logged in" do
      it "cannot destroys the requested plan of care" do
        delete v1_plan_of_care_url(plan_of_care.id), headers: therapists_header, as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
