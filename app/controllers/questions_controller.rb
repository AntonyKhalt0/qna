class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :update_best_answer, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user == @question.author
  end

  def update_best_answer
    @question.set_best_answer(params[:answer_id])
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
