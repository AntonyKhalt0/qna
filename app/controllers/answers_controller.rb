class AnswersController < ApplicationController
  def create
    @answer = question.answers.build(answer_params).save

    redirect_to question_path(question)
  end

  def update
    answer.update(answer_params)
    redirect_to question_path(question)
  end

  def destroy
    answer.destroy
    redirect_to question_path(question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end
end
