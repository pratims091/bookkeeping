# frozen_string_literal: true

class Transaction < ApplicationRecord
  VALID_TRANSACTION_TYPES = %w[credit debit].freeze

  belongs_to :user
  belongs_to :contact, class_name: 'User', foreign_key: 'contact_id', optional: true

  validates :transaction_type, presence: true, inclusion: { in: VALID_TRANSACTION_TYPES }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :happend_on, presence: true
end
