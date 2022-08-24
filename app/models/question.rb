class Question < ApplicationRecord
  has_many :answers
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  validates :title, :body, presence: true
end
