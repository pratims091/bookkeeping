# frozen_string_literal: true

class AddCompositeUniqueIndexOnUserContact < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :user_contacts, %i[user_id contact_id], unique: true, algorithm: :concurrently
  end
end
