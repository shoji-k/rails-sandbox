# frozen_string_literal: true

# Documentation: Helper for request specs
module RequestHelper
  def valid_headers(user)
    token = Auth::Token.generate(user)
    { Authorization: "Bearer #{token}" }
  end
end

RSpec.configure do |c|
  c.include RequestHelper, type: :request
end
