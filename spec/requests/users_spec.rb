require 'rails_helper'

RSpec.describe "/users", type: :request do
  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    let!(:user) { FactoryBot.create_list(:user, 2) }

    it "renders a successful response" do
      get users_url, headers: valid_headers, as: :json
      expect(response).to be_successful

      body = JSON.parse(response.body)
      expect(body.size).to eq(2)
    end
  end

  describe "GET /show" do
    let!(:user) { FactoryBot.create(:user) }

    it "renders a successful response" do
      get user_url(user), as: :json
      expect(response).to be_successful

      body = JSON.parse(response.body)
      expect(body["id"]).to eq(user.id)
    end
  end

  describe "POST /create" do
    let(:valid_attributes) {
      {
        name: "sample user",
        email: "sample@sample.com",
        password: "password",
        password_confirmation: "password"
      }
    }

    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url,
               params: { user: valid_attributes }, headers: valid_headers, as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post users_url,
             params: { user: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        {
          name: "sample user",
          email: "sample@sample.com",
          password: "password",
          password_confirmation: "wrong_password"
        }
      }

      it "does not create a new User" do
        expect {
          post users_url,
               params: { user: invalid_attributes }, as: :json
        }.to change(User, :count).by(0)
      end

      it "renders a JSON response with errors for the new user" do
        post users_url,
             params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    let!(:user) { FactoryBot.create(:user) }

    context "with valid parameters" do
      let(:new_attributes) {
        { name: "new name" }
      }

      it "updates the requested user" do
        patch user_url(user),
              params: { user: new_attributes }, headers: valid_headers, as: :json
        user.reload
        expect(response).to have_http_status(:ok)
        expect(user.name).to eq("new name")
      end

      it "renders a JSON response with the user" do
        patch user_url(user),
              params: { user: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        {
          name: "sample user",
          email: "sample@sample.com",
          password: "password",
          password_confirmation: "wrong_password"
        }
      }

      it "renders a JSON response with errors for the user" do
        patch user_url(user),
              params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:user) { FactoryBot.create(:user) }

    it "destroys the requested user" do
      expect {
        delete user_url(user), headers: valid_headers, as: :json
      }.to change(User, :count).by(-1)
    end
  end
end
