# frozen_string_literal: true

class AddIndexToUsersPhone < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :users, :phone_number, unique: true, algorithm: :concurrently
  end
end
