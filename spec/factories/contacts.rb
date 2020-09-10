# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    user { nil }
  end
end
