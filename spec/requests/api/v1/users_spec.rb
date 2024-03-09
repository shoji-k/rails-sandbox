# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/users' do
  let!(:login_user) { create(:user) }

  describe 'GET /index' do
    let(:users) { create_list(:user, 2) }

    it 'renders a successful response' do
      expect(users.size).to eq(2)

      get api_v1_users_url, headers: valid_headers(login_user), as: :json
      expect(response).to be_successful

      body = response.parsed_body
      expect(body.size).to eq(3) # login_user plus 2 users
    end
  end

  describe 'GET /show' do
    let!(:user) { create(:user) }

    context 'without authentication' do
      it 'renders a successful response' do
        get api_v1_user_url(user), as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      it 'renders a successful response' do
        get api_v1_user_url(user), as: :json,
                                   headers: valid_headers(login_user)
        expect(response).to be_successful

        body = response.parsed_body
        expect(body['id']).to eq(user.id)
      end
    end
  end

  describe 'POST /create' do
    let(:valid_attributes) do
      {
        name: 'sample user',
        email: 'sample@sample.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post api_v1_users_url,
               params: { user: valid_attributes }, headers: valid_headers(login_user), as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post api_v1_users_url,
             params: { user: valid_attributes }, headers: valid_headers(login_user), as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: 'sample user',
          email: 'sample@sample.com',
          password: 'password',
          password_confirmation: 'wrong_password'
        }
      end

      it 'does not create a new User' do
        expect do
          post api_v1_users_url,
               params: { user: invalid_attributes }, as: :json
        end.not_to change(User, :count)
      end

      it 'renders a JSON response with errors for the new user' do
        post api_v1_users_url,
             params: { user: invalid_attributes }, headers: valid_headers(login_user), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    let!(:user) { create(:user) }

    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'new name' }
      end

      it 'updates the requested user' do
        patch api_v1_user_url(user),
              params: { user: new_attributes }, headers: valid_headers(login_user), as: :json
        user.reload
        expect(response).to have_http_status(:ok)
        expect(user.name).to eq('new name')
      end

      it 'renders a JSON response with the user' do
        patch api_v1_user_url(user),
              params: { user: new_attributes }, headers: valid_headers(login_user), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: 'sample user',
          email: 'sample@sample.com',
          password: 'password',
          password_confirmation: 'wrong_password'
        }
      end

      it 'renders a JSON response with errors for the user' do
        patch api_v1_user_url(user),
              params: { user: invalid_attributes }, headers: valid_headers(login_user), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user) { create(:user) }

    it 'destroys the requested user' do
      expect do
        delete api_v1_user_url(user), headers: valid_headers(login_user), as: :json
      end.to change(User, :count).by(-1)
    end
  end
end
