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

  describe 'initialize' do
    let(:token) { described_class.generate(user) }

    it 'return jwt token' do
      instance = described_class.new(token)
      expect(instance.token).to start_with('eyJ')
      expect(instance.payload).to eq({ 'sub' => user.id })
    end
  end

  describe 'authenticated_user' do
    let(:instance) do
      token = described_class.generate(user)
      described_class.new(token)
    end

    it 'return user' do
      expect(instance.authenticated_user).to eq user
    end
  end
end
