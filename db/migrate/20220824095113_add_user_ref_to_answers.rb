# frozen_string_literal: true

class AddUserRefToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :author, foreign_key: { to_table: :users }, null: false
  end
end
