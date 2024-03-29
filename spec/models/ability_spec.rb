# frozen_string_literal: true

require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Award }
    it { should be_able_to :read, Link }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create_comment, Question }
      it { should be_able_to %i[update destroy], create(:question, author: user) }
      it { should_not be_able_to %i[update destroy], create(:question, author: other_user) }
      it { should be_able_to :update_best_answer, create(:question, author: user) }
      it { should be_able_to %i[upvote downvote unvote], create(:question, author: user) }
    end

    context 'Answer' do
      let(:question) { create(:question, author: user) }

      it { should be_able_to :create, Answer }
      it { should be_able_to :create_comment, Answer }
      it { should be_able_to %i[update destroy], create(:answer, question: question, author: user) }
      it { should_not be_able_to %i[update destroy], create(:answer, question: question, author: other_user) }
      it { should be_able_to %i[upvote downvote unvote], create(:answer, author: user, question: question) }
    end
  end
end
