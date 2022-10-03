# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at,
             :best_answer_id, :award_id, :rating, :short_title

  has_many :answers
  has_many :comments
  has_many :links
  belongs_to :author, class: 'User', foreign_key: 'author_id'

  def short_title
    object.title.truncate(7)
  end
end
