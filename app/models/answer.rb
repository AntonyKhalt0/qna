class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true
  validates :question_id, presence: true
end
