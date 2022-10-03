# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :question_subscriptions, dependent: :delete_all
  has_many :subscribers, through: :question_subscriptions, source: :user
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', optional: true, dependent: :destroy
  has_one :award, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, :rating, presence: true

  after_create :calculate_reputation

  def set_best_answer(answer_id)
    update(best_answer_id: answer_id)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
