class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.build(answer_params)

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully posted.'
    else
      render 'questions/show', locals: { question: question }
    end
  end

  def update
    answer.update(answer_params)
    redirect_to question_path(question)
  end

  def destroy
    answer.destroy
    redirect_to question_path(answer.question.id)
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
