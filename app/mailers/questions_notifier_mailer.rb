class QuestionsNotifierMailer < ApplicationMailer
  def digest(users, answer)
    @answer = answer

    users.each do |user|
      mail to: user.email
    end
  end
end
