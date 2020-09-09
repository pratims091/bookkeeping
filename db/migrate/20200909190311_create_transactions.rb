# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type, null: false
      t.references :user, null: false, foreign_key: true
      t.references :contact, null: true, foreign_key: { to_table: :users }
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.date :happend_on, null: false
      t.text :comments

      t.timestamps
    end
  end
end
