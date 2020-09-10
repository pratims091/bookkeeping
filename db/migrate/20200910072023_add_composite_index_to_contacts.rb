# frozen_string_literal: true

class AddCompositeIndexToContacts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :contacts, %i[user_id phone_number], unique: true, algorithm: :concurrently
  end
end
