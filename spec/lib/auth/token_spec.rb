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
      expect(instance.payload).to include({ 'sub' => user.id })
    end

    context 'when token is blank' do
      it 'return nil params' do
        instance = described_class.new('')
        expect(instance.token).to be_nil
        expect(instance.payload).to be_nil
      end
    end

    context 'when decode key is wrong' do
      let(:token) do
        token = user.id
        payload = { sub: token }
        JWT.encode payload, 'dummy', Auth.algorithm
      end

      it 'raise decode error' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'when algorithm is wrong' do
      let(:token) do
        Auth.algorithm = 'HS512'
        token = user.id
        payload = { sub: token }
        JWT.encode payload, Auth.token_secret_signature_key.call, 'HS256'
      end

      it 'raise decode error' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'when lifetime is over' do
      it 'return user' do
        Auth.lifetime = 1.day
        token = described_class.generate(user)
        travel_to Time.zone.now.since(2.days) do
          expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
        end
      end
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
