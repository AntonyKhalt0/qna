class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', optional: true
  
  validates :title, :body, presence: true

  def set_best_answer(answer_id)
    update(best_answer_id: answer_id)
  end
end
