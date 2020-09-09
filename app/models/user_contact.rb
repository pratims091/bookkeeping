# frozen_string_literal: true

class UserContact < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: 'User', foreign_key: 'contact_id'

  validates :user, uniqueness: { scope: :contact, message: 'contact already added'}
end
