# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :phone_number, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
