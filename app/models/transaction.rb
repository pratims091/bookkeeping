# frozen_string_literal: true

class Transaction < ApplicationRecord
  VALID_TRANSACTION_TYPES = %w[credit debit].freeze

  belongs_to :user
  belongs_to :contact, optional: true

  validates :transaction_type, presence: true, inclusion: { in: VALID_TRANSACTION_TYPES }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :happend_on, presence: true

  validate :contact_in_contacts?, if: proc { |t| t.contact_id.present? }

  scope :credit, -> { where(transaction_type: 'credit') }
  scope :deibt, -> { where(transaction_type: 'debit') }
  private

  def contact_in_contacts?
    errors.add(:contact_id, 'not in your contact list') unless (user.contacts.pluck(:id) || []).include? contact_id
  end
end
