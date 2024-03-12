# frozen_string_literal: true

module Api
  module V1
    # Description: Authentication controller for API v1
    class AuthController < Api::V1::ApplicationController
      skip_before_action :authenticate_user

      def create
        user = User.find_by(email: auth_params[:email])

        if user.nil? || !user.authenticate(auth_params[:password])
          render json: { error: 'Invalid email or password' }, status: :unauthorized
          return
        end

        token = 'sample'
        render json: { token: }, status: :created
      end

      private

      def auth_params
        params.require(:auth).permit(:email, :password)
      end
    end
  end
end
