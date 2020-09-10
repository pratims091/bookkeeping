# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    transaction_type { Transaction::VALID_TRANSACTION_TYPES.sample }
    user { nil }
    contact { nil }
    amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    happend_on { Faker::Date.between(from: 4.months.ago, to: Date.today) }
    comments { Faker::DcComics.hero }
  end
end
