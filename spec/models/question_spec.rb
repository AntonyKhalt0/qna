# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :answers }
  it { should have_one :award }
  it { should have_many :question_subscriptions }
  it { should have_many :subscribers }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :rating }

  it_behaves_like 'Attachmentable'
  it_behaves_like 'Linkable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Votable'
  it_behaves_like 'Author'

  describe 'reputation' do
    let(:user) { build(:user) }
    let(:question) { build(:question, author: user) }

    it 'calls Reputation#calculate' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
