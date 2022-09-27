# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  authorize_resource

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
    publish_answer
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("questions-#{question.id}-answers", ApplicationController.render(
                                                                       partial: 'answers/answer_body',
                                                                       locals: { answer: @answer }
                                                                     ))
  end
end
