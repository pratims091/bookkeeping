# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :transaction_type, :amount, :happend_on, :comments

  belongs_to :contact
end
