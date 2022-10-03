class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true
  
  has_one_attached :image

  validates :title, presence: true

  def give_out_to(user)
    update(user: user)
  end
end
