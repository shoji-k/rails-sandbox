# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Token do
  let!(:user) { create(:user) }

  describe 'self.generate' do
    it 'return jwt token' do
      token = described_class.generate(user)
      expect(token).to start_with('eyJ')
    end
  end

  describe 'instance' do
    it 'return jwt token' do
      token = described_class.generate(user)
      obj = described_class.new(token)
      expect(obj.token).to start_with('eyJ')
    end
  end
end
