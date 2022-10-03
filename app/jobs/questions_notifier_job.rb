class QuestionsNotifierJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionsNotifier.new.send_digest(answer)
  end
end
