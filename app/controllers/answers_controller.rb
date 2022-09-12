class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do 
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
    @question = answer.question
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end
end
