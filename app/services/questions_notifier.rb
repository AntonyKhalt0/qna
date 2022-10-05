class QuestionsNotifier
  def send_digest(answer)
    users = answer.question.subscribers

    QuestionsNotifierMailer.digest(users, answer).deliver_later
  end
end
