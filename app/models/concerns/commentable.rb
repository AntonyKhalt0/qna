module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end

  def comment(user, body)
    comment = comments.new(body)
    comment.author = user
    comment.save
    comment
  end
end
