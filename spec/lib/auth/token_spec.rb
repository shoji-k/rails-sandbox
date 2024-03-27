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
    let(:payload) do
      token = user.id
      { sub: token, iss: Auth.iss, aud: Auth.aud, exp: 1.day.from_now.to_i, iat: Time.zone.now.to_i }
    end
    let(:token) do
      JWT.encode payload, Auth.token_secret_signature_key.call, Auth.algorithm
    end

    it 'return jwt token' do
      instance = described_class.new(token)
      expect(instance.token).to start_with('eyJ')
      expect(instance.payload).to include({ 'sub' => user.id })
    end

    context 'when token argument is blank' do
      it 'return nil params' do
        instance = described_class.new('')
        expect(instance.token).to be_nil
        expect(instance.payload).to be_nil
      end
    end

    context 'when decode key is wrong' do
      let(:token) { JWT.encode payload, 'dummy', Auth.algorithm }

      it 'raise decode error' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'when algorithm is wrong' do
      let(:token) do
        Auth.algorithm = 'HS512'
        JWT.encode payload, Auth.token_secret_signature_key.call, 'HS256'
      end

      it 'raise decode error' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'when lifetime is over' do
      let(:token) do
        JWT.encode payload.merge({ exp: Time.zone.now.ago(1.second) }), Auth.token_secret_signature_key.call,
                   Auth.algorithm
      end

      it 'return user' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'when iss is wrong' do
      let(:token) do
        JWT.encode payload.merge({ iss: 'wrong iss' }), Auth.token_secret_signature_key.call,
                   Auth.algorithm
      end

      it 'return user' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'when aud is wrong' do
      let(:token) do
        JWT.encode payload.merge({ aud: 'wrong aud' }), Auth.token_secret_signature_key.call,
                   Auth.algorithm
      end

      it 'return user' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'when iat is future' do
      let(:token) do
        JWT.encode payload.merge({ iat: Time.zone.now.since(1.day).to_i }), Auth.token_secret_signature_key.call,
                   Auth.algorithm
      end

      it 'return user' do
        expect { described_class.new(token) }.to raise_error(JWT::DecodeError)
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
