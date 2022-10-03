module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    respond_to do |format|
      begin vote(1)
        format.json { render_json_success_vote }
      rescue ActiveRecord::RecordInvalid
        format.json { render_json_with_errors(@vote.errors.full_messages)}
      end  
    end
    
  end

  def downvote
    respond_to do |format|
      begin vote(-1)
        format.json { render_json_success_vote }
      rescue ActiveRecord::RecordInvalid
        format.json { render_json_with_errors(@vote.errors.full_messages)}
      end  
    end
  end

  def unvote
    respond_to do |format|
      begin @votable.cancel(current_user)
        format.json { render_json_success_vote }
      rescue ActiveRecord::RecordInvalid
        format.json { render_json_with_errors }
      end
    end
  end

  private

  def render_json_success_vote
    @votable.reload

    render json: { 
        resource: @votable.class.name.downcase,
        id: @votable.id,
        rating: @votable.rating
      }
  end

  def render_json_with_errors(errors)
    render json: { 
      errors: errors,
      resource: @votable.class.name.downcase,
      id: @votable.id, 
    }, status: :unprocessable_entity
  end

  def vote(value)
    @votable.transaction do
      @votable.lock!
      @vote = @votable.votes.new(user_id: current_user.id)
      @vote.liked = true if value == 1
      model_klass.update_counters @votable.id, rating: value
      @vote.save!
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
