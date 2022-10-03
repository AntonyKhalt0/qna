class AddUserRefToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :author, foreign_key: { to_table: :users }, null: false
  end
end
