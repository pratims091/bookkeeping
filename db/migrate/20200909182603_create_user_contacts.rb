# frozen_string_literal: true

class CreateUserContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_contacts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
