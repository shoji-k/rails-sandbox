# frozen_string_literal: true

module Auth
  # user module
  module User
    private

    def token
      request.headers['Authorization']&.split&.last
    end

    def authenticated_user
      return nil if token.nil?

      payload, _alg = JWT.decode token, Auth.token_secret_signature_key.call, true, { algorithm: Auth.algorithm }
      return nil if payload.nil?

      ::User.find_by(id: payload['sub'])
    end

    def authenticate_user
      current_user = authenticated_user
      if current_user.nil?
        head :unauthorized
      else
        current_user
      end
    end
  end
end
