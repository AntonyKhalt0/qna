class AnswersChannel < ActionCable::Channel::Base
  def follow(data)
    stream_from "question-#{data['question_id']}-answers"
  end
end
