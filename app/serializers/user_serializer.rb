# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone_number

  has_many :contacts
  has_many :transactions
end
