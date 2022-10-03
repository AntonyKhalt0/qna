class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many_attached :files
  
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
  validates :question_id, presence: true
end
