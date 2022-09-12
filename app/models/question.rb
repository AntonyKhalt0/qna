class Question < ApplicationRecord
  include Votable
  
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', optional: true
  
  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  def set_best_answer(answer_id)
    update(best_answer_id: answer_id)
  end
end
