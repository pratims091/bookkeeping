# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    transaction_type { 'MyString' }
    user { nil }
    contact { nil }
    amount { '9.99' }
    happend_on { '2020-09-10' }
    comments { 'MyText' }
  end
end
