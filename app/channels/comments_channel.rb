class CommentsChannel < ActionCable::Channel::Base
  def follow(data)
    stream_from "comments_#{data['question_id']}"
  end
end
