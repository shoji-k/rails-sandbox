# frozen_string_literal: true

module Auth
  # token for jwt
  class Token
    attr_reader :token, :payload

    def initialize(token)
      return if token.blank?

      @payload, _alg = JWT.decode token, Auth.token_secret_signature_key.call, true,
                                  { algorithm: Auth.algorithm, verify_iat: true }
      @token = token
    end

    def self.generate(user)
      token = user.id

      payload = default_claims.merge({ sub: token })
      JWT.encode payload, Auth.token_secret_signature_key.call, Auth.algorithm
    end

    def authenticated_user
      return nil unless @payload&.key?('sub')

      ::User.find_by(id: @payload['sub'])
    end

    def to_json(*_args)
      { jwt: @token }.to_json
    end

    private_class_method def self.default_claims
      {
        exp: Auth.lifetime.from_now.to_i,
        iat: Time.zone.now.to_i
      }
    end
  end
end
