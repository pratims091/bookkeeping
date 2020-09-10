# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.references :user, null: false, foreign_key: true
      t.references :contact, null: true, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.date :happend_on
      t.text :comments

      t.timestamps
    end
  end
end
