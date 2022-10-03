# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def cancel(user)
    vote = Vote.find_by(user_id: user.id, votable_type: self.class.name, votable_id: id)
    vote.liked? ? change_rating!(-1) : change_rating!(1)

    vote.destroy
  end

  private

  def change_rating!(value)
    update(rating: rating + value)
  end
end
