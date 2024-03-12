# frozen_string_literal: true

# Documentation: Helper for request specs
module RequestHelper
  def valid_headers(user)
    token = user.id

    payload = { sub: token }
    token = JWT.encode payload, Auth.token_secret_signature_key.call, Auth.algorithm
    { Authorization: "Bearer #{token}" }
  end
end

RSpec.configure do |c|
  c.include RequestHelper, type: :request
end
