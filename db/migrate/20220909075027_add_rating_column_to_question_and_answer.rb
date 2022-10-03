# frozen_string_literal: true

class AddRatingColumnToQuestionAndAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :rating, :integer, default: 0
    add_column :answers, :rating, :integer, default: 0
  end
end
