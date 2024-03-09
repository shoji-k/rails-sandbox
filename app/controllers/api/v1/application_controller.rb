# frozen_string_literal: true

module Api
  module V1
    # Description: Base controller for API v1
    class ApplicationController < ActionController::API
      before_action :authenticate_user

      private

      def authenticate_user
        token = request.headers['Authorization']&.split&.last

        head :unauthorized if token.nil?
        # render json: { errors: ['unauthorized '] }, status: :unauthorized
      end
    end
  end
end
