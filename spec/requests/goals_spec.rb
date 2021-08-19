# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/goals", type: :request do
  # Initialize Test Data
  let!(:patient_user)     { create(:user, user_type: "patient") }
  let!(:therapists_user)   { create(:user, user_type: "therapists") }
  let!(:plan_of_care)     { create(:plan_of_care, user: patient_user) }
  let!(:goals)            { create_list(:goal, 2, user: therapists_user, plan_of_care: plan_of_care) }
  let!(:goal)             { goals.first }
  let(:valid_attributes)  { { name: Faker::Music.instrument, goal_type: "stg" } }
  let(:invalid_attributes) { { name: nil } }
  let!(:patient_header)   { { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: patient_user.auth_token }) } }
  let!(:therapists_header) { { "X-AUTH-TOKEN" => Jwt::JsonToken.encode({ auth_token: therapists_user.auth_token }) } }

  describe "GET /index" do
    context "when therapists logged in" do
      it "list goals" do
        get v1_plan_of_care_goals_url(plan_of_care.id), headers: therapists_header, as: :json
        json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json.size).to eq(2)
      end
    end

    context "when patient logged in" do
      it "list goals" do
        get v1_plan_of_care_goals_url(plan_of_care.id), headers: patient_header, as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /show" do
    context "when patient logged in" do
      it "display info of goal" do
        get v1_plan_of_care_goal_url(plan_of_care.id, goal.id), headers: patient_header, as: :json
        json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json["id"]).to eq(goal.id)
      end
    end

    context "when therapists logged in" do
      it "display info of goal" do
        get v1_plan_of_care_goal_url(plan_of_care.id, goal.id), headers: therapists_header, as: :json
        json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json["id"]).to eq(goal.id)
      end
    end
  end

  describe "POST /create" do
    context "when therapists logged in" do
      context "with valid parameters" do
        it "creates a new goal" do
          expect do
            post v1_plan_of_care_goals_url(plan_of_care.id),
                 params: { goals: valid_attributes }, headers: therapists_header, as: :json
          end.to change(Goal, :count).by(1)
        end

        it "renders a JSON response with the new goal" do
          post v1_plan_of_care_goals_url(plan_of_care.id),
               params: { goals: valid_attributes }, headers: therapists_header, as: :json

          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new goal" do
          expect do
            post v1_plan_of_care_goals_url(plan_of_care.id), headers: therapists_header,
                 params: { goals: invalid_attributes }, as: :json
          end.to change(Goal, :count).by(0)
        end

        it "renders a JSON response with errors for the new plan of care" do
          post v1_plan_of_care_goals_url(plan_of_care.id), headers: therapists_header,
               params: { goals: invalid_attributes }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to eq("application/json; charset=utf-8")
        end
      end
    end

    context "when patient logged in" do
      context "with valid parameters" do
        it "doesn't create goal" do
          post v1_plan_of_care_goals_url(plan_of_care.id),
               params: { goals: valid_attributes }, headers: patient_header, as: :json

          expect(response).to have_http_status(:forbidden)
          expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
        end
      end
    end
  end

  describe "PATCH /update" do
    context "when therapists logged in" do
      context "with valid parameters" do
        let(:new_attributes) do
          { goals: { name: Faker::FunnyName.three_word_name, goal_type: "ltg" } }
        end

        it "updates the requested plan of care" do
          patch v1_plan_of_care_goal_url(plan_of_care.id, goal.id),
                params: new_attributes, headers: therapists_header, as: :json
          goal.reload
        end

        it "renders a JSON response with the plan of care" do
          patch v1_plan_of_care_goal_url(plan_of_care.id, goal.id),
                params: new_attributes, headers: therapists_header, as: :json

          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
        end
      end
    end

    context "when patient logged in" do
      context "with valid parameters" do
        let(:new_attributes) do
          { goals: { name: Faker::FunnyName.three_word_name, goal_type: "ltg" } }
        end

        it "doesn't update goal" do
          patch v1_plan_of_care_goal_url(plan_of_care.id, goal.id),
                params: new_attributes, headers: patient_header, as: :json

          expect(response).to have_http_status(:forbidden)
          expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
        end
      end
    end
  end

  describe "DELETE /destroy" do
    context "when therapists logged in" do
      it "destroys the requested goal" do
        expect do
          delete v1_plan_of_care_goal_url(plan_of_care.id, goal.id), headers: therapists_header, as: :json
        end.to change(Goal, :count).by(-1)
      end
    end

    context "when patient logged in" do
      it "doesn't destroy the requested goal" do
        delete v1_plan_of_care_goal_url(plan_of_care.id, goal.id), headers: patient_header, as: :json

        expect(response).to have_http_status(:forbidden)
        expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
      end
    end
  end
end
