# frozen_string_literal: true

# Auth for jwt
module Auth
  mattr_accessor :lifetime
  self.lifetime = 1.day

  mattr_accessor :algorithm
  self.algorithm = 'HS256'

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = lambda {
    Rails.application.secret_key_base
  }

  mattr_accessor :iss
  self.iss = 'Rails API'

  mattr_accessor :aud
  self.aud = 'user'
end
