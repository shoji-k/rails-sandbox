# frozen_string_literal: true

module Api
  module V1
    # Description: Base controller for API v1
    class ApplicationController < ActionController::API
      before_action :authenticate_user

      private

      def token
        request.headers['Authorization']&.split&.last
      end

      def authenticated_user
        return nil if token.nil?

        payload, _alg = JWT.decode token, nil, false
        return nil if payload.nil?

        User.find_by(id: payload['sub'])
      end

      def authenticate_user
        if authenticated_user.nil?
          head :unauthorized
        else
          token
        end
      end
    end
  end
end
