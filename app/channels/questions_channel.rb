# frozen_string_literal: true

class QuestionsChannel < ActionCable::Channel::Base
  def follow
    stream_from 'questions'
  end
end
