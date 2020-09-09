# frozen_string_literal: true

class User < ApplicationRecord
  validates :phone_number, uniqueness: true

  has_many :user_contacts
  has_many :contacts, through: :user_contacts
  has_many :transactions
  accepts_nested_attributes_for :transactions, allow_destroy: true, reject_if: :all_blank
end
