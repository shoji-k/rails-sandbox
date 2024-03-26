# frozen_string_literal: true

module Auth
  # token for jwt
  class Token
    attr_reader :token, :payload

    def initialize(token)
      return if token.blank?

      @payload, _alg = JWT.decode token, Auth.token_secret_signature_key.call, true, { algorithm: Auth.algorithm }
      @token = token
    end

    def self.generate(user)
      token = user.id

      payload = { sub: token }
      JWT.encode payload, Auth.token_secret_signature_key.call, Auth.algorithm
    end

    def to_json(*_args)
      { jwt: @token }.to_json
    end
  end
end
