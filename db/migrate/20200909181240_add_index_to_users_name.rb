# frozen_string_literal: true

class AddIndexToUsersName < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :users, :name, algorithm: :concurrently
  end
end
