class QuestionsChannel > AplicationCable::Channel
  def follow
    stream_from 'questions'
  end
end
