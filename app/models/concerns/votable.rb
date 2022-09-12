module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def cancel(user)
    vote = Vote.find_by(user_id: user.id, votable_type: self.class.name, votable_id: self.id)
    vote.liked? ? self.change_rating!(-1) : self.change_rating!(1)

    vote.destroy
  end

  private

  def change_rating!(value)
    update(rating: rating + value)
  end
end
