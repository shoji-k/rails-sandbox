# frozen_string_literal: true

# Auth for jwt
module Auth
  mattr_accessor :algorithm
  self.algorithm = 'HS256'

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = lambda {
    Rails.application.secret_key_base
  }
end
