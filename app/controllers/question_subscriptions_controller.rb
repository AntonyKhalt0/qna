class QuestionSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def create
    @subscription = QuestionSubscription.create(user: current_user, question_id: params[:question_id] )
  end

  def destroy
    @subscription = current_user.question_subscriptions.find(params[:id])
    @subscription.destroy
  end
end
