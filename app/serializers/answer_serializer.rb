class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id, :author_id, :rating

  belongs_to :question
  belongs_to :author
  has_many :comments
  has_many :links
end
