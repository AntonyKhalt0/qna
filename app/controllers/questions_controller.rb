class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :update_best_answer, :destroy]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    gon.question_id = @question.id
    @answer = Answer.new
    @answer.links.new
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_award
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
    @question.update(question_params) if current_user.author?(@question)
  end

  def update_best_answer
    @question.set_best_answer(params[:answer_id])
    @best_answer = @question.best_answer
    @question.award.give_out_to(@best_answer.author) if @question.award.present?
    @answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                      files: [], links_attributes: [:id, :name, :url, :_destroy],
                                      award_attributes: [:id, :title, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )      
    )
  end
end
