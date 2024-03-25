# frozen_string_literal: true

module Auth
  # token for jwt
  module Token
    def self.generate(user)
      token = user.id

      payload = { sub: token }
      JWT.encode payload, Auth.token_secret_signature_key.call, Auth.algorithm
    end

    private

    def token
      request.headers['Authorization']&.split&.last
    end

    def authenticated_user
      return nil if token.nil?

      payload, _alg = JWT.decode token, Auth.token_secret_signature_key.call, true, { algorithm: Auth.algorithm }
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
