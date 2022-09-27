# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: question
      end

      def create
        authorize! :create, Question
        @question = Question.new(question_params)
        @question.author = current_resource_owner

        if @question.save
          render json: @question
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, question
        if question.update(question_params)
          render json: question
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, question
        question.destroy
        render json: question
      end

      private

      def question_params
        params.require(:question).permit(:title, :body, links_attributes: %i[id name url _destroy],
                                                        award_attributes: %i[id title image])
      end

      def question
        @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
      end
    end
  end
end
