# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    guest_abilities

    return unless user.present?

    user_abilities(user)

    return unless user.admin?

    admin_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities(user)
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], { author_id: user.id }
    can :destroy, [Question, Answer], { author_id: user.id }
    can :update_best_answer, Question
    can :create_comment, [Question, Answer]
    can :me, User, user_id: user.id
    can %i[upvote downvote unvote], [Question, Answer]
  end

  def admin_abilities
    can :manage, :all
  end
end
