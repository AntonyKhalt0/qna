# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:create_comment]
    before_action :authenticate_user!
  end

  def create_comment
    @comment = @commentable.comment(current_user, comment_params)

    if @comment.errors.any?
      render 'comments/create'
    else
      publish_comment
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    ActionCable.server.broadcast("comments_#{question_id}", {
                                   message: ApplicationController.render(
                                     partial: 'comments/comment',
                                     locals: { comment: @comment }
                                   ),
                                   resource: @commentable.class.name.downcase,
                                   id: @commentable.id
                                 })
  end

  def question_id
    @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
  end
end
