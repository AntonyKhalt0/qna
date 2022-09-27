# frozen_string_literal: true

shared_examples_for 'Commentable' do
  it { should have_many :comments }
end
