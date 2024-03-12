# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/auth' do
  let!(:user) { create(:user, email: 'test@sample.com', password: 'password') } # rubocop:disable RSpec/LetSetup

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'returns token' do
        post api_v1_auth_url,
             params: { auth: { email: 'test@sample.com', password: 'password' } }, as: :json
        expect(response).to have_http_status(:created)

        body = response.parsed_body
        expect(body['token']).not_to be_nil
      end
    end

    context 'with invalid parameters' do
      it 'returns unauthorized with wrong email' do
        post api_v1_auth_url,
             params: { auth: { email: 'wrong@sample.com', password: 'password' } }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized with wrong password' do
        post api_v1_auth_url,
             params: { auth: { email: 'test@sample.com', password: 'wrong' } }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
