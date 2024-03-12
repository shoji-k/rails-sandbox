# frozen_string_literal: true

module Auth
  # token for jwt
  module Token
    def authenticated_user
      return nil if token.nil?

      payload, _alg = JWT.decode token, Auth.token_secret_signature_key.call, true, { algorithm: Auth.algorithm }
      return nil if payload.nil?

      User.find_by(id: payload['sub'])
    end

    private

    def token
      request.headers['Authorization']&.split&.last
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