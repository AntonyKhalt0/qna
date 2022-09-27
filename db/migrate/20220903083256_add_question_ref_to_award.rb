# frozen_string_literal: true

class AddQuestionRefToAward < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :award, foreign_key: true
  end
end
