# frozen_string_literal: true

module Auth
  # user module
  module User
    private

    def token
      request.headers['Authorization']&.split&.last
    end

    def current_user
      Auth::Token.new(token).authenticated_user
    rescue JWT::DecodeError, JWT::EncodeError
      nil
    end

    def authenticate_user
      if current_user.nil?
        head :unauthorized
      else
        current_user
      end
    end
  end
end
