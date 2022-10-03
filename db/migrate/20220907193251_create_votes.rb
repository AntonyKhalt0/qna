# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.boolean :liked, default: false
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
