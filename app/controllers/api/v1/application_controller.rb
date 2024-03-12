# frozen_string_literal: true

module Api
  module V1
    # Description: Base controller for API v1
    class ApplicationController < ActionController::API
      include Auth::Token
      before_action :authenticate_user
    end
  end
end
