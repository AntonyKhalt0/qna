# frozen_string_literal: true

class AddQuestionRefToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :question, foreign_key: true, null: false
  end
end
