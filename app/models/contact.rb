# frozen_string_literal: true

class Contact < ApplicationRecord
  belongs_to :user

  validates :phone_number, presence: true, uniqueness: { scope: :user, message: 'contact already added' }
end
