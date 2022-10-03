class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: [:votable_id, :votable_type], message: 'you can vote only once'}

  validate :authorship

  private

  def authorship
    errors.add(:user, "Author can't vote") if user.author?(votable)
  end
end
