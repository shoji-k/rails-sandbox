# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'sample name' }
    email { 'sample@sample.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
