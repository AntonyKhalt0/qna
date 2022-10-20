# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      def show
        render json: answer
      end

      def create
        authorize! :create, Answer
        @answer = question.answers.new(answer_params)
        @answer.author = current_resource_owner

        if @answer.save
          render json: @answer
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, answer
        if answer.update(answer_params)
          render json: answer
        else
          render json: { errors: answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, answer
        answer.destroy
        render json: answer
      end

      private

      def answer_params
        params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
      end

      def answer
        @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
      end

      def question
        @question ||= Question.find(params[:question_id])
      end
    end
  end
end